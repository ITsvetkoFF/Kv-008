# coding: utf-8
import tornado.web
import tornado.escape

from api.v1_0.models import *

class BaseHandler(tornado.web.RequestHandler):
    def initialize(self):
        self.sess = self.application.db_sess()

    def on_finish(self):
        self.sess.close()

    def get_current_user(self):
        # returns a user id as an int, not as a string
        user_id = self.get_cookie('user_id')
        if not user_id:
            self.send_error(401, message='Not authenticated.')
            return

        return int(user_id)

    def prepare(self):
        # Incorporate request JSON into arguments dictionary.
        # This method has to be transformed into a simple function and put into
        # bl package.
        if self.request.body:
            try:
                json_data = tornado.escape.json_decode(self.request.body)
                self.request.arguments.update(json_data)
            except ValueError:
                message = 'Unable to parse JSON.'
                self.send_error(400, message=message)

    def write_error(self, status_code, **kwargs):
        self.write(kwargs)

    def get_action_modifier(self):
        current_user = self.sess.query(User).get(self.current_user)

        for role in current_user.roles:
            for perm in role.permissions:
                if (perm.resource.name == self.__class__.__name__ and
                            perm.action == self.request.method):
                    return perm.modifier

    def set_default_headers(self):
        self.set_header("Access-Control-Allow-Origin", "*")
        self.set_header("Access-Control-Allow-Credentials", "true")
        self.set_header("Access-Control-Allow-Methods",
                        "GET,PUT,POST,DELETE,OPTIONS")
        self.set_header(
            "Access-Control-Allow-Headers",
            "Content-Type, Depth, User-Agent, X-File-Size, X-Requested-With, "
            "X-Requested-By, If-Modified-Since, X-File-Name, Cache-Control"
        )

    def create_location(self):
        x = self.request.arguments["Latitude"]
        y = self.request.arguments["Longtitude"]
        return "POINT({0} {1})".format(x, y)
