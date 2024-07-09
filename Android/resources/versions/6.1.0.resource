*** Settings ***
Resource                                        6.0.1.resource

*** Variables ***


*** Keywords ***
Validate Listing Details In Without Delivery Of Checkout
    [Arguments]                                 ${Listing_Title}        ${Listing_Price}        ${Shop_Name}        ${Number_Goods}
    Wait Until Page Contains Element            ${CHECK_OUT_NO_DELIVERY_LISTING_TITLE}
    Element Should Contain Text                 ${CHECK_OUT_NO_DELIVERY_LISTING_TITLE}            ${Listing_Title}
    ${Converted_Price}                          Convert Number To Price                           ${Listing_Price}
    Element Should Contain Text                 ${CHECK_OUT_NO_DELIVERY_LISTING_PRICE}            ${Converted_Price}${SPACE}تومان
    Page Should Contain Element                 ${CHECK_OUT_NO_DELIVERY_LISTING_IMAGE}
    Element Should Contain Text                 ${CHECK_OUT_NO_DELIVERY_SHOP_NAME}                ${Shop_Name}
    Page Should Contain Element                 ${CHECK_OUT_NO_DELIVERY_COUNT_LAYOUT}
    Element Should Contain Text                 ${CHECK_OUT_NO_DELIVERY_COUNT}            ${Number_Goods}
    Page Should Contain Element                 android=UiSelector().resourceId("${CHECK_OUT_NO_DELIVERY_PLUS_BTN}").enabled(true)
    Page Should Contain Element                 android=UiSelector().resourceId("${CHECK_OUT_NO_DELIVERY_MINUS_BTN}").enabled(false)

Validate Receipt For Step One In Checkout
    [Arguments]                                 ${Listing_Price}        ${Number_Goods}         ${Transport_Price}
    No Operation

Validate Message For Step Two With Deliver
    Element Should Contain Text                 ${CHECK_OUT_STEP_TWO_TITLE}            ${CHECK_OUT_STEP_TWO_WITH_DELIVER_TXT}
    Page Should Contain Element                 ${CHECK_OUT_DIVIDER_STEP_TWO}

Validate Receipt For Step Two In Checkout
    [Arguments]                                 ${Listing_Price}        ${Number_Goods}
    Page Should Contain Element                 android=UiScrollable(UiSelector().scrollable(true).instance(0)).scrollIntoView(new UiSelector().resourceId("${CHECK_OUT_STEP_TWO_NEXT_BTN}").text("مرحله بعدی").enabled(false))

Validate Listing Details In Step One Of Checkout
    [Arguments]                                 ${Listing_Title}        ${Listing_Price}        ${Shop_Name}        ${Number_Goods}
    Wait Until Page Contains Element            ${CHECK_OUT_LISTING_TITLE}                      timeout=10s
    Wait Until Page Contains                    ${Listing_Title}                                timeout=10s
    Element Should Contain Text                 ${CHECK_OUT_LISTING_TITLE}                      ${Listing_Title}
    Element Should Contain Text                 ${CHECK_OUT_PRODUCT_HEADER_STEP_ONE}            ${CHECK_OUT_PRODUCT_HEADER_TXT}
    ${Converted_Price}                          Convert Number To Price               ${Listing_Price}   ٬
    Element Should Contain Text                 ${CHECK_OUT_LISTING_PRICE}            ${Converted_Price}${SPACE}تومان
    Page Should Contain Element                 ${CHECK_OUT_SHOP_ICON}
    Element Should Contain Text                 ${CHECK_OUT_SHOP_NAME}                ${Shop_Name}
    Element Should Contain Text                 ${CHECK_OUT_LISTING_COUNT}            ${Number_Goods}               #  minimum yek kala ke taeen shode
    Page Should Contain Element                 android=UiSelector().resourceId("${CHECK_OUT_STEP_ONE_PLUS_BTN}").enabled(true)
    Page Should Contain Element                 android=UiSelector().resourceId("${CHECK_OUT_STEP_ONE_MINUS_BTN}").enabled(false)


Open Map To Choose Address In Checkout
    Click Element                               ${CHECKOUT_SECURE_PURCHASE_ADDRESS}
    Wait Until Page Contains Element            ${DELIVERY_ADDRESS_TOOLBAR}                     timeout=10s
    Page Should Contain Element                 ${DELIVERY_ADDRESS_ADDRESS}
    Click Element                               android=UiSelector().resourceId("${COMPONENT_EDITT_EXT}").text("انتخاب از روی نقشه")
    Wait Until Page Contains Element            ${MAP_PIN}                                      timeout=10s
    Wait Until Page Contains Element            ${MAP_MY_LOC_BTN}                               timeout=10s
    Wait Until Page Contains Element            ${CHECK_OUT_STEP_TWO_CONFIRM_LOC_BTN}           timeout=10s
    Validate Initial Location On Map

Validate Delivery Address Page
    [Arguments]                                 ${State}
    Wait Until Page Contains Element            ${PAGE_TITLE}                          timeout=10s
    Wait Until Page Contains Element            android=UiSelector().resourceId("${DELIVERY_ADRESS_SAVE_BTN}").enabled(true)                      timeout=10s
    Wait Until Page Contains                    ${State}                               timeout=10s         error="The address can not be loaded from map"
    Element Should Contain Text                 ${COMPONENT_EDITT_EXT}                 ${State}
    Page Should Contain Element                 ${DELIVERY_ADRESS_CLEAR_BTN}

Validate Address And Delivery Price In Step Two
    [Arguments]                                 ${Customer_Address_Total}               ${Delivery_Price}
    Wait Until Page Contains Element            android=UiScrollable(UiSelector().scrollable(true).instance(0)).scrollIntoView(new UiSelector().resourceId("${CHECK_OUT_STEP_TWO_NEXT_BTN}").enabled(false))
    Element Should Contain Text                 android=UiSelector().resourceId("${CHECKOUT_SECURE_PURCHASE_ADDRESS}").childSelector(new UiSelector().resourceId("${COMPONENT_EDITT_EXT}"))    ${Customer_Address_Total}


Set Delivery Time
    Click Element                               ${CHECKOUT_STEP_TWO_TIME}
    Wait Until Page Contains Element            ${TIME_OPTION_SELECT}
    ${Delivery_Date}                            Get Text                          ${TIME_OPTION_TITLE}
    ${Delivery_Time}                            Get Text                          ${TIME_OPTION_DESCRIPTION}
    Click Element                               ${TIME_OPTION_SELECT}
    Set Test Variable                           ${Delivery_Date}
    Set Test Variable                           ${Delivery_Time}
    Element Should Contain Text                android=UiSelector().resourceId("${CHECKOUT_STEP_TWO_TIME}").childSelector(new UiSelector().resourceId("${COMPONENT_EDITT_EXT}"))     ${Delivery_Date} | ${Delivery_Time}


Validate Listing Details In Step Three Of Checkout
    [Arguments]                                 ${Listing_Title}        ${Listing_Price}      ${Number_Goods}    ${Shop_Name}
    Wait Until Page Contains Element            ${CHECK_OUT_STEP_THREE_LISTING_TITLE}
    Element Should Contain Text                 ${CHECK_OUT_STEP_THREE_LISTING_TITLE}            ${Listing_Title}
    ${Converted_Price}                          Convert Number To Price                          ${Listing_Price}   ٬
    Element Should Contain Text                 ${CHECK_OUT_STEP_THREE_LISTING_PRICE}            ${Converted_Price}${SPACE}تومان
    Element Should Contain Text                 ${CHECK_OUT_STEP_THREE_SHOP_NAME}                 ${Shop_Name}
    Element Should Contain Text                 ${CHECK_OUT_STEP_THREE_COUNT_TITLE}               تعداد
    Element Should Contain Text                 ${CHECK_OUT_STEP_THREE_COUNT_TXT}                 ${Number_Goods}
    Page Should Contain Element                 ${CHECK_OUT_STEP_THREE_DIVIDER_RECIPT}
    Page Should Contain Text                    نام تحویل‌گیرنده
    Page Should Contain Text                    زمان ارسال
    Page Should Contain Text                    آدرس تحویل‌گیرنده
    Page Should Contain Text                    ${Delivery_Date} , ${Delivery_Time}
    Page Should Contain Text                    ${Customer_Address_Total}
    Page Should Contain Text                    ${Customer_Name}
    Page Should Contain Text                    نام کالا
    Page Should Contain Text                    نام فروشنده
    Swipe By Percent                            50     70     50    30  1000
    Page Should Contain Text                    با پرداخت این مبلغ شما با قوانین و مقررات شیپور موافقت کرده‌اید

Validate Receipt For Step Three In Checkout
    [Arguments]                                ${Number_Goods}     ${Listing_Price}        ${Transport_Price}
    Swipe By Percent                            50     70     50    30  1000
    Element Should Contain Text                 ${CHECK_OUT_STEP_THREE_PAYMENT_SUMMERY_COUNT_TITLE}         تعداد
    Element Should Contain Text                 ${CHECK_OUT_STEP_THREE_PAYMENT_SUMMERY_COUNT}               ${Number_Goods}${SPACE}عدد
    Element Should Contain Text                 ${CHECK_OUT_STEP_THREE_PAYMENT_SUMMERY_PRICE_TITLE}         مبلغ کالا
    ${separator_price}                          Convert Number To Price                                     ${Listing_Price}
    Element Should Contain Text                 ${CHECK_OUT_STEP_THREE_PAYMENT_SUMMERY_PRICE}               ${separator_price}${SPACE}تومان
    Element Should Contain Text                 ${CHECK_OUT_STEP_THREE_PAYMENT_SUMMERY_DELIVERY_TITLE}      هزینه ارسال
    ${separator_price}                          Convert Number To Price                                     ${Transport_Price}
    Element Should Contain Text                 ${CHECK_OUT_STEP_THREE_PAYMENT_SUMMERY_DELIVERY}            ${separator_price}${SPACE}تومان
    Element Should Contain Text                 ${CHECK_OUT_STEP_THREE_PAYMENT_SUMMERY_TOTAL_TITLE}         مبلغ کل
    ${Total_Price}                              Evaluate    (${Number_Goods} * ${Listing_Price}) + ${Transport_Price}
    ${separator_price}                          Convert Number To Price                                     ${Total_Price}
    ${Total_Price_Pay_Btn}                      Set Variable                                                ${separator_price}${SPACE}تومان
    Element Should Contain Text                 ${CHECK_OUT_STEP_THREE_PAYMENT_SUMMERY_TOTAL}               ${Total_Price_Pay_Btn}
    Element Should Contain Text                 ${CHECK_OUT_STEP_THREE_PAYMENT_CONDITIONS}                  ${CHECK_OUT_STEP_THREE_PAYMENT_CONDITIONS_TXT}
    Page Should Contain Element                 android=UiSelector().resourceId("${CHECK_OUT_STEP_THREE_PAY_BTN}").text("پرداخت${SPACE}${Total_Price_Pay_Btn}").enabled(true)

Validate Receipt For Without Delivery In Checkout
    [Arguments]                                 ${Number_Goods}     ${Listing_Price}
    Swipe By Percent                            50     70     50    30  1000
    Element Should Contain Text                 ${CHECK_OUT_NO_DELIVERY_PAYMENT_SUMMERY_COUNT_TITLE}         تعداد
    Element Should Contain Text                 ${CHECK_OUT_NO_DELIVERY_PAYMENT_SUMMERY_COUNT}               ${Number_Goods}${SPACE}عدد
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

Filter Cat
    [Arguments]                                      ${Cat}
    FOR  ${i}   IN RANGE   3
      Run Keyword And Ignore Error                   Click Element                  accessibility_id=${Cat}
      ${status}     Run Keyword And Return Status    Wait Until Page Contains       همه دسته‌های ${Cat}     timeout=15s
      Exit For Loop If    ${status}
    END
    Run Keyword Unless    ${status}                  Fail                             can not Filter Cat ${Cat}

Filter SubCat
    [Arguments]           ${SubCat}
    FOR  ${i}   IN RANGE   3
      Run Keyword And Ignore Error                   Scroll The List                 ${SubCat}
      Run Keyword And Ignore Error                   Close View Secure Purchase Popup
      ${status}                                      Run Keyword And Return Status    Wait Until Page Contains Element   id=${OfferInSerpID}    timeout=15s
      Exit For Loop If                               ${status}
    END
    Run Keyword Unless                               ${status}                 Fail    can not Filter SubCat ${SubCat}

Close View Secure Purchase Popup
    Wait Until Page Contains Element                 id=${SecurePurchase_Popup_Close_Icon}    timeout=10s
    Click Element                                    id=${SecurePurchase_Popup_Close_Icon}
