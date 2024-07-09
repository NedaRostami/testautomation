import time
import curlify

from lxml import html

from smoke_test.base import BaseSmokeTestCase
from smoke_test.exceptions import SmokeTestError

class ListingSmokeTest(BaseSmokeTestCase):
    POST_LISTING_DATA = {
        "attributes": [
            {
                "attributeID": 1,
                "attributeValue": "2500000"
            },
            {
                "attributeID": 75010,
                "attributeValue": ""
            },
            {
                "attributeID": 90157,
                "attributeValue": 453188
            },
        ],
        "categoryID": 43635,
        "description": "فروش یک الی دو عدد لوازم اداری فروش یک الی دو عدد لوازم اداری",
        "districtName": "تبت آباد",
        "images": [],
        "latitude": "",
        "locationID": 569,
        "locationType": 1,
        "longitude": "",
        "telephone": "09001000000",
        "title": "یک عدد لوازم اداری تستی علی برکه الله",
        "userType": 0
    }

    # def test_post_a_listing_webpage(self) -> None:
    #     response = self.client.get(f'{self.env.url}/listing/new')
    #     self.assertResponseStatusCodeLess(response, 400)
    #     page = html.fromstring(response.content)
    #     app_js_url = page.xpath('//script[@defer][@src]')[2].strip()
    #     response = self.client.get(f'{self.env.url}{app_js_url}')
    #     self.assertResponseStatusCodeLess(response, 400)

    def test_post_a_listing_api(self) -> None:
        try:
            response = self.client.post(f'{self.env.url}/api/v{self.env.general_api_version}/auth/state-request',
            json={'username': "09001000000"},
            headers={'X-AGENT-TYPE': 'Android App', 'App-Version': f'{self.env.general_api_version}', 'user-agent': f'Android/8.1 Sheypoor/{self.env.general_api_version}-Debug-PlayStore VersionCode/594 Manufacturer/Samsung Model/Samsung Galaxy S10 E - 8.1 - API 27 - 1080x2280'})
            self.assertResponseStatusCodeLess(response, 400)
            self.assertIsNotNone(response.body.get('token'), 'could not get token for login')
            token = response.body.get('token')
            time.sleep(2)
            response = self.client.post(f'{self.env.url}/api/v{self.env.general_api_version}/auth/number-verification',
                                    json={'token': token, 'mobilePIN': '1234'},
                                    headers={'X-AGENT-TYPE': 'Android App', 'App-Version': f'{self.env.general_api_version}', 'user-agent': f'Android/8.1 Sheypoor/{self.env.general_api_version}-Debug-PlayStore VersionCode/594 Manufacturer/Samsung Model/Samsung Galaxy S10 E - 8.1 - API 27 - 1080x2280'})
            self.assertResponseStatusCodeLess(response, 400)
            self.assertIsNotNone(response.body.get('x-ticket'))
            x_ticket = response.body.get('x-ticket')
            response = self.client.post(f'{self.env.url}/api/v{self.env.general_api_version}/listings',
                                    json=self.POST_LISTING_DATA,
                                    headers={'x-ticket': x_ticket, 'X-AGENT-TYPE': 'Android App', 'App-Version': f'{self.env.general_api_version}', 'user-agent': f'Android/8.1 Sheypoor/{self.env.general_api_version}-Debug-PlayStore VersionCode/594 Manufacturer/Samsung Model/Samsung Galaxy S10 E - 8.1 - API 27 - 1080x2280'})
            self.assertResponseStatusCodeLess(response, 400)
        except :
            print(curlify.to_curl(response.request))
            print("<br>")
            print(response.body)
        if response.status_code >= 400:
            self.assertResponseStatusCodeLess(response, 400)
