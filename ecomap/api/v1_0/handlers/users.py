# coding: utf-8
import tornado.web
import tornado.escape

from api.v1_0.handlers.base import BaseHandler
from api.v1_0.models import User
from api.v1_0.bl.models_dict_logic import get_object_from_dict, get_dict_from_orm, update_model_from_dict


class UserAPIHandler(BaseHandler):
    """
    This handler provides you to work with users.
    It implements four methods to communicate with users API.

    get - return one or all users
    post - add new user to db
    put - change parameters for specified user
    delete - deletes specified user's profile
    """

    @tornado.web.authenticated
    def get(self, user_id=None):
        """
        Method that gets you one or all users in the system.

        If you specify user id it returns something like this

        {
            "first_name": "user_2",
            "last_name": "user_2_last_name",
            "region_id": null,
            "google_id": null,
            "email": "user_2@example.com",
            "facebook_id": null,
            "password": "user_2_pass",
            "id": 3
        }

        otherwise it will be list of dicts like specified above.
        """
        if user_id is None:
            return self.write(tornado.escape.json_encode([get_dict_from_orm(user)
                                                          for user in self.sess.query(User).all()]))
        else:
            return self.write(get_dict_from_orm(self.sess.query(User).filter_by(id=user_id).first()))

    @tornado.web.authenticated
    def post(self):
        """
        Method to create new user. To create new user you must submit json like

        {
            "first_name": "user_2",
            "last_name": "user_2_last_name",
            "region_id": null,
            "google_id": null,
            "email": "user_2@example.com",
            "facebook_id": null,
            "password": "user_2_pass",
            "id": 3
        }

        """
        new_user = get_object_from_dict(User, self.request.arguments)
        self.sess.add(new_user)
        self.sess.commit()
        return self.write({'id': new_user.id})

    @tornado.web.authenticated
    def delete(self, user_id):
        """
        This method provide you to delete specified user.
        To delete you must specify user_id parameter.
        """
        self.sess.delete(self.sess.query(User).filter_by(id=user_id).first())
        self.sess.commit()

    @tornado.web.authenticated
    def put(self, user_id):
        """
        This method provides you change specified user profile with parameters that
        you transmit into json. Json must contain dictionary where key is a model
        column fields and values it's a values that you needs to change.
        """
        model = update_model_from_dict(model=self.sess.query(User).filter_by(id=user_id).first(),
                                       model_dict=self.request.arguments)
        self.sess.update(model)
        self.sess.commit()
