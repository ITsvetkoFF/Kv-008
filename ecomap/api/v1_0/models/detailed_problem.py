from api.v1_0.models import *
from sqlalchemy import *
from api.v1_0.bl.view_creator import view

metadata = Base.metadata
user_t = User.__table__.c
problems_activity_t = ProblemsActivity.__table__.c
problems_t = Problem.__table__.c
votes_activity_t = VotesActivity.__table__.c

query = select(
    [
        problems_t.id,
        problems_t.title,
        problems_t.content,
        problems_t.proposal,
        problems_t.severity,
        problems_t.status,
        problems_t.location,
        problems_t.problem_type_id,
        problems_t.region_id,
        problems_activity_t.datetime,
        func.count(votes_activity_t.id).label('votes_numbers'),
        (user_t.first_name + user_t.last_name).label('name')
    ]
).where(
    problems_activity_t.problem_id == votes_activity_t.problem_id
).where(
    problems_activity_t.problem_id == problems_t.id
).where(
    problems_activity_t.user_id == user_t.id
).group_by(
    problems_t.id,
    problems_activity_t.problem_id,
    problems_activity_t.datetime,
    user_t.first_name,
    user_t.last_name
)

detailed_problem_view = view("detailed_problem", metadata, query)



# the ORM would appreciate this
assert detailed_problem_view.primary_key == [detailed_problem_view.c.id]


class DetailedProblem(Base):
    __table__ = detailed_problem_view