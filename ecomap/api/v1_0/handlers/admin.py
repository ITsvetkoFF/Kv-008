import json
from api.v1_0.handlers.base import BaseHandler
from api.v1_0.models import *
from api.v1_0.bl.auth import get_role_perms
from api.v1_0.models._config import MODIFIERS


class PermissionHandler(BaseHandler):
    def get(self):
        # I need res_methods (handler name + method strings).
        res_methods = [' '.join(row) for row in self.sess.query(
            Permission.res_name, Permission.action).distinct().order_by(
            Permission.res_name, Permission.action)]

        role_names = [row.name for row in self.sess.query(Role.name)]

        def get_mods(res_meth, session):
            res_name, action = res_meth.split()
            return [row.modifier for row in session.query(
                Permission.modifier).filter(
                Permission.res_name == res_name,
                Permission.action == action)]

        def get_modif(role_name, res_meth, session):
            res_name, action = res_meth.split()
            perm = session.query(Permission).join(RolePermission).filter(
                Permission.res_name == res_name,
                Permission.action == action,
                RolePermission.role_name == role_name
            ).first()

            return perm.modifier if perm is not None else 'NONE'

        self.render('admin.html',
                    res_methods=res_methods,
                    role_names=role_names,
                    get_mods=get_mods,
                    get_modif=get_modif)

    def post(self):
        # clean the table
        self.sess.query(RolePermission).delete()

        for key in self.request.arguments:
            role_name, res_name, action, mod = \
                key.split() + self.request.arguments[key]

            perm = self.sess.query(Permission).filter(
                Permission.res_name == res_name,
                Permission.action == action,
                Permission.modifier == mod
            ).first()

            self.sess.add(RolePermission(role_name=role_name, perm_id=perm.id))

        self.sess.commit()
