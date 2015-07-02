import factory
from factory.alchemy import SQLAlchemyModelFactory

import api.v1_0.models as models
import api.v1_0.tests.common as common


class RoleFactory(SQLAlchemyModelFactory):
    class Meta:
        model = models.Role
        sqlalchemy_session = common.Session

    name = None


class UserFactory(SQLAlchemyModelFactory):
    """Creates a new user. You need to append role object to its attribute
    roles manually."""

    class Meta:
        model = models.User
        sqlalchemy_session = common.Session

    first_name = factory.sequence(lambda n: 'user_%s' % n)
    last_name = factory.lazy_attribute(
        lambda obj: '%s_last_name' % obj.first_name)
    email = factory.lazy_attribute(
        lambda obj: '%s@example.com' % obj.first_name)
    password = factory.lazy_attribute(lambda obj: '%s_pass' % obj.first_name)


class PermissionFactory(SQLAlchemyModelFactory):
    class Meta:
        model = models.Permission
        sqlalchemy_session = common.Session

    resource = None
    action = None
    modifier = None


class ResourceFactory(SQLAlchemyModelFactory):
    class Meta:
        model = models.Resource
        sqlalchemy_session = common.Session

    name = None
