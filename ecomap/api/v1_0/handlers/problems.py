import json

import tornado.web

from api.v1_0.bl.utils import create_location, define_values
from api.v1_0.bl.decs import (
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
    ProblemForm,
    ProblemUpdateForm
)
from api.v1_0.bl.utils import get_datetime, check_vote
from api.v1_0.bl.photo import *


class ProblemHandler(BaseHandler):

    @check_if_exists(DetailedProblem)
    def get(self, problem_id=None):
        """Returns the data for all the problems in the database.

        If problem id is specified **/api/v1/problems/3**, returns the
        data for the specified problem.
        """
        problem = self.sess.query(
            DetailedProblem,
            func.ST_AsGeoJSON(DetailedProblem.location)).filter(
            DetailedProblem.id == problem_id)
        data = generate_data(problem)[0]
        self.write(data)

    @tornado.web.authenticated
    @check_if_exists(DetailedProblem)
    @check_permission
    @validation(ProblemUpdateForm)
    def put(self, problem_id):
        """Update a problem in the database
        {
            "status": "SOLVED",
            "severity": "3",
            "title": "problem_14",
            "problem_type_id": 3,
            "content": "problem_test",
            "proposal": "test_proposal",
            "region_id": 1,
            "latitude": 4,
            "longitude":4
        }

        """
        args = self.request.arguments
        x = args.pop('latitude')
        y = args.pop('longitude')
        args['location'] = create_location(x, y)
        self.sess.query(Problem).filter_by(id=int(problem_id)). \
            update(args)

        self.sess.commit()

        activity = ProblemsActivity(
            problem_id=int(problem_id),
            user_id=self.get_current_user(),
            datetime=get_datetime(),
            activity_type="UPDATED"
        )
        self.sess.add(activity)
        self.sess.commit()

    @tornado.web.authenticated
    @check_if_exists(DetailedProblem)
    @check_permission
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
        """Returns the data for all the revisions in the database."""
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

    @tornado.web.authenticated
    @check_permission
    @validation(ProblemForm)
    def post(self):
        """Store a new problem to the database.
        {
        "status": "SOLVED",
        "severity": "3",
        "title": "problem_14",
        "problem_type_id": 3,
        "content": "problem_test",
        "proposal": "test_proposal",
        "region_id": 1,
        "latitude": 4,
        "longitude":4
        }"""
        arguments = self.request.arguments
        print arguments
        x = arguments['latitude']
        y = arguments['longitude']
        problem = Problem(
            title=arguments['title'],
            content=define_values(arguments,'content'),
            proposal=define_values(arguments,'proposal'),
            severity=define_values(arguments,'severity', '1'),
            status=define_values(arguments,'status','UNSOLVED'),
            location=create_location(x, y),
            problem_type_id=arguments['problem_type_id'],
            region_id=define_values(arguments,'region_id'))
        self.sess.add(problem)
        self.sess.commit()
        activity = ProblemsActivity(
            problem_id=problem.id,
            user_id=self.get_current_user(),
            datetime=get_datetime(),
            activity_type="ADDED")
        self.sess.add(activity)
        self.sess.commit()
        if self.get_status() is 200:
            self.write({'id': problem.id})


class VoteHandler(BaseHandler):

    @tornado.web.authenticated
    @check_if_exists(DetailedProblem)
    @check_permission
    def post(self, problem_id):
        """Creates a vote record for the specified problem."""

        if check_vote(self, problem_id):
            return self.send_error(400, message=(
                    'You can not vote twice!'))

        vote = ProblemsActivity(
            problem_id=int(problem_id),
            user_id=self.current_user,
            datetime=get_datetime(),
            activity_type='VOTE'
        )

        self.sess.add(vote)
        self.sess.commit()


class ProblemPhotosHandler(BaseHandler):

    @check_if_exists(DetailedProblem)
    def get(self, problem_id):
        """Returns all photo data for the specified problem."""
        photos = self.sess.query(Photo).filter(Photo.problem_id == problem_id)
        self.write(
            json.dumps([get_row_data(photo) for photo in photos]))

    @tornado.web.authenticated
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
