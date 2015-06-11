# coding: utf-8
import json
# tornado api
import tornado.ioloop
from tornado.testing import AsyncHTTPTestCase, gen_test
from tornado.httpclient import HTTPRequest, HTTPError
# prj api
from app import application
from api import settings
from api.utils.db import get_db_session
from api.v1_0.models.comment import Comment


class CommentsAsyncHTTPTestCase(AsyncHTTPTestCase):
    def get_app(self):
        return application

    def get_new_ioloop(self):
        return tornado.ioloop.IOLoop.instance()

    def setUp(self):
        super(CommentsAsyncHTTPTestCase, self).setUp()
        self.comments_id = int(7)
        self.url = self.get_url(r'/api/v1/comments/%d' % self.comments_id)
        self.data = json.dumps(dict(content=str('alahamora'),
                                    user_id=int(1),
                                    modified_user_id=int(2)))
        self.headers = {'Content-Type': 'application/json; charset=UTF-8'}
        self.session = get_db_session(settings)()

    def tearDown(self):
        super(CommentsAsyncHTTPTestCase, self).tearDown()
        self.session.close()


class CommentsTest(CommentsAsyncHTTPTestCase):
    @gen_test
    def test_comments_request_get_ok(self, method='GET'):
        request = HTTPRequest(url=self.url, method=method)
        response = yield self.http_client.fetch(request)
        self.assertEqual(response.code, 200)

    @gen_test
    def test_comments_request_post_bad_request(self, method='POST'):
        request = HTTPRequest(url=self.url, method=method,
                              body=self.data)
        with self.assertRaises(HTTPError) as context:
            yield self.http_client.fetch(request)
        self.assertEqual(context.exception.code, 400)

    @gen_test
    def test_comments_request_put_ok_request(self, method='PUT'):
        query_request = self.session.query(Comment).get(self.comments_id)
        request = HTTPRequest(url=self.url, method=method,
                              body=self.data, headers=self.headers)
        response = yield self.http_client.fetch(request)
        self.assertEqual(response.code, 200)

    """
    @gen_test
    def test_comments_request_delete_ok_request(self):
        request = HTTPRequest(url=self.url, method='DELETE')
        with self.assertRaises(HTTPError) as context:
            yield self.http_client.fetch(request)
        self.assertEqual(context.exception.code, 404)
    """