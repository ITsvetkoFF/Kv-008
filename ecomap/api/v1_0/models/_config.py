from sqlalchemy import Column, Integer, String, ForeignKey, Table
from sqlalchemy.ext.declarative import declarative_base
import sqlalchemy.orm as orm


STATUSES = ('SOLVED', 'UNSOLVED')
ACTIVITY_TYPES = ('ADDED', 'REMOVED', 'UPDATED', 'VOTE')
SEVERITY_TYPES = ('1', '2', '3', '4', '5')
MODIFIERS = ('ANY', 'OWN', 'NONE')
ACTIONS = ('GET', 'PUT', 'POST', 'DELETE')

Base = declarative_base()

role_permissions = Table(
    'role_permissions', Base.metadata,
    Column('role', String(100), ForeignKey('roles.name'),
           primary_key=True),
    Column('permission', Integer, ForeignKey('permissions.id'),
           primary_key=True)
)

# mapping classes to use joins
class RolePermission(object):
    pass


orm.mapper(RolePermission, role_permissions)

user_roles = Table(
    'user_roles', Base.metadata,
    Column('user', Integer, ForeignKey('users.id'), primary_key=True),
    Column('role', String(100), ForeignKey('roles.name'), primary_key=True),
)


class UserRole(object):
    pass


orm.mapper(UserRole, user_roles)
