from typing import Union, Dict, List, Any

from robot.api.deco import keyword

from libraries.base import BaseSheypoorLibrary
from .listing import Listing
from .listing_limit import ListingLimit
from .login import Login
from .toggles import Toggle
from .push_notification import PushNotification
from .queue import Queue
from .throttle import Throttle


class Mock(BaseSheypoorLibrary):

    platform_list: List[str] = ['web', 'mobile', 'android', 'ios', 'api', ]

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.listing = Listing(self.env)
        self.listing_limit = ListingLimit(self.env)
        self.login = Login(self.env)
        self.toggles = Toggle(self.env)
        self.push_notification = PushNotification(self.env)
        self.queue = Queue(self.env)
        self.throttle = Throttle(self.env)


    @keyword(name="Mock Listing Moderate")
    def moderate_listing(self, action: str, listing_id: Union[str, int]) -> bool:
        return self.listing.moderation.moderate(action, listing_id)

    @keyword(name="Mock Listing Expire")
    def expire_listing(self, expire_at: str, listing_id: Union[str, int]) -> bool:
        return self.listing.expire.expire(expire_at, listing_id)

    @keyword(name="Mock Listing Shift")
    def shift_listing(self, shift_at: str, listing_id: Union[str, int]) -> bool:
        return self.listing.shift.shift(shift_at, listing_id)

    @keyword(name="Mock Listing Limit Get")
    def get_listing_limit(self, *category: str) -> Dict[str, str]:
        return self.listing_limit.get(*category)

    @keyword(name="Mock Listing Limit Set")
    def set_listing_limit(self, price: int, limit: int, *category: str) -> bool:
        return self.listing_limit.set(price, limit, *category)

    @keyword(name='Mock Listing Bump')
    def bump_listing(self, listing_id: Union[str, int], x_ticket: str, bump_type: str, coupon_code: str = ''):
        self.listing.bump.bump_listing(listing_id, x_ticket, bump_type, coupon_code)

    @keyword(name="Mock Login Get Code")
    def get_login_code(self, number: Union[str, int]) -> int:
        return self.login.get_verification_code(number)

    @keyword(name="Mock Toggle Get")
    def get_toggle(self, source: str, name: str) -> bool:
        return self.toggles.get(source, name)

    @keyword(name="Mock Toggle Set")
    def set_toggle(self, source: str, name: str, status: Union[int, str]) -> bool:
        return self.toggles.set(source, name, status)

    @keyword(name='Send Push Notification')
    def send_push_notification(self, firebase_token: str, message: str = 'Notification Test',
                               buttons: Dict[str, Any] = None, image_url: str = ''):
        return self.push_notification.send(firebase_token, message, buttons, image_url)

    @keyword(name='Empty Default Queue')
    def empty_default_queue(self):
        return self.queue.empty_default()

    @keyword(name="Mock Throttling Get code")
    def get_throttling_code(self, token: str) -> int:
        return self.throttle.get_throttling_code(token)
