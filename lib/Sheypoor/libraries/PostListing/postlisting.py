from typing import List, Dict, Any, Union
import os

from robot.api.deco import keyword

from exceptions import UtilsError
from libraries.base import BaseSheypoorLibrary
from request import Request

from libraries import JsonServer
from libraries import Images
from libraries.Images.models import ImageSet
from libraries import Mock
from libraries import TrumpetModeration
import time

from geopy.geocoders import Nominatim


# import curlify


class PostListing(BaseSheypoorLibrary):
    platform_list: List[str] = ['web', 'mobile', 'android', 'ios', 'api', 'seo', ]

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.client = Request(exception=UtilsError, retry_count=3, timeout=10)
        self.json_server: JsonServer = JsonServer(env=self.env)
        self.images: Images = Images(env=self.env)
        self.mock: Mock = Mock(env=self.env)
        # self.lib_version = kwargs.get('version')  # version ,  input argument in library of sheypoor
        self.version_utils = self.env.general_api_version
        # self.version_utils = os.getenv('file_version', self.env.general_api_version)
        self.trumpet_moderation: TrumpetModeration = TrumpetModeration(env=self.env)

    @keyword(name='Post Listing In Background')
    def post_listing_in_background(self, listing_cat: str, listing_sub_cat: str, price: str, state: str, city: str,
                                   region: str, seller_phone_number: str, listing_img_count: Union[str, int] = 3,
                                   new_used: str = 'null', chip_discount: str = 'false', kind: str = 'null') -> Dict[str, Union[str, int]]:
        file_version: str = os.getenv('file_version')

        category_id: int = self.json_server.get_category_object(category=listing_cat, id=True)
        sub_category_id: int = self.json_server.get_category_object(category=listing_cat, sub_category=listing_sub_cat,
                                                                    id=True)
        # assert isinstance(self.json_server.get_location_object, object)
        location_id: int = self.json_server.get_location_object(location=state, city=city, district=region, id=True)

        random_listing_data: Dict = self.json_server.random_live_listing(category=str(sub_category_id))

        images_dic: ImageSet = self.images.select_images(str(category_id), listing_img_count,
                                                         random_listing_data['listingID'])
        images_list: List = self.images.upload_images(images_dic)

        POST_LISTING_DATA = {
            "attributes": random_listing_data['attributes'],
            "categoryID": sub_category_id,
            "description": random_listing_data['description'],
            # "description": 'ماسک تومان ریال سلام ماشین ظرفشویی',
            "districtName": region,
            "images": images_list,
            "latitude": "",
            "longitude": "",
            "locationID": location_id,
            "locationType": 2,
            "telephone": seller_phone_number,
            "title": random_listing_data['title'],
            "userType": 0
        }

        # handle location type
        # LOCATION_TYPE_PROVINCE = 0;
        # LOCATION_TYPE_CITY = 1;
        # LOCATION_TYPE_DISTRICT = 2;
        # LOCATION_TYPE_COUNTRY = 3;
        if region:
            POST_LISTING_DATA['locationType'] = 2
        else:
            POST_LISTING_DATA['locationType'] = 1

        # handle price
        price_attribute = {'attributeID': '1', 'attributeValue': price}
        POST_LISTING_DATA['attributes'].append(price_attribute)

        # Handle New Used Attribute
        if kind != '':
            POST_LISTING_DATA['attributes'].append(self.__handle_new_used_att(new_used))

        # handle Chip discount
        chip_discount_attribute = {'attributeID': '75028', 'attributeValue': chip_discount}
        POST_LISTING_DATA['attributes'].append(chip_discount_attribute)

        # Handle Kind of product
        if kind != '':
            POST_LISTING_DATA['attributes'].append(self.__handle_choose_kind_att(kind))

        print('&&&&&&&&&&&&&&&&&&&&&&&\n')
        print(POST_LISTING_DATA)
        print('&&&&&&&&&&&&&&&&&&&&&&&\n')

        response = self.client.post(f'{self.env.url}/api/v{self.version_utils}/auth/state-request',
                                    json={'username': seller_phone_number},
                                    headers={'X-AGENT-TYPE': 'Android App', 'App-Version': file_version,
                                             'user-agent': f'Android/8.1 Sheypoor/{self.version_utils}-Debug-PlayStore '
                                                           'VersionCode/594 Manufacturer/Samsung Model/Samsung Galaxy '
                                                           'S10 E - 8.1 - API 27 - 1080x2280'})
        response.is_valid(raise_exception=True)
        token = response.body.get('token')
        time.sleep(2)
        login_code: str = self.mock.get_login_code(seller_phone_number)
        response = self.client.post(f'{self.env.url}/api/v{self.version_utils}/auth/number-verification',
                                    json={'token': token, 'mobilePIN': login_code},
                                    headers={'X-AGENT-TYPE': 'Android App', 'App-Version': file_version})

        response.is_valid(raise_exception=True)
        x_ticket = response.body.get('x-ticket')
        response = self.client.post(f'{self.env.url}/api/v{self.version_utils}/listings',
                                    json=POST_LISTING_DATA,
                                    headers={'x-ticket': x_ticket, 'User-Agent': 'Android/8.1 Sheypoor/6.0.1-Debug-PlayStore '
                                                  'VersionCode/594 Manufacturer/Samsung Model/Samsung Galaxy '
                                                  'S10 E - 8.1 - API 27 - 1080x2280',
                                    'X-AGENT-TYPE': 'Android App', 'App-Version': file_version})
        response.is_valid(raise_exception=True)
        print(response.body)
        # res_post_moderation = response.body.get('message')
        # print(res_post_moderation)
        listing_id = response.body.get('listingID')
        is_black_list = self.trumpet_moderation.is_blacklisted(listing_id)
        if is_black_list:
            self.mock.moderate_listing('accept', listing_id)

        # TODO: implement chip_discount
        # if chip_discount == 'true':
        #     PAID_FEATURE_DATA = {
        #         "couponCode": "",
        #         "flavor": "playStore",
        #         "paidFeatureIds": [5],
        #         "paidFeatureOptionIds": {},
        #         }
        #
        #     print('&&&&&&&&&&&&&&&&&&&&&&& PAID_FEATURE_DATA\n')
        #     print(PAID_FEATURE_DATA)
        #     print('&&&&&&&&&&&&&&&&&&&&&&& PAID_FEATURE_DATA\n')
        #
        #     response = self.client.post(
        #         f'{self.env.url}/api/v{self.version_utils}/paid-feature/{listing_id}?flavor=playStore',
        #         json=PAID_FEATURE_DATA,
        #         headers={'x-ticket': x_ticket, 'X-AGENT-TYPE': 'Android App','App-Version': file_version})
        #     response.is_valid(raise_exception=True)
        #
        #     print("%%%%%%%%%%%%%   Payment responce    %%%%%%%%%%%\n")
        #     print(response.body)
        #     print("%%%%%%%%%%%%%   Payment responce    %%%%%%%%%%%\n")
        #
        #     payment_url = response.body.get('url')
        #     response = self.client.get(payment_url,
        #         headers={'x-ticket': x_ticket, 'X-AGENT-TYPE': 'Android App', 'App-Version': file_version})
        #
        #     print("%%%%%%%%%%%%%   Payment responce    %%%%%%%%%%%\n")
        #     print(response.body)
        #     print("%%%%%%%%%%%%%   Payment responce    %%%%%%%%%%%\n")
        #
        #     # print(curlify.to_curl(response.request))
        return {'listingId': listing_id, 'Listings_title': random_listing_data['title'], 'Listings_description': random_listing_data['description']}


    @keyword(name='Post Listings With uuid In Background')
    def post_listings_with_uuid_in_background(self, seller_phone_number: str, subCat_id: int, region_name: str, city_name: str,
                                                city_id: int, loc_type: str, uuid: str, count: int):
        file_version: str = os.getenv('file_version')
        random_listing_data: Dict = self.json_server.random_live_listing(subCat_id)
        POST_LISTING_DATA = {
            "attributes": random_listing_data['attributes'],
            "categoryID": subCat_id,
            "title": random_listing_data['title'],
            "description": random_listing_data['description'],
            "districtName": '',
            "images": [],
            "latitude": '',
            "longitude": '',
            "locationID": city_id,
            "locationType": 1,
            "telephone": seller_phone_number,
            "userType": 0
        }
        POST_LISTING_DATA["attributes"].append({'attributeID': 2131362897, 'attributeValue': f'{region_name}, {city_name}'})

        response = self.client.post(f'{self.env.url}/api/v{self.version_utils}/auth/state-request',
                                    json={'username': seller_phone_number},
                                    headers={'X-AGENT-TYPE': 'Android App', 'App-Version': file_version,
                                             'user-agent': f'Android/8.1 Sheypoor/{self.version_utils}-Debug-PlayStore '
                                                           'VersionCode/594 Manufacturer/Samsung Model/Samsung Galaxy '
                                                           'S10 E - 8.1 - API 27 - 1080x2280'})
        response.is_valid(raise_exception=True)
        token = response.body.get('token')
        login_code: str = self.mock.get_login_code(seller_phone_number)
        response = self.client.post(f'{self.env.url}/api/v{self.version_utils}/auth/number-verification',
                                    json={'token': token, 'mobilePIN': login_code},
                                    headers={'X-AGENT-TYPE': 'Android App', 'App-Version': file_version})

        response.is_valid(raise_exception=True)
        x_ticket = response.body.get('x-ticket')
        listing_msg: List = []
        listing_id: List = []
        count = int(count)
        for i in range(count):
            response = self.client.post(f'{self.env.url}/api/v{self.version_utils}/listings',
                                        json=POST_LISTING_DATA,
                                        headers={'x-ticket': x_ticket, 'User-Agent': 'Android/8.1 Sheypoor/6.0.1-Debug-PlayStore '
                                                      'VersionCode/594 Manufacturer/Samsung Model/Samsung Galaxy '
                                                      'S10 E - 8.1 - API 27 - 1080x2280',
                                        'X-AGENT-TYPE': 'Android App', 'App-Version': file_version, 'Unique-Id': uuid})
            response.is_valid(raise_exception=True)
            listing_msg.append(response.body.get('message'))
            listing_id.append(response.body.get('listingID'))

        return listing_id, listing_msg





    @keyword(name='Post A Random Listing In Background')
    def post_a_random_listing_in_background(self, seller_phone_number: str) -> Dict[str, Union[str, int]]:
        file_version: str = os.getenv('file_version')
        random_listing_data: Dict = self.json_server.random_live_listing()
        print(random_listing_data)
        cat_parent_name = self.json_server.get_cat_parent_name(random_listing_data['categoryID'])
        if not cat_parent_name:
            cat_parent_name = 'وسایل نقلیه'
        cat_parent_id = self.json_server.get_category_object(category=cat_parent_name, id=True)

        images_dic: ImageSet = self.images.select_images(str(cat_parent_id), 1, random_listing_data['listingID'])
        images_list: List = self.images.upload_images(images_dic)

        # set region
        locationName  = "تهران، اباذر"
        region = locationName.split('، ',1)[-1]


        #set lat & long of listing by region
        # geolocator = Nominatim(user_agent="geoapiExercises")
        # location = geolocator.geocode(locationName)
        # if location:
        #     listing_lat = "35.6719691"
        #     listing_lang = "51.4523524"
        # else:
        #     listing_lat = ""
        #     listing_lang = ""
        listing_lat = "35.6719691"
        listing_lang = "51.4523524"

        POST_LISTING_DATA = {
            "attributes": random_listing_data['attributes'],
            "categoryID": random_listing_data['categoryID'],
            "title": random_listing_data['title'],
            "description": random_listing_data['description'],
            "districtName": region,
            "images": images_list,
            "latitude": listing_lat,
            "longitude": listing_lang,
            "locationID": 883,
            "locationType": 2,
            "telephone": random_listing_data['phoneNumber'],
            "userType": 0
        }

        # handle price
        price_attribute = {'attributeID': '1', 'attributeValue': random_listing_data['price']}
        POST_LISTING_DATA['attributes'].append(price_attribute)

        print('&&&&&&&&&&&&&&&&&&&&&&&\n')
        print(POST_LISTING_DATA)
        print('&&&&&&&&&&&&&&&&&&&&&&&\n')

        response = self.client.post(f'{self.env.url}/api/v{self.version_utils}/auth/state-request',
                                    json={'username': seller_phone_number},
                                    headers={'X-AGENT-TYPE': 'Android App', 'App-Version': file_version,
                                             'user-agent': f'Android/8.1 Sheypoor/{self.version_utils}-Debug-PlayStore '
                                                           'VersionCode/594 Manufacturer/Samsung Model/Samsung Galaxy '
                                                           'S10 E - 8.1 - API 27 - 1080x2280'})
        response.is_valid(raise_exception=True)
        token = response.body.get('token')
        time.sleep(2)
        login_code: str = self.mock.get_login_code(seller_phone_number)
        response = self.client.post(f'{self.env.url}/api/v{self.version_utils}/auth/number-verification',
                                    json={'token': token, 'mobilePIN': login_code},
                                    headers={'X-AGENT-TYPE': 'Android App', 'App-Version': file_version})

        response.is_valid(raise_exception=True)
        x_ticket = response.body.get('x-ticket')
        response = self.client.post(f'{self.env.url}/api/v{self.version_utils}/listings',
                                    json=POST_LISTING_DATA,
                                    headers={'x-ticket': x_ticket, 'User-Agent': 'Android/8.1 Sheypoor/6.0.1-Debug-PlayStore '
                                                  'VersionCode/594 Manufacturer/Samsung Model/Samsung Galaxy '
                                                  'S10 E - 8.1 - API 27 - 1080x2280',
                                    'X-AGENT-TYPE': 'Android App', 'App-Version': file_version})
        response.is_valid(raise_exception=True)
        print(response.body)
        listing_id = response.body.get('listingID')
        is_black_list = self.trumpet_moderation.is_blacklisted(listing_id)
        if is_black_list:
            self.mock.moderate_listing('accept', listing_id)


        return listing_id, random_listing_data

    @keyword(name='Check That It Is In The General Category')
    def check_that_it_is_in_the_general_category(self, cat_id: str):
        non_general_categories = ['43626', '43603', '43618', '43633']
        if cat_id in non_general_categories:
            return False
        else:
            return True

    @staticmethod
    def __handle_new_used_att(new_used: str) -> Dict[str, Union[str, int]]:
        if new_used == 'نو':
            new_used_att = {'attributeID': '90155', 'attributeValue': 453187}
        elif new_used == 'در حد نو':
            new_used_att = {'attributeID': '90155', 'attributeValue': 453188}
        elif new_used == 'کارکرده':
            new_used_att = {'attributeID': '90155', 'attributeValue': 453189}
        else:
            raise Exception("please choose correct status for product in post listing")
        return new_used_att

    @staticmethod
    def __handle_choose_kind_att(kind: str) -> Dict[str, Union[str, int]]:
        if kind == 'زنانه':
            kind_att = {'attributeID': '68127', 'attributeValue': 440457}
        elif kind == 'مردانه':
            kind_att = {'attributeID': '68127', 'attributeValue': 440458}
        else:
            # raise Exception("please choose correct kind of product in post listing")
            print("please choose correct kind of product in post listing")
        return kind_att

    # def __payment_paid_feature(self, chip_discount: str, listing_id: str):
