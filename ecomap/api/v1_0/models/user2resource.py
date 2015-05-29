from sqlalchemy.orm import mapper
from api.v1_0.models import metadata


class User(object):
    def __init__(self, first_name, last_name, email, password, region_id):
        self.first_name = first_name
        self.last_name = last_name
        self.email = email
        self.password = password
        self.region_id = region_id


mapper(User, metadata.tables['users'])


class UserRole(object):
    """Mapped to the association table between users and roles."""


mapper(UserRole, metadata.tables['users_roles'])


class RolePermission(object):
    """Mapped to the association table between roles and permissions."""


mapper(RolePermission, metadata.tables['roles_permissions'])


class Permission(object):
    pass


mapper(Permission, metadata.tables['permissions'])


class Resource(object):
    pass


mapper(Resource, metadata.tables['resources'])
