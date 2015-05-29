# coding: utf-8
import tornado.web
import tornado.escape
from api.v1_0.models.user2resource import *


class BaseHandler(tornado.web.RequestHandler):
    @property
    def db_sess(self):
        return self.application.db_sess

    def get_current_user(self):
        user_id = self.get_cookie('user_id')
        if not user_id:
            self.send_error(401, message='You are not authenticated.')
            return

        return int(user_id)

    def prepare(self):
        # Incorporate request JSON into arguments dictionary.
        if self.request.body:
            try:
                json_data = tornado.escape.json_decode(self.request.body)
                self.request.arguments.update(json_data)
            except ValueError:
                message = 'Unable to parse JSON.'
                self.send_error(400, message=message)

    def write_error(self, status_code, **kwargs):
        error_dict = dict(status_code=status_code)
        error_dict.update(kwargs)
        self.write(error_dict)

    def get_action_modifier(self):
        resource_id, = self.db_sess.query(Resource.id).filter_by(
            name=self.request.path).one()
        print 'resource_id=%s' % resource_id
        action = self.request.method
        print 'action=%s' % action

        for role_id, in self.db_sess.query(UserRole.role_id).filter_by(
                user_id=self.current_user):
            for perm_id, in self.db_sess.query(
                    RolePermission.permission_id).filter_by(role_id=role_id):
                perm = self.db_sess.query(Permission).get(perm_id)
                if perm.resource_id == resource_id and perm.action == action:
                    return perm.modifier
