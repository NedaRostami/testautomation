from exceptions import TrumpetModerationError
from libraries.TrumpetModeration.base import BaseTrumpetModeration


class UserComments(BaseTrumpetModeration):

    def change_comments_status(self, user_id: str, phone: str, seller_type: str, shop_title: str, category: str,
                                sp_state: str, change_status: str, current_status: str):
        ordinary_seller = '0'
        # Because the seller type bug is not fixed, the seller type is hard code to the ordinary seller.
        comments = self.search(user_id, phone, current_status, ordinary_seller, category, sp_state)
        if comments:
            for comment in comments:
                self.validate_shop_title(seller_type, comment['ShopTitle'], shop_title)
                comment_id = comment['SRID']
                response: Response = self.client.post(
                    url=f'{self.env.url}/trumpet/comment/toggle',
                    data={'id': comment_id, 'status': change_status}
                    )
        else:
            raise Exception('Could not find this comment')

    def validate_shop_title(self, seller_type: str, shop_title: str, expected_shop_title: str):
        if seller_type == '0':
            if shop_title != None:
                raise Exception('The ordinary seller should not have the shop title')
        if shop_title != expected_shop_title:
            raise Exception('Shop title is incorrect')


    def search(self, user_id: str, phone: str, status: str, seller_type: str, category: str, sp_state: str):
        response: Response = self.client.post(
            url=f'{self.env.url}/trumpet/comment/fetch',
            data={'UserId': user_id, 'TelephonePrimary': phone, 'Status': status,
                'Type': seller_type, 'Category': category, 'SecurePurchaseState': sp_state}
        )
        response.is_valid(raise_exception=True, validate_success=True)
        results = response.body.get('data', {}).get('comments', {})
        return results
