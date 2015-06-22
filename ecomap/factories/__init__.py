from api import settings
from api.utils.db import get_db_session


session = get_db_session(settings)()
