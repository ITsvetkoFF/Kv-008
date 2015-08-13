# coding: utf-8
import os
from tornado.web import URLSpec, StaticFileHandler

from api.v1_0.handlers.photos import PhotoHandler
from api.v1_0.handlers.users import (
    UsersHandler,
    UserHandler
)
from api.v1_0.handlers.admin import PermissionHandler, RoleHandler
from api.v1_0.handlers.pages import (
    PageHandler,
    PagesHandler
)
from api.v1_0.handlers.allproblems import AllProblemsHandler
from api.v1_0.handlers.auth import (
    FacebookHandler,
    GooglePlusHandler,
    RegisterHandler,
    LoginHandler,
    LogoutHandler
)
from api.v1_0.handlers.problems import (
    ProblemsHandler,
    ProblemHandler,
    VoteHandler,
    ProblemPhotosHandler
)
from api.v1_0.handlers.comments import (
    CommentHandler,
    ProblemCommentsHandler
)
import docs
import static

# I noted those methods, that need permission control.
APIUrls = [
    URLSpec(r'/static/photos/(.*)', StaticFileHandler,
            {'path': static.PHOTOS_ROOT}),
    URLSpec(r'/static/thumbnails/(.*)', StaticFileHandler,
            {'path': static.THUMBNAILS_ROOT}),

    URLSpec(r'/api/register', RegisterHandler),
    URLSpec(r'/api/login', LoginHandler),
    URLSpec(r'/api/logout', LogoutHandler),
    URLSpec(r'/api/auth/facebook', FacebookHandler, name='fb_auth'),
    URLSpec(r'/api/auth/google', GooglePlusHandler, name='gp_auth'),

    # UsersHandler.get
    URLSpec(r'/api/users', UsersHandler),
    # UserHandler.put, UserHandler.delete, UserHandler.get
    URLSpec(r'/api/users/(\d+)', UserHandler),

    URLSpec(r'/api/allproblems', AllProblemsHandler),
    # ProblemsHandler.post
    URLSpec(r'/api/problems', ProblemsHandler),
    # ProblemHandler.put, ProblemHandler.delete
    URLSpec(r'/api/problems/(\d+)', ProblemHandler),
    # ProblemVoteHandler.post
    URLSpec(r'/api/problems/(\d+)/vote', VoteHandler),
    # ProblemPhotosHandler.post
    URLSpec(r'/api/problems/(\d+)/photos', ProblemPhotosHandler),
    # CommentsHandler.post
    URLSpec(r'/api/problems/(\d+)/comments', ProblemCommentsHandler),

    # PagesHandler.post
    URLSpec(r'/api/pages', PagesHandler),
    # PageHandler.put, PageHandler.delete
    URLSpec(r'/api/pages/(\d+)', PageHandler),

    # CommentHandler.put, CommentHandler.delete
    URLSpec(r'/api/comments/(\d+)', CommentHandler),

    # PhotoHandler.put, PhotoHandler.delete
    URLSpec(r'/api/photos/(\d+)', PhotoHandler),

    URLSpec(r'/api/docs/(.*)', StaticFileHandler,
            {'path': os.path.join(docs.DOCS_ROOT, 'build', 'html')}),

    URLSpec(r'/api/admin', PermissionHandler),
    URLSpec(r'/api/admin/role', RoleHandler)
]
