import wtforms_json
from wtforms_alchemy import ModelForm
from api.v1_0.models import Page
from api.utils.db import get_db_session
from api import settings

session = get_db_session(settings)
wtforms_json.init

class PageForm(ModelForm):
    class Meta:
        model = Page
    @classmethod
    def get_session(self):
        return session()

class PutPageFrom(ModelForm):
    class Meta:
        model = Page
        unique_validator = None