# coding: utf-8
import os
from tornado.web import URLSpec, StaticFileHandler

#import api.v1_0.handlers.administration as admin

from api.v1_0.handlers.user import UserHandler
from api.v1_0.handlers.auth import FacebookAuthHandler, GoogleAuthHandler, \
    RegisterHandler, LoginHandler, LogoutHandler
from api.v1_0.handlers.problem import ProblemVoteHandler, ProblemsHandler
from docs import DOCS_ROOT
from testmodule import TestHandler

APIUrls = [
    URLSpec(r'/api/v1/login', LoginHandler),
    URLSpec(r'/api/v1/logout', LogoutHandler),
    URLSpec(r'/api/v1/auth/facebook', FacebookAuthHandler,
            name='facebook_auth'),
    URLSpec(r'/api/v1/auth/google', GoogleAuthHandler,
            name='google_auth'),
    URLSpec(r'/api/v1/register', RegisterHandler,
            name='register'),
    URLSpec(r'/api/v1/user', UserHandler),
    URLSpec(r'/api/v1/problems/(\d+)/vote', ProblemVoteHandler),
    URLSpec(r'/api/v1/problems/(\d+)',ProblemsHandler ),
    URLSpec(r'/api/v1/test/(\d+)', TestHandler),

    URLSpec(r'/api/docs/(.*)', StaticFileHandler,
            {'path': os.path.join(DOCS_ROOT, 'build', 'html')}),

    URLSpec(r'/api/v1/admin/roles', admin.RolesHandler),
    URLSpec(r'/api/v1/admin/roles/(\d+)/resources', admin.ResourcesHandler),
    URLSpec(r'/api/v1/user/(\d+)', UserHandler),

]
