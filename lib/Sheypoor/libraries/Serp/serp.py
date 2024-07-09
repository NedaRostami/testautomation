from libraries.base import BaseSheypoorLibrary
from robot.api.deco import keyword
from typing import List
from exceptions import UtilsError
from request import Session
import lxml.html


class Serp(BaseSheypoorLibrary):
    platform_list: List[str] = ['web']

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.url = self.env.url
        self.client: Session = Session(exception=UtilsError, retry_count=3, timeout=10)

    @keyword(name='Get Landing Elements Value From Serp')
    def get_landing_elements_value_from_serp(self, page_url) -> str:
        first_page_results = self.get_landing_elements_value_from_first_serp_page(page_url)
        first_page_link_url = first_page_results[0]
        first_page_element_text = first_page_results[1]
        second_page_results = self.get_landing_elements_value_from_second_serp_page(first_page_link_url)
        second_page_link_url = second_page_results[0]
        second_page_elements_text = second_page_results[1]
        third_page_elements_text = self.get_landing_elements_value_from_third_serp_page(second_page_link_url)
        results = first_page_element_text
        results.update(second_page_elements_text)
        results.update(third_page_elements_text)
        return results

    def get_landing_elements_value_from_first_serp_page(self, page_url) -> str:
        response: Response = self.client.get(f'{self.url}/{page_url}')
        response.is_valid(raise_exception=False)
        html_page = lxml.html.fromstring(response.content)
        suggested_search = self.get_suggested_search_link_and_text(html_page)
        suggested_search_link = suggested_search[0]
        suggested_search_text = suggested_search[1]
        element_text = {'link': suggested_search_text}
        return suggested_search_link, element_text

    def get_landing_elements_value_from_second_serp_page(self, page_url) -> str:
        response: Response = self.client.get(f'{self.url}{page_url}')
        response.is_valid(raise_exception=False)
        html_page = lxml.html.fromstring(response.content)
        page_title = html_page.find(".//title").text
        search_input = html_page.xpath('//*[@name="q"]')[0].get("value")
        search_tag = self.get_tag_element_text(html_page, 0)
        content = html_page.xpath('//*[@id="content-description"]/p')[0].text
        suggested_search = self.get_suggested_search_link_and_text(html_page)
        suggested_search_link = suggested_search[0]
        suggested_search_text = suggested_search[1]
        elements_text = {'title': page_title, 'search_params': search_input, 'search_params_tag': search_tag,
                    'content': content, 'cat_link': suggested_search_text}
        return suggested_search_link, elements_text

    def get_landing_elements_value_from_third_serp_page(self, page_url) -> str:
        response: Response = self.client.get(f'{page_url}')
        response.is_valid(raise_exception=False)
        html_page = lxml.html.fromstring(response.content)
        category = html_page.xpath('//*[contains(@class,"category") and contains(@class,"form-select")]')[0].text
        city = html_page.xpath('//*[@data-popup="popup-locations"]')[0].text
        district = html_page.xpath('//*[@data-popup="popup-districts"]')[0].text
        city_tag = self.get_tag_element_text(html_page, 0)
        district_tag = self.get_tag_element_text(html_page, 1)
        category_tag = self.get_tag_element_text(html_page, 2)
        elements_text = {'cat': category, 'city': city, 'district': district, 'city_tag': city_tag,
                    'district_tag': district_tag, 'cat_tag': category_tag}
        return elements_text

    def get_suggested_search_link_and_text(self, html_page) -> str:
        suggested_search = html_page.xpath('//*[@id="internal-links-expand"]//a')[0]
        suggested_search_link = suggested_search.get("href")
        suggested_search_text = suggested_search.text
        return suggested_search_link, suggested_search_text

    def get_tag_element_text(self, html_page, index: int) -> str:
        tag_element_text = html_page.xpath('//*[@id="tags"]//*[contains(@class,"tag")]')[index].text
        return tag_element_text

    @keyword(name='Get Redirected Page Url')
    def get_redirected_page_url(self, page_url) -> str:
        response: Response = self.client.get(f'{self.url}/{page_url}')
        response.is_valid(raise_exception=False)
        html_page = lxml.html.fromstring(response.content)
        redirected_page_url = html_page.xpath('//link[@rel="canonical"]')[0].get("href")
        return redirected_page_url
