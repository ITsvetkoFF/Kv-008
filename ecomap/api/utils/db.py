# coding: utf-8
from contextlib import contextmanager

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

POSTGRES_PATTERN = 'postgresql://{login}:{password}@{host}:{port}/{dbname}'


def get_db_url(settings):
    return POSTGRES_PATTERN.format(
        login=settings['psql_login'],
        password=settings['psql_password'],
        host=settings['psql_host'],
        port=settings['psql_port'],
        dbname=settings['psql_dbname']
    )


def get_db_engine(settings):
    db_url = get_db_url(settings)
    engine = create_engine(db_url, echo=settings['debug'])
    return engine


def get_db_session(settings):
    eng = get_db_engine(settings)
    Session = sessionmaker(bind=eng)
    return Session