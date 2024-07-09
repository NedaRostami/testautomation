import unittest
import json

from request import Request, Response


class TestRequestNoRetry(unittest.TestCase):

    def setUp(self) -> None:
        self.base_url = 'https://httpbin.org'
        self.headers = {'Content-Type': 'application/json', 'header': 'true'}
        self.client = Request(headers=self.headers, retry_count=3, timeout=10)

    def test_get(self):
        response: Response = self.client.get(url=f'{self.base_url}/get')
        response.is_valid(raise_exception=True)
        self.assertEqual(response.request.method, 'GET')
        self.assertEqual(response.status_code, 200)
        self.assertIsInstance(response, Response)
        self.assertIsInstance(response.body, dict)

    def test_post(self):
        data = {'moo': 'foo'}
        response: Response = self.client.post(url=f'{self.base_url}/post', json=data)
        response.is_valid(raise_exception=True)
        self.assertEqual(response.request.method, 'POST')
        self.assertEqual(response.status_code, 200)
        self.assertIsInstance(response, Response)
        self.assertIsInstance(response.body, dict)
        self.assertEqual(response.body.get('data'), json.dumps(data))

    def test_put(self):
        data = {'moo': 'foo'}
        response: Response = self.client.put(f'{self.base_url}/put', json=data)
        response.is_valid(raise_exception=True)
        self.assertEqual(response.request.method, 'PUT')
        self.assertEqual(response.status_code, 200)
        self.assertIsInstance(response, Response)
        self.assertIsInstance(response.body, dict)
        self.assertEqual(response.body.get('data'), json.dumps(data))

    def test_delete(self):
        response: Response = self.client.delete(f'{self.base_url}/delete')
        response.is_valid(raise_exception=True)
        self.assertEqual(response.request.method, 'DELETE')
        self.assertEqual(response.status_code, 200)
        self.assertIsInstance(response, Response)
