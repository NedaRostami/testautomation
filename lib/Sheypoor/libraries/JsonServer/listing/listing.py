from typing import Dict, List, Union
import re

from libraries.Images import ImageSet
from exceptions import JsonServerError, ImageError
from ..base import BaseJsonServer


class Listing(BaseJsonServer):

    LISTING_URL: str = 'http://qa2.mielse.com:9500/listings'
    VALID_LOCATION_TYPES: List[str] = ['province', 'city', 'district']
    LOCATION_TYPE_MAPPER: Dict[str, int] = {'province': 0, 'city': 1, 'district': 2}

    def random_live_listing(self, category: str = None, location: str = None, location_type: str = None,
                            attribute_id: str = None, option_id: str = None, image: bool = False) -> Dict[str, str]:

        if location and not location_type:
            raise JsonServerError(f'provide a location type for your location,'
                                  f' it should be one of {", ".join(self.VALID_LOCATION_TYPES)}')
        if location_type and location_type not in self.VALID_LOCATION_TYPES:
            raise JsonServerError(f'location_type should be one of {", ".join(self.VALID_LOCATION_TYPES)}')

        if attribute_id and not option_id:
            raise JsonServerError('Please provide "option_id" when using "attribute_id"')

        if option_id and not attribute_id:
            raise JsonServerError('Please provide "attribute_id" when using "option_id"')

        params = dict()
        if category:
            params['categoryID'] = category
        if location:
            params['locationID'] = location
            params['locationType'] = self.LOCATION_TYPE_MAPPER[location_type]
        if attribute_id:
            attribute_id = 'a' + re.search(r'(\d+)', str(attribute_id)).group(1)
            params[attribute_id] = option_id

        print(params)
        response = self.client.get(url=self.LISTING_URL, params=params)
        listing = response.body
        if image:
            listing['images'] = self.__handle_listing_images(listing)
        listing['price'] = self.__handle_listing_price(listing)
        listing['title'] = listing['title'].replace('\n', ' ').replace('\r', '').replace('\t', ' ').replace('&amp;', '&')
        listing['description'] = listing['description'].replace('\n', ' ').replace('\r', '').replace('\t', ' ').replace('&amp;', '&')

        if listing['categoryID'] == 45234:
            listing['attributes'].append({'attributeID': 68141, 'attributeValue': '12345'})
        return listing

    @staticmethod
    def __handle_listing_images(listing) -> ImageSet:
        try:
            image_list = ImageSet.save_by_url(listing['listingID'], listing['images'])
        except:
            image_list = ImageSet.select_by_category('cars').random_images(3)
        return image_list

    @staticmethod
    def __handle_listing_price(listing) -> Union[int, str]:
        price = listing.get('price', None)
        if isinstance(price, int):
            return price
        return price.replace('\n', '') or None
