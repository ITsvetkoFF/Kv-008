import tornado.gen
import tornado.auth
import tornado.escape

from api.v1_0.handlers.base import BaseHandler
from api.utils.auth import hash_password
from api.v1_0.forms.user import (
    UserRegisterForm,
    UserLoginForm,
    UserRegisterFbForm
)
from api.v1_0.bl.auth import *
from api.v1_0.bl.decs import validation
from api.v1_0.bl.utils import define_values


class RegisterHandler(BaseHandler):
    @validation(UserRegisterForm)
    def post(self):
        """Registers a new user.

        If received data is valid, creates a new ``User``, stores it into
        the database and sets a cookie named ``user_id``.

        ``first_name``, ``last_name``, ``email`` and ``password`` key-value
        pairs are required.
        {
         "first_name":"Jon",
         "last_name":"Snow",
         "email": "jon_snow@mil.om",
         "password":"111",
         "region_id":1
        }
        """
        args = self.request.arguments
        new_user = store_new_user(
            self.sess,
            User(
                first_name=args['first_name'],
                last_name=define_values(args,'last_name'),
                email=args['email'],
                password=hash_password(args['password']),
                region_id=define_values(args,'region_id')
            )
        )
        if not new_user:
            return self.send_error(400, message='Email already in use.')

        complete_auth(self, new_user)


class FacebookHandler(BaseHandler):
    @validation(UserRegisterFbForm)
    def post(self):
        user = self.sess.query(User).filter(
            User.facebook_id == self.request.arguments['facebook_id']).first()

        if user:
            complete_auth(self, user)
        else:
            new_user = store_new_user(
                self.sess, create_fb_user(self.request.arguments))
            # If new_user is None, then her email is already in the database,
            # and that means, that she has registered directly using our
            # registration form.
            if not new_user:
                return self.send_error(400, message='Email already in use.')

            complete_auth(self, new_user)


class LoginHandler(BaseHandler):
    @validation(UserLoginForm)
    def post(self):
        """Logs in a user.
        Sets a cookie ``user_id`` and writes user's ``first_name`` and
        ``last_name`` to the client (so it can display them in the navbar).

        ``email`` and ``password`` key-value pairs are required in request
        JSON payload.

        If user authentication fails, a client gets 400 response status code
        and a message *"Invalid email/password."*.
        {
        "email": "admin@example.com",
        "password":"admin_pass"
        }
        """
        args = self.request.arguments
        user = get_user_with_email(self, args['email'])
        if user and user.password == hash_password(args['password']):
            complete_auth(self, user)
        else:
            self.send_error(400, message='Invalid email/password.')


class LogoutHandler(BaseHandler):
    def get(self):
        """Logs out a user."""
        self.clear_all_cookies()
