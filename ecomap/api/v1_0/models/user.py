from sqlalchemy import Integer, String, Column, ForeignKey
from sqlalchemy.orm import relationship

from wtforms.validators import Email

from api.v1_0.models import Base


class User(Base):
    __tablename__ = 'users'

    id = Column(Integer, primary_key=True, autoincrement=True)
    first_name = Column(String(100), nullable=False)
    last_name = Column(String(100), nullable=False)

    # additional email validation
    email = Column(String(100), nullable=False,
                   info={'validators': Email()})

    password = Column(String(100), nullable=False)
    region_id = Column(Integer, ForeignKey('regions.id'))
    google_id = Column(String(100))
    facebook_id = Column(String(100))

    region = relationship('Region')

    def check_unique_email(self, session, email, user_id=None):
        """Check email field unique constraint."""
        u = session.query(User).filter(User.email == email).first()
        # if a user sends his own email in payload
        if not u or (user_id and u.id == user_id):
            return True

        return False
