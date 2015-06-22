from api.v1_0.models import Base
import sqlalchemy as sa


class Solution(Base):
    __tablename__ = 'solutions'

    id = sa.Column(sa.Integer, primary_key=True, autoincrement=True)

    problem_id = sa.Column(sa.Integer,
                           sa.ForeignKey('problems.id', ondelete='CASCADE'),
                           nullable=False)

    administrator_id = sa.Column(sa.Integer,
                                 sa.ForeignKey('users.id'),
                                 nullable=False)

    responsible_id = sa.Column(sa.Integer,
                               sa.ForeignKey('users.id'),
                               nullable=False)

    problem = sa.orm.relationship('Problem')

    administrator = sa.orm.relationship('User',
                                        foreign_keys=[administrator_id])

    responsible = sa.orm.relationship('User',
                                      foreign_keys=[responsible_id])
