# coding: utf-8
import tornado.web
import tornado.escape

from api.v1_0.handlers.base import BaseHandler
from api.v1_0.models import User
from api.v1_0.bl.decs import check_if_exists
from api.v1_0.bl.modeldict import (
    loaded_obj_data_to_dict,
    update_loaded_obj_with_data
)


class UsersHandler(BaseHandler):
    def get(self, user_id):
        """Returns data for all users from the database or for the
        specified user.

        | If you pass user id (specifying it in the url)
        | **/api/v1/users/3**,
        | you'll get something like this:

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

        | Otherwise you'll get data for all users
        | **/api/v1/users**.
        """
        if user_id is None:
            self.write(tornado.escape.json_encode(
                [loaded_obj_data_to_dict(user) for user in self.sess.query(User)]))
        else:
            self.write(loaded_obj_data_to_dict(self.sess.query(User).get(user_id)))

    @check_if_exists(User)
    def delete(self, user_id):
        """Deletes the specified user."""
        self.sess.delete(self.sess.query(User).get(user_id))
        self.sess.commit()

    @check_if_exists(User)
    def put(self, user_id):
        """Updates data for the specified user.

        This method provides you change specified user profile with
        parameters that you transmit into json. Json must contain dictionary
        where key is a model column fields and values it's a values that you
        needs to change.
        """
        user = update_loaded_obj_with_data(
            self.sess.query(User).get(user_id),
            self.request.arguments
        )
        self.sess.commit()
