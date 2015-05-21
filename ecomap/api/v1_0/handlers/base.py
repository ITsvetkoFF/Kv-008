# coding: utf-8
import tornado.web


class BaseHandler(tornado.web.RequestHandler):

    @property
    def db_sess(self):
        return self.application.db_sess

    def get_current_user(self):
        return self.get_cookie('user_id')

