from sqlalchemy import Column, Integer, String, ForeignKey, Table
from sqlalchemy.ext.declarative import declarative_base
import sqlalchemy.orm as orm


STATUSES = ('SOLVED', 'UNSOLVED')
ACTIVITY_TYPES = ('ADDED', 'REMOVED', 'UPDATED', 'VOTE')
SEVERITY_TYPES = ('1', '2', '3', '4', '5')
MODIFIERS = ('ANY', 'OWN', 'NONE')
ACTIONS = ('GET', 'PUT', 'POST', 'DELETE')

Base = declarative_base()

# mapping classes to use joins
class RolePermission(Base):
    __tablename__ = 'role_permissions'

    role = Column(String(100), ForeignKey('roles.name'), primary_key=True)
    permission = Column(Integer, ForeignKey('permissions.id'),
                        primary_key=True)


class UserRole(Base):
    __tablename__ = 'user_roles'

    user = Column(Integer, ForeignKey('users.id'), primary_key=True)
    role = Column(String(100), ForeignKey('roles.name'), primary_key=True)
