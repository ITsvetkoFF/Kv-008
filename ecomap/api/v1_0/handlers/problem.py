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
            problem = self.sess.query(DetailedProblem).get(int(problem_id))
            if problem != None:
                problem_data = dict()
                for c in problem.__table__.columns:
                    if isinstance(getattr(problem, c.name), datetime):
                        problem_data[c.name] = str(getattr(problem, c.name))
                    else:
                        problem_data[c.name] = getattr(problem, c.name)
                self.write(problem_data)
            else:
                self.send_error(404,
                                message='Problem not found for the given id.')
        else:
            self.send_error(404, message='Problem not found for the given id.')

    def post(self, problem_id):
        """Store a new problem to the database."""
        if self.get_action_modifier() != 'NONE':

            problem = Problem(title=self.request.arguments['title'],
                              content=self.request.arguments['content'],
                              proposal=self.request.arguments['proposal'],
                              severity=self.request.arguments['severity'],
                              status=self.request.arguments['status'],
                              location=self.location(),
                              problem_type_id=self.request.arguments[
                                  'problem_type_id'],
                              region_id=self.request.arguments['region_id'])
            self.sess.add(problem)
            self.sess.commit()
            activity = ProblemsActivity(problem_id=problem.id,
                                        data=escape.json_decode(
                                            self.request.body),
                                        user_id=self.get_current_user(),
                                        datetime=datetime.utcnow(),
                                        activity_type="ADDED")
            self.sess.add(activity)
            self.sess.commit()
        else:
            message = 'You have not permission to adde problem_id.'
            self.send_error(400, message=message)

    def put(self, problem_id):
        modifire = self.get_action_modifier()
        user_id = self.sess.query(ProblemsActivity.user_id). \
            filter_by(problem_id=problem_id, activity_type='ADDED').first()

        if modifire == 'ANY' or (
                modifire == 'OWN' and user_id[0] == self.get_current_user()):
            form = self.ProblemForm(obj=self.request.arguments)
            print form.validate(), 'LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL'
            if form.validate():
                self.request.arguments['id'] = problem_id
                self.sess.query(Problem).filter_by(id=int(problem_id)). \
                    update(self.request.arguments)

                self.sess.commit()

                activity = ProblemsActivity(problem_id=int(problem_id),
                                            data=escape.json_decode(
                                                self.request.body),
                                            user_id=self.get_current_user(),
                                            datetime=datetime.utcnow(),
                                            activity_type="UPDATED")
                self.sess.add(activity)
                self.sess.commit()
            else:
                self.set_status(400)
                self.write("" % form.errors)
        else:
            message = 'You have not permission to update.'
            self.send_error(400, message=message)

    def delete(self, problem_id):
        """Delete a problem from the database by given problem id."""
        modifire = self.get_action_modifier()
        user_id = self.sess.query(ProblemsActivity.user_id). \
            filter_by(problem_id=problem_id, activity_type='ADDED').first()

        if modifire == 'ANY' or (
                        modifire == 'OWN' and user_id[
                    0] == self.get_current_user()):

            activity = ProblemsActivity(problem_id=int(problem_id),
                                        data=None,
                                        user_id=self.get_current_user(),
                                        datetime=datetime.utcnow(),
                                        activity_type='REMOVED')
            self.sess.add(activity)
            self.sess.commit()

            self.sess.query(Problem).filter_by(id=int(problem_id)).delete()
            self.sess.commit()
        else:
            message = 'You have not permission to remove.'
            self.send_error(400, message=message)


class ProblemVoteHandler(BaseHandler):
    def post(self, problem_id):
        new_vote = VotesActivity(
            problem_id=int(problem_id),
            user_id=self.current_user,
            datetime=datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')
        )

        self.sess.add(new_vote)
        self.sess.commit()
