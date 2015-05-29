from sqlalchemy import Column, Enum, Integer, String, Text, text, create_engine, ForeignKey, DateTime
from sqlalchemy.dialects.postgresql import JSON
from geoalchemy2 import Geometry
from sqlalchemy.ext.declarative import declarative_base
from api import settings
from api.utils.db import get_db_engine


# Turn off engine echo setting
settings['debug'] = False
engine = get_db_engine(settings)
Base = declarative_base()


enum_status = ('SOLVED', 'UNSOLVED')
enum_activity_type = ('ADDED', 'REMOVED', 'UPDATED')
enum_severity_type = ('1', '2', '3', '4', '5')
enum_modifiers = ('ANY', 'OWN', 'NONE')
enum_actions = ('GET', 'PUT', 'POST', 'DELETE')


class ProblemType(Base):
    __tablename__ = 'problem_types'

    id = Column(Integer, primary_key=True)
    type = Column(String(100), nullable=False)


class Role(Base):
    __tablename__ = 'roles'

    id = Column(Integer, primary_key=True)
    name = Column(String(100), nullable=False)


class Region(Base):
    __tablename__ = 'region'

    id = Column(Integer, primary_key=True)
    name = Column(String(100), nullable=False)
    location = Column(Geometry, nullable=False)


class User(Base):
    __tablename__ = 'users'

    id = Column(Integer, primary_key=True)
    name = Column(String(64), nullable=False)
    surname = Column(String(64))
    email = Column(String(128), nullable=False)
    password = Column(String, nullable=False)
    region_id = Column(Integer, ForeignKey(u'region.id', ondelete=u'CASCADE'), nullable=False)


class UserRole(Base):
    __tablename__ = 'users_roles'

    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey(u'users.id', ondelete=u'CASCADE'), primary_key=True, nullable=False)
    role_id = Column(Integer, ForeignKey(u'roles.id', ondelete=u'CASCADE'), primary_key=True, nullable=False)


class Problem(Base):
    __tablename__ = 'problems'

    id = Column(Integer, primary_key=True)
    title = Column(String(130), nullable=False)
    content = Column(Text)
    proposal = Column(Text)
    severity = Column(Enum(*enum_severity_type, name='severitytypes'))
    location = Column(Geometry, nullable=False)
    status = Column(Enum(*enum_status, name='status'))
    problem_type_id = Column(Integer, ForeignKey(u'problem_types.id', ondelete=u'CASCADE'), nullable=False)
    region_id = Column(Integer, ForeignKey(u'region.id', ondelete=u'CASCADE'), nullable=False)


class Photo(Base):
    __tablename__ = 'photos'

    id = Column(Integer, primary_key=True)
    link = Column(String(200), nullable=False)
    status = Column(Enum(*enum_status, name='status'), nullable=False)
    comment = Column(Text)
    problem_id = Column(Integer, ForeignKey(u'problems.id', ondelete=u'CASCADE'), nullable=False)
    user_id = Column(Integer, ForeignKey(u'users.id', ondelete=u'CASCADE'), nullable=False)


class PhotosActivity(Base):
    __tablename__ = 'photos_activities'

    id = Column(Integer, primary_key=True)
    photo_id = Column(Integer, ForeignKey(u'photos.id', ondelete=u'CASCADE'), nullable=False)
    problem_id = Column(Integer, ForeignKey(u'problems.id', ondelete=u'CASCADE'), nullable=False)
    user_id = Column(Integer, ForeignKey(u'users.id', ondelete=u'CASCADE'), nullable=False)
    date = Column(DateTime, nullable=False)
    activity_type = Column(Enum(*enum_activity_type, name='activitytype'), nullable=False)


class ProblemsActivity(Base):
    __tablename__ = 'problems_activities'

    id = Column(Integer, primary_key=True)
    problem_id = Column(Integer, ForeignKey(u'problems.id', ondelete=u'CASCADE'), nullable=False)
    data = Column(JSON)
    user_id = Column(Integer, ForeignKey(u'users.id', ondelete=u'CASCADE'), nullable=False)
    date = Column(DateTime, nullable=False)
    activity_type = Column(Enum(*enum_activity_type, name='activitytype'), nullable=False)


class VotesActivity(Base):
    __tablename__ = 'votes_activities'

    id = Column(Integer, primary_key=True)
    problem_id = Column(Integer, ForeignKey(u'problems.id', ondelete=u'CASCADE'), nullable=False)
    user_id = Column(Integer, ForeignKey(u'problems.id', ondelete=u'CASCADE'), nullable=False)
    date = Column(DateTime, nullable=False)


class Comment(Base):
    __tablename__ = 'comments'

    id = Column(Integer, primary_key=True)
    content = Column(Text)
    user_id = Column(Integer, ForeignKey(u'users.id', ondelete=u'CASCADE'), nullable=False)
    problem_id = Column(Integer, ForeignKey(u'problems.id', ondelete=u'CASCADE'), nullable=False)


class CommentsActivity(Base):
    __tablename__ = 'comments_activities'

    id = Column(Integer, primary_key=True)
    problem_id = Column(Integer, ForeignKey(u'problems.id', ondelete=u'CASCADE'), nullable=False)
    user_id = Column(Integer, ForeignKey(u'users.id', ondelete=u'CASCADE'), nullable=False)
    comments_id = Column(Integer, ForeignKey(u'comments.id', ondelete=u'CASCADE'), nullable=False)
    date = Column(DateTime, nullable=False)
    activity_type = Column(Enum(*enum_activity_type, name='activitytype'), nullable=False)


class Resource(Base):
    __tablename__ = 'resources'

    id = Column(Integer, primary_key=True)
    name = Column(String(100))


class Permission(Base):
    __tablename__ = 'permissions'

    id = Column(Integer, primary_key=True)
    resource_id = Column(Integer, ForeignKey(u'resources.id', ondelete=u'CASCADE'), nullable=False)
    action = Column(Enum(*enum_actions, name='actions'), nullable=False)
    modifier = Column(Enum(*enum_modifiers, name='modifiers'), nullable=False)


class RolesPermission(Base):
    __tablename__ = 'roles_permissions'

    id = Column(Integer, primary_key=True)
    role_id = Column(Integer, ForeignKey(u'roles.id', ondelete=u'CASCADE'), primary_key=True, nullable=False)
    permission_id = Column(Integer, ForeignKey(u'permissions.id', ondelete=u'CASCADE'), primary_key=True, nullable=False)


class Solution(Base):
    __tablename__ = 'solutions'

    id = Column(Integer, primary_key=True)
    problem_id = Column(Integer, ForeignKey(u'problems.id', ondelete=u'CASCADE'), nullable=False)
    administrator_id = Column(Integer, ForeignKey(u'users.id', ondelete=u'CASCADE'), nullable=False)
    problem_manager_id = Column(Integer, ForeignKey(u'users.id', ondelete=u'CASCADE'), nullable=False)