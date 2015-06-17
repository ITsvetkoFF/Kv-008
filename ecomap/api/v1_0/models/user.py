from sqlalchemy import Integer, String, Column, ForeignKey
from sqlalchemy.orm import relationship

import wtforms_json
from wtforms.validators import Email
from wtforms_alchemy import ModelForm

from api.v1_0.models._config import user_roles
from api.v1_0.models import Base


class User(Base):
    __tablename__ = 'users'

    id = Column(Integer, primary_key=True, autoincrement=True)
    first_name = Column(String(100), nullable=False)
    last_name = Column(String(100), nullable=False)
    # additional email validation
    email = Column(String(100), nullable=False, unique=True,
                   info={'validators': Email()})
    password = Column(String(100))
    region_id = Column(Integer, ForeignKey('regions.id'))
    google_id = Column(String(100))
    facebook_id = Column(String(100))

    roles = relationship('Role', secondary=user_roles)
    region = relationship('Region')

# validation for data from front-end
# register and login data validation
wtforms_json.init()


def define_register_form_class(session):
    class UserRegisterForm(ModelForm):
        class Meta:
            model = User

        @classmethod
        def get_session(cls):
            return session

    return UserRegisterForm


class UserLoginForm(ModelForm):
    class Meta:
        model = User
        only = ['email', 'password']
