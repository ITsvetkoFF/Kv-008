# coding: utf-8
import tornado.web
import tornado.escape

from api.v1_0.handlers.base import BaseAPIHandler
from api.v1_0.models.user import User


class UserAPIHandler(BaseAPIHandler):

    @tornado.web.authenticated
    def get(self):
        email = self.get_secure_cookie('email')
        return self.write({'user_name': self.current_user, 'email': email})

    @tornado.web.authenticated
    def post(self):
        return self.write({'user': 'post'})

    @tornado.web.authenticated
    def delete(self):
        return self.write({'user': 'delete'})

    @tornado.web.authenticated
    def put(self, user):
        return self.write({'user': 'put'})
