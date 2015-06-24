import random
import string
import imghdr
import json
import datetime

from tornado import escape

import os
from os.path import join

from wtforms_json import InvalidData

from api.v1_0.handlers.base import BaseHandler
from api.v1_0.models import (
    VotesActivity,
    DetailedProblem,
    Problem,
    ProblemsActivity,
    Photo
)
from api.v1_0.forms.problem import ProblemForm
from api.v1_0.bl.decs import check_if_exists
from api.v1_0.bl.utils import get_datetime
from api.v1_0.handlers.photos import PHOTOS_ROOT


# you can add more image types if necessary
PHOTO_TYPES = ('png', 'gif', 'jpeg', 'jpg')


class ProblemsHandler(BaseHandler):
    def get(self, problem_id=None):
        """Returns the data for all the problems in the database.

        If problem id is specified **/api/v1/problems/3**, returns the
        data for the specified problem.
        """
        if problem_id != None:
            problem = self.sess.query(DetailedProblem).get(int(problem_id))
            if problem != None:
                problem_data = dict()
                for c in problem.__table__.columns:
                    if isinstance(getattr(problem, c.name), datetime.datetime):
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
        """Creates a new problem and stores it into the database."""
        if self.get_action_modifier() != 'NONE':
            try:
                form = ProblemForm.from_json(self.request.arguments,
                                             skip_unknown_keys=False)
            except InvalidData as e:
                message = e.args
                self.send_error(400, message=message)
            if form.validate():

                problem = Problem(
                    title=self.request.arguments['title'],
                    # you can't use brackets because these fields are nullable
                    content=self.request.arguments.get('content'),
                    proposal=self.request.arguments.get('proposal'),
                    severity=self.request.arguments.get('severity'),
                    status=self.request.arguments.get('status'),
                    location=self.create_location(),
                    problem_type_id=self.request.arguments.get(
                        'problem_type_id'),
                    region_id=self.request.arguments.get('region_id')
                )
                self.sess.add(problem)
                self.sess.commit()
                activity = ProblemsActivity(
                    problem_id=problem.id,
                    data=escape.json_decode(self.request.body),
                    user_id=self.get_current_user(),
                    datetime=get_datetime(),
                    activity_type="ADDED")
                self.sess.add(activity)
                self.sess.commit()
            else:
                message = form.errors
                self.send_error(400, message=message)
        else:
            message = 'You have not permission to adde problem_id.'
            self.send_error(400, message=message)

    def put(self, problem_id):
        modifier = self.get_action_modifier()
        user_id = self.sess.query(ProblemsActivity.user_id). \
            filter_by(problem_id=problem_id, activity_type='ADDED').first()

        if modifier == 'ANY' or (
                        modifier == 'OWN' and user_id[
                    0] == self.get_current_user()):
            try:
                form = ProblemForm.from_json(self.request.arguments,
                                             skip_unknown_keys=False)
            except InvalidData as e:
                message = e.message
                self.send_error(400, message=message)

            if form.validate():
                self.request.arguments['location'] = self.create_location()
                self.request.arguments.pop('Latitude')
                self.request.arguments.pop('Longtitude')
                self.request.arguments['id'] = problem_id
                self.sess.query(Problem).filter_by(id=int(problem_id)). \
                    update(self.request.arguments)

                self.sess.commit()

                activity = ProblemsActivity(
                    problem_id=int(problem_id),
                    data=escape.json_decode(self.request.body),
                    user_id=self.get_current_user(),
                    datetime=get_datetime(),
                    activity_type="UPDATED"
                )
                self.sess.add(activity)
                self.sess.commit()
            else:
                message = form.errors
                self.send_error(400, message=message)
        else:
            message = 'You have not permission to update.'
            self.send_error(400, message=message)

    def delete(self, problem_id):
        """Deletes the specified problem."""
        modifier = self.get_action_modifier()
        user_id = self.sess.query(ProblemsActivity.user_id). \
            filter_by(problem_id=problem_id, activity_type='ADDED').first()

        if modifier == 'ANY' or (
                        modifier == 'OWN' and user_id[
                    0] == self.get_current_user()):

            activity = ProblemsActivity(problem_id=int(problem_id),
                                        data=None,
                                        user_id=self.get_current_user(),
                                        datetime=get_datetime(),
                                        activity_type='REMOVED')
            self.sess.add(activity)
            self.sess.commit()

            self.sess.query(Problem).filter_by(id=int(problem_id)).delete()
            self.sess.commit()
        else:
            message = 'You have not permission to remove.'
            self.send_error(400, message=message)


class ProblemVoteHandler(BaseHandler):
    @check_if_exists(Problem)
    def post(self, problem_id):
        """Creates a vote record for the specified problem."""
        new_vote = VotesActivity(
            problem_id=int(problem_id),
            user_id=self.current_user,
            datetime=get_datetime()
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
        while self.request.files['photos']:
            photo_file = self.request.files['photos'].pop()
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
                comment=self.request.body_arguments['comments'].pop().decode(
                    'utf-8')
            )
            self.sess.add(photo)

        self.sess.commit()
