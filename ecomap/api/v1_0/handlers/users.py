# coding: utf-8
import tornado.web
import tornado.escape

from api.v1_0.handlers.base import BaseHandler
from api.v1_0.models import User
from api.v1_0.bl.modeldict import get_object_from_dict, \
    get_dict_from_orm, update_model_from_dict


class UsersHandler(BaseHandler):
    @tornado.web.authenticated
    def get(self, user_id=None):
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
             "facebook_id": null,
             "password": "user_2_pass",
             "id": 3
           }

        | Otherwise you'll get data for all users
        | **/api/v1/users**.
        """
        if user_id is None:
            return self.write(
                tornado.escape.json_encode([get_dict_from_orm(user)
                                            for user in
                                            self.sess.query(User).all()]))
        else:
            return self.write(get_dict_from_orm(
                self.sess.query(User).filter_by(id=user_id).first()))

    @tornado.web.authenticated
    def delete(self, user_id):
        """Deletes the specified user."""
        self.sess.delete(self.sess.query(User).filter_by(id=user_id).first())
        self.sess.commit()

    @tornado.web.authenticated
    def put(self, user_id):
        """Updates data for the specified user.

        This method provides you change specified user profile with
        parameters that you transmit into json. Json must contain dictionary
        where key is a model column fields and values it's a values that you
        needs to change.
        """
        model = update_model_from_dict(
            model=self.sess.query(User).filter_by(id=user_id).first(),
            model_dict=self.request.arguments)
        self.sess.update(model)
        self.sess.commit()
