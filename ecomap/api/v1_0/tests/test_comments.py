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
from api.v1_0.bl.models_dict_logic import get_dict_from_orm


def query_rollback_comments(session, id, table_name):
    def wrap(f):
        def wrapped_f(*args):
            init_query = session.query(table_name).get(id)
            f(*args)
            finish_query = session.query(table_name).get(id)
            finish_query.content = init_query.content
            finish_query.modified_date = init_query.modified_date
            finish_query.modified_user_id = init_query.modified_user_id
            session.commit()
        return wrapped_f
    return wrap


class CommentsAsyncHTTPTestCase(AsyncHTTPTestCase):
    def get_app(self):
        return application

    def get_new_ioloop(self):
        return tornado.ioloop.IOLoop.instance()

    def setUp(self):
        super(CommentsAsyncHTTPTestCase, self).setUp()
        self.comments_id = int(9)
        self.url = self.get_url(r'/api/v1/comments/%d' % self.comments_id)
        self.data = json.dumps(dict(content=str('avaba kedabra'),
                                    user_id=int(1),
                                    modified_user_id=int(2)))
        self.headers = {'Content-Type': 'application/json; charset=UTF-8'}
        self.session = get_db_session(settings)()

    def tearDown(self):
        super(CommentsAsyncHTTPTestCase, self).tearDown()
        self.session.close()

    def return_comment_query(self):
        init_query = self.session.query(Comment).get(self.comments_id)
        result = get_dict_from_orm(init_query)
        self.session.commit()
        return result


class CommentsTest(CommentsAsyncHTTPTestCase):
    @gen_test
    def test_comments_get_ok_request(self, method='GET'):
        request = HTTPRequest(url=self.url, method=method)
        response = yield self.http_client.fetch(request)
        self.assertEqual(response.code, 200)

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

    def test_comments_request_delete_ok_request(self):
        result = self.return_comment_query()
        try:
            self.delete_ok_request()
        except HTTPError:
            pass
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