import sqlsoup
from sqlalchemy import Column, Enum, Integer, String, Text, text, create_engine, ForeignKey, Date
from fabric.api import local

from api import settings
from api.utils.db import get_db_session
from api.v1_0.models.page import Page


URL = '{db_type}://{username}:{password}@{host}/{database}?charset={charset}'

MYSQL_URL = URL.format(db_type='mysql',
                       username='root',
                       password='root',
                       host='localhost',
                       database='Enviromap',
                       charset='utf8')


class MigrateDB(object):
    def __init__(self):
        self.mysql_db = sqlsoup.SQLSoup(MYSQL_URL)
        self.session = get_db_session(settings)()

    def fill_test_region_id(self):
        pass

    def clear_tables(self):
        self.session.execute('DELETE FROM pages;')
        self.session.commit()
        pass

    def create_dump(self, file_name):
        local(
            "pg_dump -U {user} -h {host} -d {db} > dumps/{file_name}.sql".format(
                user=settings['psql_login'],
                host=settings['psql_host'],
                db=settings['psql_dbname'],
                file_name=file_name
            )
        )

    def migrate_resources(self):
        resources = self.mysql_db.Resources.all()
        for resource in resources:
            resource_data = Page(
                alias=resource.Alias,
                title=resource.Title,
                content=resource.Content,
                is_resource=True
            )
            self.session.add(resource_data)
            self.session.commit()

    def migrate_user_roles(self):
        pass

    def migrate_user(self):
        pass

    def migrate_problem_types(self):
        pass

    def migrate_problems(self):
        pass

    def migrate_activity(self):
        pass

    def close(self):
        self.session.close()


def main():
    # Init configs
    ecomap_db = MigrateDB()
    # -----

    # clear tables
    ecomap_db.clear_tables()
    # -----

    # migrate Resources to pages
    ecomap_db.migrate_resources()
    # -----

    # Close db
    ecomap_db.close()
    # -----

    # Dump psql
    ecomap_db.create_dump('ecomap_db_dump')
    # -----

if __name__ == '__main__':
    main()