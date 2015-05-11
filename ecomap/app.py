#!/usr/bin/env python
# coding: utf-8
import json
from tornado.httpserver import HTTPServer
from tornado.web import Application
from tornado.log import enable_pretty_logging
from tornado.ioloop import IOLoop

from api.utils.db import get_db_session
from api.v1_0.urls.urls import UrlsTable


if __name__ == "__main__":

    with open('settings.json') as json_settings:
        settings = json.load(json_settings)

    application = Application(handlers=UrlsTable, **settings)
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

    print 'starting server...'
    IOLoop.instance().start()
