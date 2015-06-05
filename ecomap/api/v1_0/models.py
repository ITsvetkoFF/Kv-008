from sqlalchemy import Column, Enum, Integer, String, Text, ForeignKey, \
    DateTime, Table

from sqlalchemy.orm import relationship

from sqlalchemy.dialects.postgresql import JSON
from geoalchemy2 import Geometry
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import *
from create_view import view



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


class ProblemType(Base):
    __tablename__ = 'problem_types'

    id = Column(Integer, primary_key=True)
    type = Column(String(100), nullable=False)


class Role(Base):
    __tablename__ = 'roles'

    id = Column(Integer, primary_key=True)
    name = Column(String(100), nullable=False)

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


class Problem(Base):
    __tablename__ = 'problems'

    id = Column(Integer, primary_key=True)
    title = Column(String(200), nullable=False)
    content = Column(Text)
    proposal = Column(Text)
    severity = Column(Enum(*enum_severity_type, name='severitytypes'))
    location = Column(Geometry, nullable=False)
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
    user_id = Column(Integer, ForeignKey(u'users.id'), nullable=False)
    datetime = Column(DateTime, nullable=False)
    activity_type = Column(Enum(*enum_activity_type, name='activitytype'),
                           nullable=False)

    photo = relationship('Photo')
    problem = relationship('Problem')
    user = relationship('User')


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
    user = relationship('User')


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


class CommentsActivity(Base):
    __tablename__ = 'comments_activities'

    id = Column(Integer, primary_key=True)
    problem_id = Column(Integer, ForeignKey('problems.id', ondelete='CASCADE'),
                        nullable=False)
    user_id = Column(Integer, ForeignKey(u'users.id', ondelete=u'CASCADE'),
                     nullable=False)
    comment_id = Column(Integer,
                        ForeignKey(u'comments.id', ondelete=u'CASCADE'),
                        nullable=False)
    datetime = Column(DateTime, nullable=False)
    activity_type = Column(Enum(*enum_activity_type, name='activitytype'),
                           nullable=False)

    problem = relationship('Problem')
    user = relationship('User')
    comment = relationship('Comment')


class Resource(Base):
    __tablename__ = 'resources'

    id = Column(Integer, primary_key=True)
    name = Column(String(100), nullable=False)


class Permission(Base):
    __tablename__ = 'permissions'

    id = Column(Integer, primary_key=True)
    resource_id = Column(Integer, ForeignKey('resources.id'), nullable=False)
    action = Column(Enum(*enum_actions, name='actions'), nullable=False)
    modifier = Column(Enum(*enum_modifiers, name='modifiers'), nullable=False)

    resource = relationship('Resource')


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



metadata = Base.metadata
user_t = User.__table__
problems_activities_t = ProblemsActivity.__table__
problems_t = Problem.__table__
votes_activities_t = VotesActivity.__table__

detailed_problem_view = view("detailed_problem", metadata,
                                select([problems_t.c.id, problems_t.c.title,
                                        problems_t.c.content, problems_t.c.proposal,
                                        problems_t.c.severity, problems_t.c.status,
                                        problems_t.c.problem_type_id, problems_t.c.region_id,
                                        problems_activities_t.c.datetime,
                                        func.count(votes_activities_t.c.id).label('votes_numbers'),
                                        (user_t.c.first_name + user_t.c.last_name).label('name')]).\
                                where( problems_activities_t.c.problem_id == votes_activities_t.c.problem_id).\
                                where(problems_t.c.id==problems_activities_t.c.problem_id).\
                                where(problems_activities_t.c.user_id==user_t.c.id).\
                                group_by( problems_t.c.id,problems_activities_t.c.problem_id, problems_activities_t.c.datetime, user_t.c.first_name, user_t.c.last_name))



# the ORM would appreciate this
assert detailed_problem_view.primary_key == [detailed_problem_view.c.id]


class DetailedProblem(Base):
    __table__ = detailed_problem_view