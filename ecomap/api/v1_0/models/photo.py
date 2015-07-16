from sqlalchemy import Column, String, Integer, Text, ForeignKey, DateTime
from api.v1_0.models import Base


class Photo(Base):
    __tablename__ = 'photos'

    id = Column(Integer,
                primary_key=True,
                autoincrement=True)

    name = Column(String(200), nullable=False)
    datetime = Column(DateTime)
    comment = Column(Text)

    problem_id = Column(Integer,
                        ForeignKey('problems.id'),
                        nullable=False)

    user_id = Column(Integer, ForeignKey('users.id'))
