import datetime
import factory
from factory.alchemy import SQLAlchemyModelFactory

import api.v1_0.bl.utils as utils
import api.v1_0.models as models
import factories.common as cm


class CommentFactory(SQLAlchemyModelFactory):
    class Meta:
        model = models.Comment
        sqlalchemy_session = cm.Session
        exclude = ('now',)

    # this attribute helps to define others, it is not passed to __init__
    now = datetime.datetime.strptime(
        utils.get_datetime(), "%Y-%m-%d %H:%M:%S")

    content = factory.sequence(lambda n: 'comment_%s_content' % n)
    created_date = now - datetime.timedelta(days=2)
    modified_date = now - datetime.timedelta(minutes=50)
    modified_user_id = factory.sequence(lambda n: n + 1)
    user = None
    problem = None


class SolutionFactory(SQLAlchemyModelFactory):
    class Meta:
        model = models.Solution
        sqlalchemy_session = cm.Session

    problem = None
    administrator = None
    responsible = None
