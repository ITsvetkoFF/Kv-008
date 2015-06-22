# coding: utf-8
import os
from tornado.web import URLSpec, StaticFileHandler

import api.v1_0.handlers.administration as admin
from api.v1_0.handlers.pages import PagesHandler, PagesListHandler
from api.v1_0.handlers.user import UserAPIHandler
from api.v1_0.handlers.allproblems import AllProblemsHandler
from api.v1_0.handlers.auth import (
    FacebookAuthHandler,
    GoogleAuthHandler,
    RegisterHandler,
    LoginHandler,
    LogoutHandler
)
from api.v1_0.handlers.problem import ProblemsHandler, ProblemVoteHandler
from api.v1_0.handlers.comments import CommentsHandler, ProblemCommentsHandler
from docs import DOCS_ROOT

APIUrls = [
    URLSpec(r'/api/v1/login', LoginHandler),
    URLSpec(r'/api/v1/logout', LogoutHandler),
    URLSpec(r'/api/v1/auth/facebook', FacebookAuthHandler, name='fb_auth'),
    URLSpec(r'/api/v1/auth/google', GoogleAuthHandler, name='google_auth'),
    URLSpec(r'/api/v1/register', RegisterHandler, name='register'),
    URLSpec(r'/api/v1/user', UserAPIHandler),
    URLSpec(r'/api/v1/problems/(\d+)/vote', ProblemVoteHandler),
    URLSpec(r'/api/v1/problems(?:/(\d+))?$',ProblemsHandler ),
    URLSpec(r'/api/v1/admin/roles', admin.RolesHandler),
    URLSpec(r'/api/v1/admin/roles/(\d+)/resources', admin.ResourcesHandler),
    URLSpec(r'/api/v1/pages', PagesListHandler),
    URLSpec(r'/api/v1/pages/(\d+)', PagesHandler),
    URLSpec(r'/api/v1/comments/(\d+)', CommentsHandler),
    URLSpec(r'/api/v1/problems/(\d+)/comments', ProblemCommentsHandler),
    URLSpec(r'/api/v1/allproblems', AllProblemsHandler),

    URLSpec(r'/api/docs/(.*)', StaticFileHandler,
            {'path': os.path.join(DOCS_ROOT, 'build', 'html')})
]
