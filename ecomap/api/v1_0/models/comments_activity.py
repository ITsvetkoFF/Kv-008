from sqlalchemy import Column, Integer, DateTime, Enum, ForeignKey
from sqlalchemy.orm import relationship

from api.v1_0.models import Base, enum_activity_type


class CommentsActivity(Base):
    __tablename__ = 'comments_activities'

    id = Column(Integer, primary_key=True)
    problem_id = Column(Integer, ForeignKey('problems.id', ondelete='CASCADE'),
                        nullable=False)
    user_id = Column(Integer, ForeignKey(u'users.id', ondelete=u'CASCADE'),
                     nullable=False)
    comment_id = Column(Integer,
                        ForeignKey(u'comments.id', ondelete=u'CASCADE'),
                        nullable=False)
    datetime = Column(DateTime, nullable=False)
    activity_type = Column(Enum(*enum_activity_type, name='activitytype'),
                           nullable=False)

    problem = relationship('Problem')
    user = relationship('User')
    comment = relationship('Comment')
