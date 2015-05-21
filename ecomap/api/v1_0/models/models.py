class User(object):
    def __init__(self, name, surname, email, password):
        self.name = name
        self.surname = surname
        self.email = email
        self.password = password

    def __repr__(self):
        return '<User> {} {} {}'.format(
            self.name,
            self.surname,
            self.role
        )


class UserRole(object):
    def __init__(self, role):
        self.role = role

    def __repr__(self):
        return '<User Role> {}'.format(self.role)


class Permission(object):
    def __init__(self, operation, modifier):
        self.operation = operation
        self.modifier = modifier

    def __repr__(self):
        return '<Permission to> {} {} {}'.format(
            self.operation,
            self.modifier,
            self.resource
        )


class Resource(object):
    def __init__(self, name):
        self.name = name

    def __repr__(self):
        return '<Resource> {}'.format(self.name)
