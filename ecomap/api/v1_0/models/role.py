from sqlalchemy import Integer, String, Column
from sqlalchemy.orm import relationship

# this import has to be here to run permission.py before Role definition.
import api.v1_0.models.permission
from api.v1_0.models import Base
from api.v1_0.models import role_permissions


class Role(Base):
    __tablename__ = 'roles'

    name = Column(String(100), primary_key=True)

    permissions = relationship('Permission', secondary=role_permissions)
