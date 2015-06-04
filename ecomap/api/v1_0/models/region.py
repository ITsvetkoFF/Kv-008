from sqlalchemy import Integer, Column, String
from geoalchemy2 import Geometry

from api.v1_0.models import Base


class Region(Base):
    __tablename__ = 'regions'

    id = Column(Integer, primary_key=True)
    name = Column(String(100), nullable=False)
    location = Column(Geometry, nullable=False)
