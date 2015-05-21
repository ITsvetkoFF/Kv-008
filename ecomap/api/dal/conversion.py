import sqlsoup
from sqlalchemy import Column, Enum, Integer, String, Text, text, create_engine, ForeignKey, Date
from sqlalchemy.dialects.postgresql import JSON
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base
from geoalchemy2 import Geometry
from fabric.api import local


Base = declarative_base()
metadata = Base.metadata
engine = create_engine('postgresql+psycopg2://postgres:db2567819@localhost/ecomap_db')
Session = sessionmaker(bind=engine)


class UserRole(Base):
    __tablename__ = 'user_roles'

    id = Column(Integer, primary_key=True, server_default=text("nextval('user_roles_id_seq'::regclass)"))
    role = Column(String(100), nullable=False)


class User(Base):
    __tablename__ = 'users'

    id = Column(Integer, primary_key=True, server_default=text("nextval('users_id_seq'::regclass)"))
    name = Column(String(64), nullable=False)
    surname = Column(String(64))
    email = Column(String(128), nullable=False)
    password = Column(String, nullable=False)
    userrole_id = Column(Integer, nullable=False)


class Problem(Base):
    __tablename__ = 'problems'

    id = Column(Integer, primary_key=True, server_default=text("nextval('problems_id_seq'::regclass)"))
    title = Column(String(130), nullable=False)
    content = Column(Text)
    proposal = Column(Text)
    severity = Column(Enum(u'None', u'1', u'2', u'3', u'4', u'5', name='severitytypes'))
    votes = Column(Integer)
    location = Column(Geometry, nullable=False)
    status = Column(Enum(u'solved', u'unsolved', name='status'))
    problemtype_id = Column(Integer, ForeignKey('problem_types.id'), nullable=False)
    region_id = Column(Integer, ForeignKey('region.id'), nullable=False)


class Region(Base):
    __tablename__ = 'region'

    id = Column(Integer, primary_key=True, server_default=text("nextval('region_id_seq'::regclass)"))
    name = Column(String(100), nullable=False)
    location = Column(Geometry, nullable=False)


class ProblemType(Base):
    __tablename__ = 'problem_types'

    id = Column(Integer, primary_key=True, server_default=text("nextval('problem_types_id_seq'::regclass)"))
    type = Column(String(100), nullable=False)


class VotesActivity(Base):
    __tablename__ = 'votes_activities'

    id = Column(Integer, primary_key=True, server_default=text("nextval('votes_activities_id_seq'::regclass)"))
    problem_id = Column(Integer, nullable=False)
    user_id = Column(Integer, nullable=False)
    date = Column(Date, nullable=False)


class ProblemActivity(Base):
    __tablename__ = 'problem_activities'

    id = Column(Integer, primary_key=True, server_default=text("nextval('problem_activities_id_seq'::regclass)"))
    problem_id = Column(Integer, nullable=False)
    data = Column(JSON)
    user_id = Column(Integer, nullable=False)
    date = Column(Date, nullable=False)
    activity_type = Column(Enum(u'ADDED', u'REMOVED', u'UPDATED', name='activitytype'), nullable=False)


class MigrateDB(object):
    def __init__(self, url):
        self.mysql_db = sqlsoup.SQLSoup(str(url))
        self.session = Session()
        self.actType = {}
        self.delId = []

    def clear_tables(self):
        region_data = Region(id=999, name='test', location='POLYGON((0 0,0 0,0 0,0 0,0 0))')
        self.session.execute('DELETE FROM votes_activities;')
        self.session.execute('DELETE FROM comments;')
        self.session.execute('DELETE FROM problem_activities;')
        self.session.execute('DELETE FROM problems;')
        self.session.execute('DELETE FROM problem_types;')
        self.session.execute('DELETE FROM region;')
        self.session.execute('DELETE FROM users;')
        self.session.execute('DELETE FROM user_roles;')
        self.session.add(region_data)
        self.session.commit()

    def create_dump(self, file_name):
        local("pg_dump ecomap_db > %s.sql" % file_name)

    def migrate_user_roles(self):
        user_roles = self.mysql_db.UserRoles.all()

        for user_role in user_roles:
            user_role_data = UserRole(id=user_role.Id, role=user_role.Role)
            self.session.add(user_role_data)
            self.session.commit()

    def migrate_user(self):
        users = self.mysql_db.Users.all()

        for user in users:
            users_data = User(id=user.Id, name=user.Name, surname=user.Surname, email=user.Email,
                              password=user.Password, userrole_id=user.UserRoles_Id)
            self.session.add(users_data)
            self.session.commit()

    def migrate_problem_types(self):
        problem_types = self.mysql_db.ProblemTypes.all()

        for problem_type in problem_types:
            problem_type_data = ProblemType(id=problem_type.Id, type=problem_type.Type)
            self.session.add(problem_type_data)
            self.session.commit()

    def migrate_problems(self):
        problems = self.mysql_db.Problems.all()

        for problem in problems:
            status = 'solved'

            if problem.Status == 0:
                status = 'unsolved'

            if problem.Latitude is None or problem.Longtitude is None:
                self.delId.append(problem.Id)
                continue

            problem_data = Problem(id=problem.Id, title=problem.Title, content=problem.Content,
                                   proposal=problem.Proposal, severity=str(problem.Severity), votes=problem.Votes,
                                   location='POINT(%s %s)' % (problem.Latitude, problem.Longtitude),
                                   status=status, problemtype_id=problem.ProblemTypes_Id,
                                   region_id=999)
            self.session.add(problem_data)
            self.session.commit()

    def migrate_activity(self):
        activity_types = self.mysql_db.ActivityTypes.all()
        for activity_type in activity_types:
            self.actType[activity_type.Id] = activity_type.Name

        activities = self.mysql_db.Activities.all()
        a_type = None
        for activity in activities:
            if self.actType[activity.ActivityTypes_Id] == 'voteForProblem':
                activity_data = VotesActivity(problem_id=activity.Problems_Id,
                                              user_id=activity.Users_Id,
                                              date=activity.Date)
            else:
                if self.actType[activity.ActivityTypes_Id] == 'addProblem':
                    a_type = 'ADDED'

                elif self.actType[activity.ActivityTypes_Id] == 'editProblem':
                    a_type = 'UPDATED'

                activity_data = ProblemActivity(problem_id=activity.Problems_Id,
                                                user_id=activity.Users_Id,
                                                date=activity.Date,
                                                activity_type=a_type)

            if activity.Users_Id is not None and a_type is not None and activity.Problems_Id not in self.delId:
                self.session.add(activity_data)
                self.session.commit()

    def close(self):
        self.session.close()


def main():
    # Init configs
    ecomap_db = MigrateDB('mysql://root:root@localhost/Enviromap?charset=utf8&use_unicode=0')
    # -----

    # clear tables
    ecomap_db.clear_tables()
    # -----

    # UserRoles
    ecomap_db.migrate_user_roles()
    # -----

    # Users
    ecomap_db.migrate_user()
    # -----

    # ProblemTypes
    ecomap_db.migrate_problem_types()
    # -----

    # Problems
    ecomap_db.migrate_problems()
    # -----

    # Activity
    ecomap_db.migrate_activity()
    # -----

    # Close db
    ecomap_db.close()
    # -----

    # Dump psql
    ecomap_db.create_dump('ecomap_db_dump')
    # -----

if __name__ == '__main__':
    main()
