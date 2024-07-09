from datetime import datetime
from typing import Union,List, Dict, Any

from lxml import html
from robot.api.deco import keyword

from exceptions import TrumpetModerationError

from libraries.base import BaseSheypoorLibrary
from request import Session
from libraries.Utils import Utils
from libraries.TrumpetModeration.payment import Payment
from libraries.TrumpetModeration.listing import Listing
from libraries.TrumpetModeration.release import Release
from libraries.TrumpetModeration.shop import Shop
from libraries.TrumpetModeration.coupon import Coupon
from libraries.TrumpetModeration.reporting import Reporting
from libraries.TrumpetModeration.packages import Packages
from libraries.TrumpetModeration.securepurchase import SecurePurchase
from libraries.TrumpetModeration.landing import Landing
from libraries.TrumpetModeration.users import Users
from libraries.TrumpetModeration.settings import Settings



class TrumpetModeration(BaseSheypoorLibrary):
    platform_list: List[str] = ['web', 'mobile', 'android', 'ios', 'api', ]
    __is_logged_in = False

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.client = Session(exception=TrumpetModerationError, retry_count=3, timeout=10)
        self.utils = Utils(env=self.env)
        self.payment = Payment(self.env, self.client)
        self.listing = Listing(self.env, self.client)
        self.release = Release(self.env, self.client)
        self.shop = Shop(self.env, self.client)
        self.coupon = Coupon(self.env, self.client)
        self.reporting = Reporting(self.env, self.client)
        self.packages = Packages(self.env, self.client)
        self.securepurchase = SecurePurchase(self.env, self.client)
        self.landing = Landing(self.env, self.client)
        self.users = Users(self.env, self.client)
        self.settings = Settings(self.env, self.client)



    @keyword(name='Set Payment Gateway')
    def set_payment_gateway(self, _type: str):
        self.__login_trumpet_moderation()
        self.payment.gateway.set(_type)

    @keyword(name='Set All Iran Price')
    def set_all_iran_price(self, catid: Union[str, int], regionId: Union[str, int], price: Union[str, int]):
        self.__login_trumpet_moderation()
        return self.packages.prices.set_all_iran(catid, regionId, price)

    @keyword(name='Set All State Price')
    def set_all_state_price(self, catid: Union[str, int], regionId: Union[str, int], price: Union[str, int]):
        self.__login_trumpet_moderation()
        return self.packages.prices.set_all_state(catid, regionId, price)

    @keyword(name='Set Bump Price')
    def set_bump_price(self, catid: Union[str, int], regionId: Union[str, int], price: Union[str, int], bumpid: str, AllIranAdditionPrice: Union[str, int], AllStateAdditionPrice: Union[str, int], SecurePurchaseAllIranAdditionPrice: Union[str, int], SecurePurchaseAllStateAdditionPrice: Union[str, int]):
        self.__login_trumpet_moderation()
        return self.packages.prices.set_bump(catid, regionId, price, bumpid, AllIranAdditionPrice, AllStateAdditionPrice, SecurePurchaseAllIranAdditionPrice, SecurePurchaseAllStateAdditionPrice)

    @keyword(name='Set Tag Price')
    def set_tag_price(self, catid: Union[str, int], regionId: str, price: Union[str, int],  tagid: Union[str, int]):
        # tagid = 5: تخفیفی or 10: فوری or 15: حراجی
        self.__login_trumpet_moderation()
        return self.packages.prices.set_tag(catid, regionId, price, tagid)

    @keyword(name='Get Bump Price By Category And Region')
    def get_bump_price_by_details(self, bump_type: str, regionID: Union[str, int], category: Union[str, int]):
        self.__login_trumpet_moderation()
        return self.packages.prices.fetch_bump_price_list(bump_type, regionID, category)

    @keyword(name='Is BlackListed')
    def is_blacklisted(self, listing_id: Union[str, int] ):
        self.__login_trumpet_moderation()
        return self.listing.history.check_blacklist(listing_id)

    @keyword(name='Random Rejection Deletion Reasons')
    def get_rejection_reasons(self, listing_id: Union[str, int], type:str ):
        # type :  rejection  or deletion
        self.__login_trumpet_moderation()
        return self.listing.history.random_rejection_deletion_reasons(listing_id, type)

    @keyword(name='Set All Limits For Category')
    def set_all_limits_for_category(self, parentid: int, catid: int, regid: int, cityid: int = None, nghid: int = None, limitcount: int = 30, limitprice: int = 11000):
        self.__login_trumpet_moderation()
        self.listing.limit.set(parentid, catid, regid, cityid, nghid, limitcount, limitprice)

    @keyword(name='Get Limits By Cat And Location')
    def get_all_limits_by_cat_and_location(self, catid: int, regid: int, cityid: int = None, nghid: int = None):
        self.__login_trumpet_moderation()
        return self.listing.limit.get_limits(catid, regid, cityid, nghid)

    @keyword(name='Get Limits Deep By Cat And Location')
    def get_limits_deep_by_cat_and_location(self, catid: int, regid: int, subCatid: int = None, cityid: int = None):
        self.__login_trumpet_moderation()
        return self.listing.limit.get_limits_deep(catid, regid, subCatid, cityid)

    @keyword(name='listing phone number')
    def listing_phone_number(self, owner_id: int):
        self.__login_trumpet_moderation()
        return self.reporting.listing_phone_number(owner_id)

    @keyword(name='Delete App Release Force Update')
    def delete_app_release_force_update(self, os_type: str = 'Android'):
        self.__login_trumpet_moderation()
        self.release.force_update.delete_release_list(os_type)

    @keyword(name='Create Shop')
    def create_shop(self, consultant_count: int = 2, secretary_count: int = 1, phone_number_count: int = 1,
                    city_id: str = '301', neighborhood_id: str = '3571', category_id: str = '43603',
                    latitude: str = '35.700065', longitude: str = '51.441538', securepurchase: int = 0,
                    shipping_type: str = '0', city_shipping_cost: str = '0', state_shipping_cost: str = '0',
                    country_shipping_cost: str = '0', status: str = '0', auto_listing_approve: str = '1', price_offer: int = 0) -> Dict[str, Any]:
        self.__login_trumpet_moderation()
        return self.shop.create(consultant_count, secretary_count, phone_number_count, city_id, neighborhood_id,
                                category_id, latitude, longitude, securepurchase, shipping_type, city_shipping_cost, state_shipping_cost, country_shipping_cost, status, auto_listing_approve, price_offer)

    @keyword(name='Add Secure Purchase To Shop')
    def add_secure_purchase_to_shop(self, secure_purchase: int, sheba: str, shop_id: int):
        self.__login_trumpet_moderation()
        return self.shop.add_secure_purchase(secure_purchase, sheba, shop_id)

    @keyword(name='Create Discount Coupon')
    def create_discount_coupon(self, discount: int = 100, start_date: datetime = None, end_date: datetime = None,
                               coupon_type: str = 'refresh_top3_2x', total_uses: int = 10000, user_uses: int = 1,
                               enabled: int = 1, notify_number: str = '09001000000', random_count: int = 0,
                               random_length: int = 0) -> str:
        self.__login_trumpet_moderation()
        return self.coupon.create(discount, start_date, end_date, coupon_type, total_uses, user_uses,
                                  enabled, notify_number, random_count, random_length)

    def __login_trumpet_moderation(self):
        if self.__is_logged_in:
            return
        response = self.client.get(f'{self.env.url}/trumpet/login')
        login_page = html.fromstring(response.content)
        csrf_token = login_page.xpath('//input[@id="csrf-key"]/@value')[0]
        data = {'csrf-key': csrf_token, 'email': {self.env.admin_user}, 'password': {self.env.admin_password}}
        self.client.post(
            url=f'{self.env.url}/trumpet/login',
            data=data
        )
        self.__is_logged_in = True

    @keyword(name='Get Status Of Payment')
    def get_status_of_payment(self, phone_number: int, ad_title: str):
        self.__login_trumpet_moderation()
        return self.securepurchase.get_status_of_payment(phone_number, ad_title)

    @keyword(name='Set Posting Cost Based On Origin And Destination Via Admin')
    def set_posting_cost_based_on_origin_and_destination_via_admin(self, origin: str, origin_id: Union[str, int], destination: str,
                                                                    destination_id: Union[str, int], destination_change: str, delivery_provider:str,
                                                                    shop_seller: str, price: str, has_delivery_time: Union[str, int]):
        self.__login_trumpet_moderation()
        return self.securepurchase.set_posting_cost_based_on_origin_and_destination_via_admin(origin, origin_id, destination, destination_id, destination_change,
                                                                                              delivery_provider, shop_seller, price, has_delivery_time)

    @keyword(name='Delete Posting Cost Based On Origin And Destination Via Admin')
    def delete_posting_cost_based_on_origin_and_destination_via_admin(self, origin_id: Union[str, int], destination_id: Union[str, int], destination: str, search_city: str):
        self.__login_trumpet_moderation()
        return self.securepurchase.delete_posting_cost_based_on_origin_and_destination_via_admin(origin_id, destination_id, destination, search_city)

    @keyword(name='Delete Landings By Searching By Path')
    def delete_landings_by_searching_by_path(self, path: str = None):
        self.__login_trumpet_moderation()
        return self.landing.delete_by_searching_by_path(path)

    @keyword(name='Delete Landings By Id')
    def delete_landings_by_id(self, *ids: List[str]):
        self.__login_trumpet_moderation()
        return self.landing.delete_by_id(*ids)

    @keyword(name='Edit Landing By Search')
    def edit_landing_by_search(self, searchPath: str = None, searchActivity: Union[str, int] = None, path: str = None,
            params: str = None, activity: Union[str, int] = None, title: str = None, alternativeTitle: str = None,
            anchorTitle: str = None, description: str = None, cat1: str = None, cat2: str = None, province1: str = None,
            city1: str = None, district1: str = None, province2: str = None, city2: str = None, district2: str = None,
            allNeighborhoods: Union[str, int] = None, redirectPath: str = None, searchTerms: str = None,
            redirectCode: Union[str, int] = None, content: str = None, note: str = None, faq: str = None):
        self.__login_trumpet_moderation()
        return self.landing.edit_by_search(searchPath, searchActivity, path, params,
                activity, title, alternativeTitle, anchorTitle, description, cat1,
                cat2, province1, city1, district1, province2, city2, district2,
                allNeighborhoods, redirectPath, searchTerms, redirectCode,
                content, note, faq)

    @keyword(name='Create Landing In Background')
    def create_landing_in_background(self, path: str, params: str, title: str, description: str,
            activity: Union[str, int] = None, alternativeTitle: str = None, anchorTitle: str = None, cat1: str = None,
            cat2: str = None, province1: str = None, city1: str = None, district1: str = None, province2: str = None,
            city2: str = None, district2: str = None, allNeighborhoods: Union[str, int] = None, redirectPath: str = None,
            searchTerms: str = None, redirectCode: Union[str, int] = None, content: str = None, note: str = None, faq: str = None):
        self.__login_trumpet_moderation()
        return self.landing.create(path, params, title, description, activity,
                alternativeTitle, anchorTitle, cat1, cat2, province1, city1, district1,
                province2, city2, district2, allNeighborhoods, redirectPath, searchTerms,
                redirectCode, content, note, faq)

    @keyword(name='Search Landing')
    def search_landing(self, path: str, activity: Union[str, int] = None):
        self.__login_trumpet_moderation()
        return self.landing.search(path, activity)

    @keyword(name='Create New Block Reason')
    def create_new_block_reason(self, reason: str, placeholder: str = 'تستی', priority: int = 1, analytics_key: str = 'تست', has_input: int = 1):
        self.__login_trumpet_moderation()
        return self.settings.block_reasons.new(reason, placeholder, priority, analytics_key, has_input)

    @keyword(name='Delete Block Reason')
    def delete_block_reason(self, id: str):
        self.__login_trumpet_moderation()
        return self.settings.block_reasons.delete(id)

    @keyword(name='Approve User Comments')
    def approve_user_comments(self, user_id: str = None, phone: str = None, seller_type: str = None, shop_title: str = None,
                            category: str = None, sp_state: str = None, current_status: str = '0' ):
        self.__login_trumpet_moderation()
        return self.users.user_comments.change_comments_status(user_id, phone, seller_type, shop_title, category, sp_state, '1', current_status)

    @keyword(name='Reject User Comments')
    def reject_user_comments(self, user_id: str = None, phone: str = None, seller_type: str = None, shop_title: str = None,
                            category: str = None, sp_state: str = None, current_status: str = '0' ):
        self.__login_trumpet_moderation()
        return self.users.user_comments.change_comments_status(user_id, phone, seller_type, shop_title, category, sp_state, '2', current_status)

    @keyword(name='Approve User Profile Photo')
    def approve_user_profile_photo(self, name: str = None, phone: str = None, activity_status: str = '2',
                            seller_type: str = None, photo_status: str = '-1'):
        self.__login_trumpet_moderation()
        return self.users.search_users.change_user_profile_photo_status(name, phone, activity_status,
        seller_type, photo_status, 'accept')

    @keyword(name='Reject User Profile Photo')
    def reject_user_profile_photo(self, name: str = None, phone: str = None, activity_status: str = None,
                            seller_type: str = None, photo_status: str = None):
        self.__login_trumpet_moderation()
        return self.users.search_users.change_user_profile_photo_status(name, phone, activity_status,
        seller_type, photo_status, 'reject')

    @keyword(name='Delete Listings')
    def delete_listings(self, ids: List, msg: str = "کاربر گرامی بر طبق قوانین سایت شیپور شما مجاز به درج آگهی تکراری نمی باشید.",
                        notify: str = "true", delete_reason_id: str = "11"):
        self.__login_trumpet_moderation()
        return self.listing.listing_operation.delete(ids, msg, notify, delete_reason_id)
