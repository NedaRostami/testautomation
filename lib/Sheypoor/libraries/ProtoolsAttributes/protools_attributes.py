import random
from lib.request import Request
from typing import List

from robot.api.deco import keyword

from exceptions import ProtoolsAttributeError
from libraries.base import BaseSheypoorLibrary


class ProtoolsAttributes(BaseSheypoorLibrary):

    platform_list: List[str] = ['web', 'mobile', 'android', 'ios', 'api', ]

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.config = None
        self.category = None
        self.form = None
        self.attributes = None
        self.client = Request(retry_count=3)

    @keyword(name='Get Post A Listing Data')
    def post_data(self, category='real-estate', **kwargs):
        results = {}
        self.__shuffle(category)
        for attribute in self.attributes:
            results.update(self.__create_attribute(attribute))
        results['category'] = self.__category_id()
        if 'price' in results:
            results['price'] = results.get('price', None) * 1000000
        for k, v in kwargs.items():
            results[k] = v
        return results

    @keyword('Normalize Phone Number')
    def normalize_phone_number(self, phone_number):
        return ''.join(reversed(phone_number.split()))

    def __shuffle(self, category):
        self.__get_config(category)
        self.__get_location()
        self.__get_category()
        self.__get_form()
        self.attributes = self.__get_attributes()

    def __get_config(self, category):
        response = self.client.get(f'{self.env.url}/api/protools/v1/config?ut={category}')
        if not response.ok:
            raise ProtoolsAttributeError(f"config endpoint status is: {response.status_code},"
                                         f" and body is: {response.text}")
        self.config = response.json()
        return self.config

    def __get_location(self, *args):
        location_list = self.config.get('regions', None)
        assert location_list is not None
        if location_list is None:
            raise ProtoolsAttributeError("Location list should not be None")
        location = self.__get_random_from_list(location_list)
        location = self.__get_sub_regions(location)
        return location['slug']

    def __get_category(self):
        category = self.config.get('categories', None)
        assert category is not None
        if category is None:
            raise ProtoolsAttributeError("category should not be None")
        category = [i for i in category if not (i['slug'] == '45000')]
        category = random.choice(category)
        self.category = category
        return category

    def __get_sub_regions(self, location):
        if isinstance(location, dict):
            sub_regions = location.get('subregions', None)
        else:
            return self.__get_random_from_list(location)
        if sub_regions:
            return self.__get_sub_regions(sub_regions)
        return sub_regions

    @staticmethod
    def __get_random_from_list(locations):
        return random.choice(locations)

    def __get_form(self):
        response = self.client.get(f'{self.env.url}/api/protools/v1/listings/form/{self.category.get("slug")}')
        assert response.status_code == 200
        if not response.ok:
            raise ProtoolsAttributeError(f"form response status is: {response.status_code}, "
                                         "body is: {response.text}")
        self.form = response.json()
        return self.form

    def __get_attributes(self):
        attributes = list()
        groups = self.form.get('groups', None)
        if groups is None:
            raise ProtoolsAttributeError("groups should not be None")
        for g in groups:
            components = self.__get_components(g)
            attributes += components
        return attributes

    @staticmethod
    def __get_components(group):
        component = group.get('components', None)
        if component is None:
            raise ProtoolsAttributeError("component should not be None")
        return component

    @staticmethod
    def __single_select_attribute(attribute):
        values = attribute.get('values', None)
        if values is None:
            raise ProtoolsAttributeError("values should not be None")
        return random.choice(values)['slug']

    @staticmethod
    def __multi_select_attribute(attribute):
        values = attribute.get('values', None)
        if values is None:
            raise ProtoolsAttributeError("values should not be None")
        values_count = len(values)
        values_indexes = random.choice(range(1, len(values)))
        samples = random.sample(range(0, values_count), values_indexes)
        values_list = [values[i]['slug'] for i in samples]
        return values_list

    @staticmethod
    def __boolean_attribute(*args):
        return random.choice([True, False])

    @staticmethod
    def __number_attribute(*args):
        return random.randint(10, 1000)

    @staticmethod
    def __text_attribute(*args):
        return f'0900{random.randint(1000000, 9999999)}'

    def __type_mapper(self):
        type_maps = {
            'location': self.__get_location,
            'single-select': self.__single_select_attribute,
            'number': self.__number_attribute,
            'multi-select': self.__multi_select_attribute,
            'boolean': self.__boolean_attribute,
            'text': self.__text_attribute,
        }
        return type_maps

    def __create_attribute(self, attribute):
        results = {}
        type_mapper = self.__type_mapper()
        attribute_name = attribute['name']
        attribute_type = attribute['type']
        results[attribute_name] = type_mapper[attribute_type](attribute)
        return results

    def __category_id(self):
        return self.category['slug']
