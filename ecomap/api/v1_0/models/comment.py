from sqlalchemy import Column, Integer, Text

from api.v1_0.models import Base


class Comment(Base):
    __tablename__ = 'comments'

    id = Column(Integer, primary_key=True)
    content = Column(Text, nullable=False)