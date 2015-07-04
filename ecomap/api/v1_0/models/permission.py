from sqlalchemy import Column, Integer, Enum, ForeignKey, String
from sqlalchemy.orm import relationship

from api.v1_0.models import Base, ACTIONS, MODIFIERS


class Permission(Base):
    __tablename__ = 'permissions'

    id = Column(Integer, primary_key=True, autoincrement=True)
    resource_name = Column(String(100), ForeignKey('resources.name'),
                           nullable=False)
    action = Column(Enum(*ACTIONS, name='actions'), nullable=False)
    modifier = Column(Enum(*MODIFIERS, name='modifiers'))
