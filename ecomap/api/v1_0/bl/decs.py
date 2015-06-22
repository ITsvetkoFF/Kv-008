from api.v1_0.models import User, Problem, Photo, Comment


def check_if_exists(model):
    message = 'Bad model argument for check_if_exists decorator.'
    assert model in (User, Photo, Problem, Comment), message

    def decorator(method):
        def wrapper(handler, id):
            if not handler.sess.query(model).get(id):
                handler.send_error(404, message='{} not found.'.format(
                    model.__name__))
                return

            method(handler, id)

        return wrapper

    return decorator
