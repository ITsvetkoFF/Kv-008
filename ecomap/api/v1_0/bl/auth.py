from api.v1_0.models.user import User
from api.v1_0.bl.modeldict import loaded_obj_data_to_dict as lodtod


def complete_authentication(handler, user):
    handler.set_cookie('user_id', str(user.id))
    handler.write({
        'first_name': user.first_name,
        'last_name': user.last_name,
        'user_roles': [role.name for role in user.roles],
        # I think that looking up a resource in an object is better
        # that in an array.
        'user_perms': {perm.resource.name: lodtod(perm) for
                       role in user.roles for perm in role.permissions}
    })


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


def combine_permissions(user):
    perms = dict()
    for role in user.roles:
        for perm in role.permissions:
            if perm.resource.name not in perms:
                perms[perm.resource.name] = lodtod(perm)
            else:
                if perms[perm.resource.name]['action'] == perm.action:
                    perms[perm.resource.name]['modifier'] = compare_modifiers(
                        perms[perm.resource.name]['modifier'], perm.modifier)
                else:
                    perms


MOD_VALUES = {'NONE': 0, 'OWN': 1, 'ANY': 2}


def compare_modifiers(mod1, mod2):
    return mod1 if MOD_VALUES[mod1] > MOD_VALUES[mod2] else mod2
