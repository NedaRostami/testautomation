from typing import Union,Tuple, Dict, List
import re
import random
import os
from pathlib import Path
from environment import Environment
from request import Session
from exceptions import StaticDataError
from libraries.base import BaseSheypoorLibrary
from request import Response
from libraries.Utils import Utils
import robot.api.logger as logger
from robot.api.deco import keyword
import operator

import lxml.html
import json


class StaticData(BaseSheypoorLibrary):

    platform_list: List[str] = ['web', 'mobile', 'android', 'ios', 'api', 'seo', ]
    __have_static_data = False

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.url = self.env.url
        self.utils = Utils(self.env)
        self.json_server: str = f'http://qa2.mielse.com:9500/static-data/{self.env.trumpet_prenv_id}/v{self.env.general_api_version}'
        self.backup_url: str = f'{self.url}/api/v{self.env.general_api_version}/general/static-data'
        self.client: Session = Session(exception=StaticDataError, retry_count=3, timeout=10)

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

    def clean_all_spaces(self, mystring: str):
        cleaned = ' '.join(mystring.split())


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

    @keyword(name='Get All Locations')
    def get_all_locations(self) -> list:
        results = []
        self.handle_static_data()
        locationsData = self.static_data.get('locationsData', [])
        for province in locationsData:
            locations = {}
            cities = []
            locations['name'] = province.get('name')
            locations['slug'] = province.get('slug')
            city_list = [i for i in province.get('cities', [])]
            for city in city_list:
                elem = {}
                elem['name'] = city.get('name')
                elem['slug'] = city.get('slug')
                cities.append(elem)
            locations['cities'] = cities
            results.append(locations)

        return results

    @keyword(name='Check Slugs')
    def check_slugs(self) -> list:
        locations = self.get_all_locations()
        exceptions = []
        all = []
        cities = []
        custom_provinces = ['تهران', 'اصفهان', 'قم', 'کرمانشاه', 'کرمان', 'همدان', 'یزد', 'اردبیل', 'زنجان', 'قزوین', 'بوشهر', 'ایلام', 'سمنان',]

        for location in locations:
            province = location.get('name')
            all.append(province)
            city_list_of_dic = location.get('cities', [])
            for city_dict in city_list_of_dic:
                city = city_dict.get('name')
                cities.append(city)

        other_provinces = [item for item in all if item not in custom_provinces]

        for province in custom_provinces:
            if not any(d['slug'] == f'استان-{province}' for d in locations):
                exceptions.append(province)

        for province in other_provinces:
            slug = province.replace(" و ", " ")
            slug = slug.replace(" ", "-")
            if not any(d['slug'] == slug for d in locations):
                exceptions.append(province)

        custom_cities = ["اردکان", "طبس", "نیر", "صالح آباد", "حاجی آباد", "سردشت", "بالاده", "خرم آباد", "محمودآباد", "رضوانشهر", "رودبار", "فیروزآباد", "نورآباد", "محمدآباد", "حسن آباد", "خور", "صفی آباد", "دولت آباد", "عشق آباد", "نصرآباد", "گلبهار", "طبس ", "محمدشهر", "گلستان", "میمه", "مهاباد"]
        # mylist = list(dict.fromkeys(custom_cities))
        print(cities)
        other_cities = [item for item in cities if item not in custom_cities]
        print(len(custom_cities))
        print(len(other_cities))
        print(len(cities))

        # for city in custom_cities:
        #     if not any(d['slug'] == f'استان-{province}' for d in locations):
        #         exceptions.append(province)

        for city in other_cities:
            slug = city.get('name').replace(" و ", " ")
            slug = slug.replace("(", "")
            slug = slug.replace(")", "")
            slug = slug.replace(" ", "-")
            if not any(d['slug'] == slug for d in cities):
                exceptions.append(city.get('name'))

        return True
