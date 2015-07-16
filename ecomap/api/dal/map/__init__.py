import json

from os.path import dirname, join


with open(join(dirname(__file__), 'ukraine.json')) as json_settings:
    geo_ukraine = json.load(json_settings)