import wtforms_json
from wtforms_alchemy import ModelForm
from api.v1_0.models import User

wtforms_json.init()


class UserRegisterForm(ModelForm):
    class Meta:
        # need to add password_required check here
        model = User

class UserLoginForm(ModelForm):
    class Meta:
        model = User
        only = ['email', 'password']
