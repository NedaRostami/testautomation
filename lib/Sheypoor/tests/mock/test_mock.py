import time
import unittest
from typing import Dict

from libraries import Mock
from request import Request


class TestMock(unittest.TestCase):

    def setUp(self) -> None:
        self.phone_number = '09001234567'
        self.headers: Dict[str, str] = {'x-ticket': '0b14a51ffe617fdaf0e256d6cb509196'}
        self.mock = Mock('staging')
        self.client = Request(headers=self.headers, retry_count=3, timeout=10)

    def test_mock_toggle(self):
        set_leads_view: bool = self.mock.set_toggle(platform='web', name='leads-views', status=1)
        time.sleep(5)
        self.assertTrue(set_leads_view)
        get_leads_view: bool = self.mock.get_toggle(platform='web', name='leads-views')
        self.assertTrue(get_leads_view)
        set_leads_view: bool = self.mock.set_toggle(platform='mobile', name='leads-views', status=0)
        self.assertTrue(set_leads_view)
        time.sleep(5)
        get_leads_view: bool = self.mock.get_toggle(platform='mobile', name='leads-views')
        self.assertFalse(get_leads_view)

    def test_login_code(self):
        self.__login()
        time.sleep(2)
        login_code = self.mock.get_login_code(self.phone_number)
        self.assertTrue(login_code)

    def test_listing_limit(self):
        set_listing_limit = self.mock.set_listing_limit(10000, 2, 'وسایل نقلیه', 'خودرو')
        self.assertTrue(set_listing_limit)
        get_listing_limit = self.mock.get_listing_limit('وسایل نقلیه', 'خودرو')
        self.assertIsInstance(get_listing_limit, dict)
        self.assertEqual(get_listing_limit.get('limit'), 2)
        self.assertEqual(get_listing_limit.get('price'), 10000)

    def test_listing_moderation(self):
        listing_id = self.__post_a_listing()
        moderated_listing = self.mock.moderate_listing('accept', listing_id)
        self.assertTrue(moderated_listing)

    def test_listing_shift(self):
        listing_id = self.__post_a_listing()
        self.mock.moderate_listing('accept', listing_id)
        shift = self.mock.shift_listing('2day', listing_id)
        self.assertTrue(shift)

    def test_listing_expire(self):
        listing_id = self.__post_a_listing()
        self.mock.moderate_listing('accept', listing_id)
        shift = self.mock.shift_listing('2day', listing_id)
        self.assertTrue(shift)

    def __login(self):
        login_url = f'{self.mock.env.url}/api/v{self.env.general_api_version}/user/state-request'
        login_body = {'username': self.phone_number}
        self.client.post(login_url, json=login_body, headers={'X-AGENT-TYPE': 'Android App', 'App-Version': f'{self.env.general_api_version}'})

    def __post_a_listing(self):
        listing_url = f'{self.mock.env.url}/api/v3.1.8/listings'
        listing_body = {
            "attributes": [],
            "categoryID": 43637,
            "description": "mock unit tests fwfwwefweffewfwef",
            "images": [],
            "locationID": 4785,
            "locationType": 2,
            "title": "mock unit tests",
        }
        response = self.client.post(listing_url, json=listing_body, headers={'X-AGENT-TYPE': 'Android App', 'App-Version': f'{self.env.general_api_version}'})
        response.is_valid(raise_exception=True)
        return response.body.get('listingID')
