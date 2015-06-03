# coding: utf-8
import os
from tornado.web import URLSpec, StaticFileHandler

from api.v1_0.handlers.user import UserAPIHandler
from api.v1_0.handlers.auth import FacebookAuthHandler, GoogleAuthHandler, \
    RegisterHandler, LoginHandler, LogoutHandler
from api.v1_0.handlers.problem import ProblemVoteHandler
from docs import DOCS_ROOT

APIUrls = [
    URLSpec(r'/api/v1/login', LoginHandler),
    URLSpec(r'/api/v1/logout', LogoutHandler),
    URLSpec(r'/api/v1/auth/facebook', FacebookAuthHandler,
            name='facebook_auth'),
    URLSpec(r'/api/v1/auth/google', GoogleAuthHandler,
            name='google_auth'),
    URLSpec(r'/api/v1/register', RegisterHandler,
            name='register'),
    URLSpec(r'/api/v1/user', UserAPIHandler),
    URLSpec(r'/api/v1/problems/(\d+)/vote', ProblemVoteHandler),

    URLSpec(r'/api/docs/(.*)', StaticFileHandler,
            {'path': os.path.join(DOCS_ROOT, 'build', 'html')})
]
