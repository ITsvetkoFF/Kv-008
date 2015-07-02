from sqlalchemy import Integer, String, Text, Column, ForeignKey, Enum, DateTime
from geoalchemy2 import Geography
from api.v1_0.models import Base, SEVERITY_TYPES, STATUSES



class DetailedProblem(Base):
    __tablename__ = 'detailed_problem'

    id = Column(Integer, primary_key=True)
    title = Column(String(200), nullable=False)
    content = Column(Text)
    proposal = Column(Text)
    severity = Column(Enum(*SEVERITY_TYPES, name='severitytypes'))
    location = Column(Geography, nullable=False)
    status = Column(Enum(*STATUSES, name='status'))
    problem_type_id = Column(Integer, ForeignKey('problem_types.id'))
    region_id = Column(Integer, ForeignKey('regions.id'))
    first_name = Column(String(100), nullable=False)
    last_name = Column(String(100), nullable=False)
    datetime = Column(DateTime, nullable=False)
    number_of_votes = Column(Integer)
    number_of_comments = Column(Integer)


