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
from factories import session
from api.v1_0.models import *

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
role_admin.permissions.extend(session.query(Permission).filter_by(
    modifier='ANY').all())

role_user = RoleFactory(name='user')
role_user.permissions.extend(session.query(Permission).filter_by(
    modifier='NONE').all()[:5])
role_user.permissions.extend(session.query(Permission).filter_by(
    modifier='OWN').all()[5:])

user_admin = UserFactory(first_name='user', last_name='admin')
user_admin.roles.append(role_admin)

# prepopulate problem types
for i in xrange(5):
    ProblemTypeFactory()

problem_types = session.query(ProblemType).all()

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
        activity_type=random.choice(ACTIVITY_TYPES),
        **kwargs
    )
    CommentFactory(**kwargs)

session.commit()
