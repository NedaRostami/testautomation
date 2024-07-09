from typing import List, Dict, Any, Union
from exceptions import TrumpetModerationError
from libraries.TrumpetModeration.base import BaseTrumpetModeration
from request import Response


class SecurePurchase(BaseTrumpetModeration):

    def get_status_of_payment(self, phone_number: Union[str, int], ad_title: str):
        response = self.client.post(
            url=f'{self.env.url}/trumpet/settings/secure-purchase-invoice/fetch',
            data={'TelephonePrimary': phone_number, 'q': ad_title}
        )
        response.is_valid(raise_exception=True, validate_success=True)
        # print(response.body)
        payment_status = response.body.get('data', {}).get('securePurchaseInvoice')[0].get('StateName')
        return payment_status

    def set_posting_cost_based_on_origin_and_destination_via_admin(self, origin: str, origin_id: Union[str, int], destination: str, destination_id: Union[str, int],
                                                                    destination_change:str, delivery_provider:str, shop_seller: str, price: str, has_delivery_time: Union[str, int]):
        destination_change_status = False
        if shop_seller == True:
            has_c2c = False
            has_c2c_value = 0
        else:
            has_c2c = True
            has_c2c_value = 1

        [new_posting_cost, change_new_posting_cost, change_price_value] = self.search_for_posting_cost_by_region(origin_id, destination, has_c2c, price, has_delivery_time)

        if new_posting_cost == True or change_new_posting_cost == True:
            if change_new_posting_cost == True:
                destination=destination_change
            if has_delivery_time == True:
                has_delivery_time_value = 1
            else:
                has_delivery_time_value = 0

            # print("has_delivery_time:", has_delivery_time)
            # print("has_delivery_time_value:", has_delivery_time_value)
            # print("has_c2c:", has_c2c)
            # print("has_c2c_value:", has_c2c_value)

            response = self.client.post(
                url=f'{self.env.url}/trumpet/settings/secure-purchase-delivery-pricing/new',
                data={'Origin': origin, 'Destination': destination, 'DeliveryProvider': delivery_provider,
                        'Price': price, 'GetPriceAutomatically': 0, 'HasC2C': has_c2c_value, 'HasDeliveryTime': has_delivery_time_value}
            )
            response.is_valid(raise_exception=True, validate_success=True)

        return  change_new_posting_cost, change_price_value

    def search_for_posting_cost_by_region(self, origin_id: Union[str, int], destination: str, has_c2c: str,
                                          price: str, has_delivery_time: Union[str, int]):
        response: Response = self.client.post(
             url=f'{self.env.url}/trumpet/settings/secure-purchase-delivery-pricing/fetch',
             data={'RegionId': origin_id}
        )
        response.is_valid(raise_exception=True, validate_success=True)
        total_display_records=int(response.body.get('data', {}).get('iTotalDisplayRecords'))
        # print("total_display_records:", total_display_records)
        change_price_value = '-1'
        new_posting_cost = False
        change_new_posting_cost = False
        if total_display_records >= 1:
            for i in range(0,total_display_records):
                destination_spdp=response.body.get('data', {}).get('securePurchaseDeliveryPricing')[i].get('Destination')
                # print("destination_spdp:", destination_spdp)
                # print("destination:", destination)
                if destination_spdp == destination:
                    exist_has_c2c=response.body.get('data', {}).get('securePurchaseDeliveryPricing')[i].get('HasC2C')
                    delivery_time_exist=response.body.get('data', {}).get('securePurchaseDeliveryPricing')[i].get('HasDeliveryTime')
                    if  (exist_has_c2c == has_c2c):
                        if (delivery_time_exist == has_delivery_time):
                            exist_price=response.body.get('data', {}).get('securePurchaseDeliveryPricing')[i].get('Price')
                            if exist_price != price:
                                change_price_value = exist_price
                        else:
                            change_new_posting_cost = True
                    else:
                        change_new_posting_cost = True
                else:
                    new_posting_cost = True
        else:
            new_posting_cost = True

        return  new_posting_cost, change_new_posting_cost, change_price_value
