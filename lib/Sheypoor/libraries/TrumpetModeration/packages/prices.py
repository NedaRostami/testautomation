from typing import Union, List, Tuple, Dict, Any
from exceptions import TrumpetModerationError
from libraries.TrumpetModeration.base import BaseTrumpetModeration
from request import Response

import copy
class Prices(BaseTrumpetModeration):

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.all_iran_url = f'{self.env.url}/trumpet/settings/all-iran-price/new'
        self.all_state_url = f'{self.env.url}/trumpet/settings/all-state-price/new'
        self.bump_price_url = f'{self.env.url}/trumpet/bump-price/new'
        self.tag_price_url = f'{self.env.url}/trumpet/settings/tag-price/new'


    def set_all_iran(self, catid: int, regionId: int, price: int):
        data = {'ID': '', 'CategoryId': catid, 'RegionId': regionId, 'Price': price}
        return self.__set(data, self.all_iran_url)


    def set_all_state(self, catid: int, regionId: int, price: int):
        data = {'ID': '', 'CategoryId': catid, 'RegionId': regionId, 'Price': price}
        return self.__set(data, self.all_state_url)

    def set_bump(self, catid: int, regionId: int, price: int, bumpid: str, AllIranAdditionPrice: Union[str, int], AllStateAdditionPrice: Union[str, int], SecurePurchaseAllIranAdditionPrice: Union[str, int], SecurePurchaseAllStateAdditionPrice: Union[str, int]):
        data = {'ID': '', 'CategoryId': catid, 'RegionId': regionId, 'Price': price, 'BumpId': bumpid, 'AllIranAdditionPrice': AllIranAdditionPrice, 'AllStateAdditionPrice': AllStateAdditionPrice, 'SecurePurchaseAllIranAdditionPrice': SecurePurchaseAllIranAdditionPrice, 'SecurePurchaseAllStateAdditionPrice': SecurePurchaseAllStateAdditionPrice}
        return self.__set(data, self.bump_price_url)

    def set_tag(self, catid: int, regionId: str, price: int, tagid: int):
        data = {'ID': '', 'CategoryId': catid, 'TagId': tagid, 'Price': price, 'RegionId': regionId}
        return self.__set(data, self.tag_price_url)

    def fetch_bump_price_list(self, bump_type: str, regionID: str, category: str):
        bump_price_list = self.__fetch_data(bump_type, regionID, category)
        if not bump_price_list:
            regionID = 'null'
            bump_price_list = self.__fetch_data(bump_type, regionID, category)
        bump_price = bump_price_list[0].get('PriceFormatted')
        return bump_price

    def __fetch_data(self, bump_type: str, regionID: str, category: str) -> list:
        url = f'{self.env.url}/trumpet/bump-price/fetch?bump_type={bump_type}&region={regionID}&category={category}'
        response = self.client.get(url)
        response.is_valid(raise_exception=True)
        list = response.body.get('data', {}).get('bumpPrice')
        return list

    def __set(self, data: dict, url: str) -> bool:
        try:
            res: Response = self.client.post(url, data=data)
            res.is_valid(raise_exception=True)
        except:
            raise
        return res.body
