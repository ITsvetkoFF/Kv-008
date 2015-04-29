# coding: utf-8
import json
import oauth2
import tornado.web

from api.v1_0.handlers.oauth import AuthController


class BaseAPIHandler(tornado.web.RequestHandler):

    def initialize(self):
        self._oauth = AuthController
        self._oauth.site_adapter.db = self.db

        if (
            'Content-Type' in self.request.headers
            and self.request.headers['Content-Type'].startswith('application/json')
        ):
            self.json_args = json.loads(self.request.body)
        else:
            self.json_args = None


    @property
    def db(self):
        return self.application.db


# http://www.tornadoweb.org/en/stable/guide/structure.html#handling-request-input
#
# parsing JSON request body
# def prepare(self):
#
#     if self.request.headers["Content-Type"].startswith("application/json"):
#         self.json_args = json.loads(self.request.body)
#     else:
#         self.json_args = None
#
# self.request.arguments -- property of tornado.httputil.HTTPServerRequest object
