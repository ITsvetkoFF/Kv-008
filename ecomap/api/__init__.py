import json
import os
import sys


with open(os.path.join(os.path.dirname(os.path.abspath(sys.argv[0])),
                       'settings.json')) as json_settings:
    settings = json.load(json_settings)
