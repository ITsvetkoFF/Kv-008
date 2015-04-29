#!/usr/bin/env python
# coding: utf-8
import sys
import os

from tornado.httpserver import HTTPServer
from tornado.web import Application
from tornado.log import enable_pretty_logging
from tornado.ioloop import IOLoop

from api.utils.db import get_db_session
from api.utils.settings import get_normalized_settings
from api.v1_0.handlers.urls import APIUrls


if __name__ == "__main__":

    # api/v1_0/settings.py
    #
    # DEBUG = True
    # BIND_PORT = 5000
    # BIND_ADDR = '127.0.0.1'
    # PSQL_LOGIN = 'test_user'
    # PSQL_PASSWORD = 'qwerty'
    # PSQL_HOST = 'localhost'
    # PSQL_PORT = 5432
    # PSQL_DBNAME = 'test_db'
    #
    # these are all in settings dictionary
    #
    # TORNADO_START is not in LocalSettings class

    settings = get_normalized_settings()
    # APIUrls is in v1_0/handlers/urls.py -- path table
    application = Application(handlers=APIUrls, **settings)
    # attaching database here -- used to initialize request handlers
    # see base.py db property
    application.db = get_db_session(settings)

    if settings['debug']:
        enable_pretty_logging()
        # simple single process pattern
        application.listen(settings['bind_port'], settings['bind_addr'], )
    else:
        server = HTTPServer(application)
        # simple multi-process pattern
        server.bind(settings['bind_port'], settings['bind_addr'] )
        server.start(settings['tornado_start'])

    IOLoop.instance().start()
