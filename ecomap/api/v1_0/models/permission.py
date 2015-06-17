from sqlalchemy import Column, Integer, Enum, ForeignKey
from sqlalchemy.orm import relationship

import api.v1_0.models.resource
from api.v1_0.models import Base, enum_actions, enum_modifiers


class Permission(Base):
    __tablename__ = 'permissions'

    id = Column(Integer, primary_key=True, autoincrement=True)
    resource_id = Column(Integer, ForeignKey('resources.id'), nullable=False)
    action = Column(Enum(*enum_actions, name='actions'), nullable=False)
    modifier = Column(Enum(*enum_modifiers, name='modifiers'), nullable=False)

    resource = relationship('Resource')
