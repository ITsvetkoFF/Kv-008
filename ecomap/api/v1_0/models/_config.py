from sqlalchemy import Column, Integer, String, ForeignKey, Table
from sqlalchemy.ext.declarative import declarative_base


STATUSES = ('SOLVED', 'UNSOLVED')
ACTIVITY_TYPES = ('ADDED', 'REMOVED', 'UPDATED')
SEVERITY_TYPES = ('1', '2', '3', '4', '5')
MODIFIERS = ('ANY', 'OWN', 'NONE')
ACTIONS = ('GET', 'PUT', 'POST', 'DELETE')

Base = declarative_base()

role_permissions = Table(
    'role_permissions', Base.metadata,
    Column('role', Integer, ForeignKey('roles.id'), primary_key=True,
           nullable=False),
    Column('permission', Integer, ForeignKey('permissions.id'),
           primary_key=True,
           nullable=False)
)

user_roles = Table(
    'user_roles', Base.metadata,
    Column('user', Integer, ForeignKey('users.id'), primary_key=True,
           nullable=False),
    Column('role', Integer, ForeignKey('roles.id'), primary_key=True,
           nullable=False)
)
