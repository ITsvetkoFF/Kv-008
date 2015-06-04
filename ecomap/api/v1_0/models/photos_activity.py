from sqlalchemy import Column, Integer, DateTime, ForeignKey, Enum
from sqlalchemy.orm import relationship

from api.v1_0.models import Base, enum_activity_type


class PhotosActivity(Base):
    __tablename__ = 'photos_activities'

    id = Column(Integer, primary_key=True)
    photo_id = Column(Integer, ForeignKey(u'photos.id', ondelete=u'CASCADE'),
                      nullable=False)
    problem_id = Column(Integer, ForeignKey('problems.id', ondelete='CASCADE'),
                        nullable=False)
    user_id = Column(Integer, ForeignKey(u'users.id'), nullable=False)
    datetime = Column(DateTime, nullable=False)
    activity_type = Column(Enum(*enum_activity_type, name='activitytype'),
                           nullable=False)

    photo = relationship('Photo')
    problem = relationship('Problem')
    user = relationship('User')