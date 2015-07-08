from sqlalchemy import Integer, String, Text, Column, ForeignKey, Enum
from sqlalchemy.orm import relationship
from geoalchemy2 import Geography
from api.v1_0.models import Base, SEVERITY_TYPES, STATUSES

class Problem(Base):
    __tablename__ = 'problems'

    id = Column(Integer, primary_key=True)
    title = Column(String(200), nullable=False)
    content = Column(Text)
    proposal = Column(Text)
    severity = Column(Enum(*SEVERITY_TYPES, name='severitytypes'))
    location = Column(Geography, nullable=False)
    status = Column(Enum(*STATUSES, name='status'))
    problem_type_id = Column(Integer, ForeignKey('problem_types.id'),
                             nullable=False)
    region_id = Column(Integer, ForeignKey('regions.id'))

    problem_type = relationship('ProblemType')
    region = relationship('Region')
