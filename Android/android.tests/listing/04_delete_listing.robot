*** Settings ***
Resource        ..${/}..${/}resources${/}common.resource
Suite Setup      Set Suite Environment
Test Setup       start app
Test Teardown    Close test application For Insert Photos
Test Timeout     10 minutes

*** Variables ***
${State}                                        البرز
${State_ID}                                     5
${City}                                         فردیس
${City_ID}                                      1117
${Region}                                       شهرک ناز
${Region_ID}                                    6879
${Sleep_time}                                   2s
${Timeout}                                      10s

${Category}                                     خدمات و کسب و کار
${Category_ID}                                  43633
${SubCategory}                                  تعمیرات
${SubCategory_ID}                               44101
${Number_Of_Photos}                             3

${coupon_type}                                  refresh_once
${Discount}                                     100
${Bump_type}                                    ۱ بار بروزرسانی
${Bump_ID}                                      5:1
${Bump_Price}                                   ۵٬۰۰۰ تومان        #  base price for Bump for this category
${Bump_Packge_Price}                            5000

*** Test Cases ***
Delete A Listing and Active It
    [Tags]    Delete      Listing

    Check Min Accepted Version Is  5.5.0
    Post A New Listing And Check it in Serp
    Delete Listing
    Activation A Deleted listing
    Check Activated Listing in Serp


*** Keywords ***
Post A New Listing And Check it in Serp
    Set Listing Limit For Cat per locations                parentid=${Category_ID}  catid=${SubCategory_ID}  regid=${State_ID}
    ...                                 cityid=${City_ID}  nghid=${Region_ID}       limitcount=${30}         limitprice=${11000}

    Post A New Listing Without Payment                 ${Category_ID}        ${Number_Of_Photos}      ${Category}        ${SubCategory}
    ...       ${State}            ${City}               ${Region}
    Back To Home Page           1
    Filter Category For Not General Category            ${Category}              ${SubCategory}
    Check Listing Title In Serp   ${listingId}          ${Title_Words}           ${Category}        ${SubCategory}
    ...                           ${State}              ${City}                  ${Region}

Activation A Deleted listing
    Wait Until Page Contains                  فعال‌سازی
    Click The Link                            فعال‌سازی
    Wait Until Page Contains                  ویرایش آگهی
    Submit Post Listing                       ${TRUE}    ${TRUE}
    Wait Until Page Contains                  ${listing_actived_paid_feature_title}
    Click The Link                            فعلاً نه
    Wait Until Page Contains                  آگهی‌های من                               timeout=${Timeout}
    Find Text By Swipe in loop                ${Title_Words}
    Check Text In Element By Swipe In Loop    ${OFFER_STATUS}                         ${APPROVED_MESSAGE}
    Back To Home Page           1

Check Activated Listing in Serp
    Filter Category For Not General Category            ${Category}              ${SubCategory}
    Check Listing Title In Serp   ${listingId}          ${Title_Words}           ${Category}        ${SubCategory}
    ...                           ${State}              ${City}                  ${Region}
