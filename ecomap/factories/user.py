import factory
from factory.alchemy import SQLAlchemyModelFactory

import api.v1_0.models as md
import factories.common as cm


class RoleFactory(SQLAlchemyModelFactory):
    class Meta:
        model = md.Role
        sqlalchemy_session = cm.Session

    name = None


class UserFactory(SQLAlchemyModelFactory):
    class Meta:
        model = md.User
        sqlalchemy_session = cm.Session

    first_name = factory.Sequence(lambda n: 'user%d' % n)

    last_name = factory.LazyAttribute(
        lambda obj: '%s_lastname' % obj.first_name)

    email = factory.LazyAttribute(
        lambda obj: '%s@example.com' % obj.first_name)

    password = factory.LazyAttribute(
        lambda obj: '%s_pass' % obj.first_name)



class UserRoleFactory(SQLAlchemyModelFactory):
    class Meta:
        model = md.UserRole
        sqlalchemy_session = cm.Session

    user = factory.SubFactory(UserFactory)
    role = None


class PermissionFactory(SQLAlchemyModelFactory):
    class Meta:
        model = md.Permission
        sqlalchemy_session = cm.Session

    res = None
    action = None
    modifier = None


class RolePermissionFactory(SQLAlchemyModelFactory):
    class Meta:
        model = md.RolePermission
        sqlalchemy_session = cm.Session

    role = None
    perm = factory.SubFactory(PermissionFactory)
