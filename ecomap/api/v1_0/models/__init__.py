from sqlalchemy import MetaData
from api import settings

from api.utils.db import get_db_engine

# Turn off engine echo setting
settings['debug'] = False
engine = get_db_engine(settings)

metadata = MetaData()
metadata.reflect(bind=engine)
