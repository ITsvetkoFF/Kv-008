# coding: utf-8
import json
# tornado api
from tornado.gen import Task
from tornado.testing import AsyncHTTPTestCase, gen_test
from tornado.httpclient import HTTPRequest, HTTPError
# prj api
from api import settings
from api.utils.db import get_db_session
from api.v1_0.models.comment import Comment
from api.v1_0.bl.models_dict_logic import get_dict_from_orm
from api.v1_0.tests import BaseHTTPTest


class CommentsAsyncHTTPTestCase(BaseHTTPTest):
    def setUp(self):
        super(CommentsAsyncHTTPTestCase, self).setUp()
        self.data = json.dumps(dict(content='avaba kedabra',
                                    user_id=1,
                                    modified_user_id=2))
        self.headers = {'Content-Type': 'application/json; charset=UTF-8'}
        self.session = get_db_session(settings)()

    def tearDown(self):
        super(CommentsAsyncHTTPTestCase, self).tearDown()
        self.session.close()


class CommentsTest(CommentsAsyncHTTPTestCase):
    def setUp(self):
        super(CommentsTest, self).setUp()
        self.comments_id = int(9)
        self.url = self.get_url(r'/api/v1/comments/%d' % self.comments_id)

    def return_comment_query(self):
        init_query = self.session.query(Comment).get(self.comments_id)
        if init_query is None:
            raise ValueError('No such comment in query.')
        result = get_dict_from_orm(init_query)
        self.session.commit()
        return result

    @gen_test
    def test_comments_get_ok_request(self, method='GET'):
        request = HTTPRequest(url=self.url, method=method)
        response = yield self.http_client.fetch(request)
        self.assertEqual(response.code, 200)
        self.assertIsNotNone(response.body)

    @gen_test
    def test_comments_post_bad_request(self, method='POST'):
        request = HTTPRequest(url=self.url, method=method,
                              body=self.data)
        with self.assertRaises(HTTPError) as context:
            yield self.http_client.fetch(request)
        self.assertEqual(context.exception.code, 400)

    @gen_test
    def put_ok_request(self, method='PUT'):
        request = HTTPRequest(url=self.url, method=method,
                              body=self.data, headers=self.headers)
        response = yield self.http_client.fetch(request)
        self.assertEqual(response.code, 200)

    def test_comments_put_ok_request(self):
        result = self.return_comment_query()
        self.put_ok_request()
        after_query = self.session.query(Comment).get(self.comments_id)
        after_query.content = result['content']
        after_query.user_id = result['user_id']
        after_query.modified_user_id = result['modified_user_id']
        self.session.commit()

    @gen_test
    def delete_ok_request(self, method='DELETE'):
        request = HTTPRequest(url=self.url, method=method)
        try:
            response = yield self.http_client.fetch(request)
            http_status = response.code
        except HTTPError as e:
            http_status = e.code
        self.assertEqual(http_status, 200)

    def test_comments_delete_ok_request(self):
        result = self.return_comment_query()
        try:
            self.delete_ok_request()
        except HTTPError as e:
            self.assertEqual(e.code, 404)
        finally:
            restore_comment = Comment(id=result['id'],
                                      content=result['content'],
                                      problem_id=result['problem_id'],
                                      user_id=result['user_id'],
                                      created_date=result['created_date'],
                                      modified_date=result['modified_date'],
                                      modified_user_id=result['modified_user_id'])
            self.session.add(restore_comment)
            self.session.commit()


class ProblemCommentsTest(CommentsAsyncHTTPTestCase):
    def setUp(self):
        super(ProblemCommentsTest, self).setUp()
        self.problems_id = int(9)
        self.url = self.get_url(r'/api/v1/problems/%d/comments' % self.problems_id)

    @gen_test
    def test_problem_comments_get_ok_request(self, method='GET'):
        request = HTTPRequest(url=self.url, method=method)
        response = yield self.http_client.fetch(request)
        self.assertEqual(response.code, 200)
        self.assertIsNotNone(response.body)

    @gen_test
    def post_ok_request(self, method='POST'):
        request = HTTPRequest(url=self.url, method=method,
                              body=self.data, headers=self.headers)
        response = yield self.http_client.fetch(request)
        self.assertEqual(response.code, 200)

    def test_problem_comments_post_ok_request(self):
        self.post_ok_request()
        remove_td = self.session.query(Comment).order_by(Comment.id.desc()).first()
        self.session.delete(remove_td)
        self.session.commit()

    @gen_test
    def test_problem_comments_put_bad_request(self, method='PUT'):
        request = HTTPRequest(url=self.url, method=method,
                              body=self.data, headers=self.headers)
        with self.assertRaises(HTTPError) as context:
            yield self.http_client.fetch(request)
        self.assertEqual(context.exception.code, 400)

    @gen_test
    def test_problem_comments_delete_bad_request(self, method='DELETE'):
        request = HTTPRequest(url=self.url, method=method)
        response = yield Task(self.http_client.fetch, request)
        self.assertEqual(response.code, 400)