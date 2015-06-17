import tornado.escape
import wtforms_json

from api.v1_0.models.user import User
from api.v1_0.models.user import (
    define_register_form_class,
    UserLoginForm
)

def decode_json(handler):
    """Decode body json."""
    try:
        data_json = tornado.escape.json_decode(handler.request.body)
        return data_json
    except ValueError:
        # if json is invalid, decode_json() returns None
        handler.send_error(400, message='Invalid request JSON.')


def create_user_register_form(user_data, handler):
    try:
        form = define_register_form_class(handler.sess)().from_json(
            user_data, skip_unknown_keys=False)
        return form
    except wtforms_json.InvalidData as e:
        handler.send_error(400, message='Invalid data: {}'.format(e.message))


def create_user_login_form(user_data, handler):
    try:
        form = UserLoginForm.from_json(
            user_data, skip_unknown_keys=False)
        return form
    except wtforms_json.InvalidData as e:
        handler.send_error(400, message='Invalid data: {}'.format(e.message))


def _store_new_user(handler, new_user):
    handler.sess.add(new_user)
    handler.sess.commit()
    return new_user.id


def store_fb_new_user(handler, user_profile):
    new_user = User(
        first_name=user_profile['first_name'],
        last_name=user_profile['last_name'],
        email=user_profile['email'],
        facebook_id=user_profile['id']
    )
    return _store_new_user(handler, new_user)


def store_google_new_user(handler, user_profile):
    new_user = User(
        first_name=user_profile['given_name'],
        last_name=user_profile['family_name'],
        email=user_profile['email'],
        google_id=user_profile['id']
    )
    return _store_new_user(handler, new_user)


def store_registered_new_user(handler, user_data):
    new_user = User(**user_data)
    return _store_new_user(handler, new_user)


def set_cookie_with_login_informer(handler, user_id):
    """Set a `user_id` cookie and send a message to the user."""
    handler.set_cookie('user_id', str(user_id))
    handler.write({'message': 'Logged in.'})


def get_absolute_redirect_uri(handler, url_name):
    """Use reverse_url and settings to create a redirect uri."""
    return 'http://{}:{}{}'.format(
        handler.settings['hostname'],
        handler.settings['bind_port'],
        handler.reverse_url(url_name)
    )


def handle_client_failure(handler, third_party, message):
    """Clear cookies and send 500."""
    handler.clear_all_cookies()
    handler.send_error(500, message='{}: {}'.format(third_party, message))


def get_stored_user_by_3rd_party_id(handler, third_party, id):
    """Get a user from the database by facebook or google id."""
    return handler.sess.query(User).filter(
        getattr(User, '{}_id'.format(third_party)) == id).first()


def get_user_by_email(handler, email):
    return handler.sess.query(User).filter(User.email == email).first()
