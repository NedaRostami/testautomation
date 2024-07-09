from typing import Tuple, Dict

from exceptions import TrumpetModerationError
from libraries.TrumpetModeration.base import BaseTrumpetModeration
from request import Response

import copy
class Limit(BaseTrumpetModeration):

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.url = f'{self.env.url}/trumpet/listing-limitation/save'
        self.get_url = f'{self.env.url}/trumpet/listing-limitation/get'
        self.del_url = f'{self.env.url}/trumpet/listing-limitation/delete'

    def set(self, parentid: int, catid: int, regid: int, CityId: int, nghid: int, limitcount: int, limitprice: int):
        allIran_all = {'CategoryId': '', 'RegionId': '', 'CityId': '', 'NeighborhoodId': '', 'LimitationCount': limitcount, 'LimitationPrice': limitprice}
        allIran_parent = {'CategoryId': parentid, 'RegionId': '', 'CityId': '', 'NeighborhoodId': '', 'LimitationCount': limitcount, 'LimitationPrice': limitprice}
        allIran_cat = {'CategoryId': catid, 'RegionId': '', 'CityId': '', 'NeighborhoodId': '', 'LimitationCount': limitcount, 'LimitationPrice': limitprice}
        region_all = {'CategoryId': '', 'RegionId': regid, 'CityId': '', 'NeighborhoodId': '', 'LimitationCount': limitcount, 'LimitationPrice': limitprice}
        region_parent = {'CategoryId': parentid, 'RegionId': regid, 'CityId': '', 'NeighborhoodId': '', 'LimitationCount': limitcount, 'LimitationPrice': limitprice}
        region_cat = {'CategoryId': catid, 'RegionId': regid, 'CityId': '', 'NeighborhoodId': '', 'LimitationCount': limitcount, 'LimitationPrice': limitprice}

        city_all = {'CategoryId': '', 'RegionId': regid, 'CityId': CityId, 'NeighborhoodId': '', 'LimitationCount': limitcount, 'LimitationPrice': limitprice}
        city_parent = {'CategoryId': parentid, 'RegionId': regid, 'CityId': CityId, 'NeighborhoodId': '', 'LimitationCount': limitcount, 'LimitationPrice': limitprice}
        city_cat = {'CategoryId': catid, 'RegionId': regid, 'CityId': CityId, 'NeighborhoodId': '', 'LimitationCount': limitcount, 'LimitationPrice': limitprice}
        neighborhood_all = {'CategoryId': '', 'RegionId': regid, 'CityId': CityId, 'NeighborhoodId': nghid, 'LimitationCount': limitcount, 'LimitationPrice': limitprice}
        neighborhood_parent = {'CategoryId': parentid, 'RegionId': regid, 'CityId': CityId, 'NeighborhoodId': nghid, 'LimitationCount': limitcount, 'LimitationPrice': limitprice}
        neighborhood_cat = {'CategoryId': catid, 'RegionId': regid, 'CityId': CityId, 'NeighborhoodId': nghid, 'LimitationCount': limitcount, 'LimitationPrice': limitprice}

        self.__delete_limit(allIran_all)
        self.__delete_limit(allIran_parent)
        self.__delete_limit(allIran_cat)
        self.__delete_limit(region_all)
        self.__delete_limit(region_parent)
        self.__delete_limit(region_cat)
        self.__delete_limit(city_all)
        self.__delete_limit(city_parent)
        self.__delete_limit(city_cat)
        self.__delete_limit(neighborhood_all)
        self.__delete_limit(neighborhood_parent)
        self.__set_limit(neighborhood_cat)

    def get_limits(self, catid: int, regid: int, CityId: int, nghid: int):
        params = {'CategoryId': catid, 'RegionId': regid, 'CityId': CityId, 'NeighborhoodId': nghid}
        limits: Response = self.client.get(self.get_url, params=params)
        limits.is_valid(validate_success=True, raise_exception=True)
        return limits.body.get('data', {})

    def get_limits_deep(self, cat_id: int, region_id: int, subCat_id: int, city_id: int):
        if not subCat_id:
            subCat_id = cat_id
        limit = self.get_limits(subCat_id, region_id, city_id, None)
        limit_count = limit['LimitationCount']
        if limit_count == -1:
            limit = self.get_limits(subCat_id, region_id, None, None)
            limit_count = limit['LimitationCount']
            if limit_count == -1:
                limit = self.get_limits(subCat_id, None, None, None)
                limit_count = limit['LimitationCount']
                if limit_count == -1:
                    limit = self.get_limits(cat_id, None, None, None)
                    limit_count = None if limit['LimitationCount'] == -1 else limit['LimitationCount']
        return limit_count


    def __set_limit(self, data: dict) -> bool:
        # delete limit first
        # self.__delete_limit(data)
        limits: Response = self.__get_limit(data)
        #set limit
        try:
            ID = int(limits.body.get('data', {}).get('ID'))
            if ID > 0:
                data['ID'] = ID
            else:
                data['ID'] = ''
            res: Response = self.client.post(self.url, data=data)
            res.is_valid(raise_exception=True)
        except:
            print(data)
            raise

        # get limits
        limits: Response = self.__get_limit(data)

        #validation: set is done?
        try:
            res_LimitationCount = limits.body.get('data', {}).get('LimitationCount')
            res_LimitationPrice = limits.body.get('data', {}).get('LimitationPrice')
            assert int(res_LimitationCount) == data["LimitationCount"], f'{res_LimitationCount} should be {data["LimitationCount"]}'
            assert int(res_LimitationPrice) == data["LimitationPrice"], f'{res_LimitationPrice} should be {data["LimitationPrice"]}'
        except AssertionError:
            print('set limit error with data:')
            print(data)
            raise


    def __delete_limit(self, data: dict) -> bool:
        limits: Response = self.__get_limit(data)
        ID = int(limits.body.get('data', {}).get('ID'))
        if ID > 0:
            delete = self.client.delete(f'{self.del_url}/{ID}')
            delete.is_valid(raise_exception=True)


    def __get_limit(self, data: dict) -> bool:
        # params for get request
        params: Response = self.__set_params(data)
        limits: Response = self.client.get(self.get_url, params=params)
        limits.is_valid(validate_success=True, raise_exception=True)
        return limits

    def __set_params(self, data: dict) -> bool:
        # params for get request
        params = copy.deepcopy(data)
        del params["LimitationCount"]
        del params["LimitationPrice"]
        # params['CityId'] = params.pop('CityId')
        return params
