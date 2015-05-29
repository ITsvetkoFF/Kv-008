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
    'drop_database'
]

import os

from fabric.api import local as fab_run

from api.v1_0.models import Base, engine


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
    fab_run('sudo -u postgres psql -c "DROP DATABASE IF EXISTS ecomap_db;"')
    fab_run('sudo -u postgres psql -c "DROP ROLE IF EXISTS ecouser;"')
    fab_run('sudo -u postgres psql -c "CREATE DATABASE ecomap_db;"')
    fab_run('sudo -u postgres psql -c "CREATE USER ecouser WITH PASSWORD \'ecouser\';"')
    fab_run('sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO ecouser;"')
    fab_run('sudo -u postgres psql ecomap_db -c "CREATE EXTENSION postgis;"')
    fab_run('sudo -u postgres psql ecomap_db -c "CREATE EXTENSION postgis_topology;"')
    Base.metadata.create_all(engine)


def create_database():
    """
    Create empty database
    """
    try:
        db_name = str(raw_input('Choose database name: '))
        if db_name is False:
            raise BaseException
    except BaseException:
        print "---> Database name not selected"
    finally:
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


def drop_database():
    """
    Drop selected database
    """
    try:
        db_name = str(raw_input('Choose database: '))
        if db_name is False:
            raise ValueError
        fab_run('sudo -u postgres psql -c "DROP DATABASE IF EXISTS %s"' % db_name)
    except ValueError:
        print "---> Database does not selected."
    except:
        print "---> Database %s does not exists." % db_name