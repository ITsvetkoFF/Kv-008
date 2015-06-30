from wtforms_json import InvalidData
from api.v1_0.models import *


def permission_control(method):
    def wrapper(handler, obj_id):
        definition_query = {
            'ProblemHandler': handler.sess.query(
                ProblemsActivity.user_id).filter_by(problem_id=obj_id,
                                                    activity_type='ADDED').first()
        }
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
                    handler.send_error(404, message=message)
            if user_id == handler.get_current_user():
                method(handler, obj_id)
            else:
                message = 'You do not have sufficient right'
                handler.send_error(400, message=message)

    return wrapper


def validation(model_form):
    Form = model_form

    def arguments_wrapper(method):
        def wrapper(handler, obj_id):
            try:
                form = Form.from_json(handler.request.arguments,
                                      skip_unknown_keys=False)
            except InvalidData as e:
                message = e.message
                handler.send_error(400, message=message)
            if form.validate():
                method(handler, obj_id)
            else:
                message = form.errors
                handler.send_error(400, message=message)

        return wrapper

    return arguments_wrapper
