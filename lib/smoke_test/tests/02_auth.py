import re
import time
import curlify
from lxml import html

from smoke_test.base import BaseSmokeTestCase

class AuthSmokeTest(BaseSmokeTestCase):

    def test_login_form(self) -> None:
        form_data = {'pagePath': '/session', 'templates[0][id]': 'template.header.my-account', }
        response = self.client.post(f'{self.env.url}/session/freshit', data=form_data)
        self.assertResponseStatusCodeLess(response, 400)
        body = response.body
        self.assertIsInstance(body, dict, 'login form encountered a problem')
        self.assertTrue(response.body.get('success'), 'login form encountered a problem')

    def test_login_web(self) -> None:
        response = self.client.get(f'{self.env.url}/session')
        self.assertResponseStatusCodeLess(response, 400)
        page = html.fromstring(response.content)
        csrf_token = page.xpath("//section[@id='session']/@data-bind")
        if not csrf_token:
            self.login_web_without_csrf()
        else:
            self.login_web_with_csrf(csrf_token)


    def login_web_with_csrf(self, csrf_token) -> None:
        csrf_token = str(re.findall(r'.*tokenValue:.*', csrf_token[0].strip()))
        csrf_token = csrf_token.split("tokenValue:")[-1].strip().replace("',\"]",'').replace("'",'')
        state_request_data = {'username': '09001000000', 'csrf-key': csrf_token}
        try:
            response = self.client.post(f'{self.env.url}/auth', data=state_request_data)
            self.assertResponseStatusCodeLess(response, 400)
        except :
            print(curlify.to_curl(response.request))
            print("<br>")
            print(response.body)
        if response.status_code >= 400:
            self.assertResponseStatusCodeLess(response, 400)
        body = response.body
        self.assertIsInstance(body, dict, 'login phone number submission failed')
        login_token = body.get('data', {}).get('token')
        self.assertTrue(login_token, 'login phone number submission failed')
        time.sleep(5)
        login_data = {'token': login_token, 'code': '1234', 'csrf-key': csrf_token}
        response = self.client.post(f'{self.env.url}/auth/verify', data=login_data)
        self.assertResponseStatusCodeLess(response, 400)


    def login_web_without_csrf(self) -> None:
        response = self.client.get(f'{self.env.url}/session')
        self.assertResponseStatusCodeLess(response, 400)
        page = html.fromstring(response.content)
        state_request_data = {'username': '09001000000'}
        try:
            response = self.client.post(f'{self.env.url}/auth', data=state_request_data)
            self.assertResponseStatusCodeLess(response, 400)
        except :
            print(curlify.to_curl(response.request))
            print("<br>")
            print(response.body)
        if response.status_code >= 400:
            self.assertResponseStatusCodeLess(response, 400)
        body = response.body
        self.assertIsInstance(body, dict, 'login phone number submission failed')
        login_token = body.get('data', {}).get('token')
        self.assertTrue(login_token, 'login phone number submission failed')
        time.sleep(5)
        login_data = {'verify_token': login_token, 'code': '1234'}
        response = self.client.post(f'{self.env.url}/auth/verify', data=login_data)
        self.assertResponseStatusCodeLess(response, 400)
