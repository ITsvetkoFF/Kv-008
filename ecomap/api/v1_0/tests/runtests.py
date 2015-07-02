import tornado.testing
import unittest


TEST_MODULES = [
    'api.v1_0.tests.test_auth',
    # 'api.v1_0.tests.test_comments',
]


def all():
    return unittest.defaultTestLoader.loadTestsFromNames(TEST_MODULES)


if __name__ == '__main__':
    tornado.testing.main()
