*** Settings ***
Resource        ..${/}..${/}resources${/}common.resource
Suite Setup      Set Suite Environment
Test Setup       start app
Test Teardown    Close test application
Test Timeout     10 minutes

*** Variables ***
${State}                               تهران
${City}                                تهران
${Region}                              آجودانیه

*** Test Cases ***
Add New Listing With Limitation And Discount
    [Tags]       Listing   Limitation
    Login to Sheypoor
    Set Listing Limit For Cat per locations                             parentid=${43612}  catid=${43614}  regid=${8}  cityid=${301}  nghid=${930}  limitcount=${0}  limitprice=${11000}
    Post Limited Listing With Discount Code In Personal Belongings
    # Get ListingID from Listing Detail And Accept
    Set Listing Limit For Cat per locations                             parentid=${43612}  catid=${43614}  regid=${8}  cityid=${301}  nghid=${930}  limitcount=${30}  limitprice=${11000}
    # Mock Listing Limit Set                                            5000    30                 لوازم شخصی       زیورآلات و ساعت


*** Keywords ***
Post Limited Listing With Discount Code In Personal Belongings
    ${Discount_Coupon}                  Create Discount Coupon                                discount=80        coupon_type=listing_limit
    Go To Post Listing Page
    Get Random Listing                  43614
    Click Category Spinner
    Input Attr
    Input Title And Decription
    Select Location                     ${State}   ${City}   ${Region}
    Submit Post Listing                 ${FALSE}   ${TRUE}
    Wait Until Page Contains            شما به سقف ۰ آگهی ${SPACE}در دوره‌ی ۳۰ روزه رسیده‌اید            timeout=10s
    Page Should Not Contain Text        ${listing_actived_approved_paid_feature_title}
    Page Should Not Contain Text        ${post_listing_paid_message_without_approved}
    ${Locator}                         Set Variable               android=UiScrollable(UiSelector().scrollable(true).instance(0)).scrollIntoView(new UiSelector().text("کد تخفیف خود را وارد کنید").instance(0))
    Input Text                         ${Locator}                 ${Discount_Coupon}
    Click Element                      ${APPLY_COUPON}
    Wait Until Page Contains           حذف کد                                                 timeout=10s
    ${Payment}                         Set Variable If            '${file_version}' > '5.3.15'            پرداخت ۲٬۳۹۸ تومان        پرداخت ۲٬۲۰۰ تومان
    Element Should Contain Text        ${APPLY_BUTTON}            ${Payment}
    ${Payment}                         Set Variable If            '${file_version}' > '5.3.15'            ۲۳,۹۸۰        ۲۲,۰۰۰
    Set Test Variable                  ${Price}                   ${Payment}
    Succes Payment From Android App
    Wait Until Page Contains           ${Title_Words}
    Element Should Contain Text        ${MY_LISTING_ITEM}          ${Title_Words}
    ${Status}       Run Keyword And Return Status       Element Should Contain Text        ${OFFER_STATUS}             ${APPROVED_MESSAGE}
    Run Keyword If          not ${Status}       Check Black List


Input Attr
    Scroll The List                    لوازم شخصی
    Scroll The List                    زیورآلات و ساعت
    Input Attribute                   قیمت (تومان)               500000
    Run Keyword And Ignore Error      Select Used New Status

Select Used New Status
    Click Spinner           وضعیت کالا
    Scroll The List         نو
