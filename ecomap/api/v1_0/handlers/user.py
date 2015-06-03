# coding: utf-8
import tornado.web
import tornado.escape

from api.v1_0.handlers.base import BaseHandler


class UserAPIHandler(BaseHandler):
    @tornado.web.authenticated
    def get(self):
        return self.write({self.request.path: 'get'})

    @tornado.web.authenticated
    def post(self):
        return self.write({self.request.path: 'post'})

    @tornado.web.authenticated
    def delete(self):
        return self.write({self.request.path: 'delete'})

    @tornado.web.authenticated
    def put(self, user):
        return self.write({self.request.path: 'put'})
