import tornado.escape
import wtforms_json

from api.v1_0.models.user import User
from api.v1_0.forms.user import UserLoginForm, UserRegisterForm


def _store_new_user(handler, new_user):
    if new_user.verify_new_email(handler):
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


def get_absolute_redirect_uri(handler, url_name):
    """Use reverse_url and settings to create a redirect uri."""
    return 'http://{}:{}{}'.format(
        handler.settings['hostname'],
        handler.settings['bind_port'],
        handler.reverse_url(url_name)
    )


def load_user_by_email(handler, email):
    return handler.sess.query(User).filter(User.email == email).first()
