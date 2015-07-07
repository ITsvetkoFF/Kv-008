from sqlalchemy import Column, Integer, String

from api.v1_0.models import Base


class Resource(Base):
    __tablename__ = 'resources'

    name = Column(String(100), primary_key=True)
