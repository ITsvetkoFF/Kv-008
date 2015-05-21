# coding: utf-8
import tornado.web
import tornado.escape

from ecomap.api.v1_0.handlers.base import BaseHandler
from ecomap.api.utils.oper_allowed import operation_allowed


class UserAPIHandler(BaseHandler):
    @tornado.web.authenticated
    @operation_allowed
    def get(self):
        return self.write({self.request.path: 'get'})

    @tornado.web.authenticated
    @operation_allowed
    def post(self):
        return self.write({self.request.path: 'post'})

    @tornado.web.authenticated
    @operation_allowed
    def delete(self):
        return self.write({self.request.path: 'delete'})

    @tornado.web.authenticated
    @operation_allowed
    def put(self, user):
        return self.write({self.request.path: 'put'})
