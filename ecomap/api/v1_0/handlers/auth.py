import urllib as urllib_parse
import functools
import tornado.web
import tornado.auth
import tornado.escape

from ecomap.api.v1_0.handlers.base import BaseHandler


class RegisterHandler(BaseHandler):
    def get(self, user_id):
        self.set_cookie('user_id', user_id)
        self.redirect('/api/v1/user')


class FacebookLoginHandler(BaseHandler, tornado.auth.FacebookGraphMixin):
    """This class implements Facebook authentication using the Graph API.

    Authentication scheme
    1. A user is directed to the Facebook platform to authorize the app.
    2. Facebook uses an HTTP redirect to send the user back to the server with
     an authorization code (authorized temporary credentials).
    3. The server receives the request with the code and requests an access
    token from Facebook, which is used to identify the user making the API
    requests.
    """

    @tornado.web.asynchronous
    def get(self):
        # user has authenticated
        userName = self.get_secure_cookie('user_name')
        userEmail = self.get_secure_cookie('email')
        if userName and userEmail:
            self.redirect(self.settings['default_redirect'])
            return

        # user has authorized our access to her email
        uri = 'http://{}:{}/auth/login/facebook' \
            .format(self.settings['hostname'], self.settings['bind_port'])
        if self.get_argument('code', None):
            self.get_authenticated_user(
                redirect_uri=uri,
                client_id=self.settings['facebook_api_key'],
                client_secret=self.settings['facebook_secret'],
                code=self.get_argument('code'),
                callback=self._on_facebook_login
            )
            return

        # a new user, getting authorization
        self.authorize_redirect(
            redirect_uri=uri,
            client_id=self.settings['facebook_api_key'],
            extra_params={'scope': 'email'}
        )

    # getting user profile information
    def _on_facebook_login(self, user):
        if not user:
            self.clear_all_cookies()
            raise tornado.web.HTTPError(500, 'Facebook authentication failed')

        # getting user profile from Facebook (we need her email)
        self.facebook_request(
            path='/me',
            access_token=user['access_token'],
            callback=self._save_user_profile
        )

    # settings cookies
    def _save_user_profile(self, user):
        if not user:
            raise tornado.web.HTTPError(500, 'Facebook user '
                                             'profile access failed')

        self.set_secure_cookie('user_name', user['name'])
        self.set_secure_cookie('email', user['email'])
        self.redirect(self.settings['default_redirect'])


# Google auth

class GoogleLoginHandler(BaseHandler, tornado.auth.GoogleOAuth2Mixin):
    @tornado.gen.coroutine
    def get(self):
        uri = 'http://{}:{}/auth/login/google' \
            .format(self.settings['hostname'], self.settings['bind_port'])

        if self.get_argument('code', False):
            user = yield self.get_authenticated_user(
                redirect_uri=uri,
                code=self.get_argument('code'),
            )
            # request for user profile (user_name, email)
            yield self.google_request(path='/me',
                                      access_token=user['access_token'],
                                      callback=self._save_user_profile)

        else:
            yield self.authorize_redirect(
                redirect_uri=uri,
                client_id=self.settings['google_oauth']['key'],
                scope=['profile', 'email'],
                response_type='code',
                extra_params={'approval_prompt': 'auto'})

    @tornado.auth._auth_return_future
    def google_request(self, path, callback, access_token=None,
                       post_args=None, **args):
        url = 'https://www.googleapis.com/plus/v1/people' + path
        all_args = {}
        if access_token:
            all_args["access_token"] = access_token
            all_args.update(args)

        if all_args:
            url += "?" + urllib_parse.urlencode(all_args)
        callback = functools.partial(self._on_google_request, callback)
        http = self.get_auth_http_client()
        if post_args is not None:
            http.fetch(url, method="POST",
                       body=urllib_parse.urlencode(post_args),
                       callback=callback)
        else:
            http.fetch(url, callback=callback)

    def _on_google_request(self, future, response):
        if response.error:
            future.set_exception(
                tornado.auth.AuthError("Erorr response %s fetching %s" %
                                       (response.error, response.request.url)))
            return

        future.set_result(tornado.escape.json_decode(response.body))

    # set secure cookie with user_name and email
    def _save_user_profile(self, user):
        if not user:
            raise tornado.web.HTTPError(500, 'Google user '
                                             'profile access failed')
        self.set_secure_cookie('user_name', user['displayName'])
        self.set_secure_cookie('email', user['emails'][0]['value'])
        self.redirect(self.settings['default_redirect'])
