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

from factories import RESOURCES


if __name__ == '__main__':
    role_admin = RoleFactory(name='admin')
    role_user = RoleFactory(name='user')
    # role without permissions
    role = RoleFactory(name='role')

    # insert resources and permissions
    for name in RESOURCES:
        res = ResourceFactory(name=name)

    common.Session.commit()
    for res in common.Session.query(Resource):
        for a in ACTIONS:
            perm_any = PermissionFactory(action=a,
                                         resource_name=res.name,
                                         modifier='ANY')
            perm_own = PermissionFactory(action=a,
                                         resource_name=res.name,
                                         modifier='OWN')
            # need to commit to get id
            common.Session.commit()

            # populate role_admin with 'ANY' permissions
            RolePermissionFactory(
                role=role_admin.name,
                permission=perm_any.id
            )
            # populate role_user with the 'OWN' permissions
            RolePermissionFactory(
                role=role_user.name,
                permission=perm_own.id
            )

    user_admin = UserFactory(first_name='user', last_name='admin')
    user = UserFactory(first_name='No', last_name='Permissions')
    common.Session.commit()

    UserRoleFactory(user=user_admin.id, role=role_admin.name)
    UserRoleFactory(user=user_admin.id, role=role_user.name)
    UserRoleFactory(user=user.id, role=role.name)
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
