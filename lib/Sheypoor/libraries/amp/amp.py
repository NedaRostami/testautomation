from libraries.base import BaseSheypoorLibrary
from robot.api.deco import keyword
from typing import List
from exceptions import UtilsError
from request import Session
import lxml.html
from urllib.parse import unquote

class amp(BaseSheypoorLibrary):
    platform_list: List[str] = ['web']

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.url = self.env.url
        self.client: Session = Session(exception=UtilsError, retry_count=3, timeout=10)

    @keyword(name='Get AMP Url From html Tags')
    def get_amp_url_from_html_tags(self, page_url: str):
        url = f'{self.url}/{page_url}'
        response: Response = self.client.get(url)
        response.is_valid(raise_exception=False)
        html_page = lxml.html.fromstring(response.content)
        existence_ad = self.check_existence_ad(html_page)
        if existence_ad:
            try:
                amp_url = html_page.xpath('//link[@rel="amphtml"]')[0].get("href")
            except:
                return 'amphtml does not exist.'
            amp_url = unquote(amp_url)
            return amp_url
        else:
            return 'There are no ads on this page.'


    def check_existence_ad(self, html_page) -> bool:
        try:
            html_page.xpath('//*[@id="no-results"]')[0]
            return False
        except:
            return True
