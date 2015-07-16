from api.v1_0.handlers.base import BaseHandler
from api.v1_0.models import *
from api.v1_0.bl.auth import get_role_perms
import tornado
import tornado.web
from api.v1_0.bl.revision import query_converter
from api.v1_0.bl.decs import check_permission


HANDLERS = [
    'UsersHandler',
    'UserHandler',
    'ProblemsHandler',
    'ProblemHandler',
    'VoteHandler',
    'ProblemPhotosHandler',
    'ProblemCommentsHandler',
    'PagesHandler',
    'PageHandler',
    'CommentHandler',
    'PhotoHandler',
    'PermissionHandler',
    'RoleHandler'
]


class PermissionHandler(BaseHandler):

    @tornado.web.authenticated
    @check_permission
    def get(self):
        data = dict()
        for role in self.sess.query(Role):
            hendlers = dict()
            permissions = get_role_perms(self.sess, role.name)
            for perm in permissions:
                methods = dict()
                hendler = perm.res_name
                for perm in permissions:
                    if perm.res_name == hendler:
                        methods[perm.action] = perm.modifier
                hendlers[hendler] = methods
            data[role.name] = hendlers

        perm_data = dict()
        for res in self.sess.query(Resource):
            for perm in self.sess.query(Permission):
                if res.name == perm.res_name:
                    perm_data[(res.name, perm.action, perm.modifier)] = perm.id

        def methods(res):
            methods_set = set()
            for key in perm_data:
                if key[0] == res:
                    methods_set.add(key[1])
            return methods_set

        def modifier(res, method):
            mod_set = set()
            for key in perm_data:
                if key[0] == res and key[1] == method:
                    mod_set.add(key[2])
            return mod_set

        def permissions_id(res, met, mod):
            return perm_data[(res, met, mod)]

        def get_modifier(role, res, method):
            try:
                d = data[role][res][method]
            except KeyError:
                return None
            return d

        self.render(
            "/ecomap/api/templates/admin.html",
            data=data,
            modifier=modifier,
            get_modifier=get_modifier,
            methods=methods,
            perm_id=permissions_id,
            resources=HANDLERS
        )

    @tornado.web.authenticated
    @check_permission
    def post(self):
        role_perm = []
        for role in self.request.arguments.keys():
            for p in self.request.arguments[role]:
                role_perm.append(RolePermission(role_name=role, perm_id=p))
        self.sess.query(RolePermission).delete()
        self.sess.add_all(role_perm)
        self.sess.commit()

        self.redirect('/api/admin?message=' + tornado.escape.url_escape(
            'Changes successfully made!'))


class RoleHandler(BaseHandler):

    @tornado.web.authenticated
    @check_permission
    def get(self):
        email = self.get_argument('email', None)
        header = ['Id', 'Email', 'First name', 'Last name', 'Role']

        if email != None:
            user_info = self.sess.query(
                User.id,
                User.email,
                User.first_name,
                User.last_name,
                UserRole.role_name
            ).join(UserRole).filter(User.email == email).first()
            user_id = self.sess.query(User.id).filter(User.email==email).first()
            if user_info == None:
                self.redirect(
                    '/api/admin/role?message=' + tornado.escape.url_escape(
                        'Email not found!'))
            info = [(key, value) for key, value in zip(header, user_info)]
            roles = query_converter(self.sess.query(Role.name).all())
            self.render(
                "/ecomap/api/templates/permission.html",
                info=info,
                roles=roles,
                user_id=user_id
            )
        self.render("/ecomap/api/templates/permission.html", info=[])

    @tornado.web.authenticated
    @check_permission
    def post(self):
        arg = self.request.arguments
        self.sess.query(UserRole).filter(UserRole.user_id==int(arg.keys()[0])).delete()
        self.sess.add(UserRole(user_id=int(arg.keys()[0]), role_name=arg.values()[0][0]))
        self.sess.commit()

        self.redirect('/api/admin/role?message=' + tornado.escape.url_escape(
            'Role successfully assigned!'))
