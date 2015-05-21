#!/usr/bin/env python
# coding: utf-8
from tornado.httpserver import HTTPServer
from tornado.web import Application
from tornado.log import enable_pretty_logging

from tornado.ioloop import IOLoop

from api.utils.database import settings, database_session
from api.v1_0.urls import UrlsTable

if __name__ == "__main__":

    application = Application(handlers=UrlsTable, **settings)

    # `db_sess` is a session factory
    #
    # A session establishes and maintains all conversations between your
    # program and the databases.It represents an intermediary zone
    # for all the Python model objects you have loaded in it.It is one of the
    # entry points to initiate a query against the database, whose results are
    # populated and mapped into unique objects within the session.A unique
    # object is the only object in the session with a particular primary key.
    #
    # Typical workflow
    # `db_sess` is instantiated. This new instance, for example called `sess`
    # is not associated with any model objects. `sess` receives query
    # requests, whose results are persisted / associated with the it.
    # Arbitrary number of model
    # objects are constructed and then added to `sess`, after which
    # point `sess` starts to maintain and manage those objects. Once all
    # the changes are made against the objects in `sess`, we may decide
    # to commit the changes from `sess` to the database or rollback those
    # changes in `sess`. sess.commit() means that the changes made to
    # the objects in `sess` so far will be persisted into the database
    # while sess.rollback() means those changes will be discarded.
    # sess.close() will close `sess` and its corresponding connections,
    # which means we are done with `sess` and want to release the
    # connection object associated with it.
    application.db_sess = database_session

    if settings['debug']:
        enable_pretty_logging()
        application.listen(settings['bind_port'], settings['bind_address'])

        print 'address:port={}:{}'.format(
            settings['bind_address'],
            settings['bind_port']
        )
        print 'URL List'
        for url in UrlsTable: print url[0]

    else:
        server = HTTPServer(application)
        server.bind(settings['bind_port'], settings['bind_address'])
        server.start(settings['tornado_start'])

    IOLoop.instance().start()
