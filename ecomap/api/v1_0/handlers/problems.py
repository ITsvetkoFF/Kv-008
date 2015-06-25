import os
import random
import string
import imghdr
import json

from os.path import join
from api.v1_0.handlers.base import BaseHandler
from api.v1_0.bl.utils import create_location
from api.v1_0.bl.decorators import permission_control, validation_json
from api.v1_0.bl.modeldict import (
    get_dict_problem_data,
    generate_data,
    revision_problems,
    revision_removed,
    query_converter
)

from sqlalchemy import func

from api.v1_0.models import (
    DetailedProblem,
    Problem,
    ProblemsActivity,
    Photo
)
from api.v1_0.forms.problem import (
    ProblemForm
)
from api.v1_0.bl.decs import check_if_exists
from api.v1_0.bl.utils import get_datetime
from api.v1_0.handlers.photos import PHOTOS_ROOT

# you can add more image types if necessary
PHOTO_TYPES = ('png', 'gif', 'jpeg', 'jpg')


class ProblemHandler(BaseHandler):
    @permission_control
    def get(self, problem_id=None):
        """Returns the data for all the problems in the database.
        
        If problem id is specified **/api/v1/problems/3**, returns the
        data for the specified problem.
        """
        problem = self.sess.query(DetailedProblem).get(int(problem_id))
        self.write(get_dict_problem_data(problem))

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

        self.sess.query(Problem).filter_by(id=int(problem_id)).delete()
        self.sess.commit()


class ProblemsHandler(BaseHandler):

    def get(self):
        current_revision = (self.sess.query(func.max(DetailedProblem.id)). \
                            first())[0]
        previous_revision = int(self.get_query_argument('rev', default=0))
        if previous_revision == 0:
            problems=dict(
                current_activity_revision=current_revision,
                data=generate_data(self,(range(1,current_revision+1)))
            )
            json_string = json.dumps(problems, ensure_ascii=False)
            self.write(json_string)
        elif previous_revision == current_revision:
            self.write(dict(current_activity_revision=current_revision))
        elif previous_revision < current_revision:
            revised_id = revision_problems(self,previous_revision)

            problems=dict(
                current_activity_revision=current_revision,
                previous_activity_revision=previous_revision,
                data=generate_data(self,revised_id) + revision_removed(
                    self, previous_revision)[1]
            )
            json_string = json.dumps(problems, ensure_ascii=False)
            self.write(json_string)


    @permission_control
    @validation_json(ProblemForm)
    def post(self):
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
            user_id=self.get_current_user(),
            datetime=get_datetime(),
            activity_type="ADDED")
        self.sess.add(activity)
        self.sess.commit()




class ProblemVoteHandler(BaseHandler):
    @check_if_exists(Problem)
    def post(self, problem_id):
        """Creates a vote record for the specified problem."""
        new_vote = ProblemsActivity(
            problem_id=int(problem_id),
            user_id=self.current_user,
            datetime=get_datetime(),
            activity_type='VOTE'
        )

        self.sess.add(new_vote)
        self.sess.commit()


class ProblemPhotosHandler(BaseHandler):
    @check_if_exists(Problem)
    def get(self, problem_id):
        """Returns all the photos data for the specified problem."""
        photos = self.sess.query(Photo).filter(Photo.problem_id == problem_id)
        response_data = [dict(
            photo_id=photo.id,
            name=photo.name,
            datetime=str(photo.datetime),
            comment=photo.comment,
            problem_id=photo.problem_id,
            user_id=photo.user_id
        ) for photo in photos]

        self.write(json.dumps(response_data))

    @check_if_exists(Problem)
    def post(self, problem_id):
        """Creates a new photo for the specified problem and stores it.

        You have to name your file input as ``photo_files`` and comment
        input as ``comment``.
        """
        while self.request.files['photo_files']:
            photo_file = self.request.files['photo_files'].pop()
            # rename files and append extensions
            original_filename = photo_file.filename

            # checking for extensions
            extension = os.path.splitext(original_filename)[1]
            if extension not in map(lambda type: '.' + type, PHOTO_TYPES):
                return self.send_error(400, message='Bad photo '
                                                    'file extension.')

            # validating uploaded file type
            file_type = imghdr.what(original_filename, photo_file.body)
            if not file_type.endswith(PHOTO_TYPES):
                self.send_error(400, message='Invalid photo file type.')
                return

            name = ''.join(
                random.choice(string.ascii_lowercase + string.digits) for
                x in range(6))
            final_filename = name + extension

            with open(join(PHOTOS_ROOT, final_filename), 'w') as output_file:
                output_file.write(photo_file.body)

            photo = Photo(
                problem_id=problem_id,
                name=final_filename,
                datetime=get_datetime(),
                user_id=self.current_user,
                comment=self.request.body_arguments['comment'][0].decode(
                    'utf-8')
            )
            self.sess.add(photo)

        self.sess.commit()
