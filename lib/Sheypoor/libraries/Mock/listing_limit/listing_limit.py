from typing import Dict

from libraries import JsonServer
from ..base import BaseMock


class ListingLimit(BaseMock):

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.url = f"{self.env.url}/trumpet/mock/listing-limitation"
        self.json_server: JsonServer = JsonServer(env=self.env)

    def get(self, *category: str) -> Dict[str, str]:
        category_id = self.__get_category_id(*category)
        print(category_id)
        response = self.client.get(self.url, params={"categoryId": category_id})
        response.is_valid(validate_success=True, raise_exception=True)
        data = response.body.get('data', {})
        return data

    def set(self, price: int, limit: int, *category: str) -> bool:
        category_id = self.__get_category_id(*category)
        print(category_id)
        response = self.client.post(self.url, data={"price": price, "limit": limit, "categoryId": category_id})
        return response.is_valid(validate_success=True, raise_exception=True)
                
    def __get_category_id(self, *category: str) -> int:
        return self.json_server.get_category_object(*category, id=True)
