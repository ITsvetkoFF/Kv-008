from functools import wraps  # updates the attributes of the decorator

from wtforms_json import InvalidData

from api.v1_0.models import *
from api.v1_0.bl.auth import get_user_roles

# importing resources from factories module
# temporary solution
from factories import RESOURCES


def get_modifiers(session, res_name, action, user_id):
    """Returns a list of modifiers (if a user has multiple roles, he
    can have multiple modifiers for the same resource-action as well)."""
    mods = session.query(Permission.modifier).join(RolePermission).filter(
        RolePermission.role.in_(get_user_roles(session, user_id))).filter(
        Permission.resource_name == res_name).filter(
        Permission.action == action)

    return [mod.modifier for mod in mods]


def check_if_exists(res_name):
    """Checks if there is a record with the specified id in the
    corresponding table.
    Suitable for only those resources that have corresponding models.
    """
    message = 'Bad resource name. Check RESOURCES.'
    assert res_name in RESOURCES, message

    def decorator(method):
        @wraps(method)
        def wrapper(handler, url_id):
            if not handler.sess.query(eval(res_name.capitalize())).get(url_id):
                return handler.send_error(404, message=(
                    '{} not found.'.format(res_name.capitalize())))

            method(handler, url_id)

        return wrapper

    return decorator


def validate_payload(form):
    """Validates request payload."""
    def arguments_wrapper(method):
        @wraps(method)
        def wrapper(*args):
            try:
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

    # 'comment' and 'photo' correspond to Comment and Photo models
    return session.query(eval(res_name.capitalize())).get(url_id).user_id


def check_permission(res_name):
    def decorator(method):
        message = 'Action not allowed.'

        @wraps(method)
        def wrapper(*args):
            # I only expect self, and some id or only self argument to
            # be passed to the handler method.
            user_id = args[0].current_user
            # get_modifier returns NONE or None if a user is not allowed to
            # perform an action.  In case of url_id is None, corresponding
            # permissions have only ANY or NONE modifiers for the specified
            # resources, so the logic for OWN is not triggered in any case
            # if resource_id is None.
            mods = get_modifiers(
                user_id=user_id,
                res_name=res_name,
                action=args[0].request.method,
                session=args[0].sess
            )

            print format(mods, '#>30')

            if 'ANY' in mods:
                return method(*args)

            if 'OWN' in mods:
                if user_id == get_owner_id(args[0].sess, res_name, args[1]):
                    return method(*args)

            return args[0].send_error(400, message=message)

        return wrapper

    return decorator

# If we rename modifiers to 'allowed', 'own_only', 'not_allowed', then we can
# user 'now_allowed' as a default value in our perm form.
# Also, it will suit better for those resources, that do not have an owner.
# For example, all_users -- get all data for all users in the database.
