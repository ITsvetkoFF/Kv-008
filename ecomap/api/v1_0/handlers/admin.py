from api.v1_0.handlers.base import BaseHandler
from api.v1_0.models import *
from api.v1_0.bl.revision import query_converter
import math
from factories.user import RoleFactory


class PermissionHandler(BaseHandler):
    def get(self):
        methods_list = ['GET', 'POST', 'PUT', 'DELETE']
        modifier = ['ANY','OWN','NONE']
        data = dict()
        for role in self.sess.query(Role):
            hendlers=dict()
            for perm in role.permissions:
                methods = dict()
                hendler = perm.resource.name
                for perm in role.permissions:
                    if perm.resource.name == hendler:
                        methods[perm.action] = perm.modifier
                hendlers[hendler]=methods
            data[role.name]= hendlers

        permissions_data = dict()
        for r in self.sess.query(Role):
            resource = dict()
            for res in self.sess.query(Resource):
                action = dict()
                for f in self.sess.query(Permission):
                    if res.id == f.resource_id:
                        # action[(f.action,f.modifier)]=f.id
                        # permissions_data[res.name]=action
                        permissions_data[(res.name,f.action,f.modifier)]=f.id
        print permissions_data

        def permissions_id(res, met, mod):
            return permissions_data[(res,met,mod)]

        def get_modifier (role, res, method):
            return data[role][res][method]

        self.render(
            "/ecomap/api/templates/admin.html",
            data = data,
            modifier=modifier,
            get_modifier=get_modifier,
            methods=methods_list,
            perm_id=permissions_id
        )

    def post(self):
        for role in self.request.arguments.keys():
            role_id = self.sess.query(Role.id).filter(Role.name==role).first()[0]
            for perm_id in self.request.arguments[role]:
                role_perm = Role(name=role)
                print role_perm.permissions, '000000000000000000000000000'
                # role_perm.permissions.extend(self.sess.query(Permission).filter_by(
                #     id=perm_id).all())
                role_admin = RoleFactory(id=role_id)
                role_admin.permissions.extend(self.sess.query(Permission).filter_by(
                    id=perm_id).all())



                # role_perm = role_permissions(role=role_id, permission=perm_id)
                # self.sess.add(role_perm)
                # print self.sess.query(Role.permissions).add({role_id:perm_id}), '0000000000000'
        self.write(self.request.arguments)
