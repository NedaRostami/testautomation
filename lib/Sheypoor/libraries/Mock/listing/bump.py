import json
from typing import Union

from lxml import html

from ..base import BaseMock


class Bump(BaseMock):

    def bump_listing(self, listing_id: Union[str, int], x_ticket: str, bump_type: str, coupon_code: str = ''):
        response = self.client.get(url=f'{self.env.url}/session/bump/{listing_id}?xTicket={x_ticket}')
        response.is_valid(raise_exception=True)
        bump_page = html.fromstring(response.content)
        data_params = json.loads(bump_page.xpath('//section[@id="bump"]/@data-params')[0])
        csrf_token = data_params.get('csrf')
        response = self.client.post(
            url=f'{self.env.url}/api/web/order/bump',
            data={
                'listingID': listing_id,
                'couponCode': coupon_code,
                'bumpType': bump_type,
                'limitationType': bump_type,
                'gatewayName': 'development',
                'csrf_token': csrf_token or ''
            }
        )
        response.is_valid(raise_exception=True)
        print(response.body)
        data = response.body.get('data', {})
        callback = self.client.post(
            url=f'{self.env.url}{data.get("action")}',
            data=data.get('params')
        )
        callback.is_valid(raise_exception=True)
