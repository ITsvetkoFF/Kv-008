# coding: utf-8

import tornado.web
import tornado.escape

from api.v1_0.models import *


class BaseHandler(tornado.web.RequestHandler):
    def initialize(self):
        print "session initialized"
        self.sess = self.application.db_sess()

    def on_finish(self):
        print "session closed"
        self.sess.close()

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
        current_user = self.sess.query(User).get(self.current_user)

        for role in current_user.roles:
            for perm in role.permissions:
                if (perm.resource.name == self.__class__.__name__ and
                            perm.action == self.request.method):
                    return perm.modifier
