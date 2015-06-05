# coding: utf-8
import tornado.web
import tornado.escape

from api.v1_0.handlers.base import BaseHandler
from api.v1_0.models import User, Region, Role


class UserHandler(BaseHandler):
    @tornado.web.authenticated
    def get(self, user_id):
        current_user = self.sess.query(User).filter_by(id=user_id).first()
        if current_user is None:
            self.send_error(404, message='User not found!')
        current_user = {
            'first_name': current_user.first_name,
            'last_name': current_user.last_name,
            'e-mail': current_user.email,
            'region': current_user.region_id,
            'google_id': current_user.google_id,
            'facebook_id': current_user.facebook_id,
            'roles': [role.name for role in current_user.roles]
        }
        self.write(tornado.escape.json_encode(current_user))

    @tornado.web.authenticated
    def delete(self, user_id):
        self.sess.delete(self.sess.query(User).filter_by(id=user_id).first())
        self.sess.commit()

    @tornado.web.authenticated
    def put(self, user_id):
        current_user = self.request.arguments
        current_user = User(
            first_name=current_user['first_name'],
            last_name=current_user['last_name'],
            email=current_user['e-mail'],
            password=current_user['password'],
            region=self.sess.query(Region).filter_by(name=current_user['region']).first()[0],
            google_id=current_user['google_id'],
            facebook_id=current_user['facebook_id'],
            roles=[self.sess.query(Role).filter_by(name=role).first()
                   for role in current_user['roles']]
        )
        self.sess.add(current_user)
        self.sess.commit()
