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
    RolePermissionFactory,
    UserRoleFactory,
    RoleFactory
)
from api.v1_0.models import *
import api.v1_0.tests.common as common


if __name__ == '__main__':
    role_admin = RoleFactory(name='admin')
    role_user = RoleFactory(name='user')

    # insert resources and permissions
    for x in xrange(8):
        res = ResourceFactory()

    common.Session.commit()
    for res in common.Session.query(Resource):
        for a in ACTIONS:
            perm = PermissionFactory(action=a, resource_name=res.name)
            # need to commit to get perm.id
            common.Session.commit()

            RolePermissionFactory(
                role=role_admin.name,
                permission=perm.id
            )
            # populate role_user with the same permissions
            RolePermissionFactory(
                role=role_user.name,
                permission=perm.id
            )

    user_admin = UserFactory(first_name='user', last_name='admin')
    common.Session.commit()

    UserRoleFactory(user=user_admin.id, role=role_admin.name)
    UserRoleFactory(user=user_admin.id, role=role_user.name)
    common.Session.commit()

    # insert problem types
    for i in xrange(8):
        ProblemTypeFactory()

    problem_types = common.Session.query(ProblemType).all()

    for i in xrange(int(sys.argv[1])):
        problem = ProblemFactory(
            problem_type=random.choice(problem_types),
            status=random.choice(STATUSES),
            severity=random.choice(SEVERITY_TYPES)
        )

        user = UserFactory()
        common.Session.commit()

        UserRoleFactory(user=user.id, role=role_user.name)

        kwargs = dict(user=user, problem=problem)
        # first you add a problem
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
