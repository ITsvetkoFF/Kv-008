from sqlalchemy import Column, Integer, String, Text, Boolean

from api.v1_0.models import Base


class Page(Base):

    __tablename__ = 'pages'

    id = Column(Integer, primary_key=True, autoincrement=True)
    alias = Column(String(30), nullable=False)
    title = Column(String(150), nullable=False)
    content = Column(Text, nullable=False)
    is_resource = Column(Boolean, nullable=False)