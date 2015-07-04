from sqlalchemy import String, Column

# this import has to be here to run permission.py before Role definition.
from api.v1_0.models import Base


class Role(Base):
    __tablename__ = 'roles'

    name = Column(String(100), primary_key=True)
