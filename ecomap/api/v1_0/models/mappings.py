from sqlalchemy import MetaData
from sqlalchemy.orm import mapper, relationship
from ecomap.api.utils.database import engine

from .models import *

metadata = MetaData()
metadata.reflect(bind=engine)

mapper(User, metadata.tables['users'])
# `user_roles` table is in a one-to-many relationship with `users` table
# and also in many-to-many relationship with `permissions` table
mapper(UserRole, metadata.tables['user_roles'], properties={
    'users': relationship(User, backref='role'),
    'permissions': relationship(
        Permission,
        secondary=metadata.tables['roles2permissions'],
        backref='roles'
    )
})
mapper(Permission, metadata.tables['permissions'])
# `resources` table is in one-to-many relationship with `permissions`  table
mapper(Resource, metadata.tables['resources'], properties={
    'permissions': relationship(Permission, backref='resource')
})
