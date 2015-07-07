import json

import tornado.web

from api.v1_0.bl.utils import create_location
from api.v1_0.bl.decs import (
    permission_control,
    validation,
    check_if_exists,
    check_permission
)
from api.v1_0.bl.modeldict import *
from api.v1_0.bl.revision import (
    generate_data,
    revision,
    removed_data,
    vote_data
)

from sqlalchemy import func

from api.v1_0.handlers.base import BaseHandler
from api.v1_0.models import (
    DetailedProblem,
    Problem,
    ProblemsActivity,
    Photo
)
from api.v1_0.forms.problem import (
    ProblemForm
)
from api.v1_0.bl.utils import get_datetime
from api.v1_0.bl.photo import *


class ProblemHandler(BaseHandler):

    def get(self, problem_id=None):
        """Returns the data for all the problems in the database.

        If problem id is specified **/api/v1/problems/3**, returns the
        data for the specified problem.
        """
        problem = self.sess.query(
            DetailedProblem,
            func.ST_AsGeoJSON(DetailedProblem.location)).filter(
            DetailedProblem.id == problem_id)
        try:
            data = generate_data(problem)[0]
        except IndexError:
            self.send_error(400, message='Entry not found for the given id.')
        self.write(data)

    @permission_control
    @validation(ProblemForm)
    def put(self, problem_id):
        x = self.request.arguments.pop('latitude')
        y = self.request.arguments.pop('longitude')
        self.request.arguments['location'] = create_location(x, y)
        self.request.arguments['id'] = problem_id
        self.sess.query(Problem).filter_by(id=int(problem_id)). \
            update(self.request.arguments)

        self.sess.commit()

        activity = ProblemsActivity(
            problem_id=int(problem_id),
            user_id=self.get_current_user(),
            datetime=get_datetime(),
            activity_type="UPDATED"
        )
        self.sess.add(activity)
        self.sess.commit()

    @permission_control
    def delete(self, problem_id):
        """Delete a problem from the database by given problem id."""

        activity = ProblemsActivity(
            problem_id=int(problem_id),
            user_id=self.get_current_user(),
            datetime=get_datetime(),
            activity_type='REMOVED')
        self.sess.add(activity)
        self.sess.commit()


class ProblemsHandler(BaseHandler):
    def get(self):
        current_revision = (self.sess.query(func.max(ProblemsActivity.id)). \
                            first())[0]
        previous_revision = int(self.get_query_argument('rev', default=0))
        if previous_revision == 0:
            query = self.sess.query(
                DetailedProblem,
                func.ST_AsGeoJSON(DetailedProblem.location))
            problems = dict(
                current_activity_revision=current_revision,
                data=generate_data(query)
            )
            json_string = json.dumps(problems, ensure_ascii=False)
            self.write(json_string)
        elif previous_revision == current_revision:
            self.write(dict(current_activity_revision=current_revision))
        elif previous_revision < current_revision:
            removed = revision(self, previous_revision, "REMOVED")
            update = revision(self, previous_revision, "UPDATED", removed)
            added = revision(self, previous_revision, "ADDED", removed, update)
            vote = revision(self, previous_revision, "VOTE", removed, update,
                            added)

            query = self.sess.query(
                DetailedProblem,
                func.ST_AsGeoJSON(DetailedProblem.location)). \
                filter(DetailedProblem.id.in_(added + update))
            small_query = self.sess.query(DetailedProblem.id,
                                          DetailedProblem.number_of_votes).filter(
                DetailedProblem.id.in_(vote))

            problems = dict(
                current_activity_revision=current_revision,
                previous_activity_revision=previous_revision,
                data=generate_data(query) + removed_data(removed) + vote_data(
                    small_query)
            )
            json_string = json.dumps(problems, ensure_ascii=False)
            self.write(json_string)
        elif previous_revision > current_revision:
            self.send_error(400,
                            message='Your revision is greater than current')

    # @permission_control
    @validation(ProblemForm)
    def post(self):
        """Store a new problem to the database."""

        x = self.request.arguments['latitude']
        y = self.request.arguments['longitude']
        problem = Problem(
            title=self.request.arguments['title'],
            content=self.request.arguments['content'],
            proposal=self.request.arguments['proposal'],
            severity=self.request.arguments['severity'],
            status=self.request.arguments['status'],
            location=create_location(x, y),
            problem_type_id=self.request.arguments['problem_type_id'],
            region_id=self.request.arguments['region_id'])
        self.sess.add(problem)
        self.sess.commit()
        activity = ProblemsActivity(
            problem_id=problem.id,
            user_id=self.get_current_user(),
            datetime=get_datetime(),
            activity_type="ADDED")
        self.sess.add(activity)
        self.sess.commit()


class VoteHandler(BaseHandler):
    @tornado.web.authenticated
    @check_if_exists(Problem)
    @check_permission
    def post(self, problem_id):
        """Creates a vote record for the specified problem."""
        vote = ProblemsActivity(
            problem_id=int(problem_id),
            user_id=self.current_user,
            datetime=get_datetime(),
            activity_type='VOTE'
        )

        self.sess.add(vote)
        self.sess.commit()


class ProblemPhotosHandler(BaseHandler):
    @tornado.web.authenticated
    @check_if_exists(Problem)
    def get(self, problem_id):
        """Returns all photo data for the specified problem."""
        photos = self.sess.query(Photo).filter(Photo.problem_id == problem_id)

        self.write(
            json.dumps([get_row_data(photo) for photo in photos]))

    @tornado.web.authenticated
    @check_if_exists(Problem)
    @check_permission
    def post(self, problem_id):
        """Stores uploaded photos to the hard drive, creates and stores
        thumbnails, stores photo data to the database.

        You have to name your file inputs (all of them) as
        ``photos`` and comment inputs (all of them) as ``comments``.
        First file will be associated with first comment and so on.
        """
        while self.request.files['photos']:
            photo_file = self.request.files['photos'].pop()

            if not check_file_ext(photo_file.filename):
                return self.send_error(400, message=(
                    'Bad file extension. JPEG and JPG formats allowed.'
                ))

            if not check_file_format(photo_file.body):
                return self.send_error(400, message=(
                    'Bad format. Only JPEG and JPG allowed.'))

            new_filename = create_new_filename()

            store_photo_data_to_db(problem_id, new_filename, self)
            filepath = store_file_to_hd(new_filename, photo_file.body)
            store_thumbnail_to_hd(filepath)
