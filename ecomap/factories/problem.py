import factory
from factory.alchemy import SQLAlchemyModelFactory

from api.v1_0.models import *
from factories import session
from api.v1_0.bl.utils import get_datetime

class RegionFactory(SQLAlchemyModelFactory):
    class Meta:
        model = Region
        sqlalchemy_session = session

    name = factory.sequence(lambda n: 'region_%s' % n)
    location = factory.sequence(lambda n: 'POINT(1%s 1%s)' % (n, n))


class ProblemTypeFactory(SQLAlchemyModelFactory):
    """Want to have multiple problems for one type."""

    class Meta:
        model = ProblemType
        sqlalchemy_session = session

    type = factory.sequence(lambda n: 'problem_type_%s' % n)


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
    location = factory.sequence(lambda n: 'POINT(49.%s 32.%s)' % (n, n))

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
    datetime = get_datetime()
    activity_type = None



