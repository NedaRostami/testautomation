from typing import Dict, Any

from faker import Faker
from robot.api.logger import trace

from exceptions import TrumpetModerationError
from libraries.TrumpetModeration.base import BaseTrumpetModeration
from libraries.Utils import Utils

import re


class Shop(BaseTrumpetModeration):
    faker = Faker('fa-IR')

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.utils = Utils(self.env)

    def create(self, consultant_count: int, secretary_count: int, phone_number_count: int,
               city_id: str, neighborhood_id: str, category_id: str, latitude: str,
               longitude: str, securepurchase: int, shipping_type: str, city_shipping_cost: str,
               state_shipping_cost: str, country_shipping_cost: str, status: str, auto_listing_approve: str, price_offer: int) -> Dict[str, Any]:
        self.__validate_consultant_count(consultant_count)
        self.__validate_secretary_count(secretary_count)
        self.__validate_phone_number_count(phone_number_count)
        self.__validate_city_id(city_id)
        self.__validate_neighborhood_id(neighborhood_id)
        self.__validate_category_id(category_id)
        self.__validate_status(status)
        self.__validate_auto_listing_approve(auto_listing_approve)
        self.__validate_secure_purchase(securepurchase)
        self.__validate_shipping_type(shipping_type)
        self.__validate_city_shipping_cost(city_shipping_cost)
        self.__validate_state_shipping_cost(state_shipping_cost)
        self.__validate_country_shipping_cost(country_shipping_cost)
        self.__validate_price_offer(price_offer)
        data = self.__create_data(consultant_count, secretary_count, phone_number_count, city_id,
                                  neighborhood_id, category_id, latitude, longitude, securepurchase, shipping_type,
                                  city_shipping_cost, state_shipping_cost, country_shipping_cost, status, auto_listing_approve, price_offer)
        response = self.client.post(f'{self.env.url}/trumpet/shop/profile/create', data=data)
        response.is_valid(raise_exception=True)
        # trace(response.body, html=True)
        check = self.client.get(f"{self.env.url}/{data['Slug']}")
        check.is_valid(raise_exception=True)
        results = self.__create_results(data, consultant_count)
        ID = self.__getid(data['Slug'])
        results.update({'ID': ID})

        if securepurchase == 1 or securepurchase == 2:
            results.update({'commission': data['Commission']})
            results.update({'sheba': data['Sheba']})

        return results

    def add_secure_purchase(self, secure_purchase: int, sheba: str, shop_id: str):

        data = {'SecurePurchase': secure_purchase, 'Sheba': sheba}
        self.edit_shop_data = {**self.edit_shop_data, **data}
        edit_data = {**self.shop_data, **self.edit_shop_data}
        response = self.client.post(f'{self.env.url}/trumpet/shop/profile/save/' + shop_id, data=edit_data)
        response.is_valid(raise_exception=True)

    def __getid(self, Slug: str) -> str:
        response = self.client.post(f'{self.env.url}/trumpet/shop/profile/search', data={'slug': Slug})
        response.is_valid(raise_exception=True)
        return response.body.get('data', {}).get('shopProfile')[0].get('ID')

    def __create_data(self, consultant_count: int, secretary_count: int, phone_number_count: int,
                      city_id: str, neighborhood_id: str, category_id: str, latitude: str,
                      longitude: str, securepurchase: int, shipping_type: str, city_shipping_cost: str, state_shipping_cost: str, country_shipping_cost: str, status: str, auto_listing_approve: str, price_offer: int) -> Dict[str, Any]:
        consultant_roles = self.__create_consultant_roles(consultant_count, secretary_count)
        commission = 7
        sheba = self.utils.random_sheba_number(prefix='IR')
        data = {
            'Title': self.faker.company(),
            'Slug': self.utils.generate_string(),
            'OwnerPhone': self.utils.random_phone_number(),
            'ConsultantRoles[]': consultant_roles,
            'ConsultantPhones[]': [self.utils.random_phone_number() for _ in range(len(consultant_roles))],
            'ConsultantNames[]': [self.faker.name() for _ in range(len(consultant_roles))],
            'Address': self.faker.address(),
            'Email': self.faker.email(),
            'Website': f'www.{self.utils.generate_string()}.com',
            'PrimaryPhone': self.utils.random_phone_number(),
            'ShopPhonesMultiple[]': [self.utils.random_phone_number() for _ in range(phone_number_count)],
            'CityId': city_id,
            'NeighbourhoodId': neighborhood_id,
            'CategoryId': category_id,
            'WorkingTime': self.utils.generate_string(size=20),
            'Description': self.faker.sentence(nb_words=6),
            'TagLine': self.faker.sentence(nb_words=3),
            'Latitude': latitude,
            'Longitude': longitude,
            'SecurePurchase': securepurchase,
            'ShippingType': shipping_type,
            'CityShippingCost': city_shipping_cost,
            'StateShippingCost': state_shipping_cost,
            'CountryShippingCost': country_shipping_cost,
            'Status': status,
            'AutoListingApprove': auto_listing_approve,
            'PriceOffer': price_offer,
        }
        if securepurchase == 1 or securepurchase == 2:
            data.update({'Commission': commission})
            data.update({'Sheba': sheba})

        return data

    @staticmethod
    def __create_results(data: Dict[str, Any], consultant_count: int) -> Dict[str, Any]:
        consultant_list = [{
            'name': data['ConsultantNames[]'][i],
            'phone': data['ConsultantPhones[]'][i],
        } for i, _ in enumerate(data['ConsultantRoles[]'][:consultant_count])]
        secretary_list = [{
            'name': data['ConsultantNames[]'][i + consultant_count],
            'phone': data['ConsultantPhones[]'][i + consultant_count],
        } for i, _ in enumerate(data['ConsultantRoles[]'][consultant_count:])]
        return {
            'title': data['Title'],
            'slug': data['Slug'],
            'owner_phone': data['OwnerPhone'],
            'address': data['Address'],
            'email': data['Email'],
            'website': data['Website'],
            'consultant_list': consultant_list,
            'secretary_list': secretary_list,
            'primary_phone': data['PrimaryPhone'],
            'shop_phones': data['ShopPhonesMultiple[]'],
            'city': data['CityId'],
            'neighborhood': data['NeighbourhoodId'],
            'category': data['CategoryId'],
            'working_time': data['WorkingTime'],
            'description': data['Description'],
            'tag_line': data['TagLine'],
            'Lat': data['Latitude'],
            'Long': data['Longitude'],
            'securepurchase': data['SecurePurchase'],
            'shipping_type': data['ShippingType'],
            'city_shipping_cost': data['CityShippingCost'],
            'state_shipping_cost': data['StateShippingCost'],
            'country_shipping_cost': data['CountryShippingCost'],
            'auto_listing_approve': data['AutoListingApprove'],
            'status': data['Status'],
            'price_offer': data['PriceOffer']
        }

    @staticmethod
    def __create_consultant_roles(consultant_count: int, secretary_count: int):
        return [0 for _ in range(consultant_count)] + [1 for _ in range(secretary_count)]

    @staticmethod
    def __validate_consultant_count(consultant_count: int) -> int:
        if int(consultant_count) < 0:
            raise TrumpetModerationError('consultant count cannot be lower than zero')
        return consultant_count

    @staticmethod
    def __validate_secretary_count(secretary_count: int) -> int:
        if int(secretary_count) < 0:
            raise TrumpetModerationError('secretary_count cannot be lower than zero')
        return secretary_count

    @staticmethod
    def __validate_phone_number_count(phone_number_count: int) -> int:
        if int(phone_number_count) < 0:
            raise TrumpetModerationError('phone_number_count cannot be lower than zero')
        return phone_number_count

    @staticmethod
    def __validate_city_id(city_id: str) -> str:
        if not city_id.isdigit():
            raise TrumpetModerationError('city_id should only contain digits')
        return city_id

    @staticmethod
    def __validate_neighborhood_id(neighborhood_id: str) -> str:
        if not neighborhood_id.isdigit():
            raise TrumpetModerationError('neighborhood_id should only contain digits')
        return neighborhood_id

    @staticmethod
    def __validate_category_id(category_id: str) -> str:
        if not category_id.isdigit():
            raise TrumpetModerationError('category_id should only contain digits')
        return category_id

    @staticmethod
    def __validate_auto_listing_approve(auto_listing_approve: str) -> str:
        if auto_listing_approve not in ('0', '1'):
            raise TrumpetModerationError('auto_listing_approve should be either 0 for deactivated, or 1 for activated')
        return auto_listing_approve

    @staticmethod
    def __validate_status(status: str) -> str:
        if status not in ('0', '1'):
            raise TrumpetModerationError('status should be either 0 for deactivated, or 1 for activated')
        return status

    @staticmethod
    def __validate_secure_purchase(secure_purchase: int) -> int:
        if secure_purchase not in [0, 1, 2]:
            raise TrumpetModerationError(
                'secure_purchase should be either 0 for inactive, or 1 for active, or 2 for active_send')
        return secure_purchase

    @staticmethod
    def __validate_shipping_type(shipping_type: str) -> str:
        if not shipping_type.isdigit():
            raise TrumpetModerationError('shipping_type should only contain digits')
        return shipping_type

    @staticmethod
    def __validate_city_shipping_cost(city_shipping_cost: str) -> str:
        if not city_shipping_cost.isdigit():
            raise TrumpetModerationError('city_shipping_cost should only contain digits')
        return city_shipping_cost

    @staticmethod
    def __validate_state_shipping_cost(state_shipping_cost: str) -> str:
        if not state_shipping_cost.isdigit():
            raise TrumpetModerationError('state_shipping_cost should only contain digits')
        return state_shipping_cost

    @staticmethod
    def __validate_country_shipping_cost(country_shipping_cost: str) -> str:
        if not country_shipping_cost.isdigit():
            raise TrumpetModerationError('country_shipping_cost should only contain digits')
        return country_shipping_cost

    @staticmethod
    def __validate_price_offer(price_offer: int) -> int:
        if price_offer not in [0, 1]:
            raise TrumpetModerationError(
                'price_offer should be either 0 for inactive, or 1 for active')
        return price_offer

    @staticmethod
    def __validate_sheba(sheba: str) -> str:
        if re.match(r'^IR\d{24}$', sheba):
            return sheba
        else:
            raise TrumpetModerationError('sheba should be started with IR and 24 number after it.')
