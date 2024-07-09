import string
import random
import re
import warnings
import csv

from urllib.parse import unquote
from typing import List, Dict, Any, Union
import os
import lxml.html
import robot.api.logger as logger
from robot.utils.asserts import fail
from robot.api.deco import keyword

from robot.libraries.BuiltIn import BuiltIn
from bs4 import BeautifulSoup

from exceptions import UtilsError
from libraries.base import BaseSheypoorLibrary
from request import Request

from geopy.geocoders import Nominatim

class Utils(BaseSheypoorLibrary):
    platform_list: List[str] = ['web', 'mobile', 'android', 'ios', 'api', 'seo', ]

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.client = Request(exception=UtilsError, retry_count=3, timeout=10)
        self.__DEFAULT_HEADERS = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.131 Safari/537.36'}
        self.__PLATFORM_HEADER_MAPPER = {
        'android': {'X-AGENT-TYPE': 'Android App', 'App-Version': f'{self.env.file_version}'},
        'mobile': {
        'User-Agent': 'Mozilla/5.0 (Linux; U; Android 8.1; en-us; SCH-I535 Build/KOT49H) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30'},
        'web': self.__DEFAULT_HEADERS,
        'aloonak': {'source':'protools'},
        'sheypoor_plus': {'source': 'protoolsCars'}
        }

        self.__DIGITS_MAPPER = {
        'en2fa': {'1': '۱', '2': '۲', '3': '۳', '4': '۴', '5': '۵', '6': '۶', '7': '۷', '8': '۸', '9': '۹', '0': '۰', },
        'fa2en': {'۱': '1', '۲': '2', '۳': '3', '۴': '4', '۵': '5', '۶': '6', '۷': '7', '۸': '8', '۹': '9', '۰': '0', },
        'ar2en': {'١': '1', '٢': '2', '٣': '3', '٤': '4', '٥': '5', '٦': '6', '٧': '7', '٨': '8', '٩': '9', '٠': '0', },
        'en2ar': {'1': '١', '2': '٢', '3': '٣', '4': '٤', '5': '٥', '6': '٦', '7': '٧', '8': '٨', '9': '٩', '0': '٠', },
        }


    @keyword(name='Random Phone Number')
    def random_phone_number(self, prefix: str = '0900') -> str:
        return f'{prefix}{random.randint(1000000, 9999999)}'

    @keyword(name='Random Sheba Number')
    def random_sheba_number(self, prefix: str = 'IR') -> str:
        return f'{prefix}{random.randint(100000000000000000000000, 900000000000000000000000)}'

    @keyword(name='Random Number')
    def random_number(self, _min: Union[str, int], _max: Union[str, int]) -> int:
        return random.randint(int(_min), int(_max))

    @keyword(name='Random Unique Numbers')
    def random_unique_number_list(self, _min: Union[str, int], _max: Union[str, int],
                                  count: Union[str, int]) -> List[int]:
        return random.sample(range(int(_min)), int(_max) + 1, int(count))

    @keyword(name='Generate String')
    def generate_string(self, size: int = 8, chars: str = None):
        if chars is None:
            chars = string.ascii_lowercase
        return ''.join(random.choice(chars) for _ in range(size))

    @keyword(name='Unquote URL')
    def unquote_url(self, url: str) -> str:
        return unquote(url)

    @keyword(name='Get Values From List')
    def get_values_from_list(self, _list: List, key: str) -> List[str]:
        return [i.get(key) for i in _list]

    @keyword(name='Split Sentence Into Words')
    def split_sentence_into_words(self, sentence: str, word_count: int):
        return ' '.join(sentence.split()[:int(word_count)])

    @keyword(name='Get Categories')
    def get_category_and_sub_category_title_list(self) -> Dict[str, List[str]]:
        response = self.client.get(f'{self.env.url}/api/v{self.env.general_api_version}/general/categories',
                                   headers={'X-AGENT-TYPE': 'Android App', 'App-Version': f'{self.env.general_api_version}'}
                                  )
        response.is_valid(raise_exception=True)
        category_list = response.body
        results = {}
        for category in category_list:
            results[category.get('categoryTitle')] = [i.get('categoryTitle') for i in category.get('children', [])]
        return results

    @keyword(name='Get Config')
    def get_toggle_config(self, platform: str) -> Dict[str, Any]:
        platform = platform.lower()
        random_key = self.generate_string()
        random_val = self.generate_string()
        if platform not in self.__PLATFORM_HEADER_MAPPER.keys():
            warnings.warn(f'could not find platform {platform}, using v{self.env.general_api_version} web as default')
        response = self.client.get(
            f'{self.env.url}/api/v{self.env.general_api_version}/general/config?{random_key}={random_val}',
            headers=self.__PLATFORM_HEADER_MAPPER.get(platform, self.__DEFAULT_HEADERS)
        )
        response.is_valid(raise_exception=True)
        config = response.body.get('features')
        return config

    @keyword(name='Convert Digits')
    def convert_digits(self, digits: str, _type: str) -> str:
        _type = _type.lower()
        if _type not in self.__DIGITS_MAPPER.keys():
            raise UtilsError(f'could not find a converter for {_type}, '
                             f'valid converters are {", ".join(self.__DIGITS_MAPPER.keys())}')
        pattern = re.compile("|".join(self.__DIGITS_MAPPER[_type].keys()))
        results = pattern.sub(lambda x: self.__DIGITS_MAPPER[_type][x.group()], digits)
        if _type == 'fa2en':
            pattern = re.compile("|".join(self.__DIGITS_MAPPER['ar2en'].keys()))
            results = pattern.sub(lambda x: self.__DIGITS_MAPPER['ar2en'][x.group()], results)
        return results

    @keyword(name='Clean All Extra Spaces')
    def clean_up_spaces(self, mystring: str):
        cleaned = ' '.join(mystring.split())
        return cleaned

    @keyword(name='Get Lat And Long')
    def get_lat_and_long_from_map_pin(self, desc_pin: str, num_float: int = 4):
        #sample of desc of pin on map :  lat/lng: (35.70000649399906,51.400000154972076)
        results = desc_pin.replace("lat/lng: (", "")
        results = results.replace(")","")
        results = results.split(",")
        index_of_expected_float = num_float + 3    # 2 number of digit + 1 number of floating point
        lat = results[0][0:index_of_expected_float]
        long = results[1][0:index_of_expected_float]
        return [lat, long]

    @keyword(name='Get Lat And Long On Web')
    def get_lat_and_long_from_map_pin_In_Web(self, desc_pin: str, num_float: int = 4, spl_lat_long: str = '%2C'):
        #sample of desc of pin on map :  lat/lng: (35.70000649399906,51.400000154972076)
        x = desc_pin.find("locations")
        y = desc_pin.find("&height")
        results = desc_pin[x:y]
        results = results.replace(")","")
        results = results.replace("locations=", "")
        results = results.split(spl_lat_long)
        index_of_expected_float = num_float + 3    # 2 number of digit + 1 number of floating point
        lat = results[1][0:index_of_expected_float]
        long = results[0][0:index_of_expected_float]
        return [lat, long]

    @keyword(name='Get Location From Lat And Long')
    def get_location_from_lat_and_long(self, lat: str, long: str, max_retry: int = 5):
        for i in range(max_retry):
            try:
                geolocator = Nominatim(user_agent="geoapiExercises", timeout=10)
                location = geolocator.reverse(lat+","+long)
                break
            except Exception as e:
                print(f'{e}: Could not get location for {i+1}th time.')
            if i == max_retry-1:
                raise Exception('Could not get location.')
        address = location.raw['address']
        city = address.get('county', '')
        city = city.split(' ')[1]
        district = address.get('neighbourhood', '')
        return [city, district]

    @keyword(name='Get Page Errors')
    def get_notice_errors(self):
        page = BuiltIn().get_library_instance('SeleniumLibrary')
        soup = BeautifulSoup(page.driver.page_source, features="lxml")
        for item in soup.main('section'):
            item.decompose()
        for item in soup.main('div'):
            item.decompose()
        for item in soup.main('span'):
            item.decompose()
        for item in soup.main('script'):
            item.decompose()
        for item in soup.main('nav'):
            item.decompose()
        for item in soup.main('header'):
            item.decompose()
        for item in soup.main('footer'):
            item.decompose()
        main_elem = soup.main
        children = main_elem.findChildren()
        logger.trace(main_elem, html=False)
        logger.trace(len(children), html=False)
        if len(children) > 0:
            notice = str(children).replace('\n', '').replace('\r', '').replace('\t', ' ')
            # logger.error(notice, html=True)
            # fail(msg="there is an ERROR in Page. see the error log")
            return True, notice
        else:
            return False, None

    @keyword(name='Create csv File Containing All Categories And SubCategories')
    def create_csv_file(self, file_path: str):
        with open(f'{file_path}.csv','w', newline='', encoding='utf-8') as csv_file:
            columns = ['*** Test Cases ***','${cat_name}', '${subCat_name}','${cat_id}', '${subCat_id}', '[Tags]']
            writer = csv.DictWriter(csv_file, fieldnames = columns)
            writer.writeheader()
            cats_subcats: List = self.get_all_categories_and_subcategories()
            for cat_subCat in cats_subcats:
                writer.writerow({'*** Test Cases ***': f'Test Listing Limits With uuid In {cat_subCat[0]}, {cat_subCat[1]}','${cat_name}': cat_subCat[0],
                                '${subCat_name}': cat_subCat[1], '${cat_id}': cat_subCat[2], '${subCat_id}': cat_subCat[3],
                                '[Tags]': f'limitation,listing,محدودیت ثبت آگهی {cat_subCat[0]},محدودیت ثبت آگهی {cat_subCat[1]}'})

    @keyword(name='Get All Categories And SubCategories')
    def get_all_categories_and_subcategories(self) -> List:
        url = f'{self.env.url}/api/v{self.env.general_api_version}/general/categories'
        response = self.client.get(url=url)
        response.is_valid(raise_exception=True)
        cats_subcats: List = []
        for category in response.body:
            cat_name = category['categoryTitle']
            cat_id = category['categoryID']
            for subcategory in category['children']:
                subcat_name = subcategory['categoryTitle']
                subcat_id = subcategory['categoryID']
                cats_subcats.append([cat_name,subcat_name,cat_id,subcat_id])
        return cats_subcats

    @keyword(name='Get Random Location Name And ID')
    def get_random_location_name_and_id(self) -> Dict:
        url = f'{self.env.url}/api/v{self.env.general_api_version}/general/locations'
        response = self.client.get(url=url)
        response.is_valid(raise_exception=True)
        result: Dict = {}
        random_province = random.randint(1, len(response.body)-1)
        province_loc = response.body[random_province]
        result["province_id"] = province_loc["provinceID"]
        result["province_name"] = province_loc["name"]
        random_city = random.randint(1, len(province_loc["cities"])-1)
        city_loc = province_loc["cities"][random_city]
        result["city_id"] = city_loc["cityID"]
        result["city_name"] = city_loc["name"]
        return result


        # try:
        #     error = main[:main.index("<section id=")]
        #     if error != " ":
        #         logger.error(error, html=True)
        #         fail(msg="there is an ERROR in Page. see the error log")
        #         return False
        #     else:
        #         return True
        # except ValueError:
        #     logger.debug(main, html=True)
        # return False
