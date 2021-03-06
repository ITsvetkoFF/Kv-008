from sqlalchemy import Column, Integer, DateTime, Enum, ForeignKey
from sqlalchemy.dialects.postgresql import JSON
from sqlalchemy.orm import relationship

from api.v1_0.models import Base, ACTIVITY_TYPES


class ProblemsActivity(Base):
    __tablename__ = 'problems_activities'

    id = Column(Integer, primary_key=True)

    problem_id = Column(Integer,
                        ForeignKey('problems.id', ondelete='CASCADE'),
                        nullable=False)

    user_id = Column(Integer, ForeignKey('users.id'))
    datetime = Column(DateTime, nullable=False)

    activity_type = Column(Enum(*ACTIVITY_TYPES, name='activitytype'),
                           nullable=False)

    problem = relationship('Problem', backref='problem_activities')
    user = relationship('User', backref='problem_activities')
