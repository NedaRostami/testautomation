class Version:

    variables = {}

    def __init__(self):
        self.app_package = 'com.sheypoor.mobile.debug'
        self.variables.update(
            APP_PACKAGE=self.app_package,
            HOME_ACTIVITY='com.sheypoor.presentation.ui.home.HomeActivity',
            SERP_ACTIVITY='com.sheypoor.presentation.ui.serp.SerpActivity',
            # SPLASH_ACTIVITY='com.sheypoor.mobile.MainActivity',
            SPLASH_ACTIVITY='com.sheypoor.mobile.MainActivity',
            CATEGORY_HEADER=self.app_package + ':id/fragmentSerpCategory',
            OFFER_STATUS=self.app_package + ':id/myAdStatus',
            CAT_ROOT=self.app_package + ':id/root',
            FILTER_COUNT=self.app_package + ':id/fragmentSerpFilterCounter',
            FILTER_HEADER=self.app_package + ':id/fragmentSerpFilterRoot',
            OfferID=self.app_package + ':id/adapterAdDetailsTitle',
            myAdDetailTitle=self.app_package + ':id/adapterAdDetailsTitle',
            REGION_HEADER=self.app_package + ':id/toolbarRootLocation',
            SAVE_SEARCH=self.app_package + ':id/fragmentSerpSaveSearch',
            SAVE_SEARCH_ICON=self.app_package + ':id/fragmentSerpSaveSearchIcon',
            VitrinInSerpID=self.app_package + ':id/title',
            ListingFav=self.app_package + ':id/whiteToolbarFavorite',
            NEW_LISTING=self.app_package + ':id/postAdFab',
            category_spinner=self.app_package + ':id/category_spinner',
            Spinner=self.app_package + ':id/spinner',
            Text_View=self.app_package + ':id/text_view',
            Photos_Upload=self.app_package + ':id/postAdAttachImage',
            Photos_ID=self.app_package + ':id/iv_photo',
            PHOTOS_DONE=self.app_package + ':id/done',
            SINGLE_EDIT_TEXT=self.app_package + ':id/edit_text',
            COMPONENT_EDITT_EXT=self.app_package + ':id/componentEditText',
            COMPONENT_EDIT_TEXT_ERROR=self.app_package + ':id/componentEditTextError',
            COMPONENT_TEXT_VIEW_ERROR=self.app_package + ':id/componentTextViewError',
            CONVERSATION_INPUT_TEXT=self.app_package + ':id/conversation_input_text',
            CONVERSATION_ROW_MAIN=self.app_package + ':id/conversation_row_main',
            CONVERSATION_ACTION=self.app_package + ':id/conversation_action',
            OFFER_DESC=self.app_package + ':id/fragmentPostAdDesc',
            OFFER_NAME=self.app_package + ':id/fragmentPostAdTitle',
            Post_Ad_Button=self.app_package + ':id/fragmentPostAdButton',
            attribute=self.app_package + ':id/attribute_layout',
            price=self.app_package + ':id/price_layout',
            neighbourhood=self.app_package + ':id/neighbourhood_layout',
            Mail_Number=self.app_package + ':id/numberInput',
            Confirm_Digit=self.app_package + ':id/pinCodeInput',
            second_number=self.app_package + ':id/second_page_number',
            OFFER_DELETE=self.app_package + ':id/myAdDelete',
            TOOLBAR=self.app_package + ':id/toolbar',
            CUSTOM=self.app_package + ':id/custom',
            INPUT_PR_NUMBER=self.app_package + ':id/componentEditTextInput',
            STAGING_BUTTON=self.app_package + ':id/fragmentDebugStaging',
            LOGOUT_BUTTON=self.app_package + ':id/api_logout',
            LIVE_BUTTON=self.app_package + ':id/fragmentDebugLive',
            PR_BUTTON=self.app_package + ':id/fragmentDebugPr',
            WELCOME_CLOSE=self.app_package + ':id/welcome_close',
            DRAWER_BADGE=self.app_package + ':id/material_drawer_badge',
            CHAT=self.app_package + ':id/offer_chat',
            SHARE_ICON=self.app_package + ':id/whiteToolbarShare',
            SCROLL_VIEW=self.app_package + ':id/scroll_View',
            LOADINGVIEW=self.app_package + ':id/loadingView',
            SEARCH_FIELD=self.app_package + ':id/main_search_textview',
            PROFILE_SETTING=self.app_package + ':id/toolbarSettings',
            OfferInSerpID=self.app_package + ':id/adapterAdTxtTitle',
            OFFERPRICE=self.app_package + ':id/offerPrice',
            FILTER_RESULT_BTN=self.app_package + ':id/componentDialogApply',
            EDIT_TEXT='android.widget.EditText',
            SPINNER_CLASS='android.widget.FrameLayout',
            AUTOMATION_NAME='UiAutomator2',
            PLATFORM_NAME_ANDROID='Android',
            DEVICE_ORIENTATION='portrait',
            USER_SETTINGS='تنظیمات',
            TRY_AGAIN='تلاش مجدد',
            SERP_LINK='همه آگهی‌ها',
            CHAT_LINK='لیست چت‌ها',
            EXPIRED='منقضی شده',
            REJECTED='رد شده',
            WAITING='در انتظار تایید',
            LOCATION_SPINNER_DEFAULT=self.app_package + ':id/fragmentPostAdLocation',
            FAV_LINK='آگهی‌های پسندیده',
            CAR_FILTER_LIST='لیست برندها و مدل‌های خودرو',
            DELETED_MESSAGE='غیرفعال',
            LOCATION_SPINNER='تهران, تهران',
            APPROVED_MESSAGE='تایید شده',
            DELETED_ADV_MESSAGE='حذف شده',
            ADAPTER_MY_ADV=self.app_package + ':id/adapterMyAd',
            CONTACT_SUPPORT='تماس با پشتیبانی',
            LOGIN_OR_REGISTER='ورود یا ثبت ‌نام در شیپور',
            SERP_VALIDATOR='وسایل نقلیه',
            MYACCOUNT='آگهی‌های من',
            LOG_OUT='خروج از حساب کاربری',
            MY_CHATS='چت‌های من',
            SupportTEL='(021) 545-87',
            APPLY_BUTTON=self.app_package + ':id/button',
            MY_LISTING_ITEM=self.app_package + ':id/myAdTitle',
            APPLY_COUPON=self.app_package + ':id/fragmentPaidFeaturesCouponButton',
            ReturnAppText='android=UiScrollable(UiSelector().scrollable(true).instance(0)).scrollIntoView(new UiSelector().text("بازگشت به برنامه"))',
            ReturnAppDesc='android=UiScrollable(UiSelector().scrollable(true).instance(0)).scrollIntoView(new UiSelector().description("بازگشت به برنامه"))',
            dialogButton=self.app_package + ':id/dialogButtonFirst',
            MAIN_MENU=self.app_package + ':id/toolbarRootMenu',
            Location_Popup=self.app_package + ':id/changeText',
            IMG_HOLDER='com.android.documentsui:id/icon_mime_sm',
            OPEN_OS_FILES='accessibility_id=Show roots',
            ALERT_TITLE=self.app_package + ':id/alertTitle',
            SEARCH_ROOT_HINT=self.app_package + ':id/toolbarRootHint',
            USER_NAME=self.app_package + ':id/nameText',
            USER_EDIT_PROFILE=self.app_package + ':id/editProfileText',
            USER_MOBILE=self.app_package + ':id/mobileText',
            TOOLBAR_BACK=self.app_package + ':id/toolbarBack',
            PAGE_TITLE=self.app_package + ':id/toolbarTitle',
            FILTER_BUTTON=self.app_package + ':id/fragmentFilterButton',
            MORE_INFO_DESC=self.app_package + ':id/adapterMoreInfoDescription',
            PLAIN_BUTTON=self.app_package + ':id/plainFirstButton',
            CLEAR_FORM=self.app_package + ':id/toolbarClearForm',
            PAGE_TITLE_TEXT=f'android=UiSelector().resourceId("{self.app_package}:id/toolbarTitle")' + '.text("{}")',
            NPS_POPUP=self.app_package + ':id/cardView',
            AD_DETAILS_PAGE=self.app_package + ':id/adDetailsViewPager',
            AD_DETAILS_LOADING = self.app_package + ':id/adDetailsLoading',
            TOOLBAR_APP_VERSION = self.app_package + ':id/versionText',
            SERP_TAB_LAYOUT_TEXT = self.app_package + ':id/tablayoutCustomTitleTextView',
            TOOLBAR_CHAT_ICON = self.app_package + ':id/toolbarRootChat',
            MY_CHAT_FILTER = self.app_package + ':id/myChatsFilterTextView',
            CHAT_ITEMS = self.app_package + ':id/adapterMyChat',
            CHAT_ITEM_MSG = self.app_package + ':id/myChatLastMessage',
            CHAT_ITEM_NICKNAME = self.app_package + ':id/myChatNickname',
            CHAT_ITEM_STATUS = self.app_package + ':id/myChatStatus',
            CHAT_ROOM_MSG = self.app_package + ':id/messageText',
            CHAT_ATTACHMENT_BOTTOM_POPUP = self.app_package + ':id/attachmentKeyboard',
            CHAT_ROOM_MAP = self.app_package + ':id/map',
            CHAT_ROOM_IMG = self.app_package + ':id/messageImage',
            CHAT_ROOM_IMG_CHECKBOX = self.app_package + ':id/adapterChatGalleryImageCheckBox',
            CHAT_ROOM_IMG_PROGRESS = self.app_package + ':id/messageImageProgress',
            CHAT_ROOM_TOOLBAR_MORE = self.app_package + ':id/toolbarMore',
            CHAT_ROOM_BLOCKED = self.app_package + ':id/blockedView',
            CHAT_ROOM_UNBLOCKE_BTN = self.app_package + ':id/unblockUser',
            HORIZONTAL_LOADING_PROGRESS = self.app_package + ':id/loadingIndicator',
        )

    @staticmethod
    def not_found():
        raise Exception('Could not find requested version')


class V5_0_2(Version):

    def __init__(self):
        super().__init__()
        self.variables.update(
            LOCATION_SPINNER_LOCATOR=f'android=UiScrollable(UiSelector().scrollable(true).instance(0)).scrollIntoView(new UiSelector().resourceId("{self.app_package}:id/fragmentPostAdLocation").childSelector(new UiSelector().className("android.widget.FrameLayout")))',
            PHONE_GALLEY_ADD_IMAGE_BTN='accessibility_id=List view',
        )
class V5_0_3(V5_0_2):

    def __init__(self):
        super().__init__()
        self.variables.update(
            SAVE_SEARCH=self.app_package + ':id/serpSaveSearch',
            SAVE_SEARCH_ICON=self.app_package + ':id/saveSearchIcon',
            TOTAL_NUMBER_ID=self.app_package + ':id/totalNumberText',
            TOTAL_NUMBER_TEXT=f'android=UiScrollable(UiSelector().scrollable(true).instance(0)).scrollIntoView(new UiSelector().resourceId("{self.app_package}:id/totalNumberText"))',
        )

class V5_0_4(V5_0_3):

    def __init__(self):
        super().__init__()

class V5_1_0(V5_0_4):

    def __init__(self):
        super().__init__()
        self.variables.update(
            myAdDetailTitle=self.app_package + ':id/myAdTitle',
            myAdImage=self.app_package + ':id/myAdImage',
            OFFER_STATUS=self.app_package + ':id/myAdStatus',
            dialogButton=self.app_package + ':id/dialogFirstButton',
        )

class V5_1_1(V5_1_0):
    def __init__(self):
        super().__init__()

class V5_1_2(V5_1_1):
    def __init__(self):
        super().__init__()

class V5_2_0(V5_1_2):

    def __init__(self):
        super().__init__()
        self.variables.update(
            LeadsAndViewsHeaderDown=self.app_package + ':id/adapterLeadsAndViewsHeaderDown',
            adapterLeadsAndViewsHeaderUp=self.app_package + ':id/adapterLeadsAndViewsHeaderUp',
        )

class V5_2_1(V5_2_0):

    def __init__(self):
        super().__init__()

class V5_2_2(V5_2_1):
    def __init__(self):
        super().__init__()

class V5_2_3(V5_2_2):
    def __init__(self):
        super().__init__()
        self.variables.update(
            IMG_HOLDER=self.app_package + ':id/postAddGalleryImageThumbnailImageView',
            OPEN_OS_FILES=self.app_package + ':id/toolbarOpenGallery',
            PHONE_GALLEY_ADD_IMAGE_BTN=self.app_package + ':id/phoneGalleryAdButton',
        )

class V5_3_0(V5_2_3):
    def __init__(self):
        super().__init__()

class V5_3_15(V5_3_0):
    def __init__(self):
        super().__init__()

class V5_3_16(V5_3_15):
    def __init__(self):
        super().__init__()

class V5_4_0(V5_3_16):
    def __init__(self):
        super().__init__()
        self.variables.update(
            IMG_HOLDER=self.app_package + ':id/postAddGalleryImageConstraintLayout',
            IMAGE_CHECKBOX=self.app_package + ':id/postAddGalleryImageCheckBox',
            LOADED_LISTING_IMAGE=self.app_package + ':id/adapterPostAdCaptureText',
            OFFER_DELETE=self.app_package + ':id/myAdDeleteButton',
            LOCATION_HEADER_TITLE=self.app_package + ':id/adapterLocationHeaderTitle',
            LOCATION_AUTO_FINDER=self.app_package + ':id/adapterLocationHeaderAutomaticFinder',
            ALL_LOCATIONS_TITLE=self.app_package + ':id/adapterAllLocationsTitle',
        )

class V5_4_1(V5_4_0):
    def __init__(self):
        super().__init__()
        self.variables.update(
            CATEGORY_TOP_FILTER=self.app_package + ':id/adapterTopFilter',
            DELETE_LISTING_BTN=self.app_package + ':id/deleteAdActionButton',
            DELETE_LISTING_BTN_TXT='حذف'
        )

class V5_5_0(V5_4_1):
    def __init__(self):
        super().__init__()
        self.variables.update(
            PAID_FEATURE_BTN_TXT='افزایش بازدید',
            STATISTICS_BTN_TXT='آمار بازدید',
            PAID_FEATURE_BUMP_TXT='بروزرسانی',
            PAID_FEATURE_Vitrin_TXT='ویترین + بروزرسانی',
            PAID_FEATURE_RECYCLER_VIEW=self.app_package + ':id/fragmentPaidFeaturesRecyclerView',
            PAID_FEATURE_BUMP_PRICE=self.app_package + ':id/bumpPrice',
            PAID_FEATURE_TITLE_TXT_VIEW=self.app_package + ':id/paidFeatureTitleTextView',
            PAID_FEATURE_PRICE_TXT_VIEW=self.app_package + ':id/paidFeaturePriceTextView',
            PAID_FEATURE_TITLE_VIEW=self.app_package + ':id/title',
            PAID_FEATURE_VALUE_VIEW=self.app_package + ':id/value',
            PAID_FEATURE_PACKEGE_SHEET_TITLE=self.app_package + ':id/bottomSheetTitle',
            PAID_FEATURE_PACKEGE_OPTION_TITLE=self.app_package + ':id/optionTitle',
            PAID_FEATURE_PACKEGE_OPTION_PRICE=self.app_package + ':id/optionPrice',
            PAID_FEATURE_ALL_IRAN_TXT='نمایش آگهی در همه‌ی ایران',
            PAID_FEATURE_ALL_STATE_TXT='نمایش آگهی در همه‌ی استان',
            PAID_FEATURE_ALL_TXT='نمایش آگهی سراسری',
            PAID_FEATURE_PAYMENT_SUMMERY_TXT='خلاصه پرداخت',
            PAID_FEATURE_TAX_TXT='مالیات بر ارزش افزوده (۹٪)',
            PAID_FEATURE_TOTAL_PRICE_TXT='مبلغ کل',
            RECEIPT_TOTAL_PRICE_TXT='مبلغ کل با احتساب مالیات',
            RECEIPT_TAX_TXT='مالیات و عوارض بر ارزش افزوده',
            SEARCH_BAR=self.app_package + ':id/toolbarSearchBarInput',
            SERP_FILTER_BUTTON=self.app_package + ':id/serpFilter',
            SERP_LISTING_LOCATION=self.app_package + ':id/adapterAdLocation',
            FILTER_SORTS_TITLE=self.app_package + ':id/fragmentFilterSortsTitle',
            FITLER_LOCATION_SPINNER=self.app_package + ':id/fragmentFilterLocation',
            FITLER_LOCATION_REGION_SELECT_BTN=self.app_package + ':id/districtSelectChooseAll',
            FITLER_LOCATION_REGION=self.app_package + ':id/fragmentFilterDistrict',
            FITLER_LOCATION_REGION_TEXT=self.app_package + ':id/componentTextView',
            FITLER_BTN=self.app_package + ':id/fragmentFilterButton',
            LISTING_DETAILS_PRICE=self.app_package + ':id/adapterAdDetailsPrice',
            LISTING_DETAILS_DESC=self.app_package + ':id/adapterAdDetailsDescription',
            LISTING_DETAILS_ID=self.app_package + ':id/adapterAdDetailsAdId',
            LISTING_DETAILS_EXPIRE_DATE=self.app_package + ':id/adapterAdDetailsExpirationDate',
            LISTING_DETAILS_CHIP_DIS_TAG=self.app_package + ':id/chipDiscountTitle',
            LISTING_DETAILS_TITLE=self.app_package + ':id/adapterAdDetailsTitle',
            LISTING_DETAILS_FIELD_TITLE=self.app_package + ':id/attributeTitle',
            LISTING_DETAILS_FIELD_VALUE=self.app_package + ':id/attributeValue',
            LISTING_DETAILS_SUBMIT_DATE=self.app_package + ':id/adapterAdDetailsDate',
            LISTING_DETAILS_CATEGORY=self.app_package + ':id/adapterAdDetailsCategory',
            TEXT_CLASS_NAME='android.widget.TextView',
            LISTING_DETAILS_CHAT_BTN=self.app_package + ':id/adDetailsChat',
            LISTING_DETAILS_CALL_BTN=self.app_package + ':id/adDetailsCall',
            SERP_FILTER_BOTTOM_POPUP=self.app_package + ':id/design_bottom_sheet',
            SERP_LISTING_PRICE=self.app_package + ':id/adapterAdPriceTextView',
        )

class V5_6_0(V5_5_0):
    def __init__(self):
        super().__init__()
        self.variables.update(
            LISTING_STATUS_SERP=self.app_package + ':id/adStatus',
            POST_ICON=self.app_package + ':id/adStatusImage',
            SECURE_PURCHASE_ICON=self.app_package + ':id/adapterAdTitleBadge',
            SECURE_PURCHASE_BADGE_ICON=self.app_package + ':id/adBadgeIcon',
            SECURE_PURCHASE_BADGE_TITLE=self.app_package + ':id/adBadgeTitle',
            SECURE_PURCHASE_BADGE_TITLE_TXT='خرید امن',
            PURCHASE_BUTTON=self.app_package + ':id/adDetailsNewSecurePurchase',
            PURCHASE_BANNER_CARD=self.app_package + ':id/adapterAdDetailsTopBannerCard',
            PURCHASE_BUTTON_TEXT='خرید',
            PURCHASE_SECURE_TEXT='خرید اینترنتی',
            TOP_BANNER_ICON=self.app_package + ':id/adapterAdDetailsTopBannerIcon',
            TOP_BANNER_TITLE=self.app_package + ':id/adapterAdDetailsTopBannerTitle',
            TOP_BANNER_TITLE_TXT='ضمانت بازگشت وجه پرداختی',
            TOP_BANNER_DESC=self.app_package + ':id/adapterAdDetailsTopBannerDescription',
            TOP_BANNER_DESC_TXT='هزینه این کالا را پرداخت کنید، اگر کالای دریافتی با مشخصات آگهی مطابقت نداشت، مبلغ پرداختی را به حسابتان بازمی‌گردانیم.',
            TOP_BANNER_LINK=self.app_package + ':id/adapterAdDetailsTopBannerLink',
            SECURE_PURCHASE_ICONS_OLD=self.app_package + ':id/badgeImage',
            LISTING_DETAILS_COST_TITLE=self.app_package + ':id/adapterAdDetailsDeliveryTimeCostTitle',
            LISTING_DETAILS_COST_TITLE_TXT=self.app_package + ':id/deliveryTimeCostTitle',
            LISTING_DETAILS_CURRENCY_TITLE_TXT=self.app_package + ':id/deliveryTimeCostCurrency',
            LISTING_DETAILS_COST_PRICE_CITY=self.app_package + ':id/deliveryTimeCostPrice',
            LISTING_DETAILS_COST_PRICE_STATE=self.app_package + ':id/deliveryTimeCostPrice',
            LISTING_DETAILS_COST_PRICE_COUNTRY=self.app_package + ':id/deliveryTimeCostPrice',
            LISTING_DETAILS_SHOP_NAME=self.app_package + ':id/adapterAdDetailsShopInfoName',
            LISTING_DETAILS_SHOP_NUMBER=self.app_package + ':id/adapterAdDetailsPhoneNumber',
            LISTING_DETAILS_REPORT_BUTTON=self.app_package + ':id/adapterAdDetailsReport',
            CHECK_OUT_INDICATOR_1=self.app_package + ':id/indicatorStepOne',
            CHECK_OUT_INDICATOR_1_NUM=self.app_package + ':id/indicatorStepOneNumber',
            CHECK_OUT_INDICATOR_1_TITLE=self.app_package + ':id/indicatorStepOneTitle',
            CHECK_OUT_INDICATOR_2=self.app_package + ':id/indicatorStepTwo',
            CHECK_OUT_INDICATOR_2_NUM=self.app_package + ':id/indicatorStepTwoNumber',
            CHECK_OUT_INDICATOR_2_TITLE=self.app_package + ':id/indicatorStepTwoTitle',
            CHECK_OUT_INDICATOR_3=self.app_package + ':id/indicatorStepThree',
            CHECK_OUT_INDICATOR_3_NUM=self.app_package + ':id/indicatorThreeNumber',
            CHECK_OUT_INDICATOR_3_TITLE=self.app_package + ':id/indicatorStepThreeTitle',
            CHECK_OUT_CONNECTOR_1_2=self.app_package + ':id/stepOneTwoConnector',
            CHECK_OUT_CONNECTOR_2_3=self.app_package + ':id/stepTwoThreeConnector',
            CHECK_OUT_DIVIDER_STEP_ONE=self.app_package + ':id/checkoutStepOneIndicatorDivider',
            CHECK_OUT_DIVIDER_TITLE=self.app_package + ':id/checkoutStepTwoTitleDivider',
            CHECK_OUT_LISTING_TITLE=self.app_package + ':id/checkoutStepOneTitleTextView',
            CHECK_OUT_LISTING_PRICE=self.app_package + ':id/checkoutStepOnePriceTextView',
            CHECK_OUT_SHOP_ICON=self.app_package + ':id/checkoutStepOneShopIconImageView',
            CHECK_OUT_SHOP_NAME=self.app_package + ':id/checkoutStepOneShopNameTextView',
            CHECK_OUT_LISTING_COUNT=self.app_package + ':id/checkoutStepOneCountTextView',
            CHECK_OUT_INCREASE_COUNT=self.app_package + ':id/checkoutStepOneAvatarIncreaseCountImageButton',
            CHECK_OUT_DECREASE_COUNT=self.app_package + ':id/checkoutStepOneAvatarDecreaseCountImageButton',
            CHECK_OUT_BANNER_TITLE=self.app_package + ':id/checkoutStepOneBannerTitleTextView',
            CHECK_OUT_BANNER_TITLE_TXT='ضمانت بازگشت وجه',
            CHECK_OUT_BANNER_DESC=self.app_package + ':id/checkoutStepOneBannerDescriptionTextView',
            CHECK_OUT_BANNER_DESC_TXT='اگر کالای خریداری شده با مشخصات آگهی مطابقت نداشت، مبلغ پرداختی را به حسابتان باز‌می‌گردانیم.',
            CHECK_OUT_STEPS_PRICE_TITLE_TXT='مبلغ کالا',
            CHECK_OUT_STEPS_DELIVER_PRICE_TITLE_TXT='هزینه ارسال',
            CHECK_OUT_STEP_ONE_PRICE_TITLE=self.app_package + ':id/checkoutStepOneBottomPriceTitleTextView',
            CHECK_OUT_STEP_ONE_PLUS_BTN=self.app_package + ':id/checkoutStepOneIncreaseCountImageButton',
            CHECK_OUT_STEP_ONE_MINUS_BTN=self.app_package + ':id/checkoutStepOneDecreaseCountImageButton',
            CHECK_OUT_STEP_ONE_DELIVER_PRICE_TITLE=self.app_package + ':id/checkoutStepOneDeliverPriceTitleTextView',
            CHECK_OUT_STEP_ONE_TOTAL_PRICE=self.app_package + ':id/checkoutStepOneTotalPriceTextView',
            CHECK_OUT_STEP_ONE_DELIVER_PRICE=self.app_package + ':id/checkoutStepOneDeliverPriceTextView',
            CHECK_OUT_STEP_ONE_NEXT_BTN=self.app_package + ':id/checkoutStepOneNextButton',
            CHECK_OUT_DIVIDER_STEP_TWO=self.app_package + ':id/checkoutStepOneIndicatorDivider',
            CHECK_OUT_STEP_TWO_TITLE=self.app_package + ':id/checkoutStepTwoTitleTextView',
            CHECK_OUT_STEP_TWO_WITH_DELIVER_TXT='برای محاسبه هزینه ارسال، نام و آدرس را وارد کنید.',
            CHECK_OUT_STEP_TWO_PRICE_TITLE=self.app_package + ':id/checkoutStepTwoBottomPriceTitleTextView',
            CHECK_OUT_STEP_TWO_DELIVER_PRICE_TITLE=self.app_package + ':id/checkoutStepTwoDeliverPriceTitleTextView',
            CHECK_OUT_STEP_TWO_TOTAL_PRICE=self.app_package + ':id/checkoutStepTwoTotalPriceTextView',
            CHECK_OUT_STEP_TWO_DELIVER_PRICE=self.app_package + ':id/checkoutStepTwoDeliverPriceTextView',
            CHECK_OUT_STEP_TWO_NEXT_BTN=self.app_package + ':id/checkoutStepTwoNextButton',
            CHECK_OUT_STEP_TWO_CONFIRM_LOC_BTN=self.app_package + ':id/placeChosenButton',
            CHECK_OUT_RECEIVER_NAME_TITLE=self.app_package + ':id/componentEditTextTitle',
            CHECK_OUT_RECEIVER_NAME_TITLE_TXT='نام تحویل‌گیرنده',
            CHECK_OUT_RECEIVER_ADDRESS_TITLE=self.app_package + ':id/componentTextViewTitle',
            CHECK_OUT_RECEIVER_ADDRESS_TITLE_TXT='آدرس تحویل‌گیرنده',
            DELIVERY_ADRESS_SAVE_BTN=self.app_package + ':id/deliveryAddressSaveButton',
            DELIVERY_ADRESS_STATE_TEXT=self.app_package + ':id/componentTextView',
            DELIVERY_ADRESS_CLEAR_BTN=self.app_package + ':id/componentTextViewClear',
            DELIVERY_ADRESS_HOUSE_NUM=self.app_package + ':id/deliveryAddressHouseNumber',
            DELIVERY_ADRESS_UNIT_NUM=self.app_package + ':id/deliveryAddressUnitNumber',
            CHECKOUT_SECURE_PURCHASE_ADDRESS=self.app_package + ':id/componentTextViewRoot',
            CHECKOUT_SECURE_PURCHASE_ADDRESS_TXT=self.app_package + ':id/componentTextView',
            DELIVERY_ADRESS_EDIT_TXT_CLEAR=self.app_package + ':id/componentEditTextClear',
            DELIVERY_ADRESS_INPUT_ADD=self.app_package + ':id/inputConstraintLayout',
            CHECK_OUT_DIVIDER_STEP_THREE=self.app_package + ':id/checkoutStepThreeIndicatorDivider',
            CHECK_OUT_STEP_THREE_PAY_BTN=self.app_package + ':id/checkoutStepThreePayButton',
            CHECK_OUT_STEP_THREE_LISTING_TITLE=self.app_package + ':id/checkoutStepThreeTitleTextView',
            CHECK_OUT_STEP_THREE_LISTING_PRICE=self.app_package + ':id/checkoutStepThreePriceTextView',
            CHECK_OUT_STEP_THREE_SHOP_ICON=self.app_package + ':id/checkoutStepThreeShopIconImageView',
            CHECK_OUT_STEP_THREE_SHOP_NAME=self.app_package + ':id/checkoutStepThreeShopNameTextView',
            CHECK_OUT_STEP_THREE_COUNT_TITLE=self.app_package + ':id/checkoutStepThreeCountTitleTextView',
            CHECK_OUT_STEP_THREE_COUNT_TXT=self.app_package + ':id/checkoutStepThreeCountTextView',
            CHECK_OUT_STEP_THREE_DIVIDER_RECIPT=self.app_package + ':id/checkoutStepThreeRecipientTopDivider',
            CHECK_OUT_STEP_THREE_CUSTOMER_TITLE=self.app_package + ':id/checkoutStepThreeRecipientNameTitleTextView',
            CHECK_OUT_STEP_THREE_CUSTOMER_NAME=self.app_package + ':id/checkoutStepThreeRecipientNameTextView',
            CHECK_OUT_STEP_THREE_CUSTOMER_ADD_TITLE=self.app_package + ':id/checkoutStepThreeRecipientAddressTitleTextView',
            CHECK_OUT_STEP_THREE_CUSTOMER_ADD=self.app_package + ':id/checkoutStepThreeRecipientAddressTextView',
            CHECK_OUT_STEP_THREE_PAYMENT_SUMMERY_TITLE=self.app_package + ':id/checkoutStepThreeSummeryTitleTextView',
            CHECK_OUT_STEP_THREE_PAYMENT_SUMMERY_COUNT_TITLE=self.app_package + ':id/checkoutStepThreeSummeryCountTitleTextView',
            CHECK_OUT_STEP_THREE_PAYMENT_SUMMERY_COUNT=self.app_package + ':id/checkoutStepThreeSummeryCountTextView',
            CHECK_OUT_STEP_THREE_PAYMENT_SUMMERY_PRICE_TITLE=self.app_package + ':id/checkoutStepThreeSummeryPriceTitleTextView',
            CHECK_OUT_STEP_THREE_PAYMENT_SUMMERY_PRICE=self.app_package + ':id/checkoutStepThreeSummeryPriceTextView',
            CHECK_OUT_STEP_THREE_PAYMENT_SUMMERY_DELIVERY_TITLE=self.app_package + ':id/checkoutStepThreeSummeryDeliveryPriceTitleTextView',
            CHECK_OUT_STEP_THREE_PAYMENT_SUMMERY_DELIVERY=self.app_package + ':id/checkoutStepThreeSummeryDeliveryPriceTextView',
            CHECK_OUT_STEP_THREE_PAYMENT_SUMMERY_TOTAL_TITLE=self.app_package + ':id/checkoutStepThreeSummeryTotalPriceTitleTextView',
            CHECK_OUT_STEP_THREE_PAYMENT_SUMMERY_TOTAL=self.app_package + ':id/checkoutStepThreeSummeryTotalPriceTextView',
            CHECK_OUT_STEP_THREE_PAYMENT_CONDITIONS=self.app_package + ':id/checkoutStepThreeTermsConditionsTextView',
            CHECK_OUT_STEP_THREE_PAYMENT_CONDITIONS_TXT='با پرداخت این مبلغ شما با قوانین و مقررات شیپور موافقت کرده‌اید',
            INPUT_EDIT_TXT=self.app_package + ':id/componentEditTextInput',
            MAP_PIN=self.app_package + ':id/markerImageView',
            MAP_MY_LOC_BTN=self.app_package + ':id/myLocationButton',
            PAGE_SUB_TITLE=self.app_package + ':id/toolbarSubtitle',
            CHAT_STATUS_ICON=self.app_package + ':id/statusIcon',
            CHAT_MESSAGE_TIME=self.app_package + ':id/messageTime',
            CHAT_MESSAGE_TEXT=self.app_package + ':id/messageText',
            CHAT_MESSAGE_TEXT_VALUE='پرداخت توسط خریدار انجام شد.',
            CHAT_SEND_BTN=self.app_package + ':id/chatSendButton',
            CHAT_CAMERA_BTN=self.app_package + ':id/chatCameraButton',
            CHAT_TEXT_EDIT=self.app_package + ':id/chatTextEdit',
            GENERAL_BTN_CHAT_PAGE=self.app_package + ':id/button',
            PAGE_IMAGE=self.app_package + ':id/toolbarImage',
            PAGE_CALL=self.app_package + ':id/toolbarCall',
            CHAT_RATING_POPUP=self.app_package + ':id/chatRatingLayout',
            CHAT_RATE_TO_SELLER_BTN=self.app_package + ':id/chatRatingAcceptButton',
            PAGE_SUB_TITLE_TEXT=f'android=UiSelector().resourceId("{self.app_package}:id/toolbarSubtitle")' + '.text("{}")',
            MAIN_RATING_STARS=self.app_package + ':id/ratingBar',
            DETAILED_RATING_STARS=self.app_package + ':id/adapterRateRatingBar',
            RATING_COMMENT_INPUT=self.app_package + ':id/componentEditTextInput',
            SUBMIT_RATE_BTN=self.app_package + ':id/rateSubmitButton',
            SUPPORT_MSG_SEND_BTN=self.app_package + ':id/messageSend',

        )

class V5_6_1(V5_6_0):
    def __init__(self):
        super().__init__()

class V5_6_2(V5_6_1):
    def __init__(self):
        super().__init__()

class V5_7_0(V5_6_2):
    def __init__(self):
        super().__init__()
        self.variables.update(
            CHECK_OUT_STEPS_STATUS_IN_PROGRESS='inProgress',
            CHECK_OUT_STEPS_STATUS_IN_ACTIVE='inActive',
            CHECK_OUT_STEPS_STATUS_PASSED='passed',
            GENERAL_BTN_CHAT_PAGE=self.app_package + ':id/securePurchaseButton',
            CHECK_OUT_NO_DELIVERY_LISTING_TITLE=self.app_package + ':id/paymentCheckoutTitleTextView',
            CHECK_OUT_NO_DELIVERY_LISTING_PRICE=self.app_package + ':id/paymentCheckoutPriceTextView',
            CHECK_OUT_NO_DELIVERY_LISTING_IMAGE=self.app_package + ':id/paymentCheckoutAvatarImageView',
            CHECK_OUT_NO_DELIVERY_SHOP_ICON=self.app_package + ':id/paymentCheckoutShopIconImageView',
            CHECK_OUT_NO_DELIVERY_SHOP_NAME=self.app_package + ':id/paymentCheckoutShopNameTextView',
            CHECK_OUT_NO_DELIVERY_COUNT_LAYOUT=self.app_package + ':id/paymentCheckoutCountLayout',
            CHECK_OUT_NO_DELIVERY_COUNT=self.app_package + ':id/paymentCheckoutCountTextView',
            CHECK_OUT_NO_DELIVERY_PLUS_BTN=self.app_package + ':id/paymentCheckoutIncreaseCountImageButton',
            CHECK_OUT_NO_DELIVERY_MINUS_BTN=self.app_package + ':id/paymentCheckoutDecreaseCountImageButton',
            CHECK_OUT_NO_DELIVERY_BANNER_TITLE=self.app_package + ':id/paymentCheckoutBannerTitleTextView',
            CHECK_OUT_NO_DELIVERY_BANNER_DESC=self.app_package + ':id/paymentCheckoutBannerDescriptionTextView',
            CHECK_OUT_NO_DELIVERY_BANNER_NOTICE_ICON=self.app_package + ':id/paymentCheckoutDeliveryBannerTitleImageView',
            CHECK_OUT_NO_DELIVERY_BANNER_NOTICE=self.app_package + ':id/paymentCheckoutDeliveryBannerTitleTextView',
            CHECK_OUT_NO_DELIVERY_BANNER_NOTICE_TXT='ارسال این کالا به عهده فروشنده است، با فروشنده هماهنگی‌های لازم برای ارسال را انجام دهید.',
            CHECK_OUT_NO_DELIVERY_PAYMENT_SUMMERY_TITLE=self.app_package + ':id/paymentCheckoutSummeryTitleTextView',
            CHECK_OUT_NO_DELIVERY_PAYMENT_SUMMERY_COUNT_TITLE=self.app_package + ':id/paymentCheckoutSummeryCountTitleTextView',
            CHECK_OUT_NO_DELIVERY_PAYMENT_SUMMERY_COUNT=self.app_package + ':id/paymentCheckoutSummeryCountTextView',
            CHECK_OUT_NO_DELIVERY_PAYMENT_SUMMERY_PRICE_TITLE=self.app_package + ':id/paymentCheckoutSummeryPriceTitleTextView',
            CHECK_OUT_NO_DELIVERY_PAYMENT_SUMMERY_PRICE=self.app_package + ':id/paymentCheckoutSummeryPriceTextView',
            CHECK_OUT_NO_DELIVERY_PAYMENT_SUMMERY_DELIVERY_TITLE=self.app_package + ':id/paymentCheckoutSummeryDeliveryPriceTitleTextView',
            CHECK_OUT_NO_DELIVERY_PAYMENT_SUMMERY_DELIVERY=self.app_package + ':id/paymentCheckoutSummeryDeliveryPriceTextView',
            CHECK_OUT_NO_DELIVERY_PAYMENT_SUMMERY_TOTAL_TITLE=self.app_package + ':id/paymentCheckoutSummeryTotalPriceTitleTextView',
            CHECK_OUT_NO_DELIVERY_PAYMENT_SUMMERY_TOTAL=self.app_package + ':id/paymentCheckoutSummeryTotalPriceTextView',
            CHECK_OUT_NO_DELIVERY_PAYMENT_CONDITIONS=self.app_package + ':id/paymentCheckoutTermsConditionsTextView',
            CHECK_OUT_NO_DELIVERY_PAY_BTN=self.app_package + ':id/paymentCheckoutPayButton',
            SECURE_PURCHASE_ACTIVAITE_BTN=self.app_package + ':id/plainFirstButton',
            SECURE_PURCHASE_CLOSE_BTN=self.app_package + ':id/plainSecondButton',
            SecurePurchase_Popup_Close_Icon=self.app_package + ':id/serpIntroSliderCloseImageView',
            CHECK_OUT_STEP_THREE_COUNT_TITLE=self.app_package + ':id/checkoutStepThreeSummeryCountTitleTextView',
            CHECK_OUT_STEP_THREE_COUNT_TXT=self.app_package + ':id/checkoutStepThreeSummeryCountTextView',
            SP_Price_Input=f'android=UiSelector().description(\"قیمت\").childSelector(new UiSelector().resourceId(\"{self.app_package}:id/componentEditTextInput\"))',
            SP_Nickname_Input=f'android=UiSelector().description(\"نام و نام خانوادگی\").childSelector(new UiSelector().resourceId(\"{self.app_package}:id/componentEditTextInput\"))',
            )

class V5_8_0(V5_7_0):
    def __init__(self):
        super().__init__()

class V5_8_1(V5_8_0):
    def __init__(self):
        super().__init__()


class V5_9_0(V5_8_1):
    def __init__(self):
        super().__init__()
        # self.variables.update(
        #     CHAT_MESSAGE_TEXT_VALUE='کلیه پرداخت‌ها برای انتشار یا ارتقای آگهی شما فقط درون برنامه و سایت شیپور انجام می‌شود. لطفا از طریق پیامک یا چت برای ثبت یا تمدید آگهی وجهی پرداخت نکنید.'
        # )

class V5_9_1(V5_9_0):
    def __init__(self):
        super().__init__()
        self.variables.update(
            SAVE_SEARCH_ICON=self.app_package + ':id/fragmentSerpSaveSearchIcon',
            )

class V6_0_0(V5_9_1):
    def __init__(self):
        super().__init__()
        self.variables.update(
            SECURE_PURCHASE_FORM='برای فعال‌سازی خرید اینترنتی اطلاعات زیر را کامل کنید.',
            MY_AD_BUMP_BUTTON_TITLE=self.app_package + ':id/myAdBumpButtonTitle',
            BUMP_ITEM_TITLE=self.app_package + ':id/bumpItemTitle',
            LOADED_LISTING_IMAGE_PROGRESS=self.app_package + ':id/adapterPostAdCaptureProgress',

            )


class V6_0_1(V6_0_0):
    def __init__(self):
        super().__init__()
        self.variables.update(
            LOCATION_SPINNER_LOCATOR=f'android=UiScrollable(UiSelector().scrollable(true).instance(0)).scrollIntoView(new UiSelector().resourceId("{self.app_package}:id/fragmentPostAdLocation").childSelector(new UiSelector().className("android.widget.ImageView")))',
            )
class V6_1_0(V6_0_1):
    def __init__(self):
        super().__init__()
        self.variables.update(
            CHECK_OUT_PRODUCT_HEADER_STEP_ONE=self.app_package + ':id/checkoutStepOneProductTitleTextView',
            CHECK_OUT_DIVIDER_STEP_ONE=self.app_package + ':id/checkoutStepOneIndicator',
            CHECK_OUT_DIVIDER_STEP_TWO=self.app_package + ':id/checkoutStepTwoIndicator',
            CHECK_OUT_DIVIDER_STEP_THREE=self.app_package + ':id/checkoutStepThreeIndicator',
            CHECK_OUT_STEP_TWO_WITH_DELIVER_TXT='اطلاعات زیر را وارد کنید',
            CHECK_OUT_PRODUCT_HEADER_TXT='مشخصات کالا',
            CHECK_OUT_RECEIVER_ADDRESS_TITLE=self.app_package + ':id/componentEditText',
            CHECKOUT_STEP_TWO_TIME=self.app_package + ':id/checkoutStepTwoTimeTextView',
            TIME_OPTION_SELECT=self.app_package + ':id/timeOptionSelect',
            TIME_OPTION_TITLE=self.app_package + ':id/timeOptionTitle',
            TIME_OPTION_DESCRIPTION=self.app_package + ':id/timeOptionDescription',
            DELIVERY_ADDRESS_TOOLBAR=self.app_package + ':id/deliveryAddressToolbar',
            DELIVERY_ADDRESS_ADDRESS=self.app_package + ':id/deliveryAddressAddress',
            CHECK_OUT_STEP_THREE_LISTING_TITLE=self.app_package + ':id/checkoutStepThreeProductNameTextView',
            CHECK_OUT_STEP_THREE_LISTING_PRICE=self.app_package + ':id/checkoutStepThreeSummeryPriceTextView',
            CHECK_OUT_STEP_THREE_SHOP_NAME=self.app_package + ':id/checkoutStepThreeShopTextView',
            CHECK_OUT_STEP_THREE_DIVIDER_RECIPT=self.app_package + ':id/checkoutStepThreeProductDivider',
            CHECK_OUT_NO_DELIVERY_BANNER_DESCRIPTION=self.app_package + ':id/paymentCheckoutDeliveryBannerDescriptionTextView',
            CHECK_OUT_NO_DELIVERY_BANNER_NOTICE_TXT='ارسال توسط فروشنده',
            CHECK_OUT_NO_DELIVERY_BANNER_DESCRIPTION_TXT='با فروشنده هماهنگی‌های لازم برای ارسال را انجام دهید، در صورتی که تا 3 روز .دیگر کالا ارسال نشد مبلغ پرداختی را به حسابتان بازمی‌گردانیم',
            )

class V6_2_0(V6_1_0):
    def __init__(self):
        super().__init__()
        self.variables.update(
            LISTING_DETAILS_SHOP_NAME=self.app_package + ':id/adapterSecureTradeAdDetailsShopInfoName',
            Location_Popup=self.app_package + ':id/changedLocationLogo',
            PURCHASE_SECURE_TEXT='خرید',
            )

class V6_2_1(V6_2_0):
    def __init__(self):
        super().__init__()

class V6_3_0(V6_2_1):
    def __init__(self):
        super().__init__()

class V6_3_1(V6_3_0):
    def __init__(self):
        super().__init__()

class V6_3_2(V6_3_1):
    def __init__(self):
        super().__init__()
        self.variables.update(
            SECURE_PURCHASE_ACTIVAITE_BTN=self.app_package + ':id/secureActivationDialogFilledFirstButton',
            SECURE_PURCHASE_CLOSE_BTN=self.app_package + ':id/filledSecondButton',
            OfferInSerpID=self.app_package + ':id/adapterAdTitleTextView',
            LISTING_DETAILS_PRICE=self.app_package + ':id/adapterAdDetailsAdTag',
            SERP_LISTING_LOCATION=self.app_package + ':id/adapterAdLocationTextView',
            )

class V6_4_0(V6_3_2):
    def __init__(self):
        super().__init__()

class V6_4_1(V6_4_0):
    def __init__(self):
        super().__init__()

class V6_4_2(V6_4_1):
    def __init__(self):
        super().__init__()

class V6_5_0(V6_4_2):
    def __init__(self):
        super().__init__()
