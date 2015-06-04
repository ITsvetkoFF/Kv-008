from sqlalchemy import Column, Integer, String

from api.v1_0.models import Base


class Resource(Base):
    __tablename__ = 'resources'

    id = Column(Integer, primary_key=True)
    name = Column(String(100), nullable=False)
