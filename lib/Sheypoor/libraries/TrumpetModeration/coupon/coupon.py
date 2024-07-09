import re
from datetime import datetime, timedelta
from typing import Union, Dict, Any

from exceptions import TrumpetModerationError
from libraries.TrumpetModeration.base import BaseTrumpetModeration
from libraries.Utils import Utils


class Coupon(BaseTrumpetModeration):
    __DATE_PATTERN = r'\d{4}-\d{1,2}-\d{1,2}'
    __VALID_COUPON_TYPES = ('refresh', 'refresh_top3', 'refresh_top3_2x', 'refresh_2x', 'refresh_once',
                            'refresh_daily3x', 'refresh_daily_5x', 'refresh_3day10x', 'refresh_1day1x',
                            'refresh_2days2x', 'refresh_3days3x', 'refresh_7days7x', 'hidden_1kx',
                            'rt_pt_1', 'rt_pt_2', 'rt_pt_3', 'rt_pt_7', 'gmv_1', 'gmv_2', 'gmv_3',
                            'listing_limit',)

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.utils = Utils(self.env)

    def create(self, discount: int, start_date: Union[str, datetime], end_date: Union[str, datetime],
               coupon_type: str, total_uses: int, user_uses: int, enabled: int, notify_number: str,
               random_count: int, random_length: int) -> str:
        start_date = self.__validate_start_date(start_date)
        end_date = self.__validate_end_date(end_date)
        self.__validate_coupon_type(coupon_type)
        discount = self.__validate_discount(discount)
        data = self.__create_data(discount, start_date, end_date, coupon_type, total_uses, user_uses,
                                  enabled, notify_number, random_count, random_length)
        response = self.client.post(f'{self.env.url}/trumpet/coupon/new', data=data)
        response.is_valid(raise_exception=True, validate_success=True)
        discount_code = data['Code']
        return discount_code

    def __create_data(self, discount: int, start_date: Union[str, datetime], end_date: Union[str, datetime],
                      coupon_type: str, total_uses: int, user_uses: int, enabled: int, notify_number: str,
                      random_count: int, random_length: int) -> Dict[str, Any]:
        discount_code = self.utils.generate_string(size=15)
        return {
            'Code': discount_code,
            'Discount': discount,
            'DateStart': datetime.strptime(start_date, '%Y-%m-%d').strftime('%s'),
            'DateEnd': datetime.strptime(end_date, '%Y-%m-%d').strftime('%s'),
            'CouponType': coupon_type,
            'NotifyNumber': notify_number,
            'UsesTotal': total_uses,
            'UsesUser': user_uses,
            'IsActive': enabled,
            'RandomCount': random_count,
            'RandomLength': random_length,
        }

    @staticmethod
    def __validate_discount(discount: Union[str, int]) -> int:
        discount = int(discount)
        if not 100 >= discount >= 0:
            raise TrumpetModerationError('discount value should be between 0 and 100')
        return discount

    def __validate_start_date(self, start_date: Union[str, datetime]) -> str:
        if start_date is None:
            start_date = datetime.now()
        if isinstance(start_date, str):
            if re.match(self.__DATE_PATTERN, start_date):
                return start_date
            else:
                raise TrumpetModerationError('invalid start_date input format, accepted format is: YYYY-mm-dd')
        elif isinstance(start_date, datetime):
            return start_date.strftime('%Y-%m-%d')
        raise TrumpetModerationError('Invalid date format, either provide a datetime object or a YYYY-mm-dd string')

    def __validate_end_date(self, end_date: Union[str, datetime]) -> str:
        if end_date is None:
            end_date = datetime.now() + timedelta(1)
        if isinstance(end_date, str):
            if re.match(self.__DATE_PATTERN, end_date):
                return end_date
            else:
                raise TrumpetModerationError('invalid start_date input format, accepted format is: YYYY-mm-dd')
        elif isinstance(end_date, datetime):
            return end_date.strftime('%Y-%m-%d')
        raise TrumpetModerationError('Invalid date format, either provide a datetime object or a YYYY-mm-dd string')

    def __validate_coupon_type(self, coupon_type: str) -> str:
        if coupon_type not in self.__VALID_COUPON_TYPES:
            raise TrumpetModerationError(f'coupon_type should be one of {", ".join(self.__VALID_COUPON_TYPES)}')
        return coupon_type
