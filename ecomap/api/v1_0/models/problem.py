from sqlalchemy import Integer, String, Text, Column, ForeignKey, Enum
from sqlalchemy.orm import relationship
from geoalchemy2 import Geography
from wtforms import FloatField
from wtforms.validators import NumberRange
from wtforms_alchemy import ModelForm
from api.v1_0.models import Base, enum_severity_type, enum_status
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
    problem_type_id = Column(Integer, ForeignKey('problem_types.id'))
    region_id = Column(Integer, ForeignKey('regions.id'))

    problem_type = relationship('ProblemType')
    region = relationship('Region')
    region = relationship('Region')


class ProblemForm(ModelForm):
        class Meta:
            model = Problem
            exclude = ['location']
            include = ['problem_type_id','region_id']
        Latitude = FloatField(validators=[NumberRange()])
        Longtitude = FloatField(validators=[NumberRange()])