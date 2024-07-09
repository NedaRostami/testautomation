*** Settings ***
Resource        ..${/}..${/}resources${/}PaidFeatureKeywords.resource
Suite Setup      Set Suite Environment
Test Setup       start app
Test Teardown    Close test application For Insert Photos
Test Timeout     10 minutes
Documentation         در این سناریو میخواهیم بعد از تعریف تگ فوری در صفحه ادمین، اگهی را با انتخاب این تگ ثبت کنیم.
...     بعد از ثبت اگهی وارد صفحه پیدفیچر شده و بررسی می کنیم که تگ فوری با قیمت مورد نظر انتخاب شده باشد و خلاصه پرداخت و دکمه پرداخت رو چک می کنیم.
...     در گام بعدی چک باکس تگ فوری را از حالت انتخاب خارج می کنیم و بررسی می کنیم که دکمه پرداخت حذف شود و خلاصه پرداخت وجود نداشته باشد.
...     در انتها هم بررسی می کنیم که تگ فوری در صحفه جزییات اگهی نباشد.

*** Variables ***

${State}                                        البرز
${State_ID}                                     5
${City}                                         تنکمان
${City_ID}                                      224
${Region}                                       ${EMPTY}
${Region_ID}                                    ${EMPTY}
${Sleep_time}                                   2s
${Timeout}                                      10s

${Category}                                     لوازم الکترونیکی
${Category_ID}                                  43596
${SubCategory}                                  صوتی و تصویری
${SubCategory_ID}                               43601
${Sub_SubCategory}                              تلویزیون
${Sub_SubCategory_ID}                           50015
${Number_Of_Photos}                             3

${NewUsed}                                      کارکرده

${Tag_Type}                                     فوری
${Tag_ID}                                       10
${Tag_Price}                                    12500
${Tax_Price}                                    1125


*** Test Cases ***
Post Listing With Instant Tag And Remove It
    [Tags]    Instant       Listing

    Check Min Accepted Version Is  5.5.0
    Set Listing Limit For Electronic Category
    Set Packages For Instant Tag
    Post A New Listing In Electronics Category
    Validate Selected Instant Tag in Paid Feature
    UnSelect Instant Tag In Paid Feature
    Validate Unselected Instant Tag In Paid Feature
    Validate Listing Details Items Without Instant Tag


*** Keywords ***
UnSelect Instant Tag In Paid Feature
    Unselect Tag In Paid Feature              ${Tag_Type}

Validate Listing Details Items Without Instant Tag
    Check Listing Status in My Listings Page By Click NOTNOW Button
    Check Listing Title In My Listing Page
    Validate Listing Details Items       ${Category}      ${SubCategory}         ${State}        ${City}       ${Region}
    ...         NewUsed=${NewUsed}       Tag_Type=${EMPTY}
