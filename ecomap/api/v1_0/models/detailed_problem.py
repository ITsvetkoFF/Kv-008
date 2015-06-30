from api.v1_0.models import *
from sqlalchemy import *
from api.v1_0.bl.view_creator import view

metadata = Base.metadata
user_t = User.__table__.c
problems_activity_t = ProblemsActivity.__table__.c
problems_t = Problem.__table__.c
comments_t = Comment.__table__.c

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
        func.count(comments_t.id).label('number_of_comments'),
        func.count(problems_activity_t.id ).label('number_of_votes'),
        user_t.first_name,
        user_t.last_name
    ]
).where(text("problems_activities.activity_type = 'VOTE' AND problems_activities.problem_id NOT IN (SELECT problems_activities.problem_id FROM problems_activities WHERE problems_activities.activity_type = 'REMOVED') ")) #AND problems_activities.activity_type != 'UPDATED' AND problems_activities.activity_type != 'ADDED' AND problems_activities.activity_type != 'REMOVED'
j = Problem.__table__  # Initial table to join.
table_list = [Comment.__table__, ProblemsActivity.__table__, User.__table__]
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

query2 = select(
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
        func.count(comments_t.id).label('number_of_comments'),
        func.count(text("NULL")).label('number_of_votes'),
        user_t.first_name,
        user_t.last_name
    ]
).where(text("problems_activities.activity_type = 'ADDED' AND problems_activities.problem_id NOT IN (SELECT problems_activities.problem_id FROM problems_activities WHERE problems_activities.activity_type = 'VOTE' OR problems_activities.activity_type = 'REMOVED') "))
j = Problem.__table__  # Initial table to join.
table_list = [Comment.__table__, ProblemsActivity.__table__, User.__table__]
for table in table_list:
    j = j.outerjoin(table)
query2 = query2.select_from(j)
query2 = query2.group_by(
    problems_t.id,
    problems_activity_t.problem_id,
    problems_activity_t.datetime,
    user_t.first_name,
    user_t.last_name,
)
query = union(query2,query1)

detailed_problem_view = view("detailed_problem", metadata, query)

# the ORM would appreciate this
assert detailed_problem_view.primary_key == [detailed_problem_view.c.id]


class DetailedProblem(Base):
    __table__ = detailed_problem_view
