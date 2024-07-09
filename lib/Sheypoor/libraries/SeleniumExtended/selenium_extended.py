from typing import List

from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from SeleniumLibrary import SeleniumLibrary

from libraries.base import BaseSheypoorLibrary


class SeleniumExtended(BaseSheypoorLibrary):

    platform_list: List[str] = ['web', ]

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.selenium: SeleniumLibrary = BuiltIn().get_library_instance('SeleniumLibrary')

    @keyword(name='Get Selenium ID')
    def get_selenium_id(self) -> str:
        return self.selenium.driver.session_id
