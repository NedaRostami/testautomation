import re
import os
import json
from json import JSONDecodeError
from robot.api.logger import info, console

from lib.request import Request

class Variables:

    def __init__(self):
        self.json_server = 'http://qa2.mielse.com:9500'
        self.trumpet_prenv_id = ''
        self.version = ''
        self.server = ''
        self.client = Request(retry_count=3)

    def get_test_environment(self):
        subdomain = self.trumpet_prenv_id
        if re.match('\d{4,5}', self.trumpet_prenv_id):
            subdomain = 'pr{}'.format(self.trumpet_prenv_id)
        server = 'https://' + subdomain + '.mielse.com'
        return server

    def get_variables(self, trumpet_prenv_id='staging', version='6.4.0'):
        self.trumpet_prenv_id = trumpet_prenv_id
        self.version = version
        self.server = self.get_test_environment()
        variables = {
            'server': self.server,
            'version': self.version,
            'trumpet_prenv_id': self.trumpet_prenv_id,
            'json_server': self.json_server,
        }

        variables = self.set_seo_vars(variables)

        return variables


    def set_seo_vars(self, variables):
        variables.update(
            #Homepage
            home_title = "شیپور - نیازمندیهای رایگان خرید و فروش، استخدام و خدمات",
            home_description = "نیازمندیهای رایگان خرید و فروش خودرو، املاک و آپارتمان، گوشی موبایل و تبلت، موتور سیکلت، لوازم خانگی، لوازم دست دوم، استخدام و خدمات در ایران",
            home_h1 = "نیازمندیهای رایگان شیپور",

            #New Listing Page
            add_new_title = "ثبت آگهی رایگان – شیپور",
            add_new_description = "ثبت آگهی رایگان خرید، فروش، اجاره، املاک، خودرو، استخدام و خدمات در ایران",
            add_new_h1 = "ثبت آگهی",

            #Only Location
            location_title = "شیپور {locationName} - نیازمندیهای رایگان خرید و فروش، استخدام و خدمات",
            location_description = "نیازمندی های رایگان خرید و فروش خودرو، موبایل، آپارتمان، موتور سیکلت، لوازم دست دوم، استخدام و خدمات در {locationName}",
            location_h1 = "همه آگهی ها در {locationName}",

            # General by regionName
            general_title = "خرید و فروش {categoryName} در {locationName} - شیپور",
            general_description = "{adsCount} {categoryName} نو و دست دوم برای خرید و فروش با قیمت های مناسب در {locationName} و حومه شهر",
            general_h1 = "آگهی های {categoryName} در {locationName}",

            ########### Mobile and tablet and accessories #############
            # Mobile and tablet
            mobile_title = "خرید و فروش {categoryName} در {locationName} - شیپور",
            mobile_description ="{adsCount} {categoryName} نو و دست دوم برای خرید و فروش با قیمت های مناسب در {locationName} و حومه شهر",
            mobile_h1 = "آگهی های {categoryName} در {locationName}",

            # Mobile and tablet brands
            mobile_brands_title = "خرید و فروش تبلت و گوشی {brand} دست دوم و نو در {locationName} - شیپور",
            mobile_brands_description = "{adsCount} گوشی موبایل {brand} دست دوم و نو برای خرید و فروش با قیمت های مناسب در {locationName} و حومه شهر",
            mobile_brands_h1 = "آگهی های گوشی {brand} در {locationName}",

            ########### Realestate #############
            # Realestate Category
            realestate_title = "خرید و فروش و اجاره خانه، آپارتمان و سایر املاک مسکونی در {locationName} - شیپور",
            realestate_description = "بیش از {adsCount} آگهی خانه، آپارتمان و سایر املاک مسکونی، اداری، تجاری و زمین برای خرید و فروش و اجاره با قیمت های مناسب در {locationName} و حومه شهر",
            realestate_h1 = "آگهی های {categoryName} در {locationName}",

            # Realestate Residential for Rent
            realestate_rent_title = "رهن و اجاره {realestateType} نوساز و چند سال ساخت در {locationName} - شیپور",
            realestate_rent_description = "{adsCount} آگهی رھن و اجاره {realestateType} با قیمت های مناسب و ارزان به صورت فوری در املاک {locationName}",
            realestate_rent_h1 = "آگهی های رهن و اجاره {realestateType} در {locationName}",

            # Realestate Residentioal for sell
            realestate_sell_title = "خرید و فروش {realestateType} چندسال ساخت و نوساز در {locationName} – شیپور",
            realestate_sell_description = "{adsCount} آگهی خرید و فروش {realestateType} با قیمت های مناسب و ارزان به صورت فوری در املاک {locationName}",
            realestate_sell_h1 = "آگهی های خرید و فروش {realestateType} در {locationName}",

            # Realestate Commercial for Rent
            realestate_commerical_rent_title = "رهن و اجاره {realestateType} نوساز و چند سال ساخت در ملک های {locationName} - شیپور",
            realestate_commerical_rent_description = "{adsCount} آگهی رھن و اجاره {realestateType} با قیمت های مناسب و ارزان به صورت فوری در املاک {locationName}",
            realestate_commerical_rent_h1 = "آگهی های رهن و اجاره {realestateType} در {locationName}",

            # Realestate Commercial for sell
            realestate_commerical_sell_title = "خرید و فروش {realestateType} نوساز و چند سال ساخت در ملک های {locationName} - شیپور",
            realestate_commerical_sell_description = "{adsCount} آگهی رھن و اجاره {realestateType} با قیمت های مناسب و ارزان به صورت فوری در املاک {locationName}",
            realestate_commerical_sell_h1 = "آگهی های خرید و فروش {realestateType} در {locationName}",

            # Land and Garden
            realestate_land_garden_title = "خرید و فروش زمین و باغ در {locationName} - شیپور",
            realestate_land_garden_description = "بیش از {adsCount} آگهی خرید و فروش زمین و باغ با قیمت های مناسب در {locationName} و حومه شهر",
            realestate_land_garden_h1 = "آگهی های {categoryName} در {locationName}",

            # Villa and Suite
            realestate_villa_suite_title = "اجاره ویلا و سوئیت در {locationName} - شیپور",
            realestate_villa_suite_description = "{adsCount} آگهی اجاره ویلا و سوئیت به صورت کوتاه مدت و فوری با قیمت های مناسب در {locationName}",
            realestate_villa_suite_h1 = "آگهی های {categoryName} در {locationName}",

            ########### Services & Businesses  صنعتی، اداری و تجاری #############
            # Services & Businesses
            industrial_commerical_title = "آگهی های مربوط به کسب و کار ها در {locationName} - شیپور",
            industrial_commerical_description = "{adsCount} آگهی کسب و کار با قیمت های مناسب در {locationName} و حومه شهر",
            industrial_commerical_h1 = "آگهی های {categoryName} در {locationName}",

            # Businesses
            # adlists_43637_title = "کسب و کار در {locationName} - شیپور",
            # adlists_43637_description = "{adsCount} آگهی کسب و کار با قیمت های مناسب در {locationName} و حومه شهر",
            # adlists_43637_h1 = "آگهی های {categoryName} در {locationName}",

            ########### Services خدمات و کسب و کار  #############
            # Services
            buisness_services_title = "خدمات در {locationName} - شیپور",
            buisness_services_description = "{adsCount} آگهی خدمات ترجمه، دکوراسیون، آرایشی، پرستاری، درمانی، کترینگ، نظافت، تعمیرات و دیگر خدمات با قیمت های مناسب در {locationName} و حومه شهر",
            buisness_services_h1 = "آگهی های {categoryName} در {locationName}",

            # Education
            buisness_services_education_title = "آموزش زبان انگلیسی، موسیقی، ورزش و سایر تخصص ها در {locationName} - شیپور",
            buisness_services_education_description = "{adsCount} آگهی آموزش زبانهای خارجی، هنر، موسیقی، ورزش، فنی حرفه ای و دیگر آموزش ها با قیمت های مناسب در {locationName} و حومه شهر",
            buisness_services_education_h1 = "آگهی های {categoryName} در {locationName}",

            # Ceremonies and kettering
            buisness_services_kettering_title = "خدمات {categoryName} در {locationName} - شیپور",
            buisness_services_kettering_description = "{adsCount} آگهی خدمات مراسم در زمینه های تهیه غذا و کترینگ، گل آرایی، عکاسی و فیلم برداری و دیگر زمینه ها با قیمت های مناسب در {locationName} و حومه شهر",
            buisness_services_kettering_h1 = "آگهی های {categoryName} در {locationName}",

            # Hairdressers and beauty
            buisness_services_beauty_title = "آرایش صورت، کاشت و طراحی ناخن، شینیون و سایر خدمات آرایشگری و زیبایی در {locationName} - شیپور",
            buisness_services_beauty_description = "{adsCount} آگهی خدمات {categoryName} با قیمت های مناسب در {locationName} و حومه شهر",
            buisness_services_beauty_h1 = "آگهی های {categoryName} در {locationName}",

            # Repairs
            buisness_services_repairs_title = "خدمات تعمیرات موبایل، لپ تاپ و سایر لوازم در {locationName} - شیپور",
            buisness_services_repairs_description = "{adsCount} آگهی تعمیرات لوازم خانگی، خودرو، موبایل، کامپیوتر و سایر لوازم با قیمت های مناسب در {locationName} و حومه شهر",
            buisness_services_repairs_h1 = "آگهی های {categoryName} در {locationName}",

            # # Translation and type
            buisness_services_translation_title = "خدمات {categoryName} در {locationName} - شیپور",
            buisness_services_translation_description = "{adsCount} خدمات تایپ و ترجمه متون ، نظیر ترجمه انگلیسی به فارسی و ترجمه فارسی به انگلیسی در {locationName} و حومه شهر",
            buisness_services_translation_h1 = "آگهی های {categoryName} در {locationName}",

            # خرید و فروش عمده  wholesale sales
            buisness_services_wholesale_title = "کسب و کار در {locationName} - شیپور",
            buisness_services_wholesale_description = "{adsCount}  آگهی کسب و کار با قیمت های مناسب در {locationName} و حومه شهر",
            buisness_services_wholesale_h1 = "آگهی های {categoryName} در {locationName}",


            # Other services
            buisness_services_other_title = "انواع خدمات در {locationName} - شیپور",
            buisness_services_other_description = "{adsCount} آگهی خدمات در زمینه های مختلف با قیمت های مناسب در {locationName} و حومه شهر",
            buisness_services_other_h1 = "آگهی های {categoryName} در {locationName}",

            # Other subcategory of services
            buisness_services_children_title = "خدمات {categoryName} در {locationName} - شیپور",
            buisness_services_children_description = "{adsCount} آگهی خدمات {categoryName} با قیمت های مناسب در {locationName} و حومه شهر",
            buisness_services_children_h1 = "آگهی های {categoryName} در {locationName}",

            ########### Jobs #############
            jobs_title = "آگهی های استخدام و کاریابی در {locationName} - شیپور",
            jobs_description = "استخدام و کاریابی با بیش از {adsCount} آگهی استخدام در تمام اصناف و تخصص ها با حقوق و مزایای مناسب در {locationName} و حومه شهر",
            jobs_h1 = "آگهی های {categoryName} در {locationName}",

            ##########

            jobs_children_title = "استخدام {categoryName} در {locationName} - شیپور",
            jobs_children_description = "{adsCount} آگهی استخدام {categoryName} با حقوق و مزایای مناسب در {locationName} و حومه شهر",
            jobs_children_h1 = "استخدام {categoryName} در {locationName}",

            ########### Vehicles #############
            new_used = "صفر و کارکرده",
            new = "صفر و انواع ماشین نو",
            used = "کارکرده و دست دوم",

            # Motorcycle
            motorcycle_title = "خرید و فروش و قیمت موتور سیکلت نو و دست دوم در {locationName} - شیپور",
            motorcycle_description = "بیش از {adsCount} آگهی موتورسیکلت صفر و کارکرده با سی سی های مختلف را باما در شیپور ببینید.",
            motorcycle_h1 = "آگهی های {categoryName} در {locationName}",

            # classic Car
            cars_classic_title = "خرید و فروش خودرو کلاسیک در {locationName} - شیپور",
            cars_classic_description ="{adsCount} خودرو کلاسیک نو و دست دوم برای خرید و فروش با قیمت های مناسب در {locationName} و حومه شهر",
            cars_classic_h1 = "آگهی های {categoryName} در {locationName}",

            # Car
            cars_title = "خرید و فروش و قیمت خودرو و ماشین دست دوم و نو در {locationName} - شیپور",
            cars_description =  " بیش از {adsCount} آگهی خودرو و ماشین صفر و کارکرده برای خرید و فروش با قیمت های مناسب در {locationName} را باما در شیپور ببینید",
            cars_h1 = "آگهی های {categoryName} در {locationName}",

            # Car Brand
            cars_brands_title = "خرید و فروش و قیمت خودرو {brand} دست دوم و نو در {locationName} - شیپور",
            cars_brands_description = "خرید و فروش {brand} : شامل بیش از {adsCount} آگهی خودرو {brand} کارکرده و صفر با قیمت های مناسب در {locationName} را با ما در شیپور ببینید.",
            cars_brands_h1 = "آگهی های خرید و فروش {brand} در {locationName}",

            # Car Model
            cars_brand_models_title = "خرید و فروش و قیمت خودرو {brand} {model} دست دوم و نو در {locationName} - شیپور",
            cars_brand_models_description = "خرید و فروش {brand} {model}  :بیش از {adsCount} خودرو و ماشین {brand} {model} کارکرده و صفر با قیمت های مناسب در {locationName} و حومه شهر را باما در شیپور ببینید.",
            cars_brand_models_h1 = "آگهی های خرید و فروش {brand} {model} در {locationName}",

            # Car with filter
            cars_with_filter_title = "خرید فروش و قیمت {brand} {model} {bodyType} {new_used_title} {paymentType} در {locationName} - شیپور",
            cars_with_filter_description = "خرید و فروش {brand} {model}: بیش از {adsCount}  خودرو و ماشین {brand} {model} : {new_used_description} با قیمت های مناسب در  {locationName} و حومه شهر را باما در شیپور ببینید.",
            cars_with_filter_h1 = "آگهی های خرید و فروش {brand} {model} {bodyType} {new_used_h1} {isCertified} {paymentType} در {locationName}",

            # Shops List
            shops_list_title = "فروشگاه اینترنتی؛ آگهی‌های خرید و فروش در {locationName} - شیپور",
            shops_list_description = "اگر به دنبال خرید و فروش خانه، آپارتمان، خودرو و ماشین یا انواع کالا و خدمات در {locationName} با قیمت مناسب هستید، از {shopCount} فروشگاه اینترنتی شیپور دیدن نمایید.",
            shops_list_h1 = "فروشگاه‌های اینترنتی {categoryName} در {locationName}",
        )
        return variables
