from sqlalchemy import orm
from api.utils.db import get_db_session
from api import settings


Session = orm.scoped_session(get_db_session(settings))
