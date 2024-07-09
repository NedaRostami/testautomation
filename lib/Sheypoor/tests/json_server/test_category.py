import unittest
from typing import Dict

from libraries import JsonServer


class TestCategory(unittest.TestCase):

    CATEGORY_COUNT = 10
    VEHICLES = 'وسایل نقلیه'
    REAL_ESTATE = 'املاک'
    JOBS = 'استخدام'
    SERVICES = 'خدمات و کسب و کار'
    CARS = 'خودرو'
    PRIDE = 'پراید'
    PEUGEOT = 'پژو'
    CAR_MODEL = 'مدل خودرو'
    BIKES = 'موتور سیکلت'
    ENGINE_DISPLACEMENT = 'حجم موتور'
    ELECTRIC = 'الکتریکی'
    CHASSIS = 'نوع شاسی'
    REPAIRS = 'تعمیرات'
    CONTRACT_TYPE = 'نوع قرارداد'
    REMOTE = 'دورکاری'
    MINIMUM_SQ_METER = 'حداقل متراژ'
    ROOM_COUNT = 'تعداد اتاق'
    PRICE = 'قیمت (تومان)'
    ERROR_LENGTH = 'length is not {}'
    ERROR_RESPONSE = 'found error in response'

    def setUp(self) -> None:
        self.json_server = JsonServer(env='staging')

    def test_category_total(self):
        category_list: Dict = self.json_server.get_category_object()
        self.assertIsInstance(category_list, dict)
        self.assertIn('categoriesData', category_list)

    def test_category_object_tier_one(self):
        category_object: Dict = self.json_server.get_category_object(category=self.VEHICLES)
        self.assertIsInstance(category_object, dict)
        self.assertNotIn('error', category_object, self.ERROR_RESPONSE)
        self.assertNotIn('success', category_object, self.ERROR_RESPONSE)

    def test_category_object_tier_one_attribute(self):
        attribute_object: Dict = self.json_server.get_category_object(category=self.REAL_ESTATE,
                                                                      attribute=self.MINIMUM_SQ_METER)
        self.assertIsInstance(attribute_object, dict)
        self.assertNotIn('error', attribute_object, self.ERROR_RESPONSE)
        self.assertNotIn('success', attribute_object, self.ERROR_RESPONSE)

    def test_category_object_tier_one_attribute_option(self):
        option_object: Dict = self.json_server.get_category_object(category=self.JOBS, attribute=self.CONTRACT_TYPE,
                                                                   attribute_option=self.REMOTE)
        self.assertIsInstance(option_object, dict)
        self.assertNotIn('error', option_object, self.ERROR_RESPONSE)
        self.assertNotIn('success', option_object, self.ERROR_RESPONSE)

    def test_category_object_tier_two(self):
        category_object: Dict = self.json_server.get_category_object(category=self.SERVICES, sub_category=self.REPAIRS)
        self.assertIsInstance(category_object, dict)
        self.assertNotIn('error', category_object, self.ERROR_RESPONSE)
        self.assertNotIn('success', category_object, self.ERROR_RESPONSE)

    def test_category_tier_two_attribute(self):
        attribute_object: Dict = self.json_server.get_category_object(category=self.VEHICLES, sub_category=self.CARS,
                                                                      attribute=self.CHASSIS)
        self.assertIsInstance(attribute_object, dict)
        self.assertNotIn('error', attribute_object, self.ERROR_RESPONSE)
        self.assertNotIn('success', attribute_object, self.ERROR_RESPONSE)

    def test_category_tier_two_attribute_option(self):
        option_object: Dict = self.json_server.get_category_object(category=self.VEHICLES, sub_category=self.BIKES,
                                                                   attribute=self.ENGINE_DISPLACEMENT,
                                                                   attribute_option=self.ELECTRIC)
        self.assertIsInstance(option_object, dict)
        self.assertNotIn('error', option_object, self.ERROR_RESPONSE)
        self.assertNotIn('success', option_object, self.ERROR_RESPONSE)

    def test_category_tier_three(self):
        category_object: Dict = self.json_server.get_category_object(category=self.VEHICLES, sub_category=self.CARS,
                                                                     brand=self.PRIDE)
        self.assertIsInstance(category_object, dict)
        self.assertNotIn('error', category_object, self.ERROR_RESPONSE)
        self.assertNotIn('success', category_object, self.ERROR_RESPONSE)

    def test_category_tier_three_attribute(self):
        attribute_object: Dict = self.json_server.get_category_object(category=self.VEHICLES, sub_category=self.CARS,
                                                                      brand=self.PEUGEOT, attribute=self.CAR_MODEL)
        self.assertIsInstance(attribute_object, dict)
        self.assertNotIn('error', attribute_object, self.ERROR_RESPONSE)
        self.assertNotIn('success', attribute_object, self.ERROR_RESPONSE)

    def test_category_tier_three_attribute_option(self):
        option_object: Dict = self.json_server.get_category_object(category=self.VEHICLES, sub_category=self.CARS,
                                                                   brand=self.PRIDE, attribute=self.CAR_MODEL,
                                                                   attribute_option='۱۱۱')
        self.assertIsInstance(option_object, dict)
        self.assertNotIn('error', option_object, self.ERROR_RESPONSE)
        self.assertNotIn('success', option_object, self.ERROR_RESPONSE)

    def test_category_id(self):
        category_object = self.json_server.get_category_object(category=self.VEHICLES)
        category_id = self.json_server.get_category_object(category=self.VEHICLES, id=True)
        expected_category_id = category_object.get('categoryID')
        self.assertIsInstance(category_id, int, 'category id is not of type int')
        self.assertEqual(category_id, expected_category_id, f'category id should be {expected_category_id} but is {category_id}')

    def test_attribute_id(self):
        attribute_object = self.json_server.get_category_object(category=self.VEHICLES, attribute=self.PRICE)
        attribute_id = self.json_server.get_category_object(category=self.VEHICLES, attribute=self.PRICE, id=True)
        expected_attribute_id = attribute_object.get('attributeID')
        self.assertIsInstance(attribute_id, int, 'attribute id is not of type int')
        self.assertEqual(attribute_id, expected_attribute_id, f'attribute id should be {expected_attribute_id} but is {attribute_id}')

    def test_option_id(self):
        option_object = self.json_server.get_category_object(category=self.REAL_ESTATE, attribute=self.ROOM_COUNT,
                                                             attribute_option='۱')
        option_id = self.json_server.get_category_object(category=self.REAL_ESTATE, attribute=self.ROOM_COUNT,
                                                         attribute_option='۱', id=True)
        expected_option_id = option_object.get('optionID')
        self.assertIsInstance(option_id, int, 'option id is not of type int')
        self.assertEqual(option_id, expected_option_id, f'option id should be {expected_option_id} but is {option_id}')
