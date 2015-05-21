# coding: utf-8
import os
import tornado
from ecomap.api.v1_0.handlers.user import UserAPIHandler
from ecomap.api.v1_0.handlers.auth import FacebookLoginHandler,\
    GoogleLoginHandler, RegisterHandler
from ecomap.docs import DOCS_ROOT


DemoUrls = [
    # (r'/auth/login', LoginHandler),
    (r'/auth/login/facebook', FacebookLoginHandler),
    (r'/auth/login/google', GoogleLoginHandler),
    (r'/auth/register/(\d+)', RegisterHandler)
]

APIUrls = [
    (r'/api/v1/user', UserAPIHandler)
]

# third argument is passed to initialize() method of StaticFileHandler class
APIDocsUrls = [
    (r'/api/docs/(.*)', tornado.web.StaticFileHandler, {
        'path': os.path.join(DOCS_ROOT, 'build', 'html')
    }),
]

UrlsTable = DemoUrls + APIUrls + APIDocsUrls
