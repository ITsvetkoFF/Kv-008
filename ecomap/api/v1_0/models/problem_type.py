from sqlalchemy import Integer, String, Column
from api.v1_0.models import Base


class ProblemType(Base):
    __tablename__ = 'problem_types'

    id = Column(Integer, primary_key=True)
    type = Column(String(100), nullable=False)
