*** Settings ***
Resource        ..${/}..${/}resources${/}PaidFeatureKeywords.resource
Suite Setup      Set Suite Environment
Test Setup       start app
Test Teardown    Close test application For Insert Photos
Test Timeout     10 minutes
Documentation       در این سناریو میخواهیم بعد از تعریف بسته بامپ ، اگهی را ثبت کنیم.
...     بعد از ثبت اگهی وارد صفحه پیدفیچر شده و بسته بامپ را انتخاب می کنیم
...     در گام بعدی یک کد تخفیف در صفحه ادمین تعریف کرده که میزان ۱۰۰ درصد را اعمال کند
...     همان کد تخفیف را در صفحه پیدفیچر وارد کرده و پرداخت باید کاملا رایگان شود
...      سپس اگهی ثبت شده را در صفحه سرپ جستجو کرده و باید اگهی در سرپ باشد. سپس جزییات اگهی را در صفحه سرپ ولیدیت میکنیم


*** Variables ***
${State}                                        تهران
${State_ID}                                     8
${City}                                         ورامین
${City_ID}                                      331
${Region}                                       ${EMPTY}
${Region_ID}                                    ${EMPTY}
${Sleep_time}                                   2s
${Timeout}                                      10s

${Category}                                     خدمات و کسب و کار
${Category_ID}                                  43633
${SubCategory}                                  تعمیرات
${SubCategory_ID}                               44101
${Number_Of_Photos}                             3

${coupon_type}                                  refresh_once
${Discount}                                     100
${Bump_Type}                                    ۱ بار بروزرسانی
${Bump_ID}                                      5:1
${Bump_Packge_Price}                            5000

*** Test Cases ***
Add New Listing Repair and Buy Bump With Coupon
    [Tags]    Bump  Listing

    Check Min Accepted Version Is  5.5.0
    Set Listing Limit For Bussiness Category
    Set Packages For Bump Price
    Post A New Listing In Bussiness Category
    Select Bump Package
    Insert Coupon and Purchasing
    Back To Home Page           2
    Filter For Business Category From Home Page
    Validate Bussiness Category Listing In Serp

*** Keywords ***
Set Listing Limit For Bussiness Category
    Set Listing Limit For Cat per locations                parentid=${Category_ID}  catid=${SubCategory_ID}  regid=${State_ID}
    ...                                 cityid=${City_ID}  nghid=${Region_ID}       limitcount=${30}         limitprice=${11000}

Post A New Listing In Bussiness Category
    Post A New Listing                            ${Category_ID}        ${Number_Of_Photos}       ${Category}
    ...                  ${SubCategory}           ${State}              ${City}                   ${Region}

Insert Coupon and Purchasing
    ${Discount_Coupon}                      Create Discount Coupon      discount=${Discount}        coupon_type=${coupon_type}
    ${Locator}                              Set Variable         android=UiScrollable(UiSelector().scrollable(true).instance(0)).scrollIntoView(new UiSelector().text("کد تخفیف خود را وارد کنید"))
#    Find Text By Swipe in loop              کد تخفیف خود را وارد کنید
    Input Text                              ${Locator}                              ${Discount_Coupon}
    Click Element                           ${APPLY_COUPON}
    Wait Until Page Contains                حذف کد                                  timeout=${Timeout}
    Click The Link                          رایگان!
    Wait Until Page Contains                بروزرسانی با موفقیت انجام شد
    Click The Link                          مشاهده آگهی

Filter For Business Category From Home Page
    Filter Category For Not General Category            ${Category}              ${SubCategory}

Validate Bussiness Category Listing In Serp
    Check Listing Title In Serp   ${listingId}          ${Title_Words}           ${Category}        ${SubCategory}
    ...                           ${State}              ${City}                  ${Region}
