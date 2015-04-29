# coding: utf-8


class LocalSettings(object):
    DEBUG = True
    BIND_PORT = 8001
    BIND_ADDR = '0.0.0.0'
    PSQL_LOGIN = 'ecouser'
    PSQL_PASSWORD = '3c0map$008kv' # just for testing. will be updated in production.
    PSQL_HOST = 'localhost'
    PSQL_PORT = 5432
    PSQL_DBNAME = 'ecomap_db'
