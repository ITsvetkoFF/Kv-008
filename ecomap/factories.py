import datetime
import random

import factory

from factory.alchemy import SQLAlchemyModelFactory

from api import settings
from api.utils.db import get_db_session
from api.v1_0.models import *

session = get_db_session(settings)()


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


class ProblemTypeFactory(SQLAlchemyModelFactory):
    """Want to have multiple problems for one type."""

    class Meta:
        model = ProblemType
        sqlalchemy_session = session

    type = factory.sequence(lambda n: 'problem_type_%s' % n)


class RegionFactory(SQLAlchemyModelFactory):
    class Meta:
        model = Region
        sqlalchemy_session = session

    name = factory.sequence(lambda n: 'region_%s' % n)
    location = factory.sequence(lambda n: 'POINT(1%s 1%s)' % (n, n))


class ProblemFactory(SQLAlchemyModelFactory):
    """Creates a problem with a new type and region."""

    class Meta:
        model = Problem
        sqlalchemy_session = session

    title = factory.sequence(lambda n: 'problem_%s' % n)
    content = factory.lazy_attribute(lambda obj: '%s_content' % obj.title)
    proposal = factory.lazy_attribute(lambda obj: '%s_proposal' % obj.title)
    status = None
    severity = None
    location = factory.sequence(lambda n: 'POINT(1%s 1%s)' % (n, n))

    problem_type = None
    region = factory.SubFactory(RegionFactory)


class ProblemActivityFactory(SQLAlchemyModelFactory):
    """Creates a new problem, user and record in problem_activities table
    tagged 'ADDED'."""

    class Meta:
        model = ProblemsActivity
        sqlalchemy_session = session

    problem = None
    user = None
    datetime = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    activity_type = 'ADDED'


class PhotoFactory(SQLAlchemyModelFactory):
    class Meta:
        model = Photo
        sqlalchemy_session = session

    link = factory.sequence(lambda n: 'photo_link_%s' % n)
    comment = factory.lazy_attribute(lambda obj: '%s_comment' % obj.link)


class PhotoActivityFactory(SQLAlchemyModelFactory):
    class Meta:
        model = PhotosActivity
        sqlalchemy_session = session

    photo = factory.SubFactory(PhotoFactory)
    problem = None
    user = None
    datetime = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    activity_type = 'ADDED'


class CommentFactory(SQLAlchemyModelFactory):
    class Meta:
        model = Comment
        sqlalchemy_session = session

    content = factory.sequence(lambda n: 'comment_%s_content' % n)


class CommentActivityFactory(SQLAlchemyModelFactory):
    class Meta:
        model = CommentsActivity
        sqlalchemy_session = session

    problem = None
    comment = factory.SubFactory(CommentFactory)
    user = None
    datetime = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    activity_type = 'ADDED'


class ResourceFactory(SQLAlchemyModelFactory):
    class Meta:
        model = Resource
        sqlalchemy_session = session

    name = None


class PermissionFactory(SQLAlchemyModelFactory):
    class Meta:
        model = Permission
        sqlalchemy_session = session

    resource = None
    action = None
    modifier = None


class SolutionFactory(SQLAlchemyModelFactory):
    class Meta:
        model = Solution
        sqlalchemy_session = session

    problem = None
    administrator = None
    responsible = None


class VoteActivityFactory(SQLAlchemyModelFactory):
    class Meta:
        model = VotesActivity
        sqlalchemy_session = session

    problem = None
    user = None
    datetime = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')


if __name__ == '__main__':
    import sys

    from api.v1_0.urls import APIUrls

    for handler_name in [urlspec.handler_class.__name__ for urlspec in
                         APIUrls]:
        resource = ResourceFactory(name=handler_name)
        for action in ('GET', 'POST', 'PUT', 'DELETE'):
            for modifier in ('ANY', 'OWN', 'NONE'):
                perm = PermissionFactory(
                    resource=resource,
                    action=action,
                    modifier=modifier
                )

    role_admin = RoleFactory(name='admin')
    role_admin.permissions.extend(session.query(Permission).filter_by(
        modifier='ANY').all())

    role_user = RoleFactory(name='user')
    # role_user has no permissions, you need to add some manually
    role_user.permissions.extend(session.query(Permission).filter_by(
        modifier='NONE').all())
    user_admin = UserFactory(first_name='user', last_name='admin')
    user_admin.roles.append(role_admin)

    # prepopulate problem types
    for i in xrange(8):
        ProblemTypeFactory()

    types = session.query(ProblemType).all()

    for i in xrange(int(sys.argv[1])):
        problem = ProblemFactory(
            problem_type=random.choice(types),
            status=random.choice(['SOLVED', 'UNSOLVED']),
            severity=random.choice(['1', '2', '3', '4', '5'])
        )
        user = UserFactory()
        user.roles.append(role_user)

        kwargs = dict(user=user, problem=problem)
        ProblemActivityFactory(**kwargs)
        PhotoActivityFactory(**kwargs)
        CommentActivityFactory(**kwargs)
        VoteActivityFactory(**kwargs)

    session.commit()
