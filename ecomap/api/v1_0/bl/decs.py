from functools import wraps  # updates the attributes of the decorator

from wtforms_json import InvalidData

from api.v1_0.models import *
from api.v1_0.bl.auth import get_user_roles


def check_if_exists(model):
    """Checks if there is a row for the specified id in the url."""
    assert model in (
        User, Photo, Problem, Comment, Page), 'Bad model argument.'

    def decorator(method):
        @wraps(method)
        def wrapper(handler, url_id):
            if not handler.sess.query(model).get(url_id):
                return handler.send_error(404, message=(
                    '{} not found.'.format(model.__name__)))

            method(handler, url_id)

        return wrapper

    return decorator


def permission_control(method):
    @wraps(method)
    def wrapper(handler, obj_id=None):
        definition_query = {'ProblemHandler': handler.sess.query(
            ProblemsActivity.user_id).filter_by(problem_id=obj_id,
                                                activity_type='ADDED').first()}
        modifier = handler.get_action_modifier()
        if modifier == 'NONE':
            message = 'You do not have sufficient right'
            handler.send_error(400, message=message)
        elif modifier == 'ANY':
            method(handler, obj_id)
        elif modifier == 'OWN':
            user_id = None
            key = handler.__class__.__name__
            if key in definition_query.keys():
                try:
                    user_id = definition_query[key][0]
                except TypeError:
                    message = 'Entry not found for the given id.'
                    handler.send_error(404, massage=message)
            if user_id == handler.get_current_user():
                method(handler, obj_id)
            else:
                message = 'You do not have sufficient right'
                handler.send_error(400, message=message)

    return wrapper


def validation(model_form):
    """Validates request payload.

    You cannot send unknown keys in payload.
    """

    def arguments_wrapper(method):
        @wraps(method)
        def wrapper(handler):
            try:
                form = model_form.from_json(handler.request.arguments,
                                      skip_unknown_keys=False)
            except InvalidData as e:
                message = e.message
                handler.send_error(400, message=message)
            if form.validate():
                method(handler)
            else:
                message = form.errors
                handler.send_error(400, message=message)

        return wrapper

    return arguments_wrapper


# Comment, Photo and Problem have user_id fields (owner)
# In case of Problem its adder id.
# User has id field (owner)
def check_permission(method):
    """Checks if a user is allowed to invoke a method."""
    message = 'Not allowed.'

    @wraps(method)
    def wrapper(*args):
        # I only expect self, and some id or only self argument to
        # be passed to the handler method.
        user_id = args[0].current_user
        res_name = args[0].__class__.__name__
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


def get_owner_id(session, res_name, url_id):
    """Gets the owner id. This function is called only in those methods,
    that deal with models that have user_id field (or User model).
    """
    if res_name == 'UserHandler':
        return int(url_id)

    if res_name in ('ProblemHandler',
                    'ProblemCommentsHandler',
                    'ProblemPhotosHandler'):
        return session.query(ProblemsActivity).filter_by(
            problem_id=url_id, activity_type='ADDED').first().user_id

    if res_name in ('CommentHandler', 'PhotoHandler'):
        # transform handler name into model name
        # cutting off 'Handler' suffix
        return session.query(eval(res_name[:-7])).get(url_id).user_id


def get_modifiers(session, res_name, action, user_id):
    """Returns a list of modifiers (if a user has multiple roles, he
    can have multiple modifiers for the same resource-action as well).
    """
    mods = session.query(Permission.modifier).join(RolePermission).filter(
        RolePermission.role_name.in_(get_user_roles(session, user_id))).filter(
        Permission.res_name == res_name).filter(
        Permission.action == action)

    return [mod.modifier for mod in mods]
