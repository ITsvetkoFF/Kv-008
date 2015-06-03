import tornado.gen
import tornado.web
from tornado.auth import GoogleOAuth2Mixin, FacebookGraphMixin
import tornado.escape

from sqlalchemy.orm.exc import NoResultFound, MultipleResultsFound

from api.v1_0.handlers.base import BaseHandler
from api.v1_0.models import User
import json


class RegisterHandler(BaseHandler):
    def post(self):
        try:
            stored_user = self.sess.query(User).filter_by(
                email=self.request.arguments['email']).one()

            if stored_user:
                self.send_error(400, message='Registration failed. '
                                             'Email already in use.')
                return

        except NoResultFound:
            pass

        except MultipleResultsFound:
            self.send_error(message='Registration failed. Multiple '
                                    'users found for the given email.')
            return

        new_user = User(
            first_name=self.request.arguments['first_name'],
            last_name=self.request.arguments['last_name'],
            email=self.request.arguments['email'],
            region_id=self.request.arguments['region_id'],
            password=self.request.arguments['password']
        )

        self.sess.add(new_user)
        self.sess.flush()
        self.set_cookie('user_id', str(new_user.id))
        self.sess.commit()


class FacebookAuthHandler(BaseHandler, tornado.auth.FacebookGraphMixin):
    @tornado.gen.coroutine
    def get(self):

        uri = 'http://{}:{}{}'.format(
            self.settings['hostname'],
            self.settings['bind_port'],
            self.reverse_url('facebook_auth')
        )

        if self.get_argument('code', None):
            user = yield self.get_authenticated_user(
                redirect_uri=uri,
                client_id=self.settings['facebook_oauth']['key'],
                client_secret=self.settings['facebook_oauth']['secret'],
                code=self.get_argument('code'),
            )

            if not user:
                self.clear_all_cookies()
                self.send_error(500, message='User facebook '
                                             'authentication failed.')
                return

            # check if this user is stored in the database
            try:
                stored_user = self.sess.query(User).filter_by(
                    facebook_id=user['id']).one()
                self.set_cookie('user_id', str(stored_user.id))
                return
            except NoResultFound:
                pass
            except MultipleResultsFound:
                self.send_error(500, 'Multiple users found for the given id.')
                return

            user_profile = yield self.facebook_request(
                path='/me',
                access_token=user['access_token'],
            )

            if not user_profile:
                self.send_error(500, message='User facebook profile '
                                             'access failed.')

            # save user to the database
            new_user = User(
                first_name=user_profile['first_name'],
                last_name=user_profile['last_name'],
                email=user_profile['email'],
                facebook_id=user_profile['id']
            )

            self.sess.add(new_user)
            self.flush()
            self.set_cookie('user_id', str(new_user.id))
            self.sess.commit()
            return

        yield self.authorize_redirect(
            redirect_uri=uri,
            client_id=self.settings['facebook_oauth']['key'],
            extra_params={'scope': 'email'}
        )


class GoogleAuthHandler(BaseHandler, GoogleOAuth2Mixin):
    @tornado.gen.coroutine
    def get(self):

        uri = 'http://{}:{}{}'.format(
            self.settings['hostname'],
            self.settings['bind_port'],
            self.reverse_url('google_auth')
        )

        if self.get_argument('code', False):
            user = yield self.get_authenticated_user(
                redirect_uri=uri,
                code=self.get_argument('code')
            )

            if not user:
                self.clear_all_cookies()
                self.send_error(500, message='User google '
                                             'authentication failed.')
                return

            access_token = str(user['access_token'])
            http_client = self.get_auth_http_client()
            response = yield http_client.fetch(
                'https://www.googleapis.com/oauth2/v1/userinfo?access_token'
                '=' + access_token)

            if not response:
                self.clear_all_cookies()
                self.send_error(500, message='User google '
                                             'profile access failed.')
                return

            user_profile = tornado.escape.json_decode(response.body)

            # check if user is stored in the database
            try:
                stored_user = self.sess.query(User).filter_by(
                    google_id=user_profile['id']).one()
                self.set_cookie('user_id', str(stored_user.id))
                return
            except NoResultFound:
                pass
            except MultipleResultsFound:
                self.send_error(message='Multiple users found for the given '
                                        'google_id.')

            # save user here, save to cookie or database
            new_user = User(
                first_name=user_profile['given_name'],
                last_name=user_profile['family_name'],
                email=user_profile['email'],
                google_id=user_profile['id']
            )

            self.sess.add(new_user)
            self.flush()
            self.set_cookie('user_id', str(new_user.id))
            self.sess.commit()
            return

        yield self.authorize_redirect(
            redirect_uri=uri,
            client_id=self.settings['google_oauth']['key'],
            scope=['profile', 'email'],
            response_type='code',
            extra_params={'approval_prompt': 'auto'}
        )


class LoginHandler(BaseHandler):
    def post(self):
        try:
            stored_user = self.sess.query(User).filter_by(
                email=self.request.arguments['email'],
                password=self.request.arguments['password']
            ).one()

            # user_data = {c.name: getattr(stored_user, c.name) for
            #              c in stored_user.__table__.columns}

        except NoResultFound:
            self.send_error(400, message='Login failed. Check your email '
                                         'and password.')
        except MultipleResultsFound:
            self.send_error(message='Login failed. Multiple users found '
                                    'for the given email.')
        else:
            self.set_cookie('user_id', str(stored_user.id))


class LogoutHandler(BaseHandler):
    def get(self):
        self.clear_all_cookies()
