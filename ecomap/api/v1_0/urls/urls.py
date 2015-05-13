# coding: utf-8
import os
import tornado
from api.v1_0.handlers.user import UserAPIHandler
from api.v1_0.handlers.auth import LoginHandler, FacebookLoginHandler, GoogleLoginHandler
from docs import DOCS_ROOT


UserUrls = [
    (r'/auth/login', LoginHandler),
    (r'/auth/login/facebook', FacebookLoginHandler),
    (r'/auth/login/google', GoogleLoginHandler),
]

APIUrls = [
    (r'/api/v1/user/?', UserAPIHandler)
]

# third argument is passed to initialize() method of StaticFileHandler class
DocsUrls = [
    (r'/api/docs/(.*)', tornado.web.StaticFileHandler, {
        'path': os.path.join(DOCS_ROOT, 'build', 'html')
    }),
]

UrlsTable = UserUrls + APIUrls + DocsUrls
