*** Settings ***
Resource         ..${/}..${/}resources${/}common.resource
Suite Setup      Set Suite Environment
Test Setup       start app
#Test Teardown    Close test application
Test Teardown    Close test application For Insert Photos
Test Timeout     10 minutes


*** Variables ***
${State}                                         مازندران
${City}                                          سلمان شهر
${Region}                                        جیسا

*** Test Cases ***
Add New Listing Real Estate
    [Tags]    RealEstate  Listing    Notifications
    Set Listing Limit For Cat per locations   parentid=${43603}  catid=${43606}  regid=${27}  cityid=${974}  nghid=${7946}  limitcount=${30}  limitprice=${11000}
    Go To Post Listing Page
    Get Random Listing                  43606
    Insert Photos                       1
    Click Category Spinner
    Real Estate
    Input Title And Decription
    Select Location                     ${State}   ${City}   ${Region}
    Submit Post Listing                 ${TRUE}    ${FALSE}
    Login By Mobile
    Get AdID And Accept Listing
    Check Listing Status in My Listings Page By Click NOTNOW Button
    Check Listing Title In My Listing Page
    Validate Listing Detail


*** Keywords ***
Validate Listing Detail
    FOR  ${index}  IN RANGE   3
      ${status}                              Run Keyword And Return Status     Wait Until Page Contains                  موقعیت مکانی    timeout=10s
      Exit For Loop If                       ${status}
      Click Element                          ${myAdDetailTitle}
    END
    Find Text By Swipe in loop                ${State}، ${City}، ${Region}
    Find Text By Swipe in loop                قابلیت تبدیل مبلغ رهن و اجاره
    Find Text By Swipe in loop                نوع ملک
    Find Text By Swipe in loop                آپارتمان
    Find Text By Swipe in loop                سن بنا
    Find Text By Swipe in loop                ۱۳۹۷
    Validate Real Estate Attributes
    Find Text By Swipe in loop                متراژ
    Find Text By Swipe in loop                95
    Find Text By Swipe in loop                تعداد اتاق
    Find Text By Swipe in loop                دسته‌بندی
    Find Text By Swipe in loop                املاک، رهن و اجاره خانه و آپارتمان
    Find Text By Swipe in loop                زمان ثبت
    # Find Text By Swipe in loop                شماره تماس تایید شده: ${Random_User_Mobile_A}
    Find Text By Swipe in loop                شناسه آگهی: ${listingId}
    # Find Text By Swipe in loop                تاریخ انقضاء آگهی:
    # Find Text By Swipe in loop                خرید خود را به صورت حضوری انجام دهید و پیش از آن هیچ مبلغی را واریز نکنید. همچنین از فروشنده انتقال مالکیت بگیرید.
    # Find Text By Swipe in loop                راهنمای خرید امن
    # Page Should Not Contain Text              آگهی‌های مرتبط

Real Estate
    Scroll The List        املاک
    Scroll The List        رهن و اجاره خانه و آپارتمان
    Click Spinner          نوع ملک
    Click The List         آپارتمان
    Click Spinner          سال ساخت بنا
    Click The List         ۱۳۹۷
    Select Storage Parking Elevator checkbox
    Input Attribute        متراژ    95
    Click Spinner          تعداد اتاق
    Click The List         ۲    #تعداد اتاق
    Input Attribute        رهن (تومان)         500000000
    Input Attribute        اجاره (تومان)         1500000
    Click The Switch       OFF   0

Select Storage Parking Elevator switcher
    Click The Switch       OFF   0
    Click The Switch       OFF   0
    Click The Switch       OFF   0

Select Storage Parking Elevator checkbox
    Click The Checkbox     0
    Click The Checkbox     1
    Click The Checkbox     2
