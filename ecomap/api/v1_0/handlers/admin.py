import tornado.escape
from api.v1_0.handlers.base import BaseHandler
from api.v1_0.models import *
from api.v1_0.bl.admin import *


class PermissionHandler(BaseHandler):
    def get(self):
        # I need res_methods (handler name + method strings).
        # Checkout html source.
        res_methods = [' '.join(row) for row in self.sess.query(
            Permission.res_name, Permission.action).distinct().order_by(
            Permission.res_name, Permission.action)]

        role_names = [row.name for row in self.sess.query(Role.name)]

        self.render('admin.html',
                    res_methods=res_methods,
                    role_names=role_names,
                    get_act_mods=get_act_mods,
                    get_mod=get_mod)

    def post(self):
        # clean the table
        self.sess.query(RolePermission).delete()

        for key in self.request.arguments:
            role_name, res_name, action, mod = \
                key.split() + self.request.arguments[key]

            self.sess.add(RolePermission(
                role_name=role_name,
                perm_id=get_perm_id(self.sess, res_name, action, mod)
            ))

        self.sess.commit()

        self.redirect('/api/admin?message=' + tornado.escape.url_escape(
            'Changes successfully made!'))
