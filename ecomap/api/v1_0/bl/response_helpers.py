def iso8601_conv_with_empty_check(date):
    if date is not None:
        return date.strftime("%Y-%m-%dT%H:%M:%S.000Z")
    else:
        return date


def conv_array_to_dict(array):
    return dict(count=len(array), data=array)