import factory
from factory.alchemy import SQLAlchemyModelFactory

from api.v1_0.models import *
from factories import session


class RoleFactory(SQLAlchemyModelFactory):
    class Meta:
        model = Role
        sqlalchemy_session = session

    name = None


class UserFactory(SQLAlchemyModelFactory):
    """Creates a new user. You need to append role object to its attribute
    roles manually."""

    class Meta:
        model = User
        sqlalchemy_session = session

    first_name = factory.sequence(lambda n: 'user_%s' % n)
    last_name = factory.lazy_attribute(
        lambda obj: '%s_last_name' % obj.first_name)
    email = factory.lazy_attribute(
        lambda obj: '%s@example.com' % obj.first_name)
    password = factory.lazy_attribute(lambda obj: '%s_pass' % obj.first_name)


class PermissionFactory(SQLAlchemyModelFactory):
    class Meta:
        model = Permission
        sqlalchemy_session = session

    resource = None
    action = None
    modifier = None


class ResourceFactory(SQLAlchemyModelFactory):
    class Meta:
        model = Resource
        sqlalchemy_session = session

    name = None
