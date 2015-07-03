import sys
import random

from api.v1_0.urls import APIUrls
from factories.problem import (
    ProblemActivityFactory,
    ProblemFactory,
    ProblemTypeFactory
)
from factories.comment import CommentFactory
from factories.user import (
    UserFactory,
    ResourceFactory,
    PermissionFactory,
    RoleFactory
)
from api.v1_0.models import *
import api.v1_0.tests.common as common


for handler_name in [urlspec.handler_class.__name__ for urlspec in APIUrls]:
    resource = ResourceFactory(name=handler_name)
    for action in ACTIONS:
        for modifier in MODIFIERS:
            perm = PermissionFactory(
                resource=resource,
                action=action,
                modifier=modifier
            )

role_admin = RoleFactory(name='admin')
role_admin.permissions.extend(common.Session.query(Permission).filter_by(
    modifier='ANY').all())

# ProblemHandler id
ph_id = common.Session.query(Resource).filter(
    Resource.name == 'ProblemHandler').first().id

role_user = RoleFactory(name='user')
role_user.permissions.extend(common.Session.query(Permission).filter(
    Permission.resource_id == ph_id).filter(
    Permission.modifier == 'ANY').filter(
    Permission.action == 'GET').all())
role_user.permissions.extend(common.Session.query(Permission).filter_by(
    modifier='OWN').filter(Permission.resource_id != ph_id).all())

user_admin = UserFactory(first_name='user', last_name='admin')
user_admin.roles.append(role_admin)

# prepopulate problem types
for i in xrange(5):
    ProblemTypeFactory()

problem_types = common.Session.query(ProblemType).all()

for i in xrange(int(sys.argv[1])):
    problem = ProblemFactory(
        problem_type=random.choice(problem_types),
        status=random.choice(STATUSES),
        severity=random.choice(SEVERITY_TYPES)
    )

    user = UserFactory()
    user.roles.append(role_user)

    kwargs = dict(user=user, problem=problem)
    ProblemActivityFactory(
        activity_type='ADDED',
        **kwargs
    )
    ProblemActivityFactory(
        activity_type='VOTE',
        **kwargs
    )
    ProblemActivityFactory(
        # Now you remove, update or vote for the problem
        activity_type=random.choice(ACTIVITY_TYPES[1:]),
        **kwargs
    )
    CommentFactory(**kwargs)

common.Session.commit()
