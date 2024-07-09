from request import Session
from typing import List
import lxml.html
from robot.api.deco import keyword

from exceptions import UtilsError
from libraries.base import BaseSheypoorLibrary
from request import Request


class WebUtils(BaseSheypoorLibrary):
    platform_list: List[str] = ['web']

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.url = self.env.url
        self.client: Session = Session(exception=UtilsError, retry_count=3, timeout=10)

    @keyword(name='Get First Listing Details URL From Home Page')
    def get_first_listing_details_url_from_home_page(self) -> str:
        url = self.env.url
        listing_details_url = self.get_data_href(url)
        return listing_details_url

    @keyword(name='Get First Shop Details URL From Shops Page')
    def get_first_shop_details_url_from_home_page(self) -> str:
        url = f'{self.url}/shops'
        shop_details_url = self.get_data_href(url)
        return shop_details_url

    def get_data_href(self, url: str, element_xpath: str = "//article[contains(@id,'listing-')]") -> str:
        response: Response = self.client.get(url)
        response.is_valid(raise_exception=False)
        html_page = lxml.html.fromstring(response.content)
        try:
            result_url = html_page.xpath(element_xpath)[0].get("data-href")
        except:
            return ''
        return result_url
