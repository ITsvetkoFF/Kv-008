# coding: utf-8


class LocalSettings(object):
    DEBUG = True
    BIND_PORT = 8000
    BIND_ADDR = '0.0.0.0'
    PSQL_LOGIN = 'ecouser'
    PSQL_PASSWORD = '3c0map$008kv' # just for testing. will be updated in production.
    PSQL_HOST = 'localhost'
    PSQL_PORT = 5432
    PSQL_DBNAME = 'ecomap_db'
    FACEBOOK_API_KEY = '903837986321574'
    FACEBOOK_SECRET = '0f4ec5b2458b64b51fc64aacdbdef3d9'
    COOKIE_SECRET = 'mycookiesecret'
    LOGIN_URL = '/auth/facebook'
