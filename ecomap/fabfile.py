# coding: utf-8

__all__ = [
    'build_docs',
    'clean_pyc',
    'init_db',
    'run',
    'test',
    'upgrade',
    'populate_db',
    'runtests'
]

import os
from fabric.api import local as fab_run

from api.v1_0.models import Base
from api.utils.db import get_db_engine
from api import settings

PROJECT_ROOT = os.path.dirname(os.path.abspath(__file__))


def clean_pyc():
    """
    Removes *.pyc files
    """
    fab_run('find . -name "*.pyc" -delete')


def test():
    """ Runs tests with nose. """
    fab_run('nosetests -vs')


def runtests():
    """Runs runtests.py with buffer and failfast options."""
    fab_run('python -m api.v1_0.tests.runtests --buffer --failfast')


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
        'sphinx-build -E -b html -a %s/docs/source %s/docs/build/html' % (
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


def init_db(dump=None):
    """Initialize ecomap_db database.
    If you set the dump configuration like fab init_db:from_dump,
    you will receive the data from dump. Otherwise you will create a new db without data.
    """
    fab_run('sudo -u postgres psql -f init_ecomap_db.sql;'
            'export PYTHONPATH=":/ecomap"')
    if dump == 'from_dump':
        path_to_dal = '/ecomap/api/dal'
        fab_run('sudo -u postgres psql ecomap_db < %s/dumps/ecomap_db_dump.sql;' % path_to_dal)
    else:
        Base.metadata.create_all(get_db_engine(settings))
        fab_run('sudo -u postgres psql -f /ecomap/api/dal/view.sql;')


def populate_db(problems_count):
    """Populate database with fake data."""
    fab_run('export PYTHONPATH=":/ecomap"')
    fab_run('python factories.py %s' % problems_count)