from lxml import html

import curlify
import json
from typing import List

from smoke_test.base import BaseSmokeTestCase


class SerpSmokeTest(BaseSmokeTestCase):

    def test_serp_web(self) -> None:
        response = self.client.get(f'{self.env.url}/ایران')
        print(response.request)
        self.assertResponseStatusCodeLess(response, 400)
        page = html.fromstring(response.content)
        listings = page.xpath('//article')
        self.assertTrue(24 <= len(listings) <= 26, 'There are not 24 listings in web serp')

    def test_category_filter_web(self) -> None:
        response = self.client.get(f'{self.env.url}/ایران/وسایل-نقلیه')
        print(response.request)
        self.assertResponseStatusCodeLess(response, 400)
        page = html.fromstring(response.content)
        listings = page.xpath('//article')
        self.assertTrue(24 <= len(listings) <= 26, 'There are not 24 listings in web filter category')

    def test_location_filter_web(self) -> None:
        response = self.client.get(f'{self.env.url}/تهران')
        print(response.request)
        self.assertResponseStatusCodeLess(response, 400)
        page = html.fromstring(response.content)
        listings = page.xpath('//article')
        self.assertTrue(24 <= len(listings) <= 26, 'There are not 24 listings in web filter Tehran')

    def test_serp_api(self) -> None:
        response = self.client.get(f'{self.env.url}/api/v{self.env.general_api_version}/listings',
                                    headers={'X-AGENT-TYPE': 'Android App', 'App-Version': f'{self.env.general_api_version}'})
        print(curlify.to_curl(response.request))
        self.assertResponseStatusCodeLess(response, 400)
        self.assertIsInstance(response.body, dict, "invalid API listings response")
        listings = self.get_listings(response)
        print("<br>")
        print(response.body)
        self.assertTrue(24 <= len(listings) <= 26, 'There are not 24 listings in api serp')

    def test_category_filter_api(self) -> None:
        response = self.client.get(f'{self.env.url}/api/v{self.env.general_api_version}/listings',
                                   params={'categoryID': '43626'},
                                   headers={'X-AGENT-TYPE': 'Android App', 'App-Version': f'{self.env.general_api_version}'})
        print(curlify.to_curl(response.request))
        self.assertResponseStatusCodeLess(response, 400)
        self.assertIsInstance(response.body, dict, "invalid API listings response")
        listings = self.get_listings(response)
        print("<br><br>")
        print(json.dumps(listings, indent=4, sort_keys=False, ensure_ascii=False))
        self.assertTrue(24 <= len(listings) <= 26, 'There are not 24 listings in API car category')

    def test_location_filter_api(self) -> None:
        response = self.client.get(f'{self.env.url}/api/v{self.env.general_api_version}/listings',
                                   params={'locationID': '8', 'locationType': 0},
                                   headers={'X-AGENT-TYPE': 'Android App', 'App-Version': f'{self.env.general_api_version}'})
        print(curlify.to_curl(response.request))
        self.assertResponseStatusCodeLess(response, 400)
        self.assertIsInstance(response.body, dict, "invalid API listings response")
        listings = self.get_listings(response)
        print("<br>")
        print(response.body)
        self.assertTrue(24 <= len(listings) <= 26, 'There are not 24 listings in API filter Tehran')


    def get_listings(self, response) -> List[str]:
        if f'{self.env.general_api_version}' <= '5.8.0':
            listings = response.body.get('listings')
        else:
            listings = []
            for data in response.body.get('data'):
                if data.get('type') == 'serp':
                    listings.extend(data.get('data').get('listings'))
        return listings
