from typing import Dict, Any

from smoke_test.base import BaseSmokeTestCase


class StaticDataSmokeTest(BaseSmokeTestCase):

    def test_static_data(self) -> None:
        response = self.client.get(f'{self.env.url}/api/v{self.env.general_api_version}/general/static-data',
                                     headers={'X-AGENT-TYPE': 'Android App', 'App-Version': f'{self.env.general_api_version}'})
        self.assertResponseStatusCodeLess(response, 400)

        body: Dict[str, Any] = response.body
        for i in body.values():
            self.assertNotEqual(i, 0, "static data version is 0")
