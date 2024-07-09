*** Settings ***
Resource          ..${/}..${/}resources${/}common.resource
Suite Setup       Set Suite Environment
Test Setup       start app
#Test Teardown    Close test application
Test Teardown    Close test application For Insert Photos
Test Timeout     10 minutes

*** Variables ***
${State}                                         آذربایجان شرقی
${City}                                          تبریز
${Region}                                        ارم


*** Test Cases ***
Add New Listing Car
    [Tags]    Car   Listing   Location    Notifications
    Set Listing Limit For Cat per locations   parentid=${43626}  catid=${43627}  regid=${1}  cityid=${12}  nghid=${4510}  limitcount=${30}  limitprice=${11000}
    Login to Sheypoor
    Go To Post Listing Page
    Get Random Listing                  43978    68150   442085
    Insert Photos                       3
    Click Category Spinner
    Car Attr
    Input Title And Decription
    Select Location                     ${State}   ${City}   ${Region}
    Submit Post Listing                 ${TRUE}    ${TRUE}
    Get AdID And Accept Listing
    Check Listing Status in My Listings Page By Click NOTNOW Button
    Check Listing Title In My Listing Page



*** Keywords ***
Car Attr
    Scroll The List         وسایل نقلیه
    Scroll The List         خودرو
    Scroll The List         رنو
    Click Spinner           مدل خودرو
    Scroll The List         پارس تندر
    ${status}               Run Keyword And Return Status    Page Should Contain Text    نوع شاسی
    Run Keyword If          ${status}      Select Chasi
    Click Spinner            نقدی/اقساطی
    Scroll The List         نقدی
    Input Attribute         سال تولید (چهار رقمی)    1398
    Input Attribute         کیلومتر         1500
    Click Spinner           رنگ
    Scroll The List         سفید
    Click Spinner           گیربکس
    Scroll The List         اتوماتیک
    Click Spinner           وضعیت بدنه
    Scroll The List         دو لکه رنگ
    # Click Spinner           نوع پلاک
    # Scroll The List         ملی
    # auto car price suggest
    # Input Attribute         قیمت (تومان)               123000000
    Swipe By Percent               50     70     50    30  1000

Select Chasi
    Click Spinner           نوع شاسی
    Scroll The List         سدان (سواری)


click gps activation
    Sleep    3s
    FOR    ${INDEX}           IN RANGE    1    21
       ${status}             Run Keyword And Return Status    wait until page contains        فلسطین     timeout=1
       Exit For Loop If      ${status}
       Run Keyword Unless    ${status}    Run Keyword And Ignore Error    Click The Link    متوجه شدم
       Run Keyword Unless    ${status}    Run Keyword And Ignore Error    Click The Link    فعال‌سازی
       Run Keyword Unless    ${status}    Run Keyword And Ignore Error    Click The Link    تایید
       Run Keyword Unless    ${status}    Run Keyword And Ignore Error    Click The Link    OK
       Run Keyword Unless    ${status}    Run Keyword And Ignore Error    Click The Link    ACTIVATE
       Run Keyword Unless    ${status}    Run Keyword And Ignore Error    Click The Link    CONFIRM
       Run Keyword Unless    ${status}    Run Keyword And Ignore Error    Scroll The List   مکان یابی خودکار
    END

select company
     Click Element      android=UiScrollable(UiSelector().scrollable(true).instance(0)).scrollIntoView(new UiSelector().resourceId("${APP_PACKAGE}:id/company")))
