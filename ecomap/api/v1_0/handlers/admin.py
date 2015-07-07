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

        roles = [row.name for row in self.sess.query(Role.name)]

        self.render('admin.html', res_methods=res_methods, mods=MODIFIERS,
                    roles=roles)
