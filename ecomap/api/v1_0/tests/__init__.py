import tornado.testing
import app


class BaseHTTPTest(tornado.testing.AsyncHTTPTestCase):
    def get_app(self):
        return app.application

# from tornado mailing list:
#
# AsyncHTTPTestCase is a subclass of AsyncTestCase, so you have the same IOLoop
# setup as AsyncTestCase. Use AsyncHTTPTestCase when you need HTTP (and can
# supply an override of get_app()); use AsyncTestCase when all you need is a
# basic IOLoop setup.
#
# So we definitely want to use AsyncHTTPTestCase as a superclass to test API.
#
# You can also use @gen_test instead of AsyncHTTPTestCase.fetch to get test
# code that looks like a coroutine (with yield statements), although this can
# be a little awkward since there's not currently a helper function like
# self.fetch() (the equivalent is something like
# `yield self.http_client.fetch(self.get_url(path))`. It won't work to mix
# the two styles, so if you use gen_test you cannot use anything else that
# calls fetch, stop, or wait.
