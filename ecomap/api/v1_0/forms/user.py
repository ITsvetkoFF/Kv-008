import wtforms_json
from wtforms_alchemy import ModelForm
from api.v1_0.models import User

wtforms_json.init()


class UserRegisterForm(ModelForm):
    class Meta:
        # need to add password_required check here
        model = User
        exclude = ['facebook_id', 'google_id']
        include = ['region_id']

class UserRegisterFbForm(ModelForm):
    class Meta:
        model = User
        exclude = ['google_id', 'password']
        include = ['region_id']

class UserRegisterGpForm(ModelForm):
    class Meta:
        model = User
        exclude = ['facebook_id', 'password']
        include = ['region_id']

class UserLoginForm(ModelForm):
    class Meta:
        model = User
        only = ['email', 'password']


class UserUpdateForm(ModelForm):
    class Meta:
        model = User
        exclude = ['facebook_id', 'google_id']
        include = ['region_id']
        optional_validator = None

