import tornado.web
import tornado.auth


class LoginHandler(tornado.web.RequestHandler):

    def get(self):
        self.write("""\
        <html>
        <body>
        <form action="/auth/login" method="POST">
        Email: <input type="email" name="email"><br>
        Password: <input type="password" name="password"><br>
        <input type="submit" value="Sign in"><br>
        </form>
        <p>Sign in with <a href="/auth/login/facebook">Facebook</a> or
        <a href="#">Gmail</a></p>
        <p><a href="#">Register</a></p>
        </body>
        </html>\
        """)

    def post(self):
        email = self.get_argument('email')
        password= self.get_argument('password')

        # look up the user in the database
        if email and password:
            pass


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
        # user has authenticated
        userName = self.get_secure_cookie('user_name')
        userEmail = self.get_secure_cookie('email')
        if userName and userEmail:
            self.redirect('/api/v1/user')
            return

        # user has authorized our access to her email
        if self.get_argument('code', None):
            self.get_authenticated_user(
                redirect_uri='http://localhost:8001/auth/login/facebook',
                client_id=self.settings['facebook_api_key'],
                client_secret=self.settings['facebook_secret'],
                code=self.get_argument('code'),
                callback=self._on_facebook_login
            )
            return

        # a new user, getting authorization
        self.authorize_redirect(
            redirect_uri='http://localhost:8001/auth/login/facebook',
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

        # self.write(user)
        # self.finish()
        self.set_secure_cookie('user_name', user['name'])
        self.set_secure_cookie('email', user['email'])
        self.redirect('/api/v1/user')
