from typing import Dict, List, Union, Any

from robot.api.deco import keyword

from libraries.base import BaseSheypoorLibrary
from .static_data import Category, Location
from .listing import Listing


class JsonServer(BaseSheypoorLibrary):

    platform_list: List[str] = ['web', 'mobile', 'android', 'ios', 'api', 'seo', ]

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.category = Category(self.env, self.general_api_version)
        self.location = Location(self.env, self.general_api_version)
        self.listing = Listing()


    @keyword('Get Category Object')
    def get_category_object(self, category: str = None, sub_category: str = None,
                            brand: str = None, attribute: str = None, attribute_option: str = None,
                            id: bool = None) -> Union[Dict[str, Any], List[Dict[str, Any]], int]:
        return self.category.get_object(category, sub_category, brand, attribute, attribute_option, id)

    @keyword('Get Location Object')
    def get_location_object(self, location: str = None, city: str = None,
                            district: str = None, id: bool = False) -> Union[Dict[str, Any], List[Dict[str, Any]], int]:
        return self.location.get_object(location, city, district, id)

    @keyword('Random Live Listing')
    def random_live_listing(self, category: str = None, location: str = None, location_type: str = None,
                            attribute_id: str = None, option_id: str = None, image: bool = True) -> Dict[str, str]:
        if category is not None:
            if category.isdigit():
                category = int(category)
                category_id = category
            else:
                category_id = self.get_category_object(category, id=True)
        else:
            category_id = None
        return self.listing.random_live_listing(category_id, location, location_type, attribute_id, option_id, image)

    @keyword(name='Get Cat Parent Name')
    def get_cat_parent_name(self, categoryID: int) -> str:
        category_list = {}
        return self.category.return_cat_parent_name(categoryID, category_list)

    @keyword(name='Get Brand Parent Cat')
    def get_brand_parent_cat(self, categoryID: int) -> str:
        category_list = {}
        return self.category.return_brand_parent_cat(categoryID, category_list)

    @keyword(name='Get Cat Name')
    def get_cat_name(self, categoryID: int) -> str:
        category_list = {}
        return self.category.return_cat_name(categoryID, category_list)
