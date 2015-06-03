import tornado

from api.v1_0.handlers.base import BaseHandler
from api.v1_0.models import Role


class RolesHandler(BaseHandler):

    def get(self, role_id=None, *args, **kwargs):
        if role_id is None:
            temp = tornado.escape.json_encode({'roles': [{'name': role.name,
                                                          'id': role.id} for role in self.db_sess.query(Role).all()]})
            self.write(temp)
        else:
            return self.redirect(url=self.request.path + '/resources/')

    def post(self, role_id=None, *args, **kwargs):
        if role_id is None:
            query = [Role(name=obj['name']) for obj in self.request.arguments[u'data']]
            self.db_sess.add_all(query)
            self.db_sess.commit()
            self.get()
        else:
            self.send_error(401, message='You are not authenticated.')
