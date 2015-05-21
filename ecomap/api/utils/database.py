# coding: utf-8
import json
from sqlalchemy import create_engine
from sqlalchemy.orm import scoped_session, sessionmaker

with open('settings.json') as json_settings:
    settings = json.load(json_settings)

POSTGRES_PATTERN = 'postgresql://{login}:{password}@{host}:{port}/{dbname}'

database_url = POSTGRES_PATTERN.format(
    login=settings['psql_login'],
    password=settings['psql_password'],
    host=settings['psql_host'],
    port=settings['psql_port'],
    dbname=settings['psql_dbname']
)

engine = create_engine(database_url, echo=settings['debug'])
database_session = scoped_session(sessionmaker(bind=engine))
