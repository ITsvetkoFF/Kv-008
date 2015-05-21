# coding: utf-8

__all__ = [
    'build_docs',
    'clean_pyc',
    'init_db',
    'run',
    'test',
    'upgrade',
]

import os

from fabric.utils import puts
from fabric.contrib.console import confirm
from fabric.api import local as fab_run
from fabric.context_managers import shell_env, lcd
from fabric.colors import green, red

from api.v1_0.models import Base
from api.utils.database import database_session


PROJECT_ROOT = os.path.dirname(os.path.abspath(__file__))


def clean_pyc():
    """
    Removes *.pyc files
    """
    fab_run('find . -name "*.pyc" -delete')


def test():
    """
    Runs tests with nose
    """
    fab_run('nosetests -vs')


def run():
    """
    Runs default App
    """
    fab_run(os.path.join(PROJECT_ROOT, 'app.py'))


def build_docs():
    """
    Builds Sphinx Docs html version, docs/build/html
    """
    fab_run(
        'sphinx-build -a %s/docs/source %s/docs/build/html' % (
            PROJECT_ROOT,
            PROJECT_ROOT
        )
    )


def upgrade():
    """
    Upgrades reqs.pip dependencies
    """
    reqs = os.path.join(PROJECT_ROOT, 'reqs.pip')
    fab_run('pip install -r %s --upgrade' % reqs)


def init_db():
    """
    Creates tables by SQLAlchemy models
    """
    with open('settings.json') as json_settings:
        settings = json.load(json_settings)

    engine = get_db_engine(settings)
    Base.metadata.create_all(bind=engine)
