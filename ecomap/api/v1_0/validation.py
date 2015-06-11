import wtforms_json
from wtforms_alchemy import ModelForm
from wtforms import FloatField
from wtforms.validators import NumberRange
from api.v1_0.models import Problem


wtforms_json.init()

class ProblemForm(ModelForm):
        class Meta:
            model = Problem
            exclude = ['location']
            include = ['problem_type_id','region_id']
        Latitude = FloatField(validators=[NumberRange()])
        Longtitude = FloatField(validators=[NumberRange()])