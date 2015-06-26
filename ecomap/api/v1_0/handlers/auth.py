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
            new_user = store_registered_new_user(self, form.data)
            # if new_user is None then email is not unique and error
            # has already been sent to the user
            if new_user is not None:
                respond_to_authed_user(self, new_user)
        else:
            self.send_error(400, message=form.errors)


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
                new_user = store_fb_new_user(self, user_profile)
                if new_user is not None:
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
                new_user_id = store_google_new_user(self, user_profile)
                if new_user_id:
                    self.set_cookie('user_id', str(new_user_id))
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
        """Logs in a user.
        Sets a cookie named ``user_id`` in case of success.

        ``email`` and ``password`` key-value pairs are required.
        """
        form = UserLoginForm.from_json(self.request.arguments)
        if not form.validate():
            self.send_error(400, message=form.errors)
            return

        user = load_user_by_email(self, form.email.data)
        # check if user exists and her passwords matches
        if user and user.password == form.password.data:
            # for production use set_secure_cookie method
            respond_to_authed_user(self, user)
        else:
            self.send_error(400, message='Invalid email/password.')


class LogoutHandler(BaseHandler):
    def get(self):
        """Logs out a user."""
        self.clear_all_cookies()
