from lxml import html

from smoke_test.base import BaseSmokeTestCase


class EnvironmentSmokeTest(BaseSmokeTestCase):

    def setUp(self) -> None:
        self.selectors = ["//img/@src", "//link/@href", "//script/@src"]

    def test_environment(self) -> None:
        response = self.client.get(url=self.env.url)
        self.assertResponseStatusCodeLess(response, 400)
    ## TODO: add test

    def https_redirect(self) -> None:
        response = self.client.get(f'http://{self.env.raw_url}')
        if self.env.is_pr:
            self.assertEquals(len(response.history), 0, f'http request on PR should not redirect')
        elif self.env.is_staging:
            self.assertGreater(len(response.history), 0, f'{response.url} has no redirection history')
            self.assertEquals(response.history[0].status_code, 301, f'{response.url} redirected with status {response.history[0].status_code}')

    def test_html_source(self) -> None:
        response = self.client.get(f'{self.env.url}')
        self.assertResponseStatusCodeLess(response, 400)
        page = html.fromstring(response.content)
        url_list = []
        for i in self.selectors:
            [url_list.append(url) for url in page.xpath(i) if url.startswith('/') and url not in url_list]
        for url in url_list:
            if url != '/img/namads/enamad.png':
                response = self.client.get(f'{self.env.url}{url}')
                self.assertResponseStatusCodeLess(response, 400)

    def test_404_not_found(self) -> None:
        response = self.client.get(f'{self.env.url}/error_4o4')
        self.assertEquals(response.status_code, 404, "response should be 404")
        page = html.fromstring(response.content)
        lost_message = page.xpath('//section[contains(@class, "text-center")]/h1/text()')
        self.assertEquals(len(lost_message), 1, '404 lost message not found')
        self.assertEquals(lost_message[0], 'به نظر می رسد گم شده اید!', '404 lost message not found')
