from sqlalchemy import Integer, String, Column, ForeignKey
from sqlalchemy.orm import relationship

from wtforms.validators import Email

from api.v1_0.models._config import user_roles
from api.v1_0.models import Base


class User(Base):
    __tablename__ = 'users'

    id = Column(Integer, primary_key=True, autoincrement=True)
    first_name = Column(String(100), nullable=False)
    last_name = Column(String(100), nullable=False)

    # additional email validation
    email = Column(String(100), nullable=False,
                   info={'validators': Email()})

    password = Column(String(100))
    region_id = Column(Integer, ForeignKey('regions.id'))
    google_id = Column(String(100))
    facebook_id = Column(String(100))

    roles = relationship('Role', secondary=user_roles)
    region = relationship('Region')

    def verify_new_email(self, handler):
        """Check email field unique constraint."""
        email_unique = False
        if handler.sess.query(User).filter(User.email == self.email).first():
            handler.send_error(400, message='Email already in use.')
        else:
            email_unique = True

        return email_unique
