# coding: utf-8
import tornado.web
import tornado.escape

from api.v1_0.handlers.base import BaseHandler
from api.v1_0.models import User
from api.v1_0.bl.decs import check_if_exists, check_permission
from api.v1_0.bl.modeldict import get_row_data, update_row_data


class UsersHandler(BaseHandler):
    @tornado.web.authenticated
    @check_permission
    def get(self):
        """Returns data for all users in the database."""
        self.write(tornado.escape.json_encode(
            [get_row_data(user) for user in self.sess.query(User)]))


class UserHandler(BaseHandler):
    @tornado.web.authenticated
    @check_if_exists(User)
    @check_permission
    def get(self, user_id):
        self.write(get_row_data(self.sess.query(User).get(user_id), True))

    @tornado.web.authenticated
    @check_if_exists(User)
    @check_permission
    def delete(self, user_id):
        """Deletes the specified user."""
        self.sess.delete(self.sess.query(User).get(user_id))
        self.sess.commit()

    @tornado.web.authenticated
    @check_if_exists(User)
    @check_permission
    def put(self, user_id):
        """Updates data for the specified user.

        This method provides you change specified user profile with
        parameters that you transmit into json. Json must contain dictionary
        where key is a model column fields and values it's a values that you
        needs to change.
        """

        user = self.sess.query(User).get(user_id)

        if 'email' in self.request.arguments:
            if not user.check_unique_email(
                    self.sess, self.request.arguments['email'], user.id):
                return self.send_error(400, message='Email already in use.')

        update_row_data(user, self.request.arguments)
        self.sess.commit()
