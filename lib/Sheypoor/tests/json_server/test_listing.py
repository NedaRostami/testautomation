import unittest
from typing import Dict

from libraries import JsonServer


class TestListing(unittest.TestCase):

    def setUp(self) -> None:
        self.json_server = JsonServer('staging')

    def test_random_listing(self):
        listing: Dict = self.json_server.random_live_listing()
        self.assertIsInstance(listing, dict)
        self.assertIn('listingID', listing)
        self.assertIn('title', listing)
        self.assertIn('description', listing)
        self.assertNotIn('error', listing)
        self.assertNotIn('success', listing)

    def test_random_listing_category(self):
        vehicles_category: int = self.json_server.get_category_object(category='وسایل نقلیه', id=True)
        listing: Dict = self.json_server.random_live_listing(category=str(vehicles_category))
        self.assertIsInstance(listing, dict)
        self.assertIn('listingID', listing)
        self.assertIn('title', listing)
        self.assertIn('description', listing)
        self.assertNotIn('error', listing)
        self.assertNotIn('success', listing)

    def test_random_listing_sub_category(self):
        cars_category: int = self.json_server.get_category_object(category='وسایل نقلیه', sub_category='خودرو',
                                                                  id=True)
        listing: Dict = self.json_server.random_live_listing(category=str(cars_category))
        self.assertIsInstance(listing, dict)
        self.assertIn('listingID', listing)
        self.assertIn('title', listing)
        self.assertIn('description', listing)
        self.assertNotIn('error', listing)
        self.assertNotIn('success', listing)

    def test_random_listing_brand(self):
        pride_category: int = self.json_server.get_category_object(category='وسایل نقلیه', sub_category='خودرو',
                                                                   brand='پراید', id=True)
        listing: Dict = self.json_server.random_live_listing(category=str(pride_category))
        self.assertIsInstance(listing, dict)
        self.assertIn('listingID', listing)
        self.assertIn('title', listing)
        self.assertIn('description', listing)
        self.assertNotIn('error', listing)
        self.assertNotIn('success', listing)

    def test_random_listing_location(self):
        tehran_location: int = self.json_server.get_location_object(location='تهران', id=True)
        listing: Dict = self.json_server.random_live_listing(location=str(tehran_location), location_type='province')
        self.assertIsInstance(listing, dict)
        self.assertIn('listingID', listing)
        self.assertIn('title', listing)
        self.assertIn('description', listing)
        self.assertNotIn('error', listing)
        self.assertNotIn('success', listing)

    def test_random_listing_city(self):
        tehran_city_location: int = self.json_server.get_location_object(location='تهران', city='تهران', id=True)
        listing: Dict = self.json_server.random_live_listing(location=str(tehran_city_location), location_type='city')
        self.assertIsInstance(listing, dict)
        self.assertIn('listingID', listing)
        self.assertIn('title', listing)
        self.assertIn('description', listing)
        self.assertNotIn('error', listing)
        self.assertNotIn('success', listing)

    def test_random_listing_province(self):
        seyyed_khandan_location: int = self.json_server.get_location_object(location='تهران', city='تهران',
                                                                            district='سید خندان', id=True)
        listing: Dict = self.json_server.random_live_listing(location=str(seyyed_khandan_location),
                                                             location_type='district')
        self.assertIsInstance(listing, dict)
        self.assertIn('listingID', listing)
        self.assertIn('title', listing)
        self.assertIn('description', listing)
        self.assertNotIn('error', listing)
        self.assertNotIn('success', listing)

    def test_random_listing_filter(self):
        pride_attribute: int = self.json_server.get_category_object(category='وسایل نقلیه', sub_category='خودرو',
                                                                     brand='پراید', attribute='مدل خودرو', id=True)
        pride_111_option: int = self.json_server.get_category_object(category='وسایل نقلیه', sub_category='خودرو',
                                                                     brand='پراید', attribute='مدل خودرو',
                                                                     attribute_option='۱۱۱', id=True)
        listing: Dict = self.json_server.random_live_listing(attribute_id=str(pride_attribute),
                                                             option_id=str(pride_111_option))
        self.assertIsInstance(listing, dict)
        self.assertIn('listingID', listing)
        self.assertIn('title', listing)
        self.assertIn('description', listing)
        self.assertNotIn('error', listing)
        self.assertNotIn('success', listing)
