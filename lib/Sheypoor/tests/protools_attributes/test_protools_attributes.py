import unittest
from typing import Dict

from libraries.ProtoolsAttributes import ProtoolsAttributes


class TestProtoolsAttributes(unittest.TestCase):

    def setUp(self) -> None:
        self.protools_attributes = ProtoolsAttributes(env='staging')

    def test_post_a_listing_data_car(self):
        post_listing_data: Dict = self.protools_attributes.post_data(category='cars')
        self.assertIsInstance(post_listing_data, dict)
        self.assertIn('location', post_listing_data)
        self.assertIn('category', post_listing_data)

    def test_post_a_listing_data_real_estate(self):
        post_listing_data: Dict = self.protools_attributes.post_data(category='real-estate')
        self.assertIsInstance(post_listing_data, dict)
        self.assertIn('location', post_listing_data)
        self.assertIn('category', post_listing_data)

    def test_post_a_listing_data_custom_parameters(self):
        post_listing_data: Dict = self.protools_attributes.post_data(int_attribute=22, str_attribute='tajious')
        self.assertIsInstance(post_listing_data, dict)
        self.assertIn('location', post_listing_data)
        self.assertIn('category', post_listing_data)
        self.assertEqual(post_listing_data.get('int_attribute'), 22)
        self.assertEqual(post_listing_data.get('str_attribute'), 'tajious')
