# coding: utf-8
import os
import tornado
from api.v1_0.handlers.user import (
    OAuth2APIHandler,
    UserAPIHandler,
)
from docs import DOCS_ROOT


PublicUrls = [
    (r'/api/v1/authorize/?', OAuth2APIHandler),
    (r'/api/v1/user/?', UserAPIHandler),
]

# third argument is passed to initialize() method of StaticFileHandler class
DocsUrls = [
    (r'/api/docs/(.*)', tornado.web.StaticFileHandler, {
        'path': os.path.join(DOCS_ROOT, 'build', 'html')
    }),
]

APIUrls = PublicUrls + DocsUrls
