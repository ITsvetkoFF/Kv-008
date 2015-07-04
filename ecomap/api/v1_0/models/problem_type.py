from sqlalchemy import Integer, String, Column
from api.v1_0.models import Base


class ProblemType(Base):
    __tablename__ = 'problem_types'

    name = Column(String(100), primary_key=True)
