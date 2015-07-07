from api.v1_0.models import UserRole, RolePermission
from api.v1_0.models.user import User
from api.v1_0.models.permission import Permission


def complete_auth(handler, user):
    """Completes authentication process setting a cookie and writing some
    user data to the client."""
    handler.set_cookie('user_id', str(user.id))
    handler.write({
        'first_name': user.first_name,
        'last_name': user.last_name,
        'user_roles': get_user_roles(handler.sess, user.id),
        'user_perms': get_user_perms(handler.sess, user.id)
    })


def get_user_perms(session, user_id):
    """Returns a list of all permissions (distinct if a user has
    multiple roles with common permissions)."""
    return session.query(
        Permission.res_name,
        Permission.action,
        Permission.modifier
    ).join(RolePermission).filter(RolePermission.role_name.in_(
        get_user_roles(session, user_id))).distinct().all()


def get_user_roles(session, user_id):
    return [row.role_name for row in session.query(UserRole.role_name).filter(
        UserRole.user_id == user_id)]


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
