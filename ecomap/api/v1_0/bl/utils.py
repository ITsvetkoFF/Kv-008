import datetime
from api.v1_0.models import ProblemsActivity

def get_datetime():
    return datetime.datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')

def iso_datetime(date):
    if date is not None:
        return date.strftime("%Y-%m-%dT%H:%M:%S.000%z")
    else:
        return date


def conv_array_to_dict(array):
    return dict(count=len(array), data=array)


def create_location( x, y):
    return "POINT({0} {1})".format(x, y)

def define_values(arguments, key, default = None):
    try:
        arguments[key]
    except KeyError:
        return default
    else:
        return arguments[key]

def check_vote(handler, problem_id):
    return handler.sess.query(ProblemsActivity.id).filter(
        ProblemsActivity.problem_id==problem_id,
        ProblemsActivity.user_id==handler.current_user,
        ProblemsActivity.activity_type=='VOTE').first()
