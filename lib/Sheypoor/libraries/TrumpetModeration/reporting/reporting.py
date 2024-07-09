from typing import Union, Dict, List, Any

from exceptions import TrumpetModerationError
from libraries.TrumpetModeration.base import BaseTrumpetModeration


class Reporting(BaseTrumpetModeration):

    __PAYMENT_STATUS_MAP: Dict[str, int] = {
        'successful': 5,
        'unsuccessful': 6,
        'pending': 1,
        'started': 2,
        'finished': 3,
    }

    __VALID_LISTING_STATUS: List[str] = ['accepted', 'rejected', 'on_moderation', 'deleted', 'dba', 'dbu', 'expired', ]

    def user_payment_count(self, user_id: Union[str, int], status: str = None, **kwargs) -> int:
        if status is None:
            status = ''
        elif status not in self.__PAYMENT_STATUS_MAP:
            raise TrumpetModerationError(f'if status is provided it should be one of '
                                         f'{", ".join(self.__PAYMENT_STATUS_MAP)}')
        category = kwargs.get('category')
        results = self.__user_payment(user_id, status=self.__PAYMENT_STATUS_MAP.get(status, ''))
        if category:
            results = [i for i in results if i['Category'] == category]
        payment_count = len(results)
        return payment_count

    def user_listing_count(self, phone_number, status: str = None, **kwargs) -> int:
        if status is None:
            status = ''
        elif status not in self.__VALID_LISTING_STATUS:
            raise TrumpetModerationError(f'if status is provided it should be one of '
                                         f'{", ".join(self.__VALID_LISTING_STATUS)}')
        category_id = kwargs.get('category_id', '')
        listing_list = self.__user_listings(phone_number, status, category_id=category_id)
        listing_count = len(listing_list)
        return listing_count

    def listing_details(self, listing_id: Union[str, int]):
        result = {}
        listing = self.__get_listing_details(listing_id)
        result['owner_id'] = listing.get('ownerID')
        result['region'] = listing.get('location', {}).get('region')
        result['city'] = listing.get('location', {}).get('city')
        result['registered_from'] = listing.get('userInfo', {}).get('registeredFrom')
        result['name'] = listing.get('userInfo', {}).get('name')
        result['title'] = listing.get('title')
        result['description'] = listing.get('description')
        result['category'] = listing.get('category', {}).get('c2',)
        result['category_id'] = listing.get('category', {}).get('categoryID')
        result['user_mobile'] = self.listing_phone_number(result['owner_id'])
        result['paid_tags'] = [i.get('title') for i in listing.get('paidTags', [])]
        result['paid_features'] = [i.get('title') for i in listing.get('paidFeature', [])]
        result['shop'] = bool(listing.get('shopInfo'))

    def listing_phone_number(self, owner_id: Union[str, int]) -> int:
        response = self.client.post(
            url=f'{self.env.url}/trumpet/user/fetch',
            data={'id': owner_id, }
        )
        response.is_valid(raise_exception=True, validate_success=True)
        phone_number = response.body.get('data', {}).get('user')[0].get('Phone')
        return phone_number

    def __user_payment(self, user_id: Union[str, int], status: int, start: int = 0) -> List[Dict[str, Any]]:
        response = self.client.post(
            url=f'{self.env.url}/trumpet/payment-report/fetch',
            data={'user_id': user_id, 'status': status, 'start': start, 'length': 50, }
        )
        response.is_valid(raise_exception=True, validate_success=True)
        payment_reports = response.body.get('data', {}).get('paymentReport')
        if payment_reports:
            payment_reports += self.__user_payment(user_id, status=status, start=start + 50)
        return payment_reports

    def __user_listings(self, phone_number: str, status: str = None, category_id: str = '', start: int = 0):
        response = self.client.post(
            url=f'{self.env.url}/trumpet/listing/fetch',
            data={'phone': phone_number, 'st': status, 'category_id': category_id, 'start': start, 'length': 50}
        )
        response.is_valid(raise_exception=True)
        listings = response.body.get('data', {}).get('add')
        if listings:
            listings += self.__user_listings(phone_number, status, category_id, start + 50)
        return listings

    def __get_listing_details(self, listing_id: Union[str, int]) -> Dict[str, Any]:
        response = self.client.get(f'{self.env.url}/api/v{self.env.general_api_version}/listings/{listing_id}',
                                   headers={'X-AGENT-TYPE': 'Android App', 'App-Version': f'{self.env.general_api_version}'}
                                  )
        response.is_valid(raise_exception=True, validate_success=True)
        listing_details = response.body
        return listing_details
