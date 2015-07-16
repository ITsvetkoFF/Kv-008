import tornado.gen
import tornado.auth
import tornado.escape

from api.v1_0.handlers.base import BaseHandler
from api.utils.auth import hash_password
from api.v1_0.forms.user import UserRegisterForm, UserLoginForm
from api.v1_0.bl.auth import *


class RegisterHandler(BaseHandler):
    def post(self):
        """Registers a new user.

        If received data is valid, creates a new ``User``, stores it into
        the database and sets a cookie named ``user_id``.

        ``first_name``, ``last_name``, ``email`` and ``password`` key-value
        pairs are required.
        """
        form = UserRegisterForm.from_json(self.request.arguments)
        if form.validate():
            new_user = store_new_user(
                self.sess,
                User(
                    first_name=form.data['first_name'],
                    last_name=form.data['last_name'],
                    email=form.data['email'],
                    password=hash_password(form.data['password'])
                )
            )
            # if new_user is None then email is not unique
            if not new_user:
                return self.send_error(400, message='Email already in use.')

            complete_auth(self, new_user)
        else:
            self.send_error(400, message=form.errors)


class FacebookHandler(BaseHandler):
    def post(self):
        user = self.sess.query(User).filter(
            User.facebook_id == self.request.arguments['id']).first()

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
    def post(self):
        """Logs in a user.
        Sets a cookie ``user_id`` and writes user's ``first_name`` and
        ``last_name`` to the client (so it can display them in the navbar).

        ``email`` and ``password`` key-value pairs are required in request
        JSON payload.

        If user authentication fails, a client gets 400 response status code
        and a message *"Invalid email/password."*.
        """
        form = UserLoginForm.from_json(self.request.arguments)
        if not form.validate():
            return self.send_error(400, message=form.errors)

        user = get_user_with_email(self, form.email.data)
        # check if user exists and her password matches
        if user and user.password == hash_password(form.password.data):
            complete_auth(self, user)
        else:
            self.send_error(400, message='Invalid email/password.')


class LogoutHandler(BaseHandler):
    def get(self):
        """Logs out a user."""
        self.clear_all_cookies()
