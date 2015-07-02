import tornado.gen
import tornado.auth
import tornado.escape

from api.v1_0.handlers.base import BaseHandler
from api.v1_0.forms.user import UserRegisterForm, UserLoginForm
from api.v1_0.bl.auth import *


class RegisterHandler(BaseHandler):
    def post(self):
        """Registers a new user.

        If received data is valid, creates a new ``User``, stores it into
        the database and sets a cookie named ``user_id``.

        ``first_name``, ``last_name``, ``email`` and ``password`` key-value
        pairs are required.
        """
        form = UserRegisterForm.from_json(self.request.arguments)
        if form.validate():
            new_user = store_new_user(self.sess, create_new_user(form.data))
            # if new_user is None then email is not unique
            if not new_user:
                return self.send_error(400, message='Email already in use.')

            complete_authentication(self, new_user)
        else:
            self.send_error(400, message=form.errors)


class FacebookHandler(BaseHandler):
    def post(self):
        user = self.sess.query(User).filter(
            User.facebook_id == self.request.arguments['id']).first()

        if user:
            complete_authentication(self, user)
        else:
            new_user = store_new_user(
                self.sess, create_fb_user(self.request.arguments))
            # If new_user is None, then her email is already in the database,
            # and that means, that she has registered directly using our
            # registration form.
            if not new_user:
                return self.send_error(400, message='Email already in use.')

            complete_authentication(self, new_user)


class LoginHandler(BaseHandler):
    def post(self):
        """Logs in a user.
        Sets a cookie ``user_id`` and writes user's ``first_name`` and
        ``last_name`` to the client (so it can display them in the navbar).

        ``email`` and ``password`` key-value pairs are required in request
        JSON payload.

        If user authentication fails, a client gets 400 response status code
        and a message *"Invalid email/password."*.
        """
        form = UserLoginForm.from_json(self.request.arguments)
        if not form.validate():
            return self.send_error(400, message=form.errors)

        user = load_user_by_email(self, form.email.data)
        # check if user exists and her password matches
        if user and user.password == form.password.data:
            complete_authentication(self, user)
        else:
            self.send_error(400, message='Invalid email/password.')


class LogoutHandler(BaseHandler):
    def get(self):
        """Logs out a user."""
        self.clear_all_cookies()


class FacebookAuthHandler(BaseHandler, tornado.auth.FacebookGraphMixin):
    @tornado.gen.coroutine
    def get(self):
        """Authenticates a user using Facebook OAuth2 service.

        In case of success sets a cookie named ``user_id``.
        """
        uri = get_absolute_redirect_uri(self, 'fb_auth')

        if self.get_argument('code', None):
            user_data = yield self.get_authenticated_user(
                redirect_uri=uri,
                client_id=self.settings['fb_oauth']['key'],
                client_secret=self.settings['fb_oauth']['secret'],
                code=self.get_argument('code')
            )
            if not user_data:
                self.send_error(500, message='Facebook authentication failed.')
                return

            user = self.sess.query(User).filter(
                User.facebook_id == user_data['id']).first()
            # check if this user exists in the database
            if user:
                self.set_cookie('user_id', str(user.id))
                return

            user_profile = yield self.facebook_request(
                path='/me',
                access_token=user_data['access_token']
            )
            if not user_profile:
                self.send_error(500, message='Facebook profile access failed.')
            else:
                new_user = store_new_user(
                    self.sess, create_fb_user(user_profile))
                if not new_user:
                    self.send_error(400, message='Email already in use.')
                    return

                self.set_cookie('user_id', str(new_user.id))
            return

        yield self.authorize_redirect(
            redirect_uri=uri,
            client_id=self.settings['fb_oauth']['key'],
            extra_params={'scope': 'email'}
        )


class GoogleAuthHandler(BaseHandler, tornado.auth.GoogleOAuth2Mixin):
    @tornado.gen.coroutine
    def get(self):
        """Authenticates a user using Google OAuth2 service.

        In case of success sets a cookie named ``user_id``.
        """
        uri = get_absolute_redirect_uri(self, 'google_auth')

        if self.get_argument('code', None):
            user_data = yield self.get_authenticated_user(
                redirect_uri=uri,
                code=self.get_argument('code')
            )
            if not user_data:
                self.send_error(500, message='Google authentication failed.')
                return

            # google request for user profile
            response = yield self.get_auth_http_client().fetch(
                'https://www.googleapis.com/oauth2/v1/userinfo?access_token'
                '=' + str(user_data['access_token']))

            if not response:
                self.send_error(500, message='Google profile access failed.')
                return

            user_profile = tornado.escape.json_decode(response.body)
            # load user with this google id, if she exists
            # Need to check whether this email is stored in the database.
            # In this case the user has already registered using register
            # facebook routes.
            user = self.sess.query(User).filter(
                User.google_id == user_profile['id']).first()

            if user:
                self.set_cookie('user_id', str(user.id))
            else:
                new_user = store_new_user(
                    self.sess, create_google_user(user_profile))
                if not new_user:
                    self.send_error(400, message='Email already in use.')
                    return

                self.set_cookie('user_id', str(new_user.id))
            return

        yield self.authorize_redirect(
            redirect_uri=uri,
            client_id=self.settings['google_oauth']['key'],
            scope=['profile', 'email'],
            response_type='code',
            extra_params={'approval_prompt': 'auto'}
        )
