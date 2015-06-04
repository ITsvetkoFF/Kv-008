from sqlalchemy import Column, Integer, ForeignKey
from sqlalchemy.orm import relationship

from api.v1_0.models import Base

class Solution(Base):
    __tablename__ = 'solutions'

    id = Column(Integer, primary_key=True)
    problem_id = Column(Integer,
                        ForeignKey(u'problems.id', ondelete=u'CASCADE'),
                        nullable=False)
    administrator_id = Column(Integer, ForeignKey(u'users.id'), nullable=False)
    responsible_id = Column(Integer, ForeignKey(u'users.id'), nullable=False)

    problem = relationship('Problem')
    administrator = relationship('User', foreign_keys=[administrator_id])
    responsible = relationship('User', foreign_keys=[responsible_id])
