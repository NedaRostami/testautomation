*** Settings ***
Resource                 6.0.0.resource

*** Variables ***


*** Keywords ***
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
