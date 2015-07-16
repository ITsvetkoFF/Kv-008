# -*- coding: cp1251 -*-


import sqlsoup
import json
from sqlalchemy import func
from fabric.api import local

from api import settings
from api.utils.auth import hash_password
from api.dal.map import geo_ukraine
from api.utils.db import get_db_session
from api.v1_0.bl.utils import create_location
from factories import roles
from api.v1_0.models import (
    Region,
    Page,
    Problem,
    ProblemsActivity,
    ProblemType,
    UserRole,
    User,
    Role,
    Photo,
    Comment
)


URL = '{db_type}://{username}:{password}@{host}/{database}?charset={charset}'

MYSQL_URL = URL.format(db_type='mysql',
                       username='root',
                       password='root',
                       host='localhost',
                       database='Enviromap',
                       charset='utf8')


class MigrateDB(object):
    """The migration of data from old MySQL database to new PSQL database.
    Migrated tables:
        - Activities -> problems_activities && comments;
        - ActivityType -> now is ENUM;
        - DeviceTokens -> killed;
        - News -> killed;
        - Photos -> photos;
        - Problems -> problems;
        - ProblemTypes -> problem_types;
        - Resources -> resources;
        - UserRoles -> user_roles && roles;
        - Users -> users;
    """
    def __init__(self):
        # Instance of MySQL db cursor.
        self.mysql_db = sqlsoup.SQLSoup(MYSQL_URL)
        # Initializing of psql session.
        self.session = get_db_session(settings)()
        # Need for remembering the valid problems.
        self.problems_id = []

    def clear_tables(self):
        """This tables need to be cleared for new migration.
        """
        self.session.execute('DELETE FROM problems_activities;')
        self.session.execute('DELETE FROM comments;')
        self.session.execute('DELETE FROM photos;')
        self.session.execute('DELETE FROM problems;')
        self.session.execute('DELETE FROM pages;')
        self.session.execute('DELETE FROM user_roles;')
        self.session.execute('DELETE FROM users;')
        self.session.execute('DELETE FROM regions;')
        self.session.execute('DELETE FROM role_permissions;')
        self.session.execute('DELETE FROM permissions;')
        self.session.execute('DELETE FROM roles;')
        self.session.execute('DELETE FROM resources;')
        self.session.execute('DELETE FROM problem_types;')
        self.session.commit()

    @staticmethod
    def create_dump(file_name):
        """Create a dump for current migration.
        """
        local(
            "sudo -u {user} pg_dump -d {db} > dumps/{file_name}.sql".format(
                user='postgres',
                db='ecomap_db',
                file_name=file_name
            )
        )

    def _check_point(self, lat, lon):
        """Filter the problems which situated in Ukraine.
        """
        query = self.session.query(Region).filter(
            Region.location.ST_Contains(create_location(lat, lon))
        )
        return False if not [loc for loc in query] else True

    def _fix_id(self, obj_res=None):
        """Fix auto_increment(sequence) to the last id.
        """
        try:
            restart_id = 1 + self.session.query(obj_res).order_by(obj_res.id.desc()).first().id
            self.session.execute('ALTER SEQUENCE %s_id_seq RESTART WITH %d' % (obj_res.__tablename__, restart_id))
            self.session.commit()
        except AttributeError as e:
            print e.message

    def _set_roles(self):
        """
        Set up two default roles.
        """
        admin_role = Role(id=1, name='admin')
        user_role = Role(id=2, name='user')

        self.session.add_all([admin_role, user_role])
        self.session.commit()

        self._fix_id(obj_res=Role)

    def fill_regions(self):
        """Fill the polygon of Ukraine for check
        if the coordinates of problem lie on the map of Ukraine.
        """
        region = Region(
            id=1,
            name='Ukraine',
            location=func.ST_GeomFromGeoJSON(json.dumps(geo_ukraine))
        )
        self.session.add(region)
        self.session.commit()

        self._fix_id(obj_res=Region)

    def migrate_resources(self):
        """Migration from Resources table to resources.
        """
        resources = self.mysql_db.Resources.all()
        for resource in resources:
            resource_data = Page(
                id=resource.Id,
                alias=resource.Alias,
                title=resource.Title,
                content=resource.Content,
                is_resource=True
            )
            self.session.add(resource_data)
            self.session.commit()

        self._fix_id(obj_res=Page)

    def _migrate_user_roles(self, users):
        """Set up for all users role - ''user''.
        """
        users_id = []

        self._set_roles()

        for user in users:
            users_id.append(user.Id)

        for user_id in users_id:
            user_role_data = UserRole(
                user_id=user_id,
                role_name='user'
            )
            self.session.add(user_role_data)
            self.session.commit()

    def migrate_user(self):
        """Migrate all users in new db.
        """
        # add admin_user
        admin = User(
            id=1,
            first_name='admin',
            last_name='admin_lastname',
            email='admin@example.com',
            password=hash_password('admin_pass'),
            region_id=1
        )
        self.session.add(admin)
        users = self.mysql_db.Users.all()
        for user in users:
            user_data = User(
                id=user.Id,
                first_name=user.Name,
                last_name=user.Surname,
                email=user.Email,
                password=user.Password,
                region_id=1
            )
            self.session.add(user_data)
            self.session.commit()
        self._migrate_user_roles(users)
        self._fix_id(obj_res=User)

    def migrate_problem_types(self):
        """Migrate all problem types in new db.
        """
        problem_types = self.mysql_db.ProblemTypes.all()
        for problem_type in problem_types:
            problem_type_data = ProblemType(
                id=problem_type.Id,
                type=problem_type.Type
            )
            self.session.add(problem_type_data)
            self.session.commit()
        self._fix_id(obj_res=ProblemType)

    def migrate_photos(self):
        """Photos migration.
        """
        photos = self.mysql_db.Photos.all()
        for photo in photos:
            if photo.Problems_Id not in self.problems_id:
                continue
            photo_data = Photo(
                id=photo.Id,
                name=photo.Link,
                comment=photo.Description,
                problem_id=photo.Problems_Id
            )
            self.session.add(photo_data)
            self.session.commit()
        self._fix_id(obj_res=Photo)

    def migrate_problems(self):
        """Problems migration.
        """
        problems = self.mysql_db.Problems.all()
        for problem in problems:
            check_arr = []
            lat = problem.Latitude
            lon = problem.Longtitude

            # Used for check if some one of table field is empty
            # for k, v in problem.__dict__.items():
            #     if k is not '_sa_instance_state':
            #         check_arr.append(problem.__dict__[k])

            # After validate the problem
            if None in [lat, lon, problem.Title, problem.Severity]:
                continue

            # Another validator
            if self._check_point(lon, lat):
                problem_data = Problem(
                    id=problem.Id,
                    title=problem.Title,
                    content=problem.Content,
                    proposal=problem.Proposal,
                    severity=str(problem.Severity),
                    location=create_location(lat, lon),
                    status='SOLVED' if int(problem.Status) is 1 else 'UNSOLVED',
                    problem_type_id=problem.ProblemTypes_Id,
                    region_id=1
                )
                # Save the valid problems.
                self.problems_id.append(problem.Id)

                self.session.add(problem_data)
                self.session.commit()

        self._fix_id(obj_res=Problem)

    def migrate_activities(self, act_type=None):
        """Migration of Activities.
        Old types to new:
            - addProblem -> ADDED;
            - editProblem -> UPDATED;
            - voteForProblem -> ADDED;
            - postPhoto -> killed;
            - postComment -> ADDED;
        All activity types(except one) go in problems_activities table.(1, 2, 3 activity type)
        The excepted type postComment, goes to comments table.(5 activity type)
        """
        activities = self.mysql_db.Activities.all()

        # getting start from id
        comment_id = 1

        for activity in activities:
            if activity.Problems_Id not in self.problems_id:
                continue

            # Take the content from JSON column.
            activity_content = json.loads(activity.Content)['Content']

            if activity.Users_Id == 2:
                user_id = None
            else:
                user_id = activity.Users_Id

            if activity.ActivityTypes_Id == 5:
                comments_data = Comment(
                    id=comment_id,
                    content=activity_content,
                    problem_id=activity.Problems_Id,
                    user_id=user_id,
                    created_date=activity.Date
                )
                comment_id += 1
                self.session.add(comments_data)
                self.session.commit()
            else:
                if activity.ActivityTypes_Id == 1:
                    act_type = 'ADDED'
                if activity.ActivityTypes_Id == 2:
                    act_type = 'UPDATED'
                if activity.ActivityTypes_Id == 3:
                    act_type = 'VOTE'

                problems_activity_data = ProblemsActivity(
                    problem_id=activity.Problems_Id,
                    user_id=user_id,
                    datetime=activity.Date,
                    activity_type=act_type
                )
                self.session.add(problems_activity_data)
                self.session.commit()

        self._fix_id(obj_res=Comment)
        self._fix_id(obj_res=ProblemsActivity)

    def close(self):
        self.session.close()

    @staticmethod
    def main():
        """Initialize the migration queue.
        """
        ecomap_db = MigrateDB()
        ecomap_db.clear_tables()
        ecomap_db.fill_regions()
        ecomap_db.migrate_resources()
        ecomap_db.migrate_problem_types()
        ecomap_db.migrate_problems()
        ecomap_db.migrate_user()
        ecomap_db.migrate_photos()
        ecomap_db.migrate_activities()
        ecomap_db.close()
        roles.main()
        MigrateDB.create_dump('ecomap_db_dump')


if __name__ == '__main__':
    MigrateDB.main()