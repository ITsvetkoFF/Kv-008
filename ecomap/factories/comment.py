import factory
from factory.alchemy import SQLAlchemyModelFactory

import api.v1_0.bl.utils as utils
import api.v1_0.models as models
import api.v1_0.tests.common as common


class CommentFactory(SQLAlchemyModelFactory):
    class Meta:
        model = models.Comment
        sqlalchemy_session = common.Session

    content = factory.sequence(lambda n: 'comment_%s_content' % n)
    problem = None
    user = None
    created_date = utils.get_datetime()
    modified_date = utils.get_datetime()
    modified_user_id = factory.sequence(lambda n: n + 1)


class SolutionFactory(SQLAlchemyModelFactory):
    class Meta:
        model = models.Solution
        sqlalchemy_session = common.Session

    problem = None
    administrator = None
    responsible = None
