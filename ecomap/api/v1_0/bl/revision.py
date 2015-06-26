from api.v1_0.models import ProblemsActivity
import json

def generate_data(query):
    all_problems = []

    for problem, point_json in (query):
        Latitude, Longtitude = json.loads(point_json)['coordinates']
        all_problems.append(dict(
            id=problem.id,
            title=problem.title,
            status=problem.status,
            datetime=str(problem.datetime),
            problem_type_id=problem.problem_type_id,
            Latitude=Latitude,
            Longitude=Longtitude,
            content=problem.content,
            severity=problem.severity,
            proposal=problem.proposal,
            region_id=problem.region_id,
            number_of_comments=problem.number_of_comments,
            number_of_votes=problem.number_of_votes,
            first_name=problem.first_name,
            last_name=problem.last_name

        ))
    return  all_problems

def query_converter(query):
    problems=tuple()
    for id in query:
        problems = problems + id
    return problems

def removed_data(removed):
    data = []
    for item in removed:
        data = data +[{'id': item, 'action':'DELETED'}]
    return data

def vote_data(query):
    data = []
    for ident, count in (query):
        data = data +[{'id': ident, 'action':'VOTE', 'count': count}]
    return data

def concat_args(args):
    result=()
    for arg in args:
        result = result + arg
    return result

def revision(model, previous_revision, type, *args):
    Table = ProblemsActivity
    query = model.sess.query(Table.problem_id).distinct(). \
        filter(
        Table.id>previous_revision,
        Table.problem_id. \
            notin_(concat_args(args)),
        Table.activity_type==type ).all()
    return query_converter(query)