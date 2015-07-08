import sys
import random

from factories.problem import (
    ProblemActivityFactory,
    ProblemFactory,
    ProblemTypeFactory
)
from factories.comment import CommentFactory
from factories.user import (
    PermissionFactory,
    UserFactory,
    UserRoleFactory,
    RolePermissionFactory
)
import api.v1_0.models as md
import factories.common as cm

from api.utils.db import get_db_engine
from api import settings


HANDLERS = [
    'UsersHandler',
    'UserHandler',
    'ProblemsHandler',
    'ProblemHandler',
    'VoteHandler',
    'ProblemPhotosHandler',
    'ProblemCommentsHandler',
    'PagesHandler',
    'PageHandler',
    'CommentHandler',
    'PhotoHandler'
]

# first of all we need to configure the session
cm.Session.configure(bind=get_db_engine(settings))

# Give role_user permissions:
# * UserHandler GET, PUT, DELETE OWN
# * ProblemsHandler POST
# * ProblemHandler PUT, DELETE OWN
# * ProblemVoteHandler POST
# * ProblemCommentsHandler POST
# * PhotoHandler PUT, DELETE OWN
user_perms = dict()
user_perms['UserHandler'] = [
    ('GET', 'OWN'),
    ('PUT', 'OWN'),
    ('DELETE', 'OWN')
]
user_perms['ProblemsHandler'] = \
    user_perms['VoteHandler'] = [
    ('POST', 'ANY')
]
user_perms['ProblemHandler'] = \
    user_perms['PhotoHandler'] = \
    user_perms['CommentHandler'] = [
    ('PUT', 'OWN'),
    ('DELETE', 'OWN')
]
user_perms['ProblemCommentsHandler'] = \
    user_perms['ProblemPhotosHandler'] = [
    ('POST', 'OWN')
]

# Give role_admin permissions:
# * UsersHandler GET
# * UserHandler GET, PUT, DELETE ANY
# * ProblemHandler PUT, DELETE ANY
# * PagesHandler POST
# * PageHandler PUT, DELETE
# * CommentsHandler PUT, DELETE ANY
# * PhotoHandler PUT, DELETE ANY
admin_perms = dict()
admin_perms['UsersHandler'] = [
    ('GET', 'ANY'),
]
admin_perms['UserHandler'] = [
    ('GET', 'ANY'),
    ('PUT', 'ANY'),
    ('DELETE', 'ANY')
]
admin_perms['PagesHandler'] = \
    admin_perms['ProblemPhotosHandler'] = \
    admin_perms['ProblemCommentsHandler'] = [
    ('POST', 'ANY')
]
admin_perms['ProblemHandler'] = \
    admin_perms['PageHandler'] = \
    admin_perms['CommentHandler'] = \
    admin_perms['PhotoHandler'] = [
    ('PUT', 'ANY'),
    ('DELETE', 'ANY')
]


def get_args(item, handler):
    return dict(zip(
        ('perm__res', 'perm__action', 'perm__modifier'),
        # item is a tuple, so I use concatenation to enable zipping
        (handler,) + item
    ))


def main():
    # create admin and simple user roles
    role_admin = md.Role(name='admin')
    UserRoleFactory(role=role_admin, user__first_name='admin')
    role_user = md.Role(name='user')
    cm.Session.add(role_admin, role_user)

    # create all resources and permissions
    for name in HANDLERS:
        hdl = md.Resource(name=name)
        cm.Session.add(hdl)

        for item in user_perms.get(name, []):
            RolePermissionFactory(role=role_user, **get_args(item, hdl))

        for item in admin_perms.get(name, []):
            RolePermissionFactory(role=role_admin, **get_args(item, hdl))

    # I have to create all these  manually so I don't create duplicates.
    perms = [
        ('UsersHandler', 'GET', 'NONE'),
        ('PagesHandler', 'POST', 'NONE'),
        ('ProblemPhotosHandler', 'POST', 'NONE'),
        ('ProblemCommentsHandler', 'POST', 'NONE'),
        ('ProblemsHandler', 'POST', 'NONE'),
        ('VoteHandler', 'POST', 'NONE'),
        ('PageHandler', 'PUT', 'NONE'),
        ('PageHandler', 'DELETE', 'NONE')
    ]
    arg_name = ('res_name', 'action', 'modifier')
    for row in perms:
        cm.Session.add(md.Permission(**dict(zip(arg_name, row))))

    # create problem types
    types = [ProblemTypeFactory() for i in xrange(8)]

    # create problems, votes and comments
    for i in xrange(int(sys.argv[1])):
        p = ProblemFactory(problem_type=random.choice(types))
        u = UserFactory()

        UserRoleFactory(role=role_user, user=u)
        ProblemActivityFactory(user=u, problem=p, activity_type='ADDED')
        ProblemActivityFactory(user=u, problem=p, activity_type='VOTE')
        CommentFactory(user=u, problem=p)

    cm.Session.commit()


if __name__ == '__main__':
    main()
