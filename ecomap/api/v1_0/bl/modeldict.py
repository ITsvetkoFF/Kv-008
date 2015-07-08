from inspect import isclass

from api.v1_0.bl.utils import iso_datetime


def get_row_data(obj, password=False):
    """Put data from the object associated table row into a dict."""
    data = {col.name: getattr(obj, col.name) for col in obj.__table__.columns}
    if 'datetime' in data:
        data['datetime'] = iso_datetime(data['datetime'])

    if not password and 'password' in data:
        del data['password']

    return data


def update_row_data(obj, data):
    while data:
        setattr(obj, *data.popitem())

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
