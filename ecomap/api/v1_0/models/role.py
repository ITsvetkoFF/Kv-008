from sqlalchemy import Integer, String, Column
from sqlalchemy.orm import relationship

from api.v1_0.models import Base
from api.v1_0.models import role_permissions

class Role(Base):
    __tablename__ = 'roles'

    id = Column(Integer, primary_key=True)
    name = Column(String(100), nullable=False, unique=True)

    permissions = relationship('Permission', secondary=role_permissions)
