from functools import wraps  # updates the attributes of the decorator

from wtforms_json import InvalidData

from api.v1_0.models import *
from api.v1_0.bl.auth import get_user_roles


RESOURCE_NAMES = ('user', 'photo', 'problem', 'comment', 'page')


def get_modifiers(session, res_name, action, user_id):
    """Returns a list of modifiers (if a user has multiple roles, he
    can have multiple modifiers for the same resource-action as well)."""
    mods = session.query(Permission.modifier).join(RolePermission).filter(
        RolePermission.role.in_(get_user_roles(session, user_id))).filter(
        Permission.resource_name == res_name).filter(
        Permission.action == action).all()

    return [mod.modifier for mod in mods]


def check_if_exists(res_name):
    """Checks if there is a record with the specified id in the
    corresponding table.
    Suitable for only those resources that have corresponding models.
    """
    message = 'Bad resource name. Check RESOURCE_NAMES in decs.py'
    assert res_name in RESOURCE_NAMES, message

    def decorator(method):
        @wraps(method)
        def wrapper(handler, url_id):
            if not handler.sess.query(eval(res_name.capitalize())).get(url_id):
                return handler.send_error(404, message=(
                    '{} not found.'.format(res_name)))

            method(handler, url_id)

        return wrapper

    return decorator


def validation(form):
    def arguments_wrapper(method):
        @wraps(method)
        def wrapper(*args):
            try:
                print '@' * 10, args[0].request.arguments, '\n\n'
                # self.request.arguments: GET\POST arguments to lists!!
                # names are of type string
                # need to reconsider this!!
                f = form.from_json(args[0].request.arguments,
                                   skip_unknown_keys=False)
                if f.validate():
                    method(*args)
                else:
                    args[0].send_error(400, message=f.errors)

            # skip_unknown_keys is False ==> InvalidData is thrown
            # if bad keys are present in the request payload
            except InvalidData as e:
                args[0].send_error(400, message=str(e))

        return wrapper

    return arguments_wrapper


# Comment, Photo and Problem have user_id field (owner)
# In case of Problem its adder id.
# User has id field (owner)
def get_owner_id(session, res_name, url_id):
    if res_name == 'user':
        return int(url_id)

    if res_name == 'problem':
        return session.query(ProblemsActivity).filter_by(
            problem_id=url_id, activity_type='ADDED').first().user_id

    # 'comment' and 'photo' strings correspond to Comment and Photo models
    return session.query(eval(res_name.capitalize())).get(url_id).user_id


def check_permission(res_name):
    def decorator(method):
        message = 'Action not allowed.'

        @wraps(method)
        def wrapper(*args):
            # I only expect self, and some id or only self argument to
            # be passed to the handler method.
            handler = args[0]
            user = handler.sess.query(User).get(handler.current_user)
            # get_modifier returns NONE or None if a user is not allowed to
            # perform an action.  In case of url_id is None, corresponding
            # permissions have only ANY or NONE modifiers for the specified
            # resources, so the logic for OWN is not triggered in any case
            # if resource_id is None.
            modifiers = get_modifiers(
                user_id=user.id,
                res_name=res_name,
                action=handler.request.method,
                session=handler.sess
            )

            print modifiers, '$'*25
            if 'ANY' in modifiers:
                return method(*args)

            if 'OWN' in modifiers:
                if user.id == get_owner_id(handler.sess, res_name, args[1]):
                    return method(*args)

            return handler.send_error(400, message=message)

        return wrapper

    return decorator
