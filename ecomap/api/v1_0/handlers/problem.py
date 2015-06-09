from datetime import datetime
from tornado import escape
from api.v1_0.handlers.base import BaseHandler
from api.v1_0.models import VotesActivity, DetailedProblem, Problem, \
    ProblemsActivity


class ProblemsHandler(BaseHandler):
    def get(self, problem_id=None):
        """Get a list of problems from the database. If problem_id is
        not None, get the problem identified by problem_id and write it to
        the client."""

        if problem_id != None:
            problem_data = dict()
            problem = self.sess.query(DetailedProblem).get(int(problem_id))
            for c in problem.__table__.columns:
                if isinstance(getattr(problem, c.name), datetime):
                    problem_data[c.name] = str(getattr(problem, c.name))
                else:
                    problem_data[c.name] = getattr(problem, c.name)

            self.write({problem_id: problem_data})
        else:
            self.send_error(404, message='Problem not found fqor the given id.')

    def post(self, problem_id=None):
        """Store a new problem to the database."""
        problem = Problem(title=self.request.arguments['title'],
                              content=self.request.arguments['content'],
                              proposal=self.request.arguments['proposal'],
                              severity=self.request.arguments['severity'],
                              status=self.request.arguments['status'],
                              location=self.request.arguments['location'],
                              problem_type_id=self.request.arguments[
                                  'problem_type_id'],
                              region_id=self.request.arguments['region_id'])
        self.sess.add(problem)
        self.sess.commit()
        activity = ProblemsActivity(problem_id=problem.id,
                                    data=escape.json_decode(self.request.body),
                                    user_id=self.get_current_user(),
                                    date=datetime.datetime.now(),
                                    activity_type="ADDED")
        self.sess.add(activity)
        self.sess.commit()

    def put(self, problem_id):

        self.request.arguments['id'] = problem_id
        self.sess.query(Problem).filter_by(id=int(problem_id)). \
            update(self.request.arguments)

        self.sess.commit()

        activity = ProblemsActivity(problem_id=int(problem_id),
                                    data=escape.json_decode(self.request.body),
                                    user_id=self.get_current_user(),
                                    datetime=datetime.datetime.now(),
                                    activity_type="UPDATED")
        self.sess.add(activity)
        self.sess.commit()

    def delete(self, problem_id):
        """Delete a problem from the database by given problem id."""
        problem = self.sess.query(Problem).get(int(problem_id))
        self.sess.delete(problem)
        self.sess.commit()

        activity = ProblemsActivity(problem_id=int(problem_id),
                                               data=escape.json_decode(
                                                   self.request.body),
                                               user_id=self.get_current_user(),
                                               datetime=datetime.datetime.now(),
                                               activity_type="DELETE")
        self.sess.add(activity)
        self.sess.commit()


class ProblemVoteHandler(BaseHandler):
    def post(self, problem_id):
        new_vote = VotesActivity(
            problem_id=int(problem_id),
            user_id=self.current_user,
            datetime=datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        )

        self.sess.add(new_vote)
        self.sess.commit()
