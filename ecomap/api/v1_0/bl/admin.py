from api.v1_0.models import Permission, RolePermission


def get_act_mods(res_meth, session):
    """Returns mods for a perm with the spec. res_name and action.
    The problem is that for some handlers we cannot use OWN mod.
    This func makes rendering a lot slower, but it is essential.
    """
    res_name, action = res_meth.split()
    return [row.modifier for row in session.query(
        Permission.modifier).filter(
        Permission.res_name == res_name,
        Permission.action == action)]


def get_mod(role_name, res_meth, session):
    """Returns the mod of the perm for the specified
    role_permission row.
    """
    res_name, action = res_meth.split()
    perm = session.query(Permission).join(RolePermission).filter(
        Permission.res_name == res_name,
        Permission.action == action,
        RolePermission.role_name == role_name
    ).first()

    return perm.modifier if perm is not None else 'NONE'


def get_perm_id(session, res_name, action, mod):
    """permissions table has to be fully populated."""
    return session.query(Permission).filter(
        Permission.res_name == res_name,
        Permission.action == action,
        Permission.modifier == mod
    ).first().id
