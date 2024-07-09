import os
import unittest
# import curlify


from environment import Environment
from request import Request, Session, Response
from smoke_test.exceptions import SmokeTestError


class BaseSmokeTestCase(unittest.TestCase):

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        env = os.environ.get('trumpet_prenv_id', None)
        general_api_version = kwargs.get('general_api_version')
        ServerType = kwargs.get('ServerType')
        if not env:
            raise SmokeTestError('trumpet_prenv_id environment variable is not set')
        self.env = Environment(env, general_api_version, ServerType)
        self.client = Request(exception=SmokeTestError, retry_count=3, retry_timeout=3, raise_exception=False)
        self.session = Session(exception=SmokeTestError, retry_count=3, retry_timeout=3, raise_exception=False)

    def assertResponseStatusCodeLess(self, response: Response, expected_response: int, message: str = None) -> None:
        if message is None:
            # curl_req = curlify.to_curl(response.request)
            # message = f"{response.request.method} {response.request.url} responded with status {response.status_code} </br> the curl is: </br> {curl_req} </br> and response is: </br> {response.body}"
            message = f"{response.request.method} {response.request.url} responded with status {response.status_code}"
        self.assertLess(response.status_code, expected_response, message)
