# coding: utf-8
import json
import oauth2
import tornado.web
import tornado.escape

from api.v1_0.handlers.base import BaseAPIHandler
from api.v1_0.models.user import User


# oauth2.web.Request -- contains data of the current HTTP request
class TornadoRequestProcessor(oauth2.web.Request):

    def __init__(self, env):
        self.method = env["REQUEST_METHOD"]
        self.query_string = env["QUERY_STRING"]
        self.path = env["PATH_INFO"]
        self.query_params = {}
        self.post_params = {}
        self.env_raw = env

        self.query_params = env["QUERY_ARGUMENTS"]
        if (
            self.method == "POST"
            and env["BODY_ARGUMENTS"]
            and env["CONTENT_TYPE"] == "application/x-www-form-urlencoded"
        ):
            self.post_params = env['BODY_ARGUMENTS']

        if (
            self.method == "POST"
            and env["BODY_ARGUMENTS"]
            and env["CONTENT_TYPE"] == "application/json"
        ):
            post_params = env['BODY_ARGUMENTS']
            self.post_params = json.loads(post_params)


class OAuth2APIHandler(BaseAPIHandler):

    def post(self):
        response = self._dispatch_request()

        for name, value in list(response.headers.items()):
            self.set_header(name, value)

        self.set_status(response.status_code)
        self.write(response.body)

    def _dispatch_request(self):
        request = TornadoRequestProcessor({
            'REQUEST_METHOD': self.request.method,
            'QUERY_STRING': self.request.query,
            'PATH_INFO': self.request.path,
            'CONTENT_TYPE': self.request.headers.get('Content-Type'),
            'QUERY_ARGUMENTS': self.request.query_arguments,
            'BODY_ARGUMENTS': self.request.body_arguments or self.request.body,
        })
        return self._oauth.dispatch(request, environ={})


class UserAPIHandler(BaseAPIHandler):

    @tornado.web.authenticated
    def get(self):
        user_name = self.get_secure_cookie('user_name')
        email = self.get_secure_cookie('email')
        return self.write({'user_name': user_name, 'email': email})

    @tornado.web.authenticated
    def post(self):
        return self.write({'user': 'post'})

    @tornado.web.authenticated
    def delete(self):
        return self.write({'user': 'delete'})

    @tornado.web.authenticated
    def put(self, user):
        return self.write({'user': 'put'})
