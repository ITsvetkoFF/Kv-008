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


role_admin = RoleFactory(name='admin')

# populate resources and permissions
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


role_user = RoleFactory(name='user')
user_admin = UserFactory(first_name='user', last_name='admin')
common.Session.commit()

UserRoleFactory(user=user_admin.id, role=role_admin.name)
common.Session.commit()
