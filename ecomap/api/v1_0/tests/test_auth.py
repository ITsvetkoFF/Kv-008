from api.v1_0.tests import BaseHTTPTest
import json


class LoginHTTPTest(BaseHTTPTest):
    def test_login_success(self):
        response = self.fetch(
            path='/api/v1/login',
            method='POST',
            body=json.dumps({'email': 'user@example.com',
                             'password': 'user_pass'})
        )
        self.assertEqual(response.code, 200)

    def test_invalid_credentials(self):
        response = self.fetch(
            path='/api/v1/login',
            method='POST',
            body='{"email": "user@example.com", "password": "u$ser_pass"}'
        )
        self.assertEqual(response.code, 400)
        self.assertEqual(response.body,
                         '{"message": "Invalid email/password."}')

    def test_invalid_json_key(self):
        response = self.fetch(
            path='/api/v1/login',
            method='POST',
            body=json.dumps({'emai': 'user@example.com',
                             'password': 'user_pass'})
        )
        self.assertEqual(response.code, 400)


class LogoutHTTPTest(BaseHTTPTest):
    def test_logout(self):
        response = self.fetch('/api/v1/logout')
        self.assertEqual(response.code, 200)


class RegisterHTTPTest(BaseHTTPTest):
    def test_register_no_required_key(self):
        response = self.fetch(
            path='/api/v1/register',
            method='POST',
            body=json.dumps({'email': 'xxx@user.com'})
        )
        self.assertEqual(response.code, 400)
