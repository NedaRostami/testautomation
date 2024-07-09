from typing import List

from appium.webdriver.common.touch_action import TouchAction
from AppiumLibrary import AppiumLibrary
from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn

from libraries.base import BaseSheypoorLibrary

import urllib.request

class AppiumExtended(BaseSheypoorLibrary):
    platform_list: List = ['android', ]

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.appium: AppiumLibrary = BuiltIn().get_library_instance('AppiumLibrary')

    @keyword(name='Scroll a Row')
    def scroll_a_row(self, x1: int = 5, y1: int = 375, x2: int = 5, y2: int = 75):
        driver = self.appium._current_application()
        action = TouchAction(driver)
        action.long_press(x=x1, y=y1).move_to(x=x2, y=y2).release().perform()

    @keyword(name='Flick')
    def flick(self, x1: int, y1: int, x2: int, y2: int, hold: int = 1000):
        driver = self.appium._current_application()
        driver.flick(x1, y1, x2, y2)

    @keyword(name='Scroll To Top')
    def scroll_to_top(self, start_locator: str, height: int = 300, hold: int = 300):
        driver = self.appium._current_application()
        element = self.appium._element_find(start_locator, True, True)
        action = TouchAction(driver)
        action.long_press(element, duration=hold).move_to(x=100, y=height).release().perform()

    @keyword(name='Swipe By Location')
    def swipe_by_location(self, x1: int, y1: int, x2: int, y2: int, hold: int = 1000):
        self.appium.swipe(x1, y1, x2, y2)

    @keyword(name='Scroll Web Elements')
    def scroll_web_elements(self, start_locator: str, end_locator: str):
        driver = self.appium._current_application()
        driver.scroll(start_locator, end_locator)

    @keyword(name='Scroll Back To')  # FIXME: Validate this with Mehrdad
    def scroll_back_to(self, start_locator: str, end_locator: str):
        driver = self.appium._current_application()
        driver.execute_script('mobile: scrollBackTo', {
            'command': 'echo', 'args': [
                self.appium._element_find(start_locator, True, True),
                self.appium._element_find(start_locator, True, True),
            ]
        })

    @keyword(name='Set Geo Location')
    def set_geo_location(self, latitude: str, longitude: str, altitude: str):
        driver = self.appium._current_application()
        driver.set_location(latitude, longitude, altitude)

    @keyword(name='Get The Clipboard')
    def get_the_clipboard(self) -> str:
        driver = self.appium._current_application()
        return driver.get_clipboard_text()

    @keyword(name='Open Notifications Shade')
    def open_notifications_shade(self):
        driver = self.appium._current_application()
        driver.open_notifications()

    @keyword(name='Push File To Device')
    def push_file_to_device(self, destination_path: str, base64data: str = None, source_path: str = None):
        """Puts the data from the file at `source_path`, encoded as Base64, in the file specified as `path`.

        Specify either `base64data` or `source_path`, if both specified default to `source_path`

        Args:
            destination_path (str): the location on the device/simulator where the local file contents should be saved
            base64data (:obj:`bytes`, optional): file contents, encoded as Base64, to be written to the file on the device/simulator
            source_path (:obj:`str`, optional): local file path for the file to be loaded on device
        """
        driver = self.appium._current_application()
        driver.push_file(destination_path, base64data, source_path)

    @keyword(name='Push File To Device From URL')
    def push_file_to_device_from_URL(self, destination_path: str, source_url: str, base64data: str = None):
        """Puts the data from the file at 'source_url`, encoded as Base64, in the file specified as `destination_path`.
        Args:
            destination_path (str): the location on the device/simulator where the local file contents should be saved
            source_url (:obj:`str`): URL file path for the file to be loaded on device
            base64data (:obj:`bytes`, optional): file contents, encoded as Base64, to be written to the file on the device/simulator
        """
        print(destination_path)
        print(source_url)
        result = urllib.request.urlretrieve(source_url)
        # if result[1] = '200'
        print(result[1])
        driver = self.appium._current_application()
        driver.push_file(destination_path, base64data, result[0])
        urllib.request.urlcleanup()

    @keyword(name='Deep Link')
    def deep_link(self, url: str, package: str):
        driver = self.appium._current_application()
        driver.execute_script('mobil: deepLink', {
            'url': url,
            'package': package,
        })

    @keyword(name='ADB Shell')
    def adb_shell(self, shell_string: str):
        driver = self.appium._current_application()
        driver.execute_script('mobile: shell', {
            'command': shell_string,
        })

    @keyword(name='Accept Alert')
    def accept_alert(self, label: str):
        driver = self.appium._current_application()
        driver.execute_script('mobile: acceptAlert', {
            'command': 'echo',
            'args': label,
        })
