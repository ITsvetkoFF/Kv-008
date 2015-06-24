from inspect import isclass
from datetime import datetime
from sqlalchemy import func
from api.v1_0.bl.utils import iso_datetime
from api.v1_0.models import DetailedProblem, ProblemsActivity
import json


def get_dict_from_orm(object_model):
    """"""
    return dict((key.name, None if isclass(object_model) else getattr(object_model, key.name))
                for key in object_model.__table__.columns)

def get_object_from_dict(model, income_dict):
    try:
        result = model()
        for key in income_dict:
            setattr(result, key, income_dict[key])
    except KeyError as e:
        raise 'No such field {filed} in model {model}'.format(
            field=key,
            model=model.__class__.__name__
        )

    return result

def update_model_from_dict(model, model_dict):
    """
    """
    for attr in model_dict:
        setattr(model, attr, model_dict[attr])

    return model

def get_dict_problem_data(problem):
    problem_data = dict()
    for c in problem.__table__.columns:
        if isinstance(getattr(problem, c.name), datetime):
            problem_data[c.name] = iso_datetime(getattr(problem, c.name))
        else:
            problem_data[c.name] = getattr(problem, c.name)
    return problem_data

def generate_data(model, revised_id = (0,)):
    all_problems = []

    for problem, point_json in (model.sess.query(
                DetailedProblem,
                func.ST_AsGeoJSON(DetailedProblem.location)).filter(DetailedProblem.id.in_(revised_id))
        ):
        Latitude, Longtitude = json.loads(point_json)['coordinates']
        all_problems.append(dict(
            id=problem.id,
            title=problem.title,
            status=problem.status,
            datetime=str(problem.datetime),
            problem_type_id=problem.problem_type_id,
            Latitude=Latitude,
            Longtitude=Longtitude,
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

def revision_problems(model, previous_revision):
    Table = ProblemsActivity
    problems_removed = revision_removed_problems(model, previous_revision)

    vote = model.sess.query(Table.problem_id).distinct(). \
        filter(
        Table.id>previous_revision,
        Table.problem_id.notin_(problems_removed),
        Table.activity_type=="VOTE"
    ).all()
    problems_votes = query_converter(vote)

    updated = model.sess.query(Table.problem_id).distinct(). \
        filter(
        Table.id>previous_revision,
        Table.problem_id.notin_(problems_removed + problems_votes),
        Table.activity_type=="UPDATED"
    ).all()
    problems_updated = query_converter(updated)
    added = model.sess.query(Table.problem_id).distinct(). \
        filter(
        Table.id>previous_revision,
        Table.problem_id. \
            notin_(problems_removed + problems_votes + problems_updated),
        Table.activity_type=="ADDED" ).all()
    problems_added = query_converter(added)
    revised_id = problems_added + problems_updated + problems_votes
    return revised_id

def revision_removed_problems (model, previous_revision):
    Table = ProblemsActivity
    removed = model.sess.query(Table.problem_id). \
        filter(
        Table.id>previous_revision,
        Table.activity_type=="REMOVED"
    ).all()
    problems_removed = query_converter(removed)
    return problems_removed

