from ecomap.api.v1_0.models.mappings import User, Resource


def operation_allowed(method):
    def wrapper(*args):
        inst = args[0]  # request handler instance
        # you need to have `user_id` cookie set
        user = inst.db_sess.query(User).get(inst.current_user)
        resource = inst.db_sess.query(Resource).filter(
            Resource.name == inst.request.path).one()

        for perm in user.role.permissions:
            if (perm.resource_id == resource.id and
                        perm.operation == inst.request.method.lower()):
                method(*args)
                return

        inst.write({
            'user': str(user),
            'resource': str(resource),
            'status 403': 'operation not allowed'
        })

    return wrapper
