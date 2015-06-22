from sqlalchemy import Column, Integer, Enum, ForeignKey
from sqlalchemy.orm import relationship

import api.v1_0.models.resource
from api.v1_0.models import Base, ACTIONS, MODIFIERS


class Permission(Base):
    __tablename__ = 'permissions'

    id = Column(Integer, primary_key=True, autoincrement=True)
    resource_id = Column(Integer, ForeignKey('resources.id'), nullable=False)
    action = Column(Enum(*ACTIONS, name='actions'), nullable=False)
    modifier = Column(Enum(*MODIFIERS, name='modifiers'), nullable=False)

    resource = relationship('Resource')
