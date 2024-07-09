*** Settings ***
Resource                  5.6.2.resource

*** Variables ***


*** Keywords ***
Validate Steps Structure For Step One
    Wait Until Page Contains Element            ${PAGE_TITLE}
    Element Should Contain Text                 ${PAGE_TITLE}                    ${PURCHASE_SECURE_TEXT}
    Page Should Contain Element                 android=UiSelector().resourceId("${CHECK_OUT_INDICATOR_1}").description("${CHECK_OUT_STEPS_STATUS_IN_PROGRESS}")
    Element Should Contain Text                 ${CHECK_OUT_INDICATOR_1_NUM}            1
    Element Should Contain Text                 ${CHECK_OUT_INDICATOR_1_TITLE}          انتخاب تعداد
    Page Should Contain Element                 ${CHECK_OUT_CONNECTOR_1_2}
    Page Should Contain Element                 android=UiSelector().resourceId("${CHECK_OUT_INDICATOR_2}").description("${CHECK_OUT_STEPS_STATUS_IN_ACTIVE}")
    Element Should Contain Text                 ${CHECK_OUT_INDICATOR_2_NUM}            2
    Element Should Contain Text                 ${CHECK_OUT_INDICATOR_2_TITLE}          آدرس و زمان
    Page Should Contain Element                 ${CHECK_OUT_CONNECTOR_2_3}
    Page Should Contain Element                 android=UiSelector().resourceId("${CHECK_OUT_INDICATOR_3}").description("${CHECK_OUT_STEPS_STATUS_IN_ACTIVE}")
    Element Should Contain Text                 ${CHECK_OUT_INDICATOR_3_NUM}            3
    Element Should Contain Text                 ${CHECK_OUT_INDICATOR_3_TITLE}          پرداخت هزینه
    Page Should Contain Element                 ${CHECK_OUT_DIVIDER_STEP_ONE}

Validate Steps Structure For Step Two
    Wait Until Page Contains Element            ${PAGE_TITLE}
    Element Should Contain Text                 ${PAGE_TITLE}       ${PURCHASE_SECURE_TEXT}
    Page Should Contain Element                 android=UiSelector().resourceId("${CHECK_OUT_INDICATOR_1}").description("${CHECK_OUT_STEPS_STATUS_PASSED}")
    Page Should Not Contain Element             ${CHECK_OUT_INDICATOR_1_NUM}
    Element Should Contain Text                 ${CHECK_OUT_INDICATOR_1_TITLE}     انتخاب تعداد
    Page Should Contain Element                 ${CHECK_OUT_CONNECTOR_1_2}         #  enable
    Page Should Contain Element                 android=UiSelector().resourceId("${CHECK_OUT_INDICATOR_2}").description("${CHECK_OUT_STEPS_STATUS_IN_PROGRESS}")
    Element Should Contain Text                 ${CHECK_OUT_INDICATOR_2_NUM}           2        #  enable
    Element Should Contain Text                 ${CHECK_OUT_INDICATOR_2_TITLE}     آدرس و زمان     #         enable
    Page Should Contain Element                 ${CHECK_OUT_CONNECTOR_2_3}         #    disable
    Page Should Contain Element                 android=UiSelector().resourceId("${CHECK_OUT_INDICATOR_3}").description("${CHECK_OUT_STEPS_STATUS_IN_ACTIVE}")
    Element Should Contain Text                 ${CHECK_OUT_INDICATOR_3_NUM}           3      #   disable
    Element Should Contain Text                 ${CHECK_OUT_INDICATOR_3_TITLE}         پرداخت هزینه         #     disable
    Page Should Contain Element                 ${CHECK_OUT_DIVIDER_STEP_TWO}

Validate Steps Structure For Step Three
    Wait Until Page Contains Element            ${PAGE_TITLE}
    Element Should Contain Text                 ${PAGE_TITLE}                     ${PURCHASE_SECURE_TEXT}
    Page Should Contain Element                 android=UiSelector().resourceId("${CHECK_OUT_INDICATOR_1}").description("${CHECK_OUT_STEPS_STATUS_PASSED}")
    Page Should Not Contain Element             ${CHECK_OUT_INDICATOR_1_NUM}
    Element Should Contain Text                 ${CHECK_OUT_INDICATOR_1_TITLE}     انتخاب تعداد
    Page Should Contain Element                 ${CHECK_OUT_CONNECTOR_1_2}
    Page Should Contain Element                 android=UiSelector().resourceId("${CHECK_OUT_INDICATOR_2}").description("${CHECK_OUT_STEPS_STATUS_PASSED}")
    Page Should Not Contain Element             ${CHECK_OUT_INDICATOR_2_NUM}
    Element Should Contain Text                 ${CHECK_OUT_INDICATOR_2_TITLE}     آدرس و زمان
    Page Should Contain Element                 ${CHECK_OUT_CONNECTOR_2_3}
    Page Should Contain Element                 android=UiSelector().resourceId("${CHECK_OUT_INDICATOR_3}").description("${CHECK_OUT_STEPS_STATUS_IN_PROGRESS}")
    Element Should Contain Text                 ${CHECK_OUT_INDICATOR_3_NUM}           3
    Element Should Contain Text                 ${CHECK_OUT_INDICATOR_3_TITLE}         پرداخت هزینه
    Page Should Contain Element                 ${CHECK_OUT_DIVIDER_STEP_THREE}

Validate Listing Details In Step One Of Checkout
    [Arguments]                 ${Listing_Title}        ${Listing_Price}        ${Shop_Name}        ${Number_Goods}
    Wait Until Page Contains Element            ${CHECK_OUT_LISTING_TITLE}
    Element Should Contain Text                 ${CHECK_OUT_LISTING_TITLE}            ${Listing_Title}
    ${Converted_Price}                          Convert Number To Price               ${Listing_Price}   ٬
    Element Should Contain Text                 ${CHECK_OUT_LISTING_PRICE}            ${Converted_Price}${SPACE}تومان
    Page Should Contain Element                 ${CHECK_OUT_SHOP_ICON}
    Element Should Contain Text                 ${CHECK_OUT_SHOP_NAME}                ${Shop_Name}
    Element Should Contain Text                 ${CHECK_OUT_LISTING_COUNT}            ${Number_Goods}               #  minimum yek kala ke taeen shode
    Page Should Contain Element                 android=UiSelector().resourceId("${CHECK_OUT_STEP_ONE_PLUS_BTN}").enabled(true)
    Page Should Contain Element                 android=UiSelector().resourceId("${CHECK_OUT_STEP_ONE_MINUS_BTN}").enabled(false)


###################################    secure purchase without delivery    ####################################
Complete Secure Purchase Without Delivery In Checkout
    [Arguments]                                 ${Number_Goods}                         ${Price}
    Wait Until Page Contains Element            ${PAGE_TITLE}
    Element Should Contain Text                 ${PAGE_TITLE}                           ${PURCHASE_BUTTON_TEXT}
    Validate Listing Details In Without Delivery Of Checkout        ${Title_Words}      ${Price}        ${Shop_title}       ${Number_Goods}
    Validate Banner For Without Delivery In Checkout
    Validate Banner For Notice Without Delivery In Checkout
    Validate Receipt For Without Delivery In Checkout               ${Number_Goods}     ${Price}
    Choose Payment Button In Checkout

Validate Listing Details In Without Delivery Of Checkout
    [Arguments]                                 ${Listing_Title}        ${Listing_Price}        ${Shop_Name}        ${Number_Goods}
    Wait Until Page Contains Element            ${CHECK_OUT_NO_DELIVERY_LISTING_TITLE}
    Wait Until Page Contains                    ${Listing_Title}
    Element Should Contain Text                 ${CHECK_OUT_NO_DELIVERY_LISTING_TITLE}            ${Listing_Title}
    ${Converted_Price}                          Convert Number To Price                           ${Listing_Price}
    Element Should Contain Text                 ${CHECK_OUT_NO_DELIVERY_LISTING_PRICE}            ${Converted_Price}${SPACE}تومان
    Page Should Contain Element                 ${CHECK_OUT_NO_DELIVERY_BANNER_NOTICE_ICON}
    Page Should Contain Element                 ${CHECK_OUT_NO_DELIVERY_SHOP_ICON}
    Element Should Contain Text                 ${CHECK_OUT_NO_DELIVERY_SHOP_NAME}                ${Shop_Name}
    Page Should Contain Element                 ${CHECK_OUT_NO_DELIVERY_COUNT_LAYOUT}
    Element Should Contain Text                 ${CHECK_OUT_NO_DELIVERY_COUNT}            ${Number_Goods}
    Page Should Contain Element                 android=UiSelector().resourceId("${CHECK_OUT_NO_DELIVERY_PLUS_BTN}").enabled(true)
    Page Should Contain Element                 android=UiSelector().resourceId("${CHECK_OUT_NO_DELIVERY_MINUS_BTN}").enabled(false)

Validate Banner For Without Delivery In Checkout
    Element Should Contain Text                 ${CHECK_OUT_NO_DELIVERY_BANNER_TITLE}               ${CHECK_OUT_BANNER_TITLE_TXT}
    Element Should Contain Text                 ${CHECK_OUT_NO_DELIVERY_BANNER_DESC}                ${CHECK_OUT_BANNER_DESC_TXT}

Validate Banner For Notice Without Delivery In Checkout
    Page Should Contain Element                 ${CHECK_OUT_NO_DELIVERY_BANNER_NOTICE_ICON}
    Element Should Contain Text                 ${CHECK_OUT_NO_DELIVERY_BANNER_NOTICE}               ${CHECK_OUT_NO_DELIVERY_BANNER_NOTICE_TXT}
    Element Should Contain Text                 ${CHECK_OUT_NO_DELIVERY_BANNER_DESCRIPTION}          ${CHECK_OUT_NO_DELIVERY_BANNER_DESCRIPTION_TXT}

Validate Receipt For Without Delivery In Checkout
    [Arguments]                  ${Number_Goods}     ${Listing_Price}
    Swipe By Percent               50     70     50    30  1000
    Element Should Contain Text                 ${CHECK_OUT_NO_DELIVERY_PAYMENT_SUMMERY_TITLE}              خلاصه پرداخت

    Element Should Contain Text                 ${CHECK_OUT_NO_DELIVERY_PAYMENT_SUMMERY_COUNT_TITLE}         تعداد
    Element Should Contain Text                 ${CHECK_OUT_NO_DELIVERY_PAYMENT_SUMMERY_COUNT}               ${Number_Goods}${SPACE}کالا

    Element Should Contain Text                 ${CHECK_OUT_NO_DELIVERY_PAYMENT_SUMMERY_PRICE_TITLE}         مبلغ کالا
    ${separator_price}                          Convert Number To Price                                     ${Listing_Price}
    Element Should Contain Text                 ${CHECK_OUT_NO_DELIVERY_PAYMENT_SUMMERY_PRICE}               ${separator_price}${SPACE}تومان

    Element Should Contain Text                 ${CHECK_OUT_NO_DELIVERY_PAYMENT_SUMMERY_DELIVERY_TITLE}      هزینه ارسال
    Element Should Contain Text                 ${CHECK_OUT_NO_DELIVERY_PAYMENT_SUMMERY_DELIVERY}            توافقی با فروشنده

    Element Should Contain Text                 ${CHECK_OUT_NO_DELIVERY_PAYMENT_SUMMERY_TOTAL_TITLE}         مبلغ کل
    ${Total_Price}                              Evaluate    (${Number_Goods} * ${Listing_Price})
    ${separator_price}                          Convert Number To Price                                     ${Total_Price}
    ${Total_Price_Pay_Btn}                      Set Variable                                                ${separator_price}${SPACE}تومان
    Element Should Contain Text                 ${CHECK_OUT_NO_DELIVERY_PAYMENT_SUMMERY_TOTAL}               ${Total_Price_Pay_Btn}

    Element Should Contain Text                 ${CHECK_OUT_NO_DELIVERY_PAYMENT_CONDITIONS}                  ${CHECK_OUT_STEP_THREE_PAYMENT_CONDITIONS_TXT}

    Page Should Contain Element                 android=UiSelector().resourceId("${CHECK_OUT_NO_DELIVERY_PAY_BTN}").text("پرداخت${SPACE}${Total_Price_Pay_Btn}").enabled(true)

Choose Payment Button In Checkout
    Click Element                               ${CHECK_OUT_NO_DELIVERY_PAY_BTN}

Success Payment For Some Features
    [Arguments]          ${Tag_Type}=${EMPTY}                                     ${Tag_Price}=${0}                     ${Tax_Price}=${0}
    ...                  ${Bump_Type}=${EMPTY}                                    ${Bump_Price}=${0}
    ...                  ${All_Iran_Packge_Price}=${0}                            ${All_State_Packge_Price}=${0}

    Wait Until Page Contains           WebView Browser Tester                      timeout=20s
    Click Text                         WebView Browser Tester
    ${status}                          Run Keyword And Return Status               Wait Until Page Contains              Open with        timeout=30s
    Run Keyword If                     ${status}                                   Open Test Browser and set default
    Handle And Validate Payment Page
    Validate Items In Payment Receipt
    ...   ${Tag_Type}                  ${Tag_Price}                ${Tax_Price}    ${Bump_Type}
    ...    ${Bump_Price}              ${All_Iran_Packge_Price}     ${All_State_Packge_Price}
    Get Source
    ${ReturnApp}                       Run Keyword And Return Status               Click Element                      ${ReturnAppDesc}
    Run Keyword If                     not ${ReturnApp}                            Click Element                      ${ReturnAppText}

Handle And Validate Payment Page
    FOR   ${i}    IN RANGE    8
      ${pass}                          Run Keyword And Return Status              Wait Until Page Contains           پرداخت شما با موفقیت انجام شد         timeout=5s
      Exit For Loop If                 ${pass}
      ${status}                        Run Keyword And Return Status              Element Should Contain Text        class=android.widget.Button           پرداخت
      Run Keyword If                   ${status}                                  Click Element                      class=android.widget.Button
    END
    Run Keyword Unless                 ${pass}                                    Fail                               Payment failed.
