from typing import Dict, Union

from .static_data import StaticData
from exceptions import JsonServerError


class Category(StaticData):

    def get_object(self, category: str = None, sub_category: str = None,
                   brand: str = None, attribute: str = None, attribute_option: str = None,
                   id: bool = None) -> Union[Dict[str, str], str]:

        url = self.url

        if sub_category and not category:
            raise JsonServerError('Please provide a category for sub category')
        if brand and not sub_category:
            raise JsonServerError('Please provide a subcategory for brand')
        if attribute_option and not attribute:
            raise JsonServerError('Please provide an attribute for attribute option')
        if category:
            url += self._add_to_url('categories', category)
        if sub_category:
            url += self._add_to_url('subcategories', sub_category)
        if brand:
            url += self._add_to_url('brands', brand)
        if attribute:
            url += self._add_to_url('attributes', attribute)
        if attribute_option:
            url += self._add_to_url('options', attribute_option)

        response = self.client.get(url=url)
        category = response.body
        if id:
            return self._get_id(category)
        return category

    def return_cat_parent_name(self, categoryID: Union[str, int], category_list: dict = {}) -> str:
        categoryID = int(categoryID)
        if not category_list:
            response = self.client.get(f'{self.env.url}/api/v{self.env.general_api_version}/general/categories')
            response.is_valid(raise_exception=True)
            category_list = response.body
        for element in category_list:
            if element['categoryID'] == categoryID:
                return element['categoryTitle']
            else:
                if element['children']:
                    check_child = self.return_cat_parent_name(categoryID, element['children'])
                    if check_child:
                        return element['categoryTitle']
                    # elif element['children'] != []:
                    #     for child_element in element['children']:
                    #         if 'brands' in child_element:
                    #             brand = self.return_cat_parent_name(categoryID, child_element['brands'].get('items'))
                    #             if brand:
                    #                 return element['categoryTitle']

    def return_brand_parent_cat(self, categoryID: Union[str, int], category_list: dict = {}) -> str:
        categoryID = int(categoryID)
        if not category_list:
            response = self.client.get(f'{self.env.url}/api/v{self.env.general_api_version}/general/categories')
            response.is_valid(raise_exception=True)
            category_list = response.body
        for element in category_list:
            if element['categoryID'] == categoryID:
                return element['categoryTitle']
            else:
                if element['children'] != []:
                    for element in element['children']:
                        if 'brands' in element:
                            brand = self.return_cat_parent_name(categoryID, element['brands'].get('items'))
                            if brand:
                                # return brand, element['categoryID'], element['categoryTitle']
                                return element['categoryTitle']

    def return_cat_name(self, categoryID: Union[str, int], category_list: dict = {}) -> str:
        categoryID = int(categoryID)
        if not category_list:
            response = self.client.get(f'{self.env.url}/api/v{self.env.general_api_version}/general/categories')
            response.is_valid(raise_exception=True)
            category_list = response.body
        for element in category_list:
            if element['categoryID'] == categoryID:
                return element['categoryTitle']
            else:
                if element['children']:
                    cat_name = self.return_cat_name(categoryID, element['children'])
                    if cat_name:
                        return cat_name
