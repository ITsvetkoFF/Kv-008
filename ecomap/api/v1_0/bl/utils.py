import datetime

def get_datetime():
    return datetime.datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')

def iso_datetime(date):
    if date is not None:
        return date.strftime("%Y-%m-%dT%H:%M:%S.000Z")
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
