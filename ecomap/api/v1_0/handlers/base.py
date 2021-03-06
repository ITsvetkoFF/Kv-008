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
        if self.request.body:
            if self.request.files:
                return
            if self.request.headers['content-type'] == (
                    'application/x-www-form-urlencoded'):
                return

            try:
                json_data = tornado.escape.json_decode(self.request.body)
                self.request.arguments.update(json_data)
            except ValueError:
                message = 'Unable to parse JSON.'
                self.send_error(400, message=message)

    def write_error(self, status_code, **kwargs):
        self.write(kwargs)

    def set_default_headers(self):
        if self.request.headers.get("Origin"):
            self.set_header("Access-Control-Allow-Origin",
                            self.request.headers.get("Origin"))
        self.set_header("Access-Control-Allow-Credentials", "true")
        self.set_header("Cache-control",
                        "no-store, no-cache, must-revalidate, max-age=0")

    def options(self, *args, **kwargs):
        self.set_header("Access-Control-Allow-Methods",
                        "GET,PUT,POST,DELETE,OPTIONS")
        self.set_header("Access-Control-Allow-Headers", "Content-type")
        self.set_status(200)
