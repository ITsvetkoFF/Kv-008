# coding: utf-8
import tornado
from tornado.testing import AsyncTestCase, AsyncHTTPClient, gen_test
from tornado.httpclient import HTTPRequest, HTTPError
from api import settings

COMMENTS_URL = '{http}{hostname}:{port}{api}'.format(http='http://',
                                                    hostname=settings['hostname'],
                                                    port=settings['bind_port'],
                                                    api=r'/api/v1/comments/3')


class CommentsTest(AsyncTestCase):
    @gen_test
    def test_comments_request_get_ok(self):
        client = AsyncHTTPClient(self.io_loop)
        request = HTTPRequest(url=COMMENTS_URL, method='GET')
        response = yield client.fetch(request)
        self.assertEqual(response.code, 200)

    @gen_test
    def test_comments_request_post_bad_request(self):
        client = AsyncHTTPClient(self.io_loop)
        request = HTTPRequest(url=COMMENTS_URL, method='POST')
        request.body = 'avaba kedabra'
        with self.assertRaises(HTTPError) as context:
            yield client.fetch(request)
        self.assertEqual(context.exception.code, 400)