from typing import Union,Tuple, Dict, List
import re
import random
import os
from pathlib import Path
from environment import Environment
from request import Session
from exceptions import SeoError
from libraries.base import BaseSheypoorLibrary
from request import Response
from libraries.Utils import Utils
import robot.api.logger as logger
from robot.api.deco import keyword


import lxml.html
import json


class Seo(BaseSheypoorLibrary):

    platform_list: List[str] = ['seo', ]
    __have_static_data = False

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.url = self.env.url
        self.utils = Utils(self.env)
        self.json_server: str = f'http://qa2.mielse.com:9500/static-data/{self.env.trumpet_prenv_id}/v{self.env.general_api_version}'
        self.backup_url: str = f'{self.url}/api/v{self.env.general_api_version}/general/static-data'
        self.client: Session = Session(exception=SeoError, retry_count=3, timeout=10)

    def handle_static_data(self):
        if self.__have_static_data:
            return
        self.get_static_data_from_file()
        self.__have_static_data = True

    def get_static_data_from_file(self):
        __location__ = os.path.realpath(os.path.join(os.getcwd(), os.path.dirname(__file__)))
        file_name = os.path.join(__location__, f'static_data_{self.env.general_api_version}.json')
        file_path = Path(os.path.join(__location__, f'static_data_{self.env.general_api_version}.json'))
        if file_path.is_file() and os.path.getsize(file_name) != 0:
            f = open(file_path, "r")
            self.static_data = f.read()
            self.static_data = json.loads(self.static_data)
            f.close()
        else:
            self.static_data = self.get_static_data_online()
            self.save_static_data_to_file()

    def is_file_empty(file_path):
        """ Check if file is empty by confirming if its size is 0 bytes"""
        # Check if file exist and it is empty
        return os.path.isfile(file_name) and os.path.getsize(file_name) != 0

    def save_static_data_to_file(self):
        json_data = json.dumps(self.static_data, indent = 4)
        __location__ = os.path.realpath(os.path.join(os.getcwd(), os.path.dirname(__file__)))
        file_path = os.path.join(__location__, f'static_data_{self.env.general_api_version}.json')
        with open(file_path, "w") as outfile:
            outfile.write(json_data)


    def get_static_data_online(self):
        static_data = self.client.get(self.json_server)
        if static_data.status_code >= 400:
            print('Cannot retrieve static data from json server: {}'.format(static_data.text))
        try:
            return static_data.body
        except JSONDecodeError:
            static_data = self.client.get(self.backup_url)
        if static_data.status_code >= 400:
            raise Exception('Cannot retrieve static data')
        logger.trace(static_data, html=True)
        return static_data.body

    @keyword(name='Get Seo Page Details')
    def get_seo_title_desc_and_h1(self, route: str):
        page_url = f'{self.url}{route}'
        response: Response = self.client.get(page_url)
        response.is_valid(raise_exception=False)
        html_page = lxml.html.fromstring(response.content)
        title = html_page.xpath('//html/head/title')[0].text
        desc = html_page.xpath('//html/head/meta[@name="description"]/@content')[0]
        h1 = self.get_h1(html_page)
        try:
            # adsCount = html_page.xpath('//*[@id="pagination"]//strong[3]')[0].text
            # adsCount = adsCount.replace(",", "")
            # adsCount = self.utils.convert_digits(adsCount, 'fa2en')
            adsCount = re.findall(r'\d+', desc)[0]
        except IndexError:
            adsCount = 0

        return title, desc, h1, adsCount

    def get_h1(self, html_page):
        try:
            h1 = html_page.xpath('//h1')[0].text
            if h1 == None:
                h1 = False
        except IndexError:
            try:
                h3 = html_page.xpath('//*[@id="no-results"]//h3')[0].text
                h3 = h3.strip()
                if h3 == 'متاسفانه نتیجه‌ای پیدا نشد.':
                    h1 = False
            except IndexError:
                h1 = False

        return h1

    def clean_all_spaces(self, mystring: str):
        cleaned = ' '.join(mystring.split())

    @keyword(name='Get Random Location')
    def get_random_location(self, counter: str = 1, province: str = None) -> list:
        result = []
        self.handle_static_data()
        locationsData = self.static_data.get('locationsData', [])
        if province:
            locationsData = [elem for elem in locationsData if province in elem['name']]
            counter = 1

        random_list = random.sample(list(locationsData), int(counter))
        for location in random_list:
            locations = {}
            locations['province_name'] = location.get('name')
            locations['province_slug'] = location.get('slug')
            random_city = random.sample(list(location.get('cities')), 1)[0]
            locations['city_name'] = random_city.get('name')
            locations['city_slug'] = random_city.get('slug')
            result.append(locations)

        return result


    @keyword(name='Get Random Location ID And Slug')
    def get_random_location_id_slug(self, counter: str = 1) -> list:
        result = []
        self.handle_static_data()
        locationsData = self.static_data.get('locationsData', [])
        random_list = random.sample(list(locationsData), int(counter))
        for location in random_list:
            locations = {}
            locations['province_name'] = location.get('name')
            locations['province_slug'] = location.get('slug')
            locations['provinceID'] = location.get('provinceID')
            random_city = random.sample(list(location.get('cities')), 1)[0]
            locations['city_name'] = random_city.get('name')
            locations['city_slug'] = random_city.get('slug')
            locations['cityID'] = random_city.get('cityID')
            result.append(locations)

        return result

    @keyword(name='Get Random Category')
    def get_random_category(self, category: str = None) -> str:
        results = {}
        self.handle_static_data()
        categoriesData = self.static_data.get('categoriesData', [])
        if category:
            categoriesData = [elem for elem in categoriesData if category in elem['categoryTitle']]
        for category in categoriesData:
            results[category.get('categoryTitle')] = [i.get('categoryTitle') for i in category.get('children', [])]
        category = random.sample(list(results), 1)[0]
        subcategories = results.get(category)
        subcategory = random.sample(list(subcategories), 1)[0]

        return category, subcategory

    @keyword(name='Get All Sub Category')
    def get_all_sub_category(self, category: str = None) -> str:
        results = {}
        self.handle_static_data()
        categoriesData = self.static_data.get('categoriesData', [])
        if category:
            categoriesData = [elem for elem in categoriesData if category in elem['categoryTitle']]
        for category in categoriesData:
            results[category.get('categoryTitle')] = [i.get('categoryTitle') for i in category.get('children', [])]
        category = random.sample(list(results), 1)[0]
        subcategories = results.get(category)

        return subcategories

    @keyword(name='Get Random Brand')
    def get_random_brand(self, category: str, subcategory: str, counter: str = 1) -> list:
        url = f'{self.json_server}/categories/{category}/subcategories/{subcategory}/brands'
        response = self.client.get(url=url)
        response.is_valid(raise_exception=True)
        brands_json = response.body.get('items')

        if counter != 'All':
            Length = len(brands_json)
            if Length <= int(counter):
                cnt = Length
            else:
                cnt = int(counter)
            brand_list = random.sample(list(brands_json), cnt)
        else:
            brand_list = brands_json
        brands = []

        for brand in brand_list:
            brands.append(brand.get('categoryTitle'))

        return brands


    @keyword(name='Get Random Model')
    def get_random_model(self, category: str, subcategory: str, brand: str = None, counter: str = 1) -> list:
        if not brand:
            url = f'{self.json_server}/categories/{category}/subcategories/{subcategory}/brands'
            response = self.client.get(url=url)
            response.is_valid(raise_exception=True)
            brands_json = response.body
            # brands_json = json.loads(brands_json)
            # brands_json = json.dumps(brands_json, indent=4, sort_keys=False, ensure_ascii=False)
            # logger.trace(brands_json)
            print(brands_json)
            brands_with_attributes = [elem for elem in brands_json if elem['attributes'] != []]
            brands_with_model = [elem for elem in brands_with_attributes if elem['attributes'][0]['attributeTitle'] != 'مدل']
            random_brand = random.sample(list(brands_with_model), 1)[0]
            brand = random_brand.get('categoryTitle')
        url = f'{self.json_server}/categories/{category}/subcategories/{subcategory}/brands/{brand}/attributes/مدل خودرو/options'
        response = self.client.get(url=url)
        response.is_valid(raise_exception=True)
        models_json = response.body
        if counter != 'All':
            Length = len(models_json)
            if Length <= int(counter):
                cnt = Length
            else:
                cnt = int(counter)
            models_list = random.sample(list(models_json), cnt)
        else:
            models_list = models_json
        models = []
        for model in models_list:
            models.append(model.get('optionValue'))

        return brand, models


    @keyword(name='Check Cat And SubCat')
    def get_header_breadcrumbs(self, cat_type: str, route: str):
        tag_xpath = '//*[@id="tags"]/span[1]'
        page_url = f'{self.url}{route}'
        response: Response = self.client.get(page_url)
        response.is_valid(raise_exception=False)
        html_page = lxml.html.fromstring(response.content)
        try:
            cat = html_page.xpath('//*[@id="breadcrumbs"]/ul/li[3]/a')[0].text
        except IndexError:
            cat = html_page.xpath('//*[@id="breadcrumbs"]/ul/li[3]/b')[0].text
        cat = cat.strip()
        if cat_type == 'subcat':
            try:
                subcat = html_page.xpath('//*[@id="breadcrumbs"]/ul/li[4]/a')[0].text
            except IndexError:
                subcat = html_page.xpath('//*[@id="breadcrumbs"]/ul/li[4]/b')[0].text
            subcat = subcat.strip()
        else:
            subcat = ''
        tag = html_page.xpath(tag_xpath)[0].text
        tag = tag.replace('\n', '').replace('\r', '').replace('\t', '')
        tag = tag.strip()
        try:
            h1 = html_page.xpath('//*[@id="serp-title"]/h1')[0].text
        except IndexError:
            h3 = html_page.xpath('//*[@id="no-results"]//h3')[0].text
            h3 = h3.strip()
            if h3 == 'متاسفانه نتیجه‌ای پیدا نشد.':
                h1 = h3

        return cat, subcat, h1 , tag
