import factory
from factory.alchemy import SQLAlchemyModelFactory
from api.v1_0.bl.utils import get_datetime
from api.v1_0.models import *
from factories import session


class CommentFactory(SQLAlchemyModelFactory):
    class Meta:
        model = Comment
        sqlalchemy_session = session

    content = factory.sequence(lambda n: 'comment_%s_content' % n)
    problem = None
    user = None
    created_date = get_datetime()
    modified_date = get_datetime()
    modified_user_id = factory.sequence(lambda n: n + 1)


class SolutionFactory(SQLAlchemyModelFactory):
    class Meta:
        model = Solution
        sqlalchemy_session = session

    problem = None
    administrator = None
    responsible = None
