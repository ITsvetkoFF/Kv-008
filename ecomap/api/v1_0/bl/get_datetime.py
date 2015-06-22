import datetime

def get_datetime():
    return datetime.datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')
