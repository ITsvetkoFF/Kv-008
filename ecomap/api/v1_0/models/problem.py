from sqlalchemy import Integer, String, Text, Column, ForeignKey, Enum
from sqlalchemy.orm import relationship
from geoalchemy2 import Geography

from api.v1_0.models import Base, enum_severity_type, enum_status


class Problem(Base):
    __tablename__ = 'problems'

    id = Column(Integer, primary_key=True)
    title = Column(String(200), nullable=False)
    content = Column(Text)
    proposal = Column(Text)
    severity = Column(Enum(*enum_severity_type, name='severitytypes'))
    location = Column(Geography, nullable=False)
    status = Column(Enum(*enum_status, name='status'))
    problem_type_id = Column(Integer, ForeignKey(u'problem_types.id'))
    region_id = Column(Integer, ForeignKey('regions.id'))

    problem_type = relationship('ProblemType')
    region = relationship('Region')