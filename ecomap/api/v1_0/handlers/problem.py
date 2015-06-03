from datetime import datetime

from api.v1_0.handlers.base import BaseHandler
from api.v1_0.models import VoteActivity


class ProblemsHandler(BaseHandler):
    def get(self, problem_id=None):
        """Get a list of problems from the database. If problem_id is
        not None, get the problem identified by problem_id and write it to
        the client."""

    def post(self):
        """Store a new problem to the database."""


    def put(self, problem_id):
        """Edit the problem, identified by problem_id."""

    def delete(self, problem_id):
        """Delete a problem from the database by given problem id."""


class ProblemVoteHandler(BaseHandler):
    def post(self, problem_id):
        new_vote = VoteActivity(
            problem_id=int(problem_id),
            user_id=self.current_user,
            datetime=datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        )

        self.sess.add(new_vote)
        self.sess.commit()

