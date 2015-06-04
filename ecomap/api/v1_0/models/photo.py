from sqlalchemy import Column, Integer, String, Text

from api.v1_0.models import Base


class Photo(Base):
    __tablename__ = 'photos'

    id = Column(Integer, primary_key=True)
    link = Column(String(200), nullable=False)
    comment = Column(Text)