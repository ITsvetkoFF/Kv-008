from sqlalchemy import Column, Integer, DateTime, ForeignKey
from sqlalchemy.orm import relationship

from api.v1_0.models import Base


class VotesActivity(Base):
    __tablename__ = 'votes_activities'

    id = Column(Integer, primary_key=True)

    problem_id = Column(Integer,
                        ForeignKey('problems.id', ondelete='CASCADE'),
                        nullable=False)

    user_id = Column(Integer,
                     ForeignKey('users.id', ondelete='CASCADE'),
                     nullable=False)

    datetime = Column(DateTime, nullable=False)

    problem = relationship('Problem')
    user = relationship('User')
