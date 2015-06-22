from datetime import datetime
from tornado import escape
from wtforms_json import InvalidData
from api.v1_0.handlers.base import BaseHandler
from api.v1_0.bl.response_helpers import create_location
from api.v1_0.models import VotesActivity, DetailedProblem, Problem, \
    ProblemsActivity,ProblemForm
from api.v1_0.bl.decorators import permission_control, validation_json
from api.v1_0.bl.models_dict_logic import get_dict_problem_data


class ProblemsHandler(BaseHandler):
    @permission_control
    def get(self, problem_id=None):
        """Get a list of problems from the database. If problem_id is
        not None, get the problem identified by problem_id and write it to
        the client."""

        problem = self.sess.query(DetailedProblem).get(int(problem_id))
        self.write(get_dict_problem_data(problem))


    @permission_control
    @validation_json(ProblemForm)
    def post(self, problem_id):
        """Store a new problem to the database."""

        x = self.request.arguments.pop('Latitude')
        y = self.request.arguments.pop('Longtitude')
        problem = Problem(
            title=self.request.arguments['title'],
            content=self.request.arguments['content'],
            proposal=self.request.arguments['proposal'],
            severity=self.request.arguments['severity'],
            status=self.request.arguments['status'],
            location=create_location(x,y),
            problem_type_id=self.request.arguments['problem_type_id'],
            region_id=self.request.arguments['region_id'])
        self.sess.add(problem)
        self.sess.commit()
        activity = ProblemsActivity(
            problem_id=problem.id,
            data=escape.json_decode(
                self.request.body),
            user_id=self.get_current_user(),
            datetime=datetime.utcnow(),
            activity_type="ADDED")
        self.sess.add(activity)
        self.sess.commit()


    @permission_control
    @validation_json(ProblemForm)
    def put(self, problem_id):

        x = self.request.arguments.pop('Latitude')
        y = self.request.arguments.pop('Longtitude')
        self.request.arguments['location'] = create_location(x,y)
        self.request.arguments['id'] = problem_id
        self.sess.query(Problem).filter_by(id=int(problem_id)). \
            update(self.request.arguments)

        self.sess.commit()

        activity = ProblemsActivity(
            problem_id=int(problem_id),
            data=escape.json_decode(
                self.request.body),
            user_id=self.get_current_user(),
            datetime=datetime.utcnow(),
            activity_type="UPDATED"
        )
        self.sess.add(activity)
        self.sess.commit()


    @permission_control
    def delete(self, problem_id):
        """Delete a problem from the database by given problem id."""

        activity = ProblemsActivity(
            problem_id=int(problem_id),
            data=None,
            user_id=self.get_current_user(),
            datetime=datetime.utcnow(),
            activity_type='REMOVED')
        self.sess.add(activity)
        self.sess.commit()

        self.sess.query(Problem).filter_by(id=int(problem_id)).delete()
        self.sess.commit()




class ProblemVoteHandler(BaseHandler):
    def post(self, problem_id):
        new_vote = VotesActivity(
            problem_id=int(problem_id),
            user_id=self.current_user,
            datetime=datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')
        )

        self.sess.add(new_vote)
        self.sess.commit()
