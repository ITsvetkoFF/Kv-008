#!/usr/bin/env python
# coding: utf-8
from tornado.httpserver import HTTPServer
from tornado.web import Application
from tornado.log import enable_pretty_logging
from tornado.ioloop import IOLoop

from api import settings
from api.utils.db import get_db_session
from api.v1_0.urls import APIUrls

application = Application(handlers=APIUrls, **settings)
application.db_sess = get_db_session(settings)

if __name__ == '__main__':
    if settings['debug']:
        enable_pretty_logging()
        application.listen(settings['bind_port'], settings['bind_address'])
    else:
        server = HTTPServer(application)
        server.bind(settings['bind_port'], settings['bind_address'])
        server.start(settings['tornado_start'])

    IOLoop.instance().start()
