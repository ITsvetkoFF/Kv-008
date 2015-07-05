# coding: utf-8
import os
from tornado.web import URLSpec, StaticFileHandler

from api.v1_0.handlers.photos import PhotoHandler
from api.v1_0.handlers.users import UsersHandler, UserHandler
from api.v1_0.handlers.admin import (
    RolesHandler,
    ResourcesHandler
)
from api.v1_0.handlers.pages import (
    PageHandler,
    PagesHandler
)
from api.v1_0.handlers.allproblems import AllProblemsHandler
from api.v1_0.handlers.auth import (
    RegisterHandler,
    LoginHandler,
    LogoutHandler,
    FacebookHandler
)
from api.v1_0.handlers.problems import (
    ProblemsHandler,
    ProblemHandler,
    ProblemVoteHandler,
    ProblemPhotosHandler
)
from api.v1_0.handlers.comments import (
    CommentsHandler,
    ProblemCommentsHandler
)
import docs
import static

APIUrls = [
    URLSpec(r'/static/photos/(.*)', StaticFileHandler,
            {'path': static.PHOTOS_ROOT}),
    URLSpec(r'/static/thumbnails/(.*)', StaticFileHandler,
            {'path': static.THUMBNAILS_ROOT}),

    URLSpec(r'/api/register', RegisterHandler),
    URLSpec(r'/api/login', LoginHandler),
    URLSpec(r'/api/logout', LogoutHandler),
    URLSpec(r'/api/auth/facebook', FacebookHandler),

    URLSpec(r'/api/users', UsersHandler),
    URLSpec(r'/api/users/(\d+)', UserHandler),

    URLSpec(r'/api/allproblems', AllProblemsHandler),
    URLSpec(r'/api/problems', ProblemsHandler),
    URLSpec(r'/api/problems/(\d+)', ProblemHandler),
    URLSpec(r'/api/problems/(\d+)/vote', ProblemVoteHandler),
    URLSpec(r'/api/problems/(\d+)/photos', ProblemPhotosHandler),
    URLSpec(r'/api/problems/(\d+)/comments', ProblemCommentsHandler),

    URLSpec(r'/api/admin/roles', RolesHandler),
    URLSpec(r'/api/admin/roles/(\d+)/resources', ResourcesHandler),

    URLSpec(r'/api/pages', PagesHandler),
    URLSpec(r'/api/pages/(\d+)', PageHandler),

    URLSpec(r'/api/comments/(\d+)', CommentsHandler),

    URLSpec(r'/api/photos/(\d+)', PhotoHandler),

    URLSpec(r'/api/docs/(.*)', StaticFileHandler,
            {'path': os.path.join(docs.DOCS_ROOT, 'build', 'html')})
]
