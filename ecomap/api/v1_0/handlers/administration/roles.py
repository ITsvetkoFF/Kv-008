import tornado.escape

from api.v1_0.handlers.base import BaseHandler
from api.v1_0.models import Role


class RolesHandler(BaseHandler):

    def get(self, *args, **kwargs):
        temp = tornado.escape.json_encode({'roles': [{'name': role.name,
                                                      'id': role.id} for role in self.sess.query(Role).all()]})
        self.write(temp)

    def put(self):
        query = Role(name=self.request.arguments['role_name'])
        self.sess.add(query)
        self.sess.commit()
        self.write(tornado.escape.json_encode({'role_id': query.id}))
