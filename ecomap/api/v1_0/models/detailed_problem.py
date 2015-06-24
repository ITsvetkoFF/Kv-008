from api.v1_0.models import *
from sqlalchemy import *
from api.v1_0.bl.view_creator import view

metadata = Base.metadata
user_t = User.__table__.c
problems_activity_t = ProblemsActivity.__table__.c
problems_t = Problem.__table__.c

query = select(
    [
        problems_t.id,
        problems_t.title,
        problems_t.content,
        problems_t.proposal,
        problems_t.severity,
        problems_t.status,
        func.ST_GeogFromWKB(problems_t.location).label('location'),
        problems_t.problem_type_id,
        problems_t.region_id,
        problems_activity_t.datetime,
        func.count(problems_activity_t.id ).label('number_of_votes'),
        user_t.first_name,
        user_t.last_name
    ]
).where(text("problems_activities.activity_type = 'VOTE'"))
j = Problem.__table__  # Initial table to join.
table_list = [ProblemsActivity.__table__, User.__table__]
for table in table_list:
    j = j.outerjoin(table)
query = query.select_from(j)
query = query.group_by(
    problems_t.id,
    problems_activity_t.problem_id,
    problems_activity_t.datetime,
    user_t.first_name,
    user_t.last_name,
)

query1 = select(
    [
        problems_t.id,
        problems_t.title,
        problems_t.content,
        problems_t.proposal,
        problems_t.severity,
        problems_t.status,
        func.ST_GeogFromWKB(problems_t.location).label('location'),
        problems_t.problem_type_id,
        problems_t.region_id,
        problems_activity_t.datetime,
        func.count(text("NULL")).label('number_of_votes'),
        user_t.first_name,
        user_t.last_name
    ]
).where(text("problems_activities.activity_type != 'VOTE'"))
j = Problem.__table__  # Initial table to join.
table_list = [ProblemsActivity.__table__, User.__table__]
for table in table_list:
    j = j.outerjoin(table)
query1 = query1.select_from(j)
query1 = query1.group_by(
    problems_t.id,
    problems_activity_t.problem_id,
    problems_activity_t.datetime,
    user_t.first_name,
    user_t.last_name,
)
query2 = union(query,query1)

detailed_problem_view = view("detailed_problem", metadata, query2)

# the ORM would appreciate this
assert detailed_problem_view.primary_key == [detailed_problem_view.c.id]


class DetailedProblem(Base):
    __table__ = detailed_problem_view
