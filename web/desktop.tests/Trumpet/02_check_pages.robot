*** Settings ***
Documentation                               Test All Trumpet Page And Subs
Test Setup                                  Open Admin browser
Test Teardown                               Run Keywords    wait until page loading is finished    Clean Up Tests
Resource                                    ../../resources/setup.resource

*** Test Cases ***
ChecK Trumpet Sections A
  [Tags]    Trumpet
  Trumpet Users
  Trumpet Users Verification
  Trumpet Listing Search
  Trumpet Listing Moderation
  Trumpet Listing Moderation suspicious
  Trumpet Listing Moderation Reported
  Trumpet Listing Moderation Blacklisted
  Trumpet Reporting Listing Search
  Trumpet Stats Groups
  Run Keyword If	'${trumpet_prenv_id}' != 'staging'    Trumpet Stats Regions
  Trumpet Stats Moderators
  Run Keyword If	'${trumpet_prenv_id}' != 'staging'    Trumpet Stats Registers
  Trumpet Stats Reviews
  Trumpet Stats Rejects
  Trumpet Stats Sources New
  Trumpet Stats Sources Edit
  Trumpet Stats Fata
  Trumpet Stats SMSAvgDelivery
  Trumpet Setting Reason Reject
  Trumpet Filtering IP
  Trumpet Filtering Word
  Trumpet Filtering Emails
  Trumpet Filtering Mobiles
  Trumpet Admin Search
  Trumpet Admin New

*** Keywords ***
Trumpet Users
    [Tags]                                  Users   Trumpet
    #Click Link                              کاربران
    #Click Link                              جستجوی کاربران
    Go To                                   ${SERVER}/trumpet/user/search
    Wait Until Page Contains                جستجوی کاربران    timeout=10s

Trumpet Users Verification
    [Tags]                                  Users
    #Click Link                              کاربران
    #Click Link                             پیگیری کد تایید
    Go To                                   ${SERVER}/trumpet/user/verification-code
    Wait Until Page Contains               پیگیری کد تایید    timeout=10s

Trumpet Listing Search
    [Tags]                                  ListingSearch
    #Click Link                              آگهی ها
    #Click Link                              جستجوی آگهی ها
    Go To                                   ${SERVER}/trumpet/listing/search
    Wait Until Page Contains                جستجوی آگهی ها    timeout=10s

Trumpet Listing Moderation
    [Tags]                                  ListingModeration
    #Click Link                              آگهی ها
    #Click Link                              مدیریت آگهی ها
    Go To                                   ${SERVER}/trumpet/listing/moderation
    Wait Until Page Contains                مدیریت آگهی ها    timeout=10s

Trumpet Listing Moderation suspicious
    [Tags]                                  ListingSuspicious
    #Click Link                              آگهی ها
    #Click Link                              مدیریت آگهی های مشکوک
    Go To                                   ${SERVER}/trumpet/listing/moderation/suspicious
    Wait Until Page Contains                 مدیریت آگهی های مشکوک    timeout=10s

Trumpet Listing Moderation Reported
    [Tags]                                  ListingReported
    #Click Link                              آگهی ها
    #Click Link                              مدیریت آگهی های گزارش شده
    Go To                                   ${SERVER}/trumpet/listing/moderation/reported
    Wait Until Page Contains                مدیریت آگهی های گزارش شده    timeout=10s


Trumpet Listing Moderation Blacklisted
    [Tags]                                  ListingBlacklisted
    #Click Link                              آگهی ها
    #Click Link                              مدیریت آگهی های مسدود
    Go To                                   ${SERVER}/trumpet/listing/moderation/blacklisted
    Wait Until Page Contains                 مدیریت آگهی های مسدود    timeout=10s


Trumpet Reporting Listing Search
    [Tags]                                  Reporting
    #Click Link                              آگهی های گزارش شده
    #Click Link                              جستجوی آگهی های گزارش شده
    Go To                                   ${SERVER}/trumpet/reported-listing/search
    Wait Until Page Contains                 جستجوی آگهی های گزارش شده    timeout=10s

#Trumpet Stats
    #[Tags]                                  Stats
    #Go To                                   ${SERVER}/trumpet/stats

Trumpet Stats Groups
    [Tags]                                  StatsGroups
    #Click Link                              آمار و گزارش
    #Click Link                              گزارش گروهبندی‌ ها
    Go To                                   ${SERVER}/trumpet/stats/category
    Wait Until Page Contains                گزارش گروه‌بندی‌ ها   timeout=10s

Trumpet Stats Regions
    [Tags]                                  StatsRegion
    #Click Link                              آمار و گزارش
    #Click Link                             آمار استان ها
    Go To                                   ${SERVER}/trumpet/stats/region
    Wait Until Page Contains                آمار استان ها    timeout=10s

Trumpet Stats Moderators
    [Tags]                                  StatsModerators
    #Click Link                              آمار و گزارش
    #Click Link                              آمار مدیران
    Go To                                   ${SERVER}/trumpet/stats/moderator
    Wait Until Page Contains                 آمار مدیران    timeout=10s

Trumpet Stats Registers
    [Tags]                                  StatsRegisters
    #Click Link                              آمار و گزارش
    #Click Link                              آمار ثبت نام ها
    Go To                                   ${SERVER}/trumpet/stats/registers
    Wait Until Page Contains                آمار ثبت نام ها    timeout=10s

Trumpet Stats Reviews
    [Tags]                                  StatsReviews
    #Click Link                              آمار و گزارش
    #Click Link                              آمار زمان بررسی
    Go To                                   ${SERVER}/trumpet/stats/review
    Wait Until Page Contains                آمار زمان بررسی    timeout=10s

Trumpet Stats Rejects
    [Tags]                                  StatsRejects
    #Click Link                              آمار و گزارش
    #Click Link                              آمار آگهی های رد شده
    Go To                                   ${SERVER}/trumpet/stats/rejects
    Wait Until Page Contains                آمار آگهی های رد شده    timeout=10s

Trumpet Stats Sources New
    [Tags]                                  StatsSourcesNew
    #Click Link                              آمار و گزارش
    #Click Link                              آمار پلت فرم ها - آگهی جدید
    Go To                                   ${SERVER}/trumpet/stats/sources/new
    Wait Until Page Contains                آمار پلت فرم ها    timeout=10s

Trumpet Stats Sources Edit
    [Tags]                                  StatsSourcesEdit
    #Click Link                              آمار و گزارش
    #Click Link                              آمار پلت فرم ها - ویرایش شده
    Go To                                   ${SERVER}/trumpet/stats/sources/edit
    Wait Until Page Contains                آمار پلت فرم ها - ویرایش شده    timeout=10s

Trumpet Stats Fata
    [Tags]                                  StatsFata
    #Click Link                             آمار و گزارش
    #Click Link                             گزارش برای پلیس فتا
    Go To                                   ${SERVER}/trumpet/stats/fata
    Wait Until Page Contains                گزارش برای پلیس فتا    timeout=10s

Trumpet Stats SMSAvgDelivery
    [Tags]                                  StatsSMSAvgDelivery
    #Click Link                             آمار و گزارش
    #Click Link                             گزارش برای پلیس فتا
    Go To                                   ${SERVER}/trumpet/stats/SMSAvgDelivery
    Wait Until Page Contains                SMS    timeout=10s

Trumpet Setting Reason Reject
    [Tags]                                  SettingReasonReject
    #Click Link                              تنظیمات
    #Click Link                              دلیل رد یا حذف
    Go To                                   ${SERVER}/trumpet/reason/search/reject
    Wait Until Page Contains                دلیل رد یا حذف     timeout=10s

Trumpet Filtering IP
    [Tags]                                  FilteringIP
    #Click Link                              فیلترها
    #Click Link                              فیلتر آی پی ها
    Go To                                   ${SERVER}/trumpet/filter/search/ip
    Wait Until Page Contains Element        id=filters

Trumpet Filtering Word
    [Tags]                                  FilteringWord
    #Click Link                              فیلترها
    #Click Link                              فیلتر کلمات بد
    Go To                                   ${SERVER}/trumpet/filter/search/word
    Wait Until Page Contains Element        id=filters

Trumpet Filtering Emails
    [Tags]                                  FilteringEmails
    #Click Link                              فیلترها
    #Click Link                              فیلتر ایمیل ها
    Go To                                   ${SERVER}/trumpet/filter/search/email
    Wait Until Page Contains Element        id=filters

Trumpet Filtering Mobiles
    [Tags]                                  FilteringMobiles
    #Click Link                              فیلترها
    #Click Link                               فیلتر موبایل ها
    Go To                                   ${SERVER}/trumpet/filter/search/phone
    Wait Until Page Contains Element        id=filters

Trumpet Admin Search
    [Tags]                                  AdminSearch
    #Click Link                              مدیریت مدیران
    #Click Link                              جستجو
    Go To                                   ${SERVER}/trumpet/admin
    Wait Until Page Contains                 مدیران     timeout=10s

Trumpet Admin New
    [Tags]                                  AdminNew
    #Click Link                              مدیریت مدیران
    #Click Link                              مدیران جدید
    Go To                                   ${SERVER}/trumpet/admin/new
    Wait Until Page Contains                مدیر جدید     timeout=10s
