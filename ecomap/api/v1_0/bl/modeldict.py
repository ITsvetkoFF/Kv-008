from inspect import isclass
from datetime import datetime

from api.v1_0.bl.utils import iso_datetime


def loaded_obj_data_to_dict(obj):
    """Put data from the object associated table row into a dict."""
    data = {col.name: getattr(obj, col.name) for col in obj.__table__.columns}
    if 'datetime' in data:
        data['datetime'] = iso_datetime(data['datetime'])

    return data


def create_obj_with_data(model, data):
    return model(**data)

    # doesn't make sense
    #
    # try:
    #     result = model()
    #     for key in income_dict:
    #         setattr(result, key, income_dict[key])
    # except KeyError as e:
    #     raise 'No such field {filed} in model {model}'.format(
    #         field=key,
    #         model=model.__class__.__name__
    #     )


def update_loaded_obj_with_data(obj, data):
    obj.__dict__.update(data)
    return obj


# Misha's magic
def get_dict_from_orm(object_model):
    """"""
    return dict((key.name,
                 None if isclass(object_model) else getattr(object_model,
                                                            key.name))
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
