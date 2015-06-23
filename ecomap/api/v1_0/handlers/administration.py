import tornado.escape
import tornado.web

from api.v1_0.handlers.base import BaseHandler
from api.v1_0.models import Permission, Resource, Role
from api.v1_0.bl.modeldict import get_dict_from_orm, \
    get_object_from_dict


class RolesHandler(BaseHandler):
    """
    This handler provides you to manipulates role profiles.
    """

    @tornado.web.authenticated
    def get(self, *args, **kwargs):
        """Returns the specified role or all the roles otherwise.

        Answer format:

        .. code-block: json

           {
             "id": 1,
             "name": "admin"
           }

        """
        temp = tornado.escape.json_encode(
            [get_dict_from_orm(role) for role in self.sess.query(Role).all()])
        self.write(temp)

    @tornado.web.authenticated
    def put(self):
        query = get_object_from_dict(Role, self.request.arguments)
        self.sess.add(query)
        self.sess.commit()
        self.write(tornado.escape.json_encode({'id': query.id}))


class ResourcesHandler(BaseHandler):
    """Manipulates resources using administrative account.

    get - returns all roles list if role_id isn't specified otherwise it
    returns specified role.
    put - changes role profile
    """

    @tornado.web.authenticated
    class PermissionsOutput:
        """Returns answers of ResourceHandler."""

        def __init__(self, db, role_id, resource_id):
            self.ID = resource_id
            self.NAME = db.query(Resource).filter_by(
                id=resource_id).first().name
            self.GET = None
            self.PUT = None
            self.POST = None
            self.DELETE = None

            for permission in db.query(Role).filter_by(
                    id=role_id).first().permissions:
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
        """Returns all the resources for the specified user.

        Resources are in format:

        .. code-block:: json

           {
             "ID": 1,
             "NAME": "LoginHandler",
             "GET": "ANY",
             "PUT": "ANY",
             "POST": "ANY",
             "DELETE": "ANY"
           }

        If the specified user is not found, returns an error:

        .. code-block:: json

           {
             "status_code": 404,
             "message": "Role not found"
           }

        """
        role = self.sess.query(Role).filter_by(id=role_id).first()

        if role is None:
            self.send_error(404, message='Role not found')

        permissions = [permissions.id
                       for permissions in role.permissions]
        resources = set([self.sess.query(Permission.resource_id).filter_by(
            id=idx).first()[0]
                         for idx in permissions])
        answer = [self.PermissionsOutput(db=self.sess,
                                         role_id=role_id,
                                         resource_id=idx).__dict__
                  for idx in resources]
        self.write(tornado.escape.json_encode(answer))

    @tornado.web.authenticated
    def put(self):
        """Changes resources."""
        query = Permission(resource_id=self.request.arguments['resource_id'],
                           action=self.request.arguments['action'],
                           modifier=self.request.arguments['modifier'])
        self.sess.update(query)
        self.sess.commit()
