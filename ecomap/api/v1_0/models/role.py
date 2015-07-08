from sqlalchemy import Integer, String, Column
from sqlalchemy.orm import relationship

# this import has to be here to run permission.py before Role definition.
import api.v1_0.models.permission
from api.v1_0.models import Base


class Role(Base):
    __tablename__ = 'roles'

    id = Column(Integer, primary_key=True)
    name = Column(String(100), nullable=False, unique=True)
