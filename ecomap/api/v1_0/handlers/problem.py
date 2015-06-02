from api.v1_0.handlers.base import BaseHandler


class ProblemsAPIHandler(BaseHandler):
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
        problem = self.db_sess.query(Problem).get(problem_id)
        self.db_sess.delete(problem)
        self.db_sess.commit()
