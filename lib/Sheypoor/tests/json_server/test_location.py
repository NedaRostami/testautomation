import unittest
from typing import Dict

from libraries import JsonServer


class TestLocation(unittest.TestCase):

    TEHRAN = 'تهران'
    ERAM = 'ارم'

    def setUp(self) -> None:
        self.json_server = JsonServer('staging')

    def test_location_total(self):
        location_object: Dict = self.json_server.get_location_object()
        self.assertIsInstance(location_object, dict)
        self.assertIn('locationsData', location_object)
        self.assertNotIn('error', location_object)
        self.assertNotIn('success', location_object)

    def test_location_tier_one(self):
        location_object: Dict = self.json_server.get_location_object(location=self.TEHRAN)
        self.assertIsInstance(location_object, dict)
        self.assertIn('provinceID', location_object)
        self.assertNotIn('error', location_object)
        self.assertNotIn('success', location_object)

    def test_location_tier_two(self):
        location_object: Dict = self.json_server.get_location_object(location=self.TEHRAN, city=self.TEHRAN)
        self.assertIsInstance(location_object, dict)
        self.assertIn('cityID', location_object)
        self.assertNotIn('error', location_object)
        self.assertNotIn('success', location_object)

    def test_location_tier_three(self):
        location_object: Dict = self.json_server.get_location_object(location=self.TEHRAN, city=self.TEHRAN,
                                                                     district=self.ERAM)
        self.assertIsInstance(location_object, dict)
        self.assertIn('districtID', location_object)
        self.assertNotIn('error', location_object)
        self.assertNotIn('success', location_object)
