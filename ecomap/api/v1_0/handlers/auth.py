import tornado.gen
import tornado.auth
import tornado.escape

from api.v1_0.handlers.base import BaseHandler
from api.v1_0.bl.auth_logic import *


class RegisterHandler(BaseHandler):
    def post(self):
        user_data = decode_json(self)
        if user_data is None:
            # there was an exception while decoding
            # response message was sent
            return
        form = create_user_register_form(user_data, self)
        if form is None:
            # there was an exception while checking fields
            # response message was sent
            return

        if form.validate():
            new_user_id = store_registered_new_user(self, user_data)
            set_cookie_with_login_informer(self, new_user_id)
        else:
            self.send_error(400, message='Invalid data sent.',
                            errors=form.errors)


class FacebookAuthHandler(BaseHandler, tornado.auth.FacebookGraphMixin):
    @tornado.gen.coroutine
    def get(self):
        uri = get_absolute_redirect_uri(self, 'fb_auth')

        if self.get_argument('code', None):
            user_data = yield self.get_authenticated_user(
                redirect_uri=uri,
                client_id=self.settings['fb_oauth']['key'],
                client_secret=self.settings['fb_oauth']['secret'],
                code=self.get_argument('code')
            )
            if not user_data:
                handle_client_failure('Facebook', 'Authentication failure.')
                return

            user = get_stored_user_by_3rd_party_id(
                self, 'facebook', user_data['id']
            )
            if user:
                set_cookie_with_login_informer(self, user.id)
                return

            user_profile = yield self.facebook_request(
                path='/me',
                access_token=user_data['access_token']
            )
            if not user_profile:
                handle_client_failure('Facebook', 'Profile access failure.')
                return

            new_user_id = store_fb_new_user(self, user_profile)
            set_cookie_with_login_informer(self, str(new_user_id))
            return

        yield self.authorize_redirect(
            redirect_uri=uri,
            client_id=self.settings['fb_oauth']['key'],
            extra_params={'scope': 'email'}
        )


class GoogleAuthHandler(BaseHandler, tornado.auth.GoogleOAuth2Mixin):
    @tornado.gen.coroutine
    def get(self):
        uri = get_absolute_redirect_uri(self, 'google_auth')

        if self.get_argument('code', None):
            user_data = yield self.get_authenticated_user(
                redirect_uri=uri,
                code=self.get_argument('code')
            )
            if not user_data:
                handle_client_failure('Google', 'Authentication failure.')
                return

            # google request for user profile
            response = yield self.get_auth_http_client().fetch(
                'https://www.googleapis.com/oauth2/v1/userinfo?access_token'
                '=' + str(user_data['access_token']))

            if not response:
                handle_client_failure('google', 'profile access failure')
                return

            user_profile = tornado.escape.json_decode(response.body)

            user = get_stored_user_by_3rd_party_id(
                self, 'google', user_profile['id']
            )
            if user:
                set_cookie_with_login_informer(self, user.id)
                return

            new_user_id = store_google_new_user(self, user_profile)
            set_cookie_with_login_informer(self, str(new_user_id))
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
        login_data = decode_json(self)
        if login_data is None:
            # there was an exception while decoding
            return

        form = create_user_login_form(login_data, self)
        if not form:
            return

        user = get_user_by_email(self, form.email.data)
        if user and user.password == form.password.data:
            set_cookie_with_login_informer(self, user.id)
        else:
            self.send_error(400, message='Invalid email and/or password.')


class LogoutHandler(BaseHandler):
    def get(self):
        self.clear_all_cookies()
        self.send_error(200, message='Logged out.')
