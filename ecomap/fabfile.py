# coding: utf-8

__all__ = [
    'build_docs',
    'clean_pyc',
    'init_db',
    'run',
    'test',
    'upgrade',
    'create_database',
    'import_dump',
    'drop_database',
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


def init_db():
    fab_run('sudo -u postgres psql -f init_ecomap_db.sql;'
            'export PYTHONPATH=":/ecomap"')
    Base.metadata.create_all(get_db_engine(settings))

def populate_db(problems_count):
    """Populate database with fake data."""
    fab_run('export PYTHONPATH=":/ecomap"')
    fab_run('python factories.py %s' % problems_count)


def create_database(db_name):
    """
    Create empty database
    """
    fab_run('sudo -u postgres psql -c "CREATE DATABASE %s"' % db_name)


def import_dump():
    """
    Import dump to database
    """
    while True:
        try:
            db_name = str(raw_input('Choose database (default "ecomap_db"): ')) or 'ecomap_db'
            dump_name = str(raw_input('Dump name(only name): '))
            fab_run('sudo -u postgres psql  %s < ../ecomap/api/dal/dumps/%s.sql' % (db_name, dump_name))
            break
        except:
            answer = str(raw_input("Incorrect dump name. Try again? y/N: "))
            if answer == 'y':
                continue
            else:
                break


def drop_database(db_name):
    """
    Drop selected database
    """
    fab_run('sudo -u postgres psql -c "DROP DATABASE IF EXISTS %s"' % db_name)
