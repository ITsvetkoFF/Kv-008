import tornado

from api.v1_0.handlers.base import BaseHandler
from api.v1_0.models import Permission, RolePermission, Role, Resource


class ResourcesHandler(BaseHandler):

    class PermissionsOutput:

        def __init__(self, db, role_id, resource_id):
            self.ID = resource_id
            self.NAME = db.query(Resource.name).filter_by(id=resource_id).first()
            self.GET = None
            self.PUT = None
            self.POST = None
            self.DELETE = None

            for permission_id in db.query(RolePermission.permission_id).filter_by(role_id=role_id).all():
                for permission in db.query(Permission).filter_by(id=permission_id).all():
                    if permission.action.uooer() == 'GET':
                        self.GET = permission.modifier
                    elif permission.action.uooer() == 'PUT':
                        self.PUT = permission.modifier
                    elif permission.action.uooer() == 'POST':
                        self.POST = permission.modifier
                    elif permission.action.uooer() == 'DELETE':
                        self.DELETE = permission.modifier

    def get(self, role_id, *args, **kwargs):
        permissions = [id for id in self.db_sess.query(RolePermission.permission_id).filter_by(role_id=role_id).all()]
        resources = set([self.db_sess.query(Permission.resource_id).filter_by(id=idx).first()
                         for idx in permissions])
        answer = [self.PermissionsOutput(db=self.db_sess,
                                         role_id=role_id,
                                         resource_id=idx).__dict__
                  for idx in resources]
        self.write(tornado.escape.json_encode(answer))

    def put(self):
        pass
