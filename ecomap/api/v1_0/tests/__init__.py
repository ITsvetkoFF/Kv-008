import tornado.testing

import app


class BaseHTTPTest(tornado.testing.AsyncHTTPTestCase):
    def get_app(self):
        return app.application

# * AsyncHTTPTestCase
#     - get_app -- returns tornado.web.Application or other HTTPServer callback
#     - fetch -- synchronously fetch a url
#     - get_http_port -- returns the port used by the server
#     - get_url -- returns an absolute url for the given path on the test
# server
#
#
# Python unit testing framework PyUnit
# important concepts:
#   test fixture -- preparation and cleanup actions (working environment for
#       the testing code.
#   test case -- the smallest testable units (set of inputs --> response)
#   test suite -- a collection of test cases, test suites or both
#   test runner -- a component that executes tests and provides the outcome
#       to the user
#
# * TestCase
#       This class implements the interface needed by the testrunner to allow
#       it to drive the test, and methods that the test code can use to check
#       for and report various kinds of failure.
#   - setUp -- preparation
#   - tearDown -- cleanup
#   - runTest -- perform specific testing code
#
#   - assertEqual -- to check for an expected result
#   - assertFalse -- to verify a condition
#   - assertRaises -- to verify that a specific exception gets raised
#
# * TestSuite -- aggregator of tests and test suites
