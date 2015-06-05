from sqlalchemy import Integer, String, Column, ForeignKey
from sqlalchemy.orm import relationship

from api.v1_0.models import Base, user_roles


class User(Base):
    __tablename__ = 'users'

    id = Column(Integer, primary_key=True)
    first_name = Column(String(100), nullable=False)
    last_name = Column(String(100), nullable=False)
    email = Column(String(100), nullable=False)
    password = Column(String(100))
    region_id = Column(Integer, ForeignKey('regions.id'))
    google_id = Column(String(100))
    facebook_id = Column(String(100))

    roles = relationship('Role', secondary=user_roles)
    region = relationship('Region')
