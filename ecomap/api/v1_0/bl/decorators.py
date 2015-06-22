from wtforms_json import InvalidData
from api.v1_0.models import *


def permission_control(method):
    def wrapper(handler, obj_id):
        definition_query = {'ProblemsHandler' : handler.sess.query(ProblemsActivity.user_id).filter_by(problem_id=obj_id, activity_type='ADDED').first()}
        modifier = handler.get_action_modifier()
        if modifier == 'NONE':
            message = 'You have not permission to adde problem_id.'
            handler.send_error(400, message=message)
        elif modifier == 'ANY':
            method(handler, obj_id)
        elif modifier == 'OWN':
            user_id = None
            for key in definition_query.keys():
                if handler.__class__.__name__ == key:
                    try:
                        user_id = definition_query[key][0]
                    except TypeError:
                        message='Problem not found for the given id.'
                        handler.send_error(404, massage=message)
            if user_id == handler.get_current_user():
                method(handler, obj_id)
            else:
                message = 'You have not permission to adde problem_id.'
                handler.send_error(400, message=message)
    return wrapper

def checking_validaty(cform):
    Form = cform
    def arguments_wrapper(method):
        def wrapper(handler, obj_id):
            try:
                form = Form.from_json(handler.request.arguments,
                                      skip_unknown_keys=True)
            except InvalidData as e:
                message = e.message
                handler.send_error(400, message=message)
            if form.validate():
                method(handler,obj_id)
            else:
                message = form.errors
                handler.send_error(400, message=message)
        return wrapper
    return arguments_wrapper