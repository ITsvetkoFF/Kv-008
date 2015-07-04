from api.v1_0.models._config import UserRole, RolePermission
from api.v1_0.models.user import User
from api.v1_0.models.permission import Permission


def complete_authentication(handler, user):
    handler.set_cookie('user_id', str(user.id))
    handler.write({
        'first_name': user.first_name,
        'last_name': user.last_name,
        'user_roles': get_user_roles(handler.sess, user.id),
        'user_perms': get_user_perms()
    })


def get_user_perms(session, user_id):
    session.query(
        Permission.resource_name,
        Permission.action,
        Permission.modifier
    ).join(RolePermission).filter(
        RolePermission.role.in_(get_user_roles(session, user_id)))


def get_user_roles(session, user_id):
    return [row.role for row in
            session.query(UserRole.role).filter(UserRole.user == user_id)]


def store_new_user(session, new_user):
    # check_new_email returns a user, if her email matches
    if not new_user.check_new_email(session):
        session.add(new_user)
        session.commit()
        return new_user


def create_fb_user(user_profile):
    return User(
        first_name=user_profile['first_name'],
        last_name=user_profile['last_name'],
        email=user_profile['email'],
        facebook_id=user_profile['id']
    )


def create_google_user(user_profile):
    return User(
        first_name=user_profile['given_name'],
        last_name=user_profile['family_name'],
        email=user_profile['email'],
        google_id=user_profile['id']
    )


def create_new_user(user_data):
    return User(**user_data)


def get_absolute_redirect_uri(handler, url_name):
    """Use reverse_url and settings to create a redirect uri."""
    return 'http://{}:{}{}'.format(
        handler.settings['hostname'],
        handler.settings['bind_port'],
        handler.reverse_url(url_name)
    )


def load_user_by_email(handler, email):
    return handler.sess.query(User).filter(User.email == email).first()
