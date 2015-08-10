from api.v1_0.models import UserRole, RolePermission
from api.v1_0.models.user import User
from api.v1_0.models.permission import Permission
from api.v1_0.bl.utils import define_values


def complete_auth(handler, user):
    """Completes authentication process setting a cookie and writing some
    user data to the client."""
    handler.set_cookie('user_id', str(user.id))
    handler.write({
        'user_id': user.id,
        'first_name': user.first_name,
        'last_name': user.last_name,
        'user_roles': ':'.join(get_user_roles(handler.sess, user.id)),
        'user_perms': [':'.join(row) for row in get_user_perms(
            handler.sess, user.id)]
    })


def get_user_perms(session, user_id):
    """Returns a query obj of all permissions (distinct if a user has
    multiple roles with common permissions).
    """
    return session.query(
        Permission.res_name,
        Permission.action,
        Permission.modifier
    ).join(RolePermission).filter(RolePermission.role_name.in_(
        get_user_roles(session, user_id))).distinct()


def get_role_perms(session, role_name):
    return session.query(Permission).join(RolePermission).filter(
        RolePermission.role_name == role_name).all()


def get_user_roles(session, user_id):
    return [row.role_name for row in session.query(UserRole.role_name).filter(
        UserRole.user_id == user_id)]


def store_new_user(session, new_user):
    if new_user.check_unique_email(session, new_user.email):
        session.add(new_user)
        user_id = session.query(User.id).filter(
            User.email == new_user.email).first()
        session.add(UserRole(user_id=user_id, role_name='user'))
        session.commit()
        return new_user


def create_fb_user(user_profile):
    return User(
        first_name=user_profile['first_name'],
        last_name=define_values(user_profile,'last_name'),
        email=user_profile['email'],
        region_id=define_values(user_profile,'region_id'),
        facebook_id=user_profile['facebook_id']
    )


def get_absolute_redirect_uri(handler, url_name):
    """Use reverse_url and settings to create a redirect uri."""
    return 'http://{}:{}{}'.format(
        handler.settings['hostname'],
        handler.settings['bind_port'],
        handler.reverse_url(url_name)
    )


def get_user_with_email(handler, email):
    return handler.sess.query(User).filter(User.email == email).first()
