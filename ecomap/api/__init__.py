import json

from os.path import dirname, join

with open(join(dirname(dirname(__file__)), 'settings.json')) as json_settings:
    settings = json.load(json_settings)
