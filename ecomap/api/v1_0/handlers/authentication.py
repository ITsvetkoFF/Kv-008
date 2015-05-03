import tornado.web
import tornado.auth


class LoginHandler(tornado.web.RequestHandler):

    def get(self):
        self.write("""\
        <html>
        <body>
        <form action="/auth/login" method="POST">
        Name: <input type="text" name="name">
        <input type="submit" value="Sign in"><br>
        </form>
        <p>Sign in with <a href="/auth/login/facebook">Facebook</a> or
        <a href="#">Gmail</a></p>
        </body>
        </html>\
        """)

    def post(self):
        user_name = self.get_argument('name')
        if user_name:
            self.set_secure_cookie('user_name', user_name)
            self.redirect('/api/v1/user')


class FacebookLoginHandler(tornado.web.RequestHandler,
                           tornado.auth.FacebookGraphMixin):
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
        if self.get_argument('code', None):
            print 'authorization code found ==> getting access_token'
            self.get_authenticated_user(
                redirect_uri='http://localhost:8001/auth/login/facebook',
                client_id=self.settings['facebook_api_key'],
                client_secret=self.settings['facebook_secret'],
                code=self.get_argument('code'),
                callback=self._on_facebook_login
            )
            return
        elif self.get_secure_cookie('access_token'):
            print 'access_token found ==> redirecting to /api/v1/user'
            self.redirect('/api/v1/user')
            return

        print 'getting authorization code'
        self.authorize_redirect(
            redirect_uri='http://localhost:8001/auth/login/facebook',
            client_id=self.settings['facebook_api_key'],
            extra_params={'scope': 'public_profile,email'}
        )

    def _on_facebook_login(self, user):
        if not user:
            self.clear_all_cookies()
            raise tornado.web.HTTPError(500, 'Facebook authentication failed')

        self.set_secure_cookie('user_name', str(user['name']))
        self.set_secure_cookie('access_token', str(user['access_token']))
        print 'cookies set ==> redirecting to /api/v1/user'
        self.redirect('/api/v1/user')
