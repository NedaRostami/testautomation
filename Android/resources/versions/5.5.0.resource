*** Settings ***
Resource                  5.4.1.resource

*** Variables ***


*** Keywords ***
########################################      All Iran And Bump in Paid Feature      ###############################################
Select Bump
    [Arguments]                                 ${Input_Bump_type}                         ${Input_Bump_Price}
    Wait Until Page Contains                    ${PAID_FEATURE_BUMP_ADVERTISMENT_MSG}
    ${Bump_Price}                               Convert Number To Price                    ${Input_Bump_Price}
    ${Bump_Price}                               Set Variable                               ${Bump_Price}${SPACE}تومان
    Click The Link                              ${PAID_FEATURE_BUMP_TXT}
    Click The Link                              ${Input_Bump_type}
    Wait Until Page Contains Element            ${PAID_FEATURE_RECYCLER_VIEW}
    Page Should Contain Text                    ${PAID_FEATURE_BUMP_MSG}
    Element Should Contain Text                 ${PAID_FEATURE_BUMP_PRICE}                 ${Bump_Price}
    Page Should Not Contain Text                ${PAID_FEATURE_NO_BUMP_MSG}

Select Vitrin
    [Arguments]             ${Input_Vitrin_type}          ${Input_Vitrin_Price}
    Wait Until Page Contains                    ${PAID_FEATURE_BUMP_ADVERTISMENT_MSG}
    ${Vitrin_Price}                             Convert Number To Price                    ${Input_Vitrin_Price}
    ${Vitrin_Price}                             Set Variable                               ${Vitrin_Price}${SPACE}تومان
    Click The Link                              ${PAID_FEATURE_Vitrin_TXT}
    Click The Link                              ${Input_Vitrin_type}
    Wait Until Page Contains Element            ${PAID_FEATURE_RECYCLER_VIEW}
    Page Should Contain Text                    ${PAID_FEATURE_NO_BUMP_MSG}
    Element Should Contain Text                 ${PAID_FEATURE_BUMP_PRICE}                 ${Vitrin_Price}
    Page Should Not Contain Text                ${PAID_FEATURE_BUMP_MSG}

Select All Iran OR All State
    [Arguments]                                 ${Input_All_Iran_Price}                   ${Input_All_State_Price}       ${All_Type}
    Wait Until Page Contains Element            ${PAID_FEATURE_RECYCLER_VIEW}
    ${All_Iran_Price}                           Convert Number To Price                    ${Input_All_Iran_Price}
    ${All_Iran_Price}                           Set Variable                               ${All_Iran_Price}${SPACE}تومان
    ${All_State_Price}                          Convert Number To Price                    ${Input_All_State_Price}
    ${All_State_Price}                          Set Variable                               ${All_State_Price}${SPACE}تومان
#TODO: uncomment below line after debugging
#    ${All_Price_Before_Select}           Set Variable If       ${Input_All_Iran_Price} > ${Input_All_State_Price}
#    ...                                  از${SPACE}${All_State_Price}       از${SPACE}${All_Iran_Price}
#    Page Should Contain Element By ID And Text         ${PAID_FEATURE_PRICE_TXT_VIEW}           ${All_Price_Before_Select}

    Click Element By ID And Text                ${PAID_FEATURE_TITLE_TXT_VIEW}              ${PAID_FEATURE_ALL_TXT}
    Wait Until Page Contains Element            android=UiSelector().resourceId("${PAID_FEATURE_PACKEGE_SHEET_TITLE}").text("${PAID_FEATURE_PACKAGE_MSG}")
    Page Should Contain Element                 android=UiSelector().resourceId("${PAID_FEATURE_PACKEGE_OPTION_PRICE}").text("${All_Iran_Price}")
    Page Should Contain Element                 android=UiSelector().resourceId("${PAID_FEATURE_PACKEGE_OPTION_PRICE}").text("${All_State_Price}")
    Run Keyword If                              '${All_Type}' == 'All_Iran'         Choose All Iran Package         ${All_Iran_Price}
    ...    ELSE IF                              '${All_Type}' == 'All_State'        Choose All State Package        ${All_State_Price}


Choose All Iran Package
    [Arguments]                                 ${Input_All_Iran_Price}
    Sleep                                       2s
    Click Element                               android=UiSelector().resourceId("${PAID_FEATURE_PACKEGE_OPTION_TITLE}").text("${PAID_FEATURE_ALL_IRAN_TXT}")
    Wait Until Page Contains Element            android=UiScrollable(UiSelector().scrollable(true).instance(0)).scrollIntoView(new UiSelector().resourceId("${PAID_FEATURE_PRICE_TXT_VIEW}").text("${Input_All_Iran_Price}"))

Choose All State Package
    [Arguments]                                 ${Input_All_State_Price}
    Sleep                                       2s
    Click Element                               android=UiSelector().resourceId("${PAID_FEATURE_PACKEGE_OPTION_TITLE}").text("${PAID_FEATURE_ALL_STATE_TXT}")
    Wait Until Page Contains Element            android=UiScrollable(UiSelector().scrollable(true).instance(0)).scrollIntoView(new UiSelector().resourceId("${PAID_FEATURE_PRICE_TXT_VIEW}").text("${Input_All_State_Price}"))

Press Payment Button In Paid Feature
    Click Element                     ${APPLY_BUTTON}

Open Paid Feature Page
    Wait Until Page Contains                ${STATISTICS_BTN_TXT}                  timeout=${Timeout}
    ${status}           Run Keyword And Return Status         Page Should Contain Text           ${PAID_FEATURE_BTN_TXT}
    Run Keyword Unless         ${status}                      Click The Link                     ${STATISTICS_BTN_TXT}
    Wait Until Page Contains                    ${PAID_FEATURE_BTN_TXT}          timeout=${Timeout}
    Click The Link                              ${PAID_FEATURE_BTN_TXT}

#################################   Listing Details  ################################
Validate Listing Details Items
    [Arguments]      ${Category}= لوازم خانگی           ${SubCategory}=مبلمان و لوازم چوبی
    ...              ${State}=تهران                     ${City}=تهران                       ${Region}=${EMPTY}
    ...              ${Price}=${EMPTY}                  ${NewUsed}=${EMPTY}                 ${Tag_Type}=${EMPTY}
    ...              ${Status}=${APPROVED_MESSAGE}      ${SellerORCustomer}=Seller          ${Kind}=${EMPTY}
    ...              ${Seller_Number}=${EMPTY}          ${BarCode}=${EMPTY}                 ${BrandName}=${EMPTY}

    Wait Until Page Contains                ${LISTING_DETAILS_TITLE}
    Element Should Contain Text             ${LISTING_DETAILS_TITLE}    ${Title_Words}
    Has Tag In Listing Details              ${Tag_Type}
    Run Keyword If          '${Price}' != '${EMPTY}'                    Validate Price In Listing Details               ${Price}            ${SellerORCustomer}
    Run Keyword If          '${SellerORCustomer}' == 'Seller'           Validate Listing Status In Listing Details      ${Status}
    Validate Listing Location In Listing Details                        ${State}            ${City}          ${Region}
    Run Keyword If          '${CheckNewUsed}' != '${EMPTY}'             Validate Condition Of Listing in Listing Details       ${NewUsed}
    Run Keyword If          '${BarCode}' != '${EMPTY}'                  Validate BarCode in Listing Details       ${BarCode}   ${BrandName}
    Run Keyword If          '${Kind}' != '${EMPTY}'                     Validate Listing Kind In Listing Details        ${Kind}
    Validate Category In Listing Details                                ${Category}         ${SubCategory}
    Validate Submit Time in Listing Details
#    Validate Listing Description in Listing Details                     ${Title_Description}
    Run Keyword If          '${SellerORCustomer}' == 'Customer'         Validate Listing Number Of Seller In Listing Details        ${Seller_Number}
    Validate Listing Id In Listing Details                              ${listingId}
    Run Keyword If          '${SellerORCustomer}' == 'Customer'         Validate Listing Report In Listing Details
    Run Keyword If          '${SellerORCustomer}' == 'Seller'           Validate Expire Date in Listing Details

Has Tag In Listing Details
    [Arguments]                         ${Tag_Type}
    Run Keyword If                     '${Tag_Type}' != '${EMPTY}'   Element Should Contain Text        ${LISTING_DETAILS_CHIP_DIS_TAG}      ${Tag_Type}
    ...       ELSE                      Page Should Not Contain Element                                 ${LISTING_DETAILS_CHIP_DIS_TAG}

Validate Price In Listing Details
    [Arguments]                         ${Price}                           ${SellerORCustomer}
    Run Keyword If                     '${SellerORCustomer}'=='Seller'     Page Should Contain Element By ID And Text        ${LISTING_DETAILS_FIELD_TITLE}            قیمت
    Run Keyword If                     '${Price}' == '${0}'                Listing Has No Price        ${SellerORCustomer}
    ...    ELSE IF                     '${Price}' != '${0}'                Listing Has Price           ${Price}             ${SellerORCustomer}

Listing Has Price
    [Arguments]                         ${Price}       ${SellerORCustomer}
    ${separator_price}                  Evaluate       f'{${Price}:,}'
    Page Should Contain Element By ID And Text         ${LISTING_DETAILS_PRICE}                 ${separator_price}${SPACE}تومان
    Run Keyword If   '${SellerORCustomer}'=='Seller'   Page Should Contain Element By ID And Text         ${LISTING_DETAILS_FIELD_VALUE}           ${Price}

Listing Has No Price
    [Arguments]                         ${SellerORCustomer}
    Page Should Contain Element By ID And Text         ${LISTING_DETAILS_PRICE}                 قیمت توافقی
    Run Keyword If   '${SellerORCustomer}'=='Seller'   Page Should Contain Element By ID And Text         ${LISTING_DETAILS_FIELD_VALUE}           0

Validate Listing Status In Listing Details
    [Arguments]                         ${Listing_Status}=تایید شده
    Page Should Contain Element By ID And Text              ${LISTING_DETAILS_FIELD_TITLE}      وضعیت
    Page Should Contain Element By ID And Text              ${LISTING_DETAILS_FIELD_VALUE}      ${Listing_Status}

Validate Listing Location In Listing Details
    [Arguments]                         ${State}            ${City}                             ${Region}
    Page Should Contain Element By ID And Text              ${LISTING_DETAILS_FIELD_TITLE}      موقعیت مکانی
    ${loc} =	Set Variable If	       '${Region}' == '${EMPTY}'	        ${State}،${SPACE}${City}	     ${State}،${SPACE}${City}،${SPACE}${Region}
    Page Should Contain Element By ID And Text              ${LISTING_DETAILS_FIELD_VALUE}      ${loc}

Validate Condition Of Listing in Listing Details
    [Arguments]                         ${NewUsed}
    Page Should Contain Element By ID And Text              ${LISTING_DETAILS_FIELD_TITLE}      وضعیت کالا
    Page Should Contain Element By ID And Text              ${LISTING_DETAILS_FIELD_VALUE}      ${NewUsed}

Validate BarCode in Listing Details
    [Arguments]                         ${BarCode}          ${BrandName}
    Page Should Contain Element By ID And Text              ${LISTING_DETAILS_FIELD_TITLE}      شناسه کالا
    Page Should Contain Element By ID And Text              ${LISTING_DETAILS_FIELD_VALUE}      ${BarCode}
    Page Should Contain Element By ID And Text              ${LISTING_DETAILS_FIELD_TITLE}      برند
    Page Should Contain Element By ID And Text              ${LISTING_DETAILS_FIELD_VALUE}      ${BrandName}

Validate Listing Kind In Listing Details
    [Arguments]                         ${Kind}
    Page Should Contain Element By ID And Text              ${LISTING_DETAILS_FIELD_TITLE}      زنانه / مردانه
    Page Should Contain Element By ID And Text              ${LISTING_DETAILS_FIELD_VALUE}      ${Kind}

Validate Submit Time in Listing Details
    Page Should Contain Element By Class And Text           ${TEXT_CLASS_NAME}                  زمان ثبت
    Page Should Contain Element By ID And Text              ${LISTING_DETAILS_SUBMIT_DATE}      لحظاتی پیش

Validate Category In Listing Details
    [Arguments]                         ${Category}         ${SubCategory}
    Page Should Contain Element By Class And Text           ${TEXT_CLASS_NAME}                  دسته‌بندی
    Page Should Contain Element By ID And Text              ${LISTING_DETAILS_CATEGORY}         ${Category}،${SPACE}${SubCategory}

Validate Listing Description in Listing Details
    [Arguments]                         ${Description}
    Page Should Contain Element By ID And Text              ${LISTING_DETAILS_DESC}             ${Description}

Validate Listing Number Of Seller In Listing Details
    [Arguments]                         ${Seller_Number}
    Run Keyword If          '${Seller_Number}' == '${EMPTY}'        Fail            There is no argument of seller number for validating Listing Details
    ${HiddenMobile}                     Catenate            SEPARATOR=XXX      ${Seller_Number[:4]}   ${Seller_Number[7:]}
    Page Should Contain Element By ID And Text          ${LISTING_DETAILS_SHOP_NUMBER}      شماره تماس تایید شده:${SPACE}${HiddenMobile}

Validate Listing Report In Listing Details
    Page Should Contain Element By ID And Text              ${LISTING_DETAILS_REPORT_BUTTON}      گزارش آگهی

Validate Listing Id In Listing Details
    [Arguments]                         ${Listing_ID}
    Page Should Contain Element By ID And Text              ${LISTING_DETAILS_ID}               شناسه آگهی:${SPACE}${Listing_ID}

Validate Expire Date in Listing Details
    Element Should Contain Text By ID And Text              ${LISTING_DETAILS_EXPIRE_DATE}      تاریخ انقضاء آگهی:
