from datetime import datetime
import json

from api.v1_0.models.user import User
from api.v1_0.models.comment import Comment
from api.v1_0.handlers.base import BaseHandler
from api.v1_0.bl.response_helpers import iso8601_conv_with_empty_check, conv_array_to_dict


class CommentsHandler(BaseHandler):
    def get(self, comment_id):
        comment_query = self.sess.query(Comment).get(comment_id)
        if not comment_query:
            self.send_error(status_code=404, message='Not Found')
        response = {
            'id': comment_query.id,
            'content': comment_query.content,
            'problem_id': comment_query.problem_id,
            'user_id': comment_query.user_id,
            'created_date': iso8601_conv_with_empty_check(comment_query.created_date),
            'modified_date': iso8601_conv_with_empty_check(comment_query.modified_date),
            'modified_user_id': comment_query.modified_user_id
        }
        self.write(response)

    def post(self, comment_id):
        if comment_id:
            self.send_error(status_code=400, message='Bad Request')

    def put(self, comment_id):
        comment_query = self.sess.query(Comment).get(comment_id)
        if not comment_query:
            self.send_error(status_code=404, message='Not Found')

        comment_query.content = self.request.arguments['content']
        comment_query.modified_date = datetime.utcnow()
        comment_query.modified_user_id = self.request.arguments['modified_user_id']
        self.sess.commit()

    def delete(self, comment_id):
        comment_query = self.sess.query(Comment).get(comment_id)
        if not comment_query:
            self.send_error(status_code=404, message='Not Found')
        self.sess.delete(comment_query)
        self.sess.commit()


class ProblemCommentsHandler(BaseHandler):
    def get(self, problem_id):
        json_response = []
        comments_query = self.sess.query(Comment).filter_by(problem_id=problem_id).all()
        if not comments_query:
            self.send_error(status_code=404, message='Not Found')

        for comment_query in comments_query:
            user_query = self.sess.query(User).get(comment_query.user_id)

            if comment_query.modified_user_id is not None:
                modified_query = self.sess.query(User).get(comment_query.modified_user_id)
                first_name = modified_query.first_name
            else:
                first_name = None

            response = {
                'id': comment_query.id,
                'content': comment_query.content,
                'created_by': user_query.first_name,
                'created_date': iso8601_conv_with_empty_check(comment_query.created_date),
                'modified_date': iso8601_conv_with_empty_check(comment_query.modified_date),
                'modified_by': first_name,
            }
            json_response.append(response)
        self.write(conv_array_to_dict(json_response))

    def post(self, problem_id):
        new_comment = Comment(content=str(self.request.arguments['content']),
                              problem_id=problem_id,
                              user_id=int(self.request.arguments['user_id']),
                              created_date=datetime.utcnow())
        self.sess.add(new_comment)
        self.sess.commit()

    def put(self, problem_id):
        if problem_id:
            self.send_error(status_code=400, message='Bad Request')

    def delete(self, problem_id):
        if problem_id:
            self.send_error(status_code=400, message='Bad Request')