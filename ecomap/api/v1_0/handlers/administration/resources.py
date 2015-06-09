import tornado.escape
import tornado.web

from api.v1_0.handlers.base import BaseHandler
from api.v1_0.models import Permission, Resource, Role


class ResourcesHandler(BaseHandler):

    class PermissionsOutput:

        def __init__(self, db, role_id, resource_id):
            self.ID = resource_id
            self.NAME = db.query(Resource).filter_by(id=resource_id).first().name
            self.GET = None
            self.PUT = None
            self.POST = None
            self.DELETE = None

            for permission in db.query(Role).filter_by(id=role_id).first().permissions:
                if permission.action.upper() == 'GET':
                    self.GET = permission.modifier
                elif permission.action.upper() == 'PUT':
                    self.PUT = permission.modifier
                elif permission.action.upper() == 'POST':
                    self.POST = permission.modifier
                elif permission.action.upper() == 'DELETE':
                    self.DELETE = permission.modifier

    @tornado.web.authenticated
    def get(self, role_id, *args, **kwargs):
        role = self.sess.query(Role).filter_by(id=role_id).first()
        if role is None:
            self.send_error(404, message='Role not found')

        permissions = [permissions.id
                       for permissions in role.permissions]
        resources = set([self.sess.query(Permission.resource_id).filter_by(id=idx).first()[0]
                         for idx in permissions])
        answer = [self.PermissionsOutput(db=self.sess,
                                         role_id=role_id,
                                         resource_id=idx).__dict__
                  for idx in resources]
        print(answer)
        self.write(tornado.escape.json_encode(answer))

    @tornado.web.authenticated
    def put(self):
        query = Permission(resource_id=self.request.arguments.resource_id,
                           action=self.request.arguments.action,
                           modifier=self.request.arguments.modifier)
        self.sess.update(query)
        self.sess.commit()

