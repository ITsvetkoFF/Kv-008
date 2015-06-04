from sqlalchemy import Column, Integer, ForeignKey, Table
from sqlalchemy.ext.declarative import declarative_base


Base = declarative_base()

enum_status = ('SOLVED', 'UNSOLVED')
enum_activity_type = ('ADDED', 'REMOVED', 'UPDATED')
enum_severity_type = ('1', '2', '3', '4', '5')
enum_modifiers = ('ANY', 'OWN', 'NONE')
enum_actions = ('GET', 'PUT', 'POST', 'DELETE')

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