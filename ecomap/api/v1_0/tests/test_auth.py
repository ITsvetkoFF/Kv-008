import json

from factories.user import UserFactory

from api.v1_0.tests import BaseHTTPTest
from api.v1_0.tests import common
import api.v1_0.models as models


class LoginHTTPTest(BaseHTTPTest):
    def setUp(self):
        BaseHTTPTest.setUp(self)

        self.session = common.Session()
        self.session.add(UserFactory(first_name='Mike', last_name='Ross'))
        self.session.commit()

    def test_login_success(self):
        response = self.fetch(
            path='/api/login',
            method='POST',
            body=json.dumps({'email': 'Mike@example.com',
                             'password': 'Mike_pass'})
        )
        self.assertEqual(response.code, 200)

    def test_login_failure(self):
        response = self.fetch(
            path='/api/login',
            method='POST',
            body=json.dumps({'email': 'Mike@example.com',
                             # wrong password
                             'password': 'Ross_pass'})
        )
        self.assertEqual(response.code, 400)
        self.assertEqual(response.body,
                         json.dumps({'message': 'Invalid email/password.'}))

    def test_no_required_key(self):
        response = self.fetch(
            path='/api/login',
            method='POST',
            body=json.dumps({'email': 'Mike@example.com'})
        )
        self.assertEqual(response.code, 400)

    def tearDown(self):
        self.session.query(models.User).delete()
        self.session.commit()
        common.Session.remove()


class RegisterHTTPTest(BaseHTTPTest):
    def setUp(self):
        BaseHTTPTest.setUp(self)

        self.session = common.Session()
        self.session.query(models.User).delete()
        self.session.commit()

    def test_no_required_key(self):
        response = self.fetch(
            path='/api/register',
            method='POST',
            body=json.dumps({'email': 'Mike@example.com'})
        )
        self.assertEqual(response.code, 400)
        self.assertEqual([], self.session.query(models.User).all())

    def test_register_success(self):
        user_data = dict(first_name='Mike',
                         last_name='Ross',
                         email='Mike@example.com',
                         password='Mike_pass',
                         region_id=None,
                         facebook_id=None,
                         google_id=None)

        response = self.fetch(
            path='/api/register',
            method='POST',
            body=json.dumps(user_data)
        )
        self.assertEqual(response.code, 200)
        stored_users = self.session.query(models.User).filter_by(
            email=user_data['email']).all()
        self.assertEqual(1, len(stored_users))

    def test_duplicate_emails(self):
        self.session.add(UserFactory(first_name='Mike', last_name='Ross'))
        self.session.commit()

        response = self.fetch(
            path='/api/register',
            method='POST',
            body=json.dumps(
                dict(first_name='Harvey',
                     last_name='Spector',
                     email='Mike@example.com',
                     password='pass'))
        )
        self.assertEqual(response.code, 400)
        self.assertEqual(response.body,
                         json.dumps({'message': 'Email already in use.'}))

    def tearDown(self):
        self.session.query(models.User).delete()
        self.session.commit()
        common.Session.remove()
