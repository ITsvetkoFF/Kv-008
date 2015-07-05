# coding: utf-8
import tornado.web
import tornado.escape

from api.v1_0.handlers.base import BaseHandler
from api.v1_0.models import User
from api.v1_0.bl.decs import check_if_exists, check_permission
from api.v1_0.bl.modeldict import (
    get_row_data,
    update_loaded_obj_with_data
)


class UsersHandler(BaseHandler):
    @tornado.web.authenticated
    def get(self):
        """Returns data for all users in the database.

        | User data is like this:

        .. code-block:: json

           {
             "first_name": "user_2",
             "last_name": "user_2_last_name",
             "email": "user_2@example.com",
             "facebook_id": "",
             "password": "user_2_pass",
             "id": 3,
             "region_id": null
           }

        """
        self.write(tornado.escape.json_encode(
            [get_row_data(user) for user in self.sess.query(User)]))


class UserHandler(BaseHandler):
    @tornado.web.authenticated
    @check_if_exists('user')
    @check_permission('user')
    def get(self, user_id):
        """Returns data for the specified user."""
        self.write(get_row_data(self.sess.query(User).get(user_id)))

    @tornado.web.authenticated
    @check_if_exists('user')
    @check_permission('user')
    def delete(self, user_id):
        """Deletes the specified user."""
        self.sess.delete(self.sess.query(User).get(user_id))
        self.sess.commit()

    @tornado.web.authenticated
    @check_if_exists('user')
    @check_permission('user')
    def put(self, user_id):
        """Updates data for the specified user.

        This method provides you change specified user profile with
        parameters that you transmit into json. Json must contain dictionary
        where key is a model column fields and values it's a values that you
        needs to change.
        """
        user = self.sess.query(User).get(user_id)
        update_loaded_obj_with_data(
            user,
            self.request.arguments
        )
        self.sess.commit()
