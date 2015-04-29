# coding: utf-8
import os
import types
import json


from api.utils.helpers import import_string


ENV_VARS = (
    'DEBUG',
    'BIND_PORT',
    'BIND_ADDR',

    'TORNADO_START',

    'PSQL_LOGIN',
    'PSQL_PASSWORD',
    'PSQL_HOST',
    'PSQL_PORT',
    'PSQL_DBNAME',
)


# please, explain it to me
def normalized_env_attrs():
    env_attrs = {}
    for key, value in os.environ.items():
        namespace = {}
        val = '%s = %s' % (key, value)
        try:
            exec val in namespace
            value = namespace[key]
        except Exception:
            pass

        env_attrs[key] = value

    return env_attrs


def get_normalized_settings():
    """utility function to build and return application settings dictionary"""
    assert 'CONFIG_CLASS' in os.environ, 'CONFIG_CLASS env variable is needed'
    settings_cls = import_string(os.environ['CONFIG_CLASS'])
    settings = dict([
        (k.lower(), v) for k, v in settings_cls.__dict__.items()
        if not k.startswith('__')
    ])

    # checking for environment variables from ENV_VARS
    env_settings = normalized_env_attrs()

    for env_var in ENV_VARS:
        if env_var in env_settings:
            settings[env_var.lower()] = env_settings[env_var]

    return settings
