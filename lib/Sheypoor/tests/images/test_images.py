import unittest

from libraries.Images import Images
from libraries.Images.models import ImageSet, Image
from libraries.JsonServer import JsonServer


class TestImages(unittest.TestCase):

    def setUp(self) -> None:
        self.images = Images(env='staging')
        self.json_server = JsonServer(env='staging')

    def test_select_images_no_listing_id(self):
        image_list: ImageSet = self.images.select_images(category='cars', count=5)
        self.assertIsInstance(image_list, ImageSet)
        self.assertEqual(len(image_list), 5)
        for i in image_list:
            self.assertIsInstance(i, Image)
            self.assertEqual(i.category, 'cars')
            self.assertTrue(i.file_path)

    def test_select_images_listing_id(self):
        listing = self.json_server.random_live_listing(category='43626')
        image_list = self.images.select_images(category='cars', count=3, listing_id=listing['listingID'])
        self.assertIsInstance(image_list, ImageSet)
        self.assertEqual(len(image_list), 3)
        for i in image_list:
            self.assertIsInstance(i, Image)
            self.assertTrue(i.file_path)

    def test_select_images_higher_than_listing_images(self):
        listing = self.json_server.random_live_listing(category='43626')
        image_list = self.images.select_images(category='cars', count=9, listing_id=listing['listingID'])
        self.assertIsInstance(image_list, ImageSet)
        self.assertEqual(len(image_list), 9)
        for i in image_list:
            self.assertIsInstance(i, Image)
            self.assertTrue(i.file_path)

    def test_select_images_lower_than_listing_images(self):
        listing = self.json_server.random_live_listing(category='43626')
        image_list = self.images.select_images(category='cars', count=1, listing_id=listing['listingID'])
        self.assertIsInstance(image_list, ImageSet)
        self.assertEqual(len(image_list), 1)
        for i in image_list:
            self.assertIsInstance(i, Image)
            self.assertTrue(i.file_path)

    def test_fetch_listing_images(self):
        listing = self.json_server.random_live_listing(category='43626')
        image_list = self.images.get_listing_images(listing_id=listing['listingID'])
        self.assertIsInstance(image_list, ImageSet)
        self.assertEqual(len(image_list), len(listing['images']))
        for i in image_list:
            self.assertIsInstance(i, Image)
            self.assertTrue(i.file_path)
