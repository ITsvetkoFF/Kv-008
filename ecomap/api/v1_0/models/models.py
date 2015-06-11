from sqlalchemy import Column, Enum, Integer, String, Text, Boolean, ForeignKey, DateTime
from sqlalchemy.dialects.postgresql import JSON
from geoalchemy2 import Geometry, Geography
from sqlalchemy.orm import relationship, backref

from api.v1_0.models import Base, enum_actions, enum_modifiers, \
    enum_status, enum_activity_type, enum_severity_type, user_roles, \
    role_permissions


class Page(Base):

    __tablename__ = 'pages'

    id = Column(Integer, primary_key=True, autoincrement=True)
    alias = Column(String(30), nullable=False)
    title = Column(String(150), nullable=False)
    content = Column(Text, nullable=False)
    is_resource = Column(Boolean, nullable=False)


class ProblemType(Base):
    __tablename__ = 'problem_types'

    id = Column(Integer, primary_key=True)
    type = Column(String(100), nullable=False)


class Role(Base):
    __tablename__ = 'roles'

    id = Column(Integer, primary_key=True)
    name = Column(String(100), nullable=False, unique=True)

    permissions = relationship('Permission', secondary=role_permissions)


class Region(Base):
    __tablename__ = 'regions'

    id = Column(Integer, primary_key=True)
    name = Column(String(100), nullable=False)
    location = Column(Geometry, nullable=False)


class User(Base):
    __tablename__ = 'users'

    id = Column(Integer, primary_key=True)
    first_name = Column(String(100), nullable=False)
    last_name = Column(String(100), nullable=False)
    email = Column(String(100), nullable=False)
    password = Column(String(100))
    region_id = Column(Integer, ForeignKey('regions.id'))
    google_id = Column(String(100))
    facebook_id = Column(String(100))

    roles = relationship('Role', secondary=user_roles)
    region = relationship('Region')


class UserRole(Base):
    __tablename__ = 'users_roles'

    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey(u'users.id', ondelete=u'CASCADE'), primary_key=True, nullable=False)
    role_id = Column(Integer, ForeignKey(u'roles.id', ondelete=u'CASCADE'), primary_key=True, nullable=False)


class Problem(Base):
    __tablename__ = 'problems'

    id = Column(Integer, primary_key=True)
    title = Column(String(200), nullable=False)
    content = Column(Text)
    proposal = Column(Text)
    severity = Column(Enum(*enum_severity_type, name='severitytypes'))
    location = Column(Geography, nullable=False)
    status = Column(Enum(*enum_status, name='status'))
    problem_type_id = Column(Integer, ForeignKey(u'problem_types.id'))
    region_id = Column(Integer, ForeignKey('regions.id'))

    problem_type = relationship('ProblemType')
    region = relationship('Region')


class Photo(Base):
    __tablename__ = 'photos'

    id = Column(Integer, primary_key=True)
    link = Column(String(200), nullable=False)
    comment = Column(Text)


class PhotosActivity(Base):
    __tablename__ = 'photos_activities'

    id = Column(Integer, primary_key=True)
    photo_id = Column(Integer, ForeignKey(u'photos.id', ondelete=u'CASCADE'),
                      nullable=False)
    problem_id = Column(Integer, ForeignKey('problems.id', ondelete='CASCADE'),
                        nullable=False)
    user_id = Column(Integer, ForeignKey(u'users.id', ondelete='CASCADE'), nullable=False)
    datetime = Column(DateTime, nullable=False)
    activity_type = Column(Enum(*enum_activity_type, name='activitytype'),
                           nullable=False)

    photo = relationship('Photo')
    problem = relationship('Problem')
    user = relationship('User', backref=backref('photo_activities', cascade="all, delete-orphan"), single_parent=True)


class ProblemsActivity(Base):
    __tablename__ = 'problems_activities'

    id = Column(Integer, primary_key=True)
    problem_id = Column(Integer, ForeignKey('problems.id', ondelete='CASCADE'),
                        nullable=False)
    data = Column(JSON)
    user_id = Column(Integer, ForeignKey(u'users.id'), nullable=False)
    datetime = Column(DateTime, nullable=False)
    activity_type = Column(Enum(*enum_activity_type, name='activitytype'),
                           nullable=False)

    problem = relationship('Problem')
    user = relationship('User', backref=backref('problem_activities', cascade="all, delete-orphan"))


class VotesActivity(Base):
    __tablename__ = 'votes_activities'

    id = Column(Integer, primary_key=True)
    problem_id = Column(Integer, ForeignKey('problems.id', ondelete='CASCADE'),
                        nullable=False)
    user_id = Column(Integer, ForeignKey(u'users.id', ondelete=u'CASCADE'),
                     nullable=False)
    datetime = Column(DateTime, nullable=False)

    problem = relationship('Problem')
    user = relationship('User')


class Comment(Base):
    __tablename__ = 'comments'

    id = Column(Integer, primary_key=True)
    content = Column(Text, nullable=False)
    problem_id = Column(Integer, ForeignKey('problems.id'),
                        nullable=False)
    user_id = Column(Integer, ForeignKey(u'users.id'),
                     nullable=False)
    created_date = Column(DateTime, nullable=False)
    modified_date = Column(DateTime, nullable=True)
    modified_user_id = Column(Integer, nullable=True)

    problem = relationship('Problem')
    user = relationship('User')


class CommentsActivity(Base):
    __tablename__ = 'comments_activities'

    id = Column(Integer, primary_key=True)
    content = Column(Text)
    problem_id = Column(Integer, nullable=False)
    user_id = Column(Integer, nullable=False)
    comments_id = Column(Integer, nullable=False)
    date = Column(DateTime, nullable=False)
    activity_type = Column(Enum(*enum_activity_type, name='activitytype'), nullable=False)


class Resource(Base):
    __tablename__ = 'resources'

    id = Column(Integer, primary_key=True)
    name = Column(String(100), nullable=False)


class Permission(Base):
    __tablename__ = 'permissions'

    id = Column(Integer, primary_key=True, autoincrement=True)
    resource_id = Column(Integer, ForeignKey('resources.id'), nullable=False)
    action = Column(Enum(*enum_actions, name='actions'), nullable=False)
    modifier = Column(Enum(*enum_modifiers, name='modifiers'), nullable=False)

    resource = relationship('Resource')


class RolesPermission(Base):
    __tablename__ = 'roles_permissions'

    id = Column(Integer, primary_key=True)
    role_id = Column(Integer, ForeignKey(u'roles.id', ondelete=u'CASCADE'), primary_key=True, nullable=False)
    permission_id = Column(Integer, ForeignKey(u'permissions.id', ondelete=u'CASCADE'), primary_key=True, nullable=False)


class Solution(Base):
    __tablename__ = 'solutions'

    id = Column(Integer, primary_key=True)
    problem_id = Column(Integer,
                        ForeignKey(u'problems.id', ondelete=u'CASCADE'),
                        nullable=False)
    administrator_id = Column(Integer, ForeignKey(u'users.id'), nullable=False)
    responsible_id = Column(Integer, ForeignKey(u'users.id'), nullable=False)

    problem = relationship('Problem')
    administrator = relationship('User', foreign_keys=[administrator_id])
    responsible = relationship('User', foreign_keys=[responsible_id])
