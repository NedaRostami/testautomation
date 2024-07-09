*** Settings ***
Resource                  5.5.0.resource

*** Variables ***


*** Keywords ***
########################################      Secure Purchase          ###############################################

Check Listing With Secure Purchase In Serp
    [Arguments]                                 ${Listing_ID}    ${Listing_Title}    ${Category}      ${SubCategory}
    ...                                         ${State}         ${City}             ${Region}
    # Check Listing Title In Serp                ${Listing_ID}      ${Listing_Title}          ${Category}      ${SubCategory}        ${State}         ${City}          ${Region}
    ${Is_in_Serp}                                Run Keyword And Return Status                Validate Listing Card In Serp
    Run Keyword Unless                           ${Is_in_Serp}
    ...                                          Add Filter To Serp                           ${Listing_Title}    ${Category}   ${SubCategory}   ${State}    ${City}   ${Region}
    ${Is_in_Serp}                                Run Keyword And Return Status                Validate Listing Card In Serp
    Run Keyword Unless                           ${Is_in_Serp}
    ...                                          Advance Search Listing Title In Serp         ${Listing_Title}

Validate Listing Card In Serp
    Element Should Contain Text                  android=UiScrollable(UiSelector().scrollable(true).instance(0)).scrollIntoView(new UiSelector().description("listing_${Listing_ID}").childSelector(new UiSelector().resourceId("${OfferInSerpID}")))             ${Listings_title}
    Element Should Contain Text                  android=UiScrollable(UiSelector().scrollable(true).instance(0)).scrollIntoView(new UiSelector().description("listing_${Listing_ID}").childSelector(new UiSelector().resourceId("${SERP_LISTING_LOCATION}")))     ${City}
    Page Should Not Contain Element              android=UiSelector().description("listing_${Listing_ID}").childSelector(new UiSelector().resourceId("${SECURE_PURCHASE_ICON}"))
    Page Should Not Contain Element              android=UiSelector().description("listing_${Listing_ID}").childSelector(new UiSelector().resourceId("${POST_ICON}"))
    Page Should Not Contain Element              android=UiSelector().description("listing_${Listing_ID}").childSelector(new UiSelector().resourceId("${LISTING_STATUS_SERP}"))
    Page Should Contain Element                  android=UiSelector().description("listing_${Listing_ID}").childSelector(new UiSelector().resourceId("${SECURE_PURCHASE_BADGE_ICON}"))
    Element Should Contain Text                  android=UiSelector().description("listing_${Listing_ID}").childSelector(new UiSelector().resourceId("${SECURE_PURCHASE_BADGE_TITLE}"))      ${SECURE_PURCHASE_BADGE_TITLE_TXT}

Validate Secure Purchase Detail In Listing Details Page
    Wait Until Page Contains Element       ${PURCHASE_BUTTON}
    Element Should Contain Text            ${PURCHASE_BUTTON}      ${PURCHASE_BUTTON_TEXT}
    Validate Secure Purchase Banner In Listing Details Page
    Page Should Not Contain Element        ${SECURE_PURCHASE_ICONS_OLD}

#    این فیچرها مربوط به خرید امن نیست
#    TODO:  add checking "بیشتر" element for listings which have more than 5 line

Validate Secure Purchase Banner In Listing Details Page
    Page Should Contain Element            ${TOP_BANNER_ICON}
    Element Should Contain Text            ${TOP_BANNER_TITLE}          ${TOP_BANNER_TITLE_TXT}
    Element Should Contain Text            ${TOP_BANNER_DESC}           ${TOP_BANNER_DESC_TXT}

Validate Details Of Transportation Cost And Time In Listing Details Page
    [Arguments]                 ${State}      ${Deliver_Price_City}   ${Deliver_Price_State}   ${Deliver_Price_Country}
#    Swipe By Percent               50     70     50    30  1000
    Page Should Contain Element By ID And Text          ${LISTING_DETAILS_COST_TITLE}               هزینه و زمان ارسال
    Page Should Contain Element By ID And Text          ${LISTING_DETAILS_COST_TITLE_TXT}           ارسال به${SPACE}${State}${SPACE}(کمتر از ۲۴ ساعت)
    Page Should Contain Element By ID And Text          ${LISTING_DETAILS_COST_TITLE_TXT}           ارسال به سراسر ایران (۲ تا ۳ روز کاری)
    Page Should Contain Element By ID And Text          ${LISTING_DETAILS_CURRENCY_TITLE_TXT}       تومان
    ${P_City}                                           Convert Number To Price                     ${Deliver_Price_City}       ,
    Page Should Contain Element By ID And Text          ${LISTING_DETAILS_COST_PRICE_CITY}          ${P_City}
#    ${P_State}                                         Convert Number To Price                     ${Deliver_Price_State}      ,
#    Page Should Contain Element By ID And Text         ${LISTING_DETAILS_COST_PRICE_STATE}         ${P_State}
    ${P_Country}                                        Convert Number To Price                     ${Deliver_Price_Country}    ,
    Page Should Contain Element By ID And Text          ${LISTING_DETAILS_COST_PRICE_COUNTRY}       ${P_Country}

Validate Shop Name in Listing Details Page
    [Arguments]                     ${Shop_Name}
    Page Should Contain Element By ID And Text          ${LISTING_DETAILS_SHOP_NAME}                ${Shop_Name}

#################    Step One - Check out ###################################
Validate Steps Structure For Step One
    Wait Until Page Contains Element            ${PAGE_TITLE}
    Element Should Contain Text                 ${PAGE_TITLE}                           ${SECURE_PURCHASE_BADGE_TITLE_TXT}
    Page Should Contain Element                 ${CHECK_OUT_INDICATOR_1}
    Element Should Contain Text                 ${CHECK_OUT_INDICATOR_1_NUM}            1
    Element Should Contain Text                 ${CHECK_OUT_INDICATOR_1_TITLE}          انتخاب تعداد
    Page Should Contain Element                 ${CHECK_OUT_CONNECTOR_1_2}
    Page Should Contain Element                 ${CHECK_OUT_INDICATOR_2}
    Element Should Contain Text                 ${CHECK_OUT_INDICATOR_2_NUM}            2
    Element Should Contain Text                 ${CHECK_OUT_INDICATOR_2_TITLE}          آدرس و زمان
    Page Should Contain Element                 ${CHECK_OUT_CONNECTOR_2_3}
    Page Should Contain Element                 ${CHECK_OUT_INDICATOR_3}
    Element Should Contain Text                 ${CHECK_OUT_INDICATOR_3_NUM}            3
    Element Should Contain Text                 ${CHECK_OUT_INDICATOR_3_TITLE}          پرداخت هزینه
    Page Should Contain Element                 ${CHECK_OUT_DIVIDER_STEP_ONE}

Validate Contents Of Step One In Checkout
    [Arguments]                 ${Listing_Title}        ${Listing_Price}        ${Shop_Name}        ${Number_Goods}          ${Transport_Price}
    Validate Listing Details In Step One Of Checkout    ${Listing_Title}        ${Listing_Price}    ${Shop_Name}             ${Number_Goods}
    Validate Banner In Check Out
    Validate Receipt For Step One In Checkout           ${Listing_Price}        ${Number_Goods}     ${Transport_Price}

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
    Page Should Contain Element                 android=UiSelector().resourceId("${CHECK_OUT_STEP_ONE_MINUS_BTN}")

Validate Banner In Check Out
    Element Should Contain Text                 ${CHECK_OUT_BANNER_TITLE}               ${CHECK_OUT_BANNER_TITLE_TXT}
    Element Should Contain Text                 ${CHECK_OUT_BANNER_DESC}                ${CHECK_OUT_BANNER_DESC_TXT}

Validate Receipt For Step One In Checkout
    [Arguments]                                 ${Listing_Price}        ${Number_Goods}         ${Transport_Price}
    Swipe By Percent               50     70     50    30  1000             # just for scrolling page to down
    Element Should Contain Text By ID And Text  ${CHECK_OUT_STEP_ONE_PRICE_TITLE}               ${CHECK_OUT_STEPS_PRICE_TITLE_TXT}
    Element Should Contain Text By ID And Text  ${CHECK_OUT_STEP_ONE_DELIVER_PRICE_TITLE}       ${CHECK_OUT_STEPS_DELIVER_PRICE_TITLE_TXT}
    ${Total_Price}                              Evaluate                                        ${Number_Goods} * ${Listing_Price}
    ${separator_price}                          Convert Number To Price                         ${Total_Price}       ٬
    Element Should Contain Text By ID And Text  ${CHECK_OUT_STEP_ONE_TOTAL_PRICE}               ${separator_price}${SPACE}تومان      #   = تعداد کالا در قیمت
    Element Should Contain Text By ID And Text  ${CHECK_OUT_STEP_ONE_DELIVER_PRICE}             ${Transport_Price}

Validate And Press Next Step Button In Step One
    Page Should Contain Element       android=UiSelector().resourceId("${CHECK_OUT_STEP_ONE_NEXT_BTN}").text("مرحله بعدی").enabled(true)
    Click Element                        ${CHECK_OUT_STEP_ONE_NEXT_BTN}

#################    Step Two - Check out ###################################
Validate Steps Structure For Step Two
    Wait Until Page Contains Element            ${PAGE_TITLE}
    Element Should Contain Text                 ${PAGE_TITLE}                       ${SECURE_PURCHASE_BADGE_TITLE_TXT}
    Page Should Contain Element                 ${CHECK_OUT_INDICATOR_1}
    Page Should Not Contain Element             ${CHECK_OUT_INDICATOR_1_NUM}
    Element Should Contain Text                 ${CHECK_OUT_INDICATOR_1_TITLE}      انتخاب تعداد
    Page Should Contain Element                 ${CHECK_OUT_CONNECTOR_1_2}
    Page Should Contain Element                 ${CHECK_OUT_INDICATOR_2}
    Element Should Contain Text                 ${CHECK_OUT_INDICATOR_2_NUM}        2
    Element Should Contain Text                 ${CHECK_OUT_INDICATOR_2_TITLE}      آدرس و زمان
    Page Should Contain Element                 ${CHECK_OUT_CONNECTOR_2_3}
    Page Should Contain Element                 ${CHECK_OUT_INDICATOR_3}
    Element Should Contain Text                 ${CHECK_OUT_INDICATOR_3_NUM}        3
    Element Should Contain Text                 ${CHECK_OUT_INDICATOR_3_TITLE}      پرداخت هزینه
    Page Should Contain Element                 ${CHECK_OUT_DIVIDER_STEP_TWO}

Validate Contents Of Step Two In Checkout
    [Arguments]                ${Listing_Price}        ${Number_Goods}
    Validate Message For Step Two With Deliver
    Validate Receipt For Step Two In Checkout          ${Listing_Price}        ${Number_Goods}
    Validate Delivery Address TextBox In Checkout

Validate Message For Step Two With Deliver
    Element Should Contain Text                 ${CHECK_OUT_STEP_TWO_TITLE}            ${CHECK_OUT_STEP_TWO_WITH_DELIVER_TXT}
    Page Should Contain Element                 ${CHECK_OUT_DIVIDER_TITLE}

Validate Receipt For Step Two In Checkout
    [Arguments]                 ${Listing_Price}        ${Number_Goods}
    Page Should Contain Element                 android=UiScrollable(UiSelector().scrollable(true).instance(0)).scrollIntoView(new UiSelector().resourceId("${CHECK_OUT_STEP_TWO_NEXT_BTN}").text("مرحله بعدی").enabled(false))
    Element Should Contain Text                 ${CHECK_OUT_STEP_TWO_PRICE_TITLE}               ${CHECK_OUT_STEPS_PRICE_TITLE_TXT}
    Element Should Contain Text                 ${CHECK_OUT_STEP_TWO_DELIVER_PRICE_TITLE}       ${CHECK_OUT_STEPS_DELIVER_PRICE_TITLE_TXT}
    ${Total_Price}                              Evaluate                                        ${Number_Goods} * ${Listing_Price}
    ${separator_price}                          Convert Number To Price                         ${Total_Price}       ٬
    Element Should Contain Text By ID And Text  ${CHECK_OUT_STEP_TWO_TOTAL_PRICE}               ${separator_price}${SPACE}تومان   #  ۶٬۰۰۰٬۰۰۰ تومان   = تعداد کالا در قیمت
    Element Should Contain Text By ID And Text  ${CHECK_OUT_STEP_TWO_DELIVER_PRICE}             آدرس را وارد کنید

Validate Delivery Address TextBox In Checkout
    Element Should Contain Text                 ${CHECK_OUT_RECEIVER_NAME_TITLE}                ${CHECK_OUT_RECEIVER_NAME_TITLE_TXT}
    Element Should Contain Text                 ${CHECK_OUT_RECEIVER_ADDRESS_TITLE}            ${CHECK_OUT_RECEIVER_ADDRESS_TITLE_TXT}

Open Map To Choose Address In Checkout
    Click Element                               ${CHECKOUT_SECURE_PURCHASE_ADDRESS}
    Wait Until Page Contains Element            ${SEARCH_ROOT_HINT}                             timeout=10s
    Wait Until Page Contains Element            ${MAP_MY_LOC_BTN}                               timeout=10s
    Wait Until Page Contains Element            ${CHECK_OUT_STEP_TWO_CONFIRM_LOC_BTN}           timeout=10s
    Sleep       8s
    Wait Until Page Contains Element            android=UiSelector().resourceId("${MAP_PIN}")
    Validate Initial Location On Map

Validate Initial Location On Map
    Validate Current Location On Map By Lat-Long            ${Default_Lat}              ${Default_Long}

Validate Current Location On Map By Lat-Long
    [Arguments]                                 ${Expected_Lat}                 ${Expected_Long}
    ${desc}                                     Get Element Attribute           android=UiSelector().resourceId("${MAP_PIN}")       content-desc
    @{lat_long}                                 Get Lat And Long                ${desc}
    ${lat_Min}                                  Evaluate            ${Expected_Lat} - 0.1000
    ${status_lat}                               Evaluate            ${lat_Min} <= ${lat_long}[0] <= ${Expected_Lat}
    ${long_Min}                                 Evaluate            ${Expected_Long} - 0.1000
    ${status_long}                              Evaluate            ${long_Min} <= ${lat_long}[1] <= ${Expected_Long}
    Run Keyword If                              '${status_lat}' == '${FALSE}' or '${status_long}' == '${FALSE}'      Fail         Initial Location of pin in Map is not in Tehran

Select Current Location Of Device For Address On Map
    Click Element                             ${MAP_MY_LOC_BTN}
    # ${latlang}                                  Set Variable             lat/lng: (35.754409956742165,51.415348425507545)
    # FOR  ${i}    IN RANGE   5
    #   Click Element                             ${MAP_MY_LOC_BTN}
    #   sleep                                     5s
    #   ${desc}                                   Get Element Attribute    android=UiSelector().resourceId("${MAP_PIN}")       content-desc
    #   Exit For Loop If                          '${latlang}' == '${desc}'
    # END

Confirm Location On Map
    Click Element                               ${CHECK_OUT_STEP_TWO_CONFIRM_LOC_BTN}

#Validate Lat And Long Of Current Location
#    [Arguments]             ${Latitude}         ${Longitude}
#    ${desc}                 Get Element Attribute           android=UiSelector().resourceId("${MAP_PIN}")       content-desc
#    @{lat_long}             Get Lat And Long                ${desc}
#    should be equal as strings          ${lat_long}[0]                ${Latitude}
#    should be equal as strings          ${lat_long}[1]                ${Longitude}

Validate Delivery Address Page
    [Arguments]                                     ${State}
    Wait Until Page Contains Element                ${PAGE_TITLE}                          timeout=10s
    Wait Until Page Contains Element                android=UiSelector().resourceId("${DELIVERY_ADRESS_SAVE_BTN}").enabled(false)                      timeout=10s
    Wait Until Page Contains                        ${State}                               timeout=10s         error="The address can not be loaded from map"
    Element Should Contain Text                     ${COMPONENT_EDITT_EXT}                 ${State}
    Page Should Contain Element                     ${DELIVERY_ADRESS_CLEAR_BTN}

Input Delivery Address Detail
    [Arguments]                     ${Address}             ${House_Num}           ${Unit_Num}
    Element Should Contain Text     android=UiSelector().resourceId("${DELIVERY_ADRESS_INPUT_ADD}").childSelector(new UiSelector().resourceId("${INPUT_EDIT_TXT}"))        ${Address}
    ${Clear_House_Num_locator}      Set Variable     android=UiSelector().resourceId("${DELIVERY_ADRESS_HOUSE_NUM}").childSelector(new UiSelector().resourceId("${DELIVERY_ADRESS_EDIT_TXT_CLEAR}"))
    ${status}                       Run Keyword And Return Status           Page Should Contain Element         ${Clear_House_Num_locator}
    Run Keyword If                  ${status}                               Click Element                       ${Clear_House_Num_locator}
    Input Text                      android=UiSelector().resourceId("${DELIVERY_ADRESS_HOUSE_NUM}").childSelector(new UiSelector().resourceId("${INPUT_EDIT_TXT}"))        ${House_Num}
    Input Text                      android=UiSelector().resourceId("${DELIVERY_ADRESS_UNIT_NUM}").childSelector(new UiSelector().resourceId("${INPUT_EDIT_TXT}"))         ${Unit_Num}
    Page Should Contain Element     android=UiSelector().resourceId("${DELIVERY_ADRESS_SAVE_BTN}").enabled(true)
    Click Element                   ${DELIVERY_ADRESS_SAVE_BTN}

Set Delivery Time
    No Operation

Validate And Press Next Step Button In Step Two
    Page Should Contain Element             android=UiSelector().resourceId("${CHECK_OUT_STEP_TWO_NEXT_BTN}").text("مرحله بعدی").enabled(true)
    Click Element                           ${CHECK_OUT_STEP_TWO_NEXT_BTN}
    Page Should Not Contain Text            ${CH_OUT_SEC_PURCHASE_POST_TXT_VALID_MSG}

Validate Address And Delivery Price In Step Two
    [Arguments]                                 ${Customer_Address_Total}               ${Delivery_Price}
    Wait Until Page Contains Element            android=UiScrollable(UiSelector().scrollable(true).instance(0)).scrollIntoView(new UiSelector().resourceId("${CHECK_OUT_STEP_TWO_NEXT_BTN}").enabled(true))
    Element Should Contain Text                 android=UiSelector().resourceId("${CHECKOUT_SECURE_PURCHASE_ADDRESS}").childSelector(new UiSelector().resourceId("${CHECKOUT_SECURE_PURCHASE_ADDRESS_TXT}"))    ${Customer_Address_Total}
    ${separator_price}                          Convert Number To Price                 ${Delivery_Price}       ٬
    Element Should Contain Text By ID And Text  ${CHECK_OUT_STEP_TWO_DELIVER_PRICE}     ${separator_price}${SPACE}تومان       #     هزینه ارسال را وارد کنیدباید بر اساس مبدا و مقصد تغییر کند



#################    Step Three - Check out ###################################
Validate Steps Structure For Step Three
    Wait Until Page Contains Element            ${PAGE_TITLE}
    Element Should Contain Text                 ${PAGE_TITLE}                       ${PURCHASE_SECURE_TEXT}
    Page Should Contain Element                 ${CHECK_OUT_INDICATOR_1}
    Page Should Not Contain Element             ${CHECK_OUT_INDICATOR_1_NUM}
    Element Should Contain Text                 ${CHECK_OUT_INDICATOR_1_TITLE}      انتخاب تعداد
    Page Should Contain Element                 ${CHECK_OUT_CONNECTOR_1_2}
    Page Should Contain Element                 ${CHECK_OUT_INDICATOR_2}
    Page Should Not Contain Element             ${CHECK_OUT_INDICATOR_2_NUM}
    Element Should Contain Text                 ${CHECK_OUT_INDICATOR_2_TITLE}      آدرس و زمان
    Page Should Contain Element                 ${CHECK_OUT_CONNECTOR_2_3}
    Page Should Contain Element                 ${CHECK_OUT_INDICATOR_3}
    Element Should Contain Text                 ${CHECK_OUT_INDICATOR_3_NUM}        3
    Element Should Contain Text                 ${CHECK_OUT_INDICATOR_3_TITLE}      پرداخت هزینه
    Page Should Contain Element                 ${CHECK_OUT_DIVIDER_STEP_THREE}

Validate Listing Details In Step Three Of Checkout
    [Arguments]                                 ${Listing_Title}        ${Listing_Price}      ${Number_Goods}    ${Shop_Name}
    Wait Until Page Contains Element            ${CHECK_OUT_STEP_THREE_LISTING_TITLE}
    Element Should Contain Text                 ${CHECK_OUT_STEP_THREE_LISTING_TITLE}            ${Listing_Title}
    ${Converted_Price}                          Convert Number To Price                          ${Listing_Price}   ٬
    Element Should Contain Text                 ${CHECK_OUT_STEP_THREE_LISTING_PRICE}            ${Converted_Price}${SPACE}تومان
    Page Should Contain Element                 ${CHECK_OUT_STEP_THREE_SHOP_ICON}
    Element Should Contain Text                 ${CHECK_OUT_STEP_THREE_SHOP_NAME}                 ${Shop_Name}
    Element Should Contain Text                 ${CHECK_OUT_STEP_THREE_COUNT_TITLE}               تعداد:
    Element Should Contain Text                 ${CHECK_OUT_STEP_THREE_COUNT_TXT}                 ${Number_Goods}
    Page Should Contain Element                 ${CHECK_OUT_STEP_THREE_DIVIDER_RECIPT}

Validate Customer Info For Step Three
    [Arguments]                 ${Customer_Name}        ${Customer_Address}
    Element Should Contain Text                 ${CHECK_OUT_STEP_THREE_CUSTOMER_TITLE}            ${CHECK_OUT_RECEIVER_NAME_TITLE_TXT}:
    Element Should Contain Text                 ${CHECK_OUT_STEP_THREE_CUSTOMER_NAME}             ${Customer_Name}
    Element Should Contain Text                 ${CHECK_OUT_STEP_THREE_CUSTOMER_ADD_TITLE}        ${CHECK_OUT_RECEIVER_ADDRESS_TITLE_TXT}:
    Element Should Contain Text                 ${CHECK_OUT_STEP_THREE_CUSTOMER_ADD}              ${Customer_Address}

Validate Receipt For Step Three In Checkout
    [Arguments]                                ${Number_Goods}     ${Listing_Price}        ${Transport_Price}
    Swipe By Percent                            50     70     50    30  1000
    Element Should Contain Text                 ${CHECK_OUT_STEP_THREE_PAYMENT_SUMMERY_TITLE}               خلاصه پرداخت
    Element Should Contain Text                 ${CHECK_OUT_STEP_THREE_PAYMENT_SUMMERY_COUNT_TITLE}         تعداد
    Element Should Contain Text                 ${CHECK_OUT_STEP_THREE_PAYMENT_SUMMERY_COUNT}               ${Number_Goods}${SPACE}کالا
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

Choose Payment Button In Step Three
    Click Element                               ${CHECK_OUT_STEP_THREE_PAY_BTN}

Succes Payment From Android App In Secure Purchase
    Hanle WebView Browser Tester
    Wait Until Page Contains             پرداخت با موفقیت انجام شد                   timeout=30s
    Wait Until Page Contains             مبلغ پرداختی نزد شیپور به امانت می‌ماند      timeout=5s
    Wait Until Page Contains             اکنون فروشنده موظف است کالا را برای شما ارسال کند، برای پیگیری ارسال کالا روی دکمه زیر بزنید               timeout=5s
    Get Source
    ${ReturnApp}                         Run Keyword And Return Status    Click Element            android=UiSelector().text("پیگیری ارسال")
    Run Keyword If                       not ${ReturnApp}                 Fail            Can not back to application after payment for secure purcase

Hanle WebView Browser Tester
    ${status}                          Run Keyword And Return Status               Wait Until Page Contains           WebView Browser Tester        timeout=5s
    Run Keyword If                     ${status}                                   Click Text                         WebView Browser Tester
    ${status}                          Run Keyword And Return Status               Wait Until Page Contains           Open with        timeout=5s
    Run Keyword If                     ${status}                                   Open Test Browser and set default

Validate Chat Page Of Customer
    [Arguments]                          ${Number_Goods}            ${Price}        ${Delivery_Price_City}=${0}
    ${Total_Price}                       Evaluate    (${Number_Goods} * ${Price}) + ${Delivery_Price_City}
    ${separator_price}                   Convert Number To Price    ${Total_Price}       ,
    ${Payment_Msg}                       Set Variable               مبلغ${SPACE}${separator_price}${SPACE}تومان${SPACE}با موفقیت پرداخت شد
    Wait Until Page Contains             ${Payment_Msg}
    Wait Until Page Contains             ${SECURE_PURCHASE_PAYMENT_MSG}
    Wait Until Page Contains Element     android=UiSelector().resourceId("${PAGE_TITLE}").text("${Listings_title}")
#    Page Should Contain Element          android=UiSelector().resourceId("${PAGE_SUB_TITLE}").text("${Customer_Name}")
    Page Should Contain Element          ${CHAT_STATUS_ICON}
    Element Should Contain Text          ${CHAT_MESSAGE_TIME}       امروز
    Element Should Contain Text          ${CHAT_MESSAGE_TEXT}      ${CHAT_MESSAGE_TEXT_VALUE}
    Page Should Contain Element          ${CHAT_SEND_BTN}
    Page Should Contain Element          ${CHAT_CAMERA_BTN}
    Element Should Contain Text          ${CHAT_TEXT_EDIT}          پیامتان را بنویسید
    Page Should Contain Element          android=UiSelector().resourceId("${GENERAL_BTN_CHAT_PAGE}").text("تماس با پشتیبانی")
    Page Should Contain Element          android=UiSelector().resourceId("${GENERAL_BTN_CHAT_PAGE}").text("تماس با فروشنده")
    Page Should Contain Element          ${PAGE_IMAGE}
    Page Should Contain Element          ${PAGE_CALL}
#    TODO:  how to swipe down notification of android
#    Page Should Contain Element          android=UiSelector().resourceId("android:id/text").text("پرداخت توسط خریدار انجام شد.")
#    Page Should Contain Element          android=UiSelector().resourceId("android:id/title").text("شما پیام جدیدی دارید")

Send A Message To Support
    [Arguments]                               ${logged_in}=${TRUE}
    Fill Support Message Required Fields      ${logged_in}
    Submit Message To Support

Fill Support Message Required Fields
    [Arguments]                               ${logged_in}
    Input Attribute                           ایمیل                                     test@gmail.com
    Input Telephone                           ${logged_in}
    Input The Support Message Title And Desc

Input Telephone
    [Arguments]                               ${login}
    Run Keyword Unless                        ${login}                                  Mobile Generator A
    Input Attribute                           شماره تماس                               ${Random_User_Mobile_A}

Input The Support Message Title And Desc
    Input Attribute                           عنوان                      تست پشتیبانی شیپور
    Input Attribute                           پیام        تست پیام به پشتیبانی در اندروید

Submit Message To Support
    Click Support Message Send Button
    Validate The Message Sent To Support

Click Support Message Send Button
    Click Element                             id=${SUPPORT_MSG_SEND_BTN}

Validate The Message Sent To Support
    Wait Until Page Contains                  ${message_of_successfully_send_support_message}            timeout=20s
    Click The Link                            متوجه شدم
