from datetime import datetime
from api.v1_0.models.user import User
from api.v1_0.models.comment import Comment
from api.v1_0.handlers.base import BaseHandler
from api.v1_0.bl.utils import iso_datetime, conv_array_to_dict
from api.v1_0.bl.decs import validation
from api.v1_0.forms.comment import CommentForm
import json


class CommentHandler(BaseHandler):
    def get(self, comment_id):
        """Returns comment by its id.

        Answer format:

        .. code-block: json

        {
            "modified_date": "2015-06-25T22:30:49.000Z",
            "modified_user_id": 1,
            "user_id": 2,
            "problem_id": 1,
            "content": "comment_0_content",
            "created_date": "2015-06-25T22:30:49.000Z",
            "id": 1
        }

        """
        comment_query = self.sess.query(Comment).get(comment_id)
        if not comment_query:
            self.send_error(status_code=404, message='Not Found')
        response = {
            'id': comment_query.id,
            'content': comment_query.content,
            'problem_id': comment_query.problem_id,
            'user_id': comment_query.user_id,
            'created_date': iso_datetime(comment_query.created_date),
            'modified_date': iso_datetime(comment_query.modified_date),
            'modified_user_id': comment_query.modified_user_id
        }
        self.write(response)
    
    @validation(CommentForm)
    def put(self, comment_id):
        """For modifying comment by its id.

        Send format:

        .. code-block: json

        {
            "content": 1
        }

        """
        comment_query = self.sess.query(Comment).get(comment_id)
        if not comment_query:
            self.send_error(status_code=404, message='Not Found')

        comment_query.content = self.request.arguments['content']
        comment_query.modified_date = datetime.utcnow()
        comment_query.modified_user_id = self.current_user
        self.sess.commit()

    def delete(self, comment_id):
        """Delete comment by its id.
        """
        comment_query = self.sess.query(Comment).get(comment_id)
        if not comment_query:
            self.send_error(status_code=404, message='Not Found')
        self.sess.delete(comment_query)
        self.sess.commit()


class ProblemCommentsHandler(BaseHandler):
    def get(self, problem_id):
        """Return comments for current problem.

        Answer format:

        .. code-block: json

        {
            "count": <count of data elements>,
            "data": [
                {
                    "modified_date": "2015-06-25T22:30:49.000Z",
                    "modified_by": "user_1",
                    "created_by": "user_2",
                    "content": "comment_1_content",
                    "created_date": "2015-06-25T22:30:49.000Z",
                    "id": 2
                },
                {},
                ...
            ]
        }

        """
        json_response = []
        comments_query = self.sess.query(Comment).filter_by(
            problem_id=problem_id).all()
        if not comments_query:
            self.write(json.dumps(json_response))
            return

        for comment_query in comments_query:
            user_query = self.sess.query(User).get(comment_query.user_id)

            if comment_query.modified_user_id is not None:
                modified_query = self.sess.query(User).get(
                    comment_query.modified_user_id)
                first_name = modified_query.first_name
            else:
                first_name = None

            response = {
                'id': comment_query.id,
                'content': comment_query.content,
                'user_id': comment_query.user_id,
                'created_by': user_query.first_name,
                'created_date': iso_datetime(comment_query.created_date),
                'modified_date': iso_datetime(comment_query.modified_date),
                'modified_by': first_name,
            }
            json_response.append(response)
        self.write(conv_array_to_dict(json_response))

    @validation(CommentForm)
    def post(self, problem_id):
        """For adding comment to current problem.

        Send format:

        .. code-block: json

        {
            "content": 1
        }

        """
        new_comment = Comment(content=unicode(self.request.arguments['content']),
                              problem_id=problem_id,
                              user_id=self.current_user,
                              created_date=datetime.utcnow())
        self.sess.add(new_comment)
        self.sess.commit()
