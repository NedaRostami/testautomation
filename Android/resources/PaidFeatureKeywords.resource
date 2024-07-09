*** Settings ***
Resource          common.resource

*** Variables ***
${State}                                        تهران
${State_ID}                                     8
${City}                                         تهران
${City_ID}                                      301
${Region}                                       آجودانیه
${Region_ID}                                    930
${Sleep_time}                                   2s
${Timeout}                                      10s

${Category}                                     ورزش فرهنگ فراغت
${Category_ID}                                  43619
${SubCategory}                                  کلکسیونی
${SubCategory_ID}                               44113
${Sub_SubCategory}                              ${EMPTY}
${Sub_SubCategory_ID}                           ${EMPTY}
${Number_Of_Photos}                             3

${NewUsed}                                      نو
${BarCode}                                      ${EMPTY}
${BrandName}                                    ${EMPTY}

${Bump_Type}                                    ۱ بار بروزرسانی
${Bump_ID}                                      5:1
${Bump_Type_Receipt}                            بروزرسانی (۱ بار بروزرسانی)
${Vitrin_Type}                                  ۷ روزه + ۷ بروزرسانی
${Vitrin_ID}                                    6:8
${Vitrin_Type_Receipt}                          ویترین + بروزرسانی (۷ روزه)

${All_Iran_Packge_Price}                        299900
${All_State_Packge_Price}                       120000
${Bump_Packge_Price}                            5000
${Vitrin_Packge_Price}                          30000
${Tax_Price}                                    28341       # (15000+299900)*0.09    =  28341

${Tag_Type}                                     فوری
${Tag_ID}                                       10
${Tag_Price}                                    12500
${AllIranAdditionPrice}                         ${All_Iran_Packge_Price}
${AllStateAdditionPrice}                        ${All_State_Packge_Price}
${SecurePurchaseAllIranAdditionPrice}           0
${SecurePurchaseAllStateAdditionPrice}          0



*** Keywords ***
###########################   set package or tag in Admin  #################################################
Set Packages For Bump Price
    Set Bump Price                  catid=${Category_ID}   regionId=${State_ID}    price=${Bump_Packge_Price}   bumpid=${Bump_ID}
    ...                             AllIranAdditionPrice=${AllIranAdditionPrice}   AllStateAdditionPrice=${AllStateAdditionPrice}
    ...                             SecurePurchaseAllIranAdditionPrice=${SecurePurchaseAllIranAdditionPrice}    SecurePurchaseAllStateAdditionPrice=${SecurePurchaseAllStateAdditionPrice}

Set Packages For Bump and AllIran and AllState
    Set All Iran Price              catid=${Category_ID}   regionId=${State_ID}    price=${All_Iran_Packge_Price}
    Set All State Price             catid=${Category_ID}   regionId=${State_ID}    price=${All_State_Packge_Price}
    Set Bump Price                  catid=${Category_ID}   regionId=${State_ID}    price=${Bump_Packge_Price}        bumpid=${Bump_ID}
    ...                             AllIranAdditionPrice=${AllIranAdditionPrice}   AllStateAdditionPrice=${AllStateAdditionPrice}
    ...                             SecurePurchaseAllIranAdditionPrice=${SecurePurchaseAllIranAdditionPrice}    SecurePurchaseAllStateAdditionPrice=${SecurePurchaseAllStateAdditionPrice}

Set Packages For Bump and Vitrin and AllIran and AllState
    Set All Iran Price              catid=${Category_ID}   regionId=${State_ID}   price=${All_Iran_Packge_Price}
    Set All State Price             catid=${Category_ID}   regionId=${State_ID}   price=${All_State_Packge_Price}
    Set Bump Price                  catid=${Category_ID}   regionId=${State_ID}   price=${Vitrin_Packge_Price}        bumpid=${Vitrin_ID}
    ...                             AllIranAdditionPrice=${AllIranAdditionPrice}   AllStateAdditionPrice=${AllStateAdditionPrice}
    ...                             SecurePurchaseAllIranAdditionPrice=${SecurePurchaseAllIranAdditionPrice}    SecurePurchaseAllStateAdditionPrice=${SecurePurchaseAllStateAdditionPrice}
    Set Bump Price                  catid=${Category_ID}   regionId=${State_ID}   price=${Bump_Packge_Price}          bumpid=${Bump_ID}
    ...                             AllIranAdditionPrice=${AllIranAdditionPrice}   AllStateAdditionPrice=${AllStateAdditionPrice}
    ...                             SecurePurchaseAllIranAdditionPrice=${SecurePurchaseAllIranAdditionPrice}    SecurePurchaseAllStateAdditionPrice=${SecurePurchaseAllStateAdditionPrice}


Set Packages For Chip Discount
    Set Tag Price           catid=${Category_ID}   regionId=${State_ID}   price=${Tag_Price}   tagid=${Tag_ID}

Set Packages For Instant Tag
    Set Tag Price           catid=${Category_ID}   regionId=${State_ID}   price=${Tag_Price}   tagid=${Tag_ID}

###########################   Select different option in Paid feature page  #################################################
Select Bump Package
    Select Bump                       ${Bump_Type}          ${Bump_Packge_Price}

Select Bump And All Iran
    Select Bump                       ${Bump_Type}                ${Bump_Packge_Price}
    Select All Iran OR All State      ${All_Iran_Packge_Price}    ${All_State_Packge_Price}      All_Iran
    Validate Changing Bump Price Based On All Iran                ${All_Iran_Packge_Price}

Select Bump And All State
    Select Bump                       ${Bump_Type}                ${Bump_Packge_Price}
    Select All Iran OR All State      ${All_Iran_Packge_Price}    ${All_State_Packge_Price}      All_State
    Validate Changing Bump Price Based On All State               ${All_State_Packge_Price}

Select Vitrin And All State
    Select Vitrin                     ${Vitrin_Type}        ${Vitrin_Packge_Price}
    Select All Iran OR All State      ${All_Iran_Packge_Price}       ${All_State_Packge_Price}      All_State
    Validate Changing Vitrin Price Based On All State       ${Vitrin_Packge_Price}

Update Bump Price
    Set Suite Variable                ${Bump_Packge_Price}     ${Bump_Price_Updated}

###########################   Select Tag in Paid feature  #################################################
Select Tag In Paid Feature
    [Arguments]           ${Tag_Type}
    Click Element By ID And Text         ${PAID_FEATURE_TITLE_TXT_VIEW}             ${Tag_Type}
    Wait Until Page Contains             ${APPLY_BUTTON}
    ${accept_version} =      Run Keyword If      '${Tag_Type}' == 'تخفیفی'
    ...                      Set Variable        5.6.0
    ...                      ELSE IF             '${Tag_Type}' == 'فوری'
    ...                      Set Variable        5.6.2
    Run Keyword If          '${file_version}' > '${accept_version}'
    ...                      Page Should Contain CheckBox By Text And Status           ${Tag_Type}          checked

Unselect Tag In Paid Feature
    [Arguments]           ${Tag_Type}
    Click Element By ID And Text         ${PAID_FEATURE_TITLE_TXT_VIEW}             ${Tag_Type}
    Page Should Not Contain Element      ${APPLY_BUTTON}
    ${accept_version} =      Run Keyword If      '${Tag_Type}' == 'تخفیفی'
    ...                      Set Variable        5.6.0
    ...                      ELSE IF             '${Tag_Type}' == 'فوری'
    ...                      Set Variable        5.6.2
    Run Keyword If          '${file_version}' > '${accept_version}'
    ...                      Page Should Contain CheckBox By Text And Status        ${Tag_Type}          unchecked

###########################   Validate price of packages based on business rules  #################################################
Validate Changing Bump Price Based On All Iran
    [Arguments]                       ${expected_price}
    Set Suite Variable                ${Bump_Price_Updated}     ${expected_price}
    ${Bump_Price_text}                Convert Number To Price   ${Bump_Price_Updated}
    ${Bump_Price_text}                Set Variable              ${Bump_Price_text}${SPACE}تومان
    Page Should Contain Element By ID And Text                  ${PAID_FEATURE_BUMP_PRICE}          ${Bump_Price_text}

Validate Changing Bump Price Based On All State
    [Arguments]                       ${expected_price}
    Set Suite Variable                ${Bump_Price_Updated}     ${Bump_Price_Updated}
    ${Bump_Price_text}                Convert Number To Price   ${Bump_Price_Updated}
    ${Bump_Price_text}                Set Variable              ${Bump_Price_text}${SPACE}تومان
    Page Should Contain Element By ID And Text                  ${PAID_FEATURE_BUMP_PRICE}          ${Bump_Price_text}

Validate Changing Vitrin Price Based On All State
    [Arguments]                       ${Vitrin_Packge_Price}
    ${Vitrin_Price_Updated}             Evaluate                   2 * ${Vitrin_Packge_Price}
    Set Suite Variable                  ${Vitrin_Price_Updated}    ${Vitrin_Price_Updated}
    ${Vitrin_Price_text}                Convert Number To Price    ${Vitrin_Price_Updated}
    ${Vitrin_Price_text}                Set Variable               ${Vitrin_Price_text}${SPACE}تومان
    Page Should Contain Element By ID And Text                     ${PAID_FEATURE_BUMP_PRICE}        ${Vitrin_Price_text}

###########################   Validate Payment Summery in Paid Feature page  #################################################
Validate Payment Summery In Paid Feature For Bump And All Iran And Press Payment
    Validate Payment Summery In Paid Feature    All_Packge_Price=${All_Iran_Packge_Price}   Tax_Price=${Tax_Price}
    ...                Bump_Type=${Bump_Type}   Bump_Price=${Bump_Price_Updated}
    Press Payment Button In Paid Feature

Validate Payment Summery In Paid Feature For Bump And All State And Press Payment
    Validate Payment Summery In Paid Feature    All_Packge_Price=${All_State_Packge_Price}  Tax_Price=${Tax_Price}
    ...                Bump_Type=${Bump_Type}   Bump_Price=${Bump_Price_Updated}
    Press Payment Button In Paid Feature

Validate Payment Summery In Paid Feature For Vitrin And All State And Press Payment
    Validate Payment Summery In Paid Feature    All_Packge_Price=${All_State_Packge_Price}  Tax_Price=${Tax_Price}
    ...             Bump_Type=${Vitrin_Type}    Bump_Price=${Vitrin_Price_Updated}
    Press Payment Button In Paid Feature

Validate Status Tag In Paid Feature
    [Arguments]             ${Tag_Type}        ${Tag_Price}         ${Tax_Price}       ${tag_status}
    Swipe By Percent               50     70     50    10  1000
    Page Should Contain Element By ID And Text              ${PAID_FEATURE_TITLE_TXT_VIEW}          ${Tag_Type}
    ${separator_price}                                      Convert Number To Price                 ${Tag_Price}
    Page Should Contain Element By ID And Text              ${PAID_FEATURE_PRICE_TXT_VIEW}          ${separator_price}${SPACE}تومان
    ${accept_version} =     Run Keyword If                  '${Tag_Type}' == 'تخفیفی'
    ...                     Set Variable                    5.6.0
    ...                     ELSE IF                         '${Tag_Type}' == 'فوری'
    ...                     Set Variable                    5.6.2
    Run Keyword If         '${tag_status}' == 'selected'    Tag Should Be Selected                  ${Tag_Type}     ${Tag_Price}    ${Tax_Price}     ${accept_version}
    ...   ELSE IF          '${tag_status}' == 'unselected'  Tag Should not be selected              ${Tag_Type}      ${accept_version}

Tag Should Be Selected
    [Arguments]             ${Tag_Type}           ${Tag_Price}      ${Tax_Price}                    ${accept_version}
    Run Keyword If         '${file_version}' > '${accept_version}'      Page Should Contain CheckBox By Text And Status     ${Tag_Type}          checked
    ${Total_Price}          Evaluate                        ${Tag_Price} + ${Tax_Price}
    ${separator_price}                                      Convert Number To Price                 ${Total_Price}
    Element Should Contain Text                             ${APPLY_BUTTON}                         پرداخت${SPACE}${separator_price}${SPACE}تومان

Tag Should Not Be Selected
    [Arguments]             ${Tag_Type}         ${accept_version}
    Run Keyword If         '${file_version}' > '${accept_version}'      Page Should Contain CheckBox By Text And Status     ${Tag_Type}           unchecked
    Page Should Not Contain Element                         ${APPLY_BUTTON}

Validate Payment Summery In Paid Feature
    [Arguments]         ${Tag_Type}=${EMPTY}                ${Tag_Price}=${0}              ${All_Packge_Price}=${0}        ${Tax_Price}=${0}
    ...                 ${Bump_Type}=${EMPTY}               ${Bump_Price}=${0}
    Page Should Contain Element By ID And Text              ${PAID_FEATURE_TITLE_VIEW}                                     ${PAID_FEATURE_PAYMENT_SUMMERY_TXT}
    Run Keyword If      '${Tag_Type}' != '${EMPTY}'         Validate Tag Price              ${Tag_Type}                    ${Tag_Price}
    Run Keyword If      '${Bump_Type}' != '${EMPTY}'        Validate Bump Price             ${Bump_Type}                   ${Bump_Price}
    Run Keyword If      '${All_Packge_Price}' != '${0}'     Validate All Package Price      ${All_Packge_Price}
    Run Keyword If      '${Tax_Price}' != '${0}'            Validate Tax Price              ${Tax_Price}
    ${Total_Price}       Evaluate                           ${Tag_Price} + ${All_Packge_Price} + ${Tax_Price} + ${Bump_Price}
    Validate Total Price            ${Total_Price}

Validate Tag Price
    [Arguments]                     ${Tag_Type}             ${Tag_Price}
    Page Should Contain Element By ID And Text              ${PAID_FEATURE_TITLE_VIEW}          ${Tag_Type}
    ${separator_price}                                      Convert Number To Price             ${Tag_Price}
    Page Should Contain Element By ID And Text              ${PAID_FEATURE_VALUE_VIEW}          ${separator_price}${SPACE}تومان

Validate Bump Price
    [Arguments]         ${Bump_Type}                        ${Bump_Price}
    Page Should Contain Element By ID And Text              ${PAID_FEATURE_TITLE_VIEW}          ${Bump_Type}
    ${separator_price}                                      Convert Number To Price             ${Bump_Price}
    Page Should Contain Element By ID And Text              ${PAID_FEATURE_VALUE_VIEW}          ${separator_price}${SPACE}تومان

Validate All Package Price
    [Arguments]         ${All_Packge_Price}
    Page Should Contain Element By ID And Text              ${PAID_FEATURE_TITLE_VIEW}          ${PAID_FEATURE_ALL_TXT}
    ${separator_price}                                      Convert Number To Price             ${All_Packge_Price}
    Page Should Contain Element By ID And Text              ${PAID_FEATURE_VALUE_VIEW}          ${separator_price}${SPACE}تومان

Validate Tax Price
    [Arguments]         ${Tax_Price}
    Page Should Contain Element By ID And Text              ${PAID_FEATURE_TITLE_VIEW}          ${PAID_FEATURE_TAX_TXT}
    ${separator_price}                                      Convert Number To Price             ${Tax_Price}
    Page Should Contain Element By ID And Text              ${PAID_FEATURE_VALUE_VIEW}          ${separator_price}${SPACE}تومان

Validate Total Price
    [Arguments]         ${Total_Price}
    Page Should Contain Element By ID And Text              ${PAID_FEATURE_TITLE_VIEW}          ${PAID_FEATURE_TOTAL_PRICE_TXT}
    ${separator_price}                                      Convert Number To Price             ${Total_Price}
    Page Should Contain Element By ID And Text              ${PAID_FEATURE_VALUE_VIEW}          ${separator_price}${SPACE}تومان
    Element Should Contain Text                             ${APPLY_BUTTON}                     پرداخت${SPACE}${separator_price}${SPACE}تومان

Check No Payment Summery In Paid Feature
    [Arguments]           ${Tag_Type}=فوری
    Page Should Not Contain Element By ID And Text          ${PAID_FEATURE_TITLE_VIEW}          ${PAID_FEATURE_PAYMENT_SUMMERY_TXT}
    Page Should Not Contain Element By ID And Text          ${PAID_FEATURE_TITLE_VIEW}          ${Tag_Type}
    Page Should Not Contain Element By ID And Text          ${PAID_FEATURE_TITLE_VIEW}          ${PAID_FEATURE_ALL_TXT}
    Page Should Not Contain Element By ID And Text          ${PAID_FEATURE_TITLE_VIEW}          ${PAID_FEATURE_TAX_TXT}
    Page Should Not Contain Element By ID And Text          ${PAID_FEATURE_TITLE_VIEW}          ${PAID_FEATURE_TOTAL_PRICE_TXT}

###########################   Validate Success payment after purchasing packages  #################################################
Success Payment For Bump And All Iran Features
#    Success Payment For Some Features       Tax_Price=${Tax_Price}          Bump_Type=${Bump_Type}
#    ...                           Bump_Price‍‍=${Bump_Price_Updated}          All_Iran_Packge_Price=${All_Iran_Packge_Price}
    Success Payment For Some Features        ${EMPTY}   0   ${Tax_Price}      ${Bump_Type}   ${Bump_Price_Updated}   ${All_Iran_Packge_Price}

Success Payment For Bump And All State Features
#    Success Payment For Some Features       Tax_Price=${Tax_Price}          Bump_Type=${Bump_Type}
#    ...                           Bump_Price‍‍=${Bump_Price_Updated}          All_State_Packge_Price=${All_State_Packge_Price}
    Success Payment For Some Features        ${EMPTY}   0   ${Tax_Price}      ${Bump_Type}   ${Bump_Price_Updated}
    ...                                      0              ${All_State_Packge_Price}

Success Payment For Vitrin And All State Features
#    Success Payment For Some Features       Tax_Price=${Tax_Price}          Bump_Type=${Vitrin_Type}
#    ...                           Bump_Price‍‍=${Vitrin_Price_Updated}        All_State_Packge_Price=${All_State_Packge_Price}
    Success Payment For Some Features        ${EMPTY}   0   ${Tax_Price}     ${Vitrin_Type_Receipt}   ${Vitrin_Price_Updated}
    ...                                      0              ${All_State_Packge_Price}

Validate Items In Payment Receipt
    [Arguments]          ${Tag_Type}=${EMPTY}                    ${Tag_Price}=${0}                       ${Tax_Price}=${0}
    ...                  ${Bump_Type}=${EMPTY}                   ${Bump_Price}=${0}
    ...                  ${All_Iran_Packge_Price}=${0}           ${All_State_Packge_Price}=${0}

    Run Keyword If      '${Tag_Type}' != '${EMPTY}'              Validate Tag In Receipt                  ${Tag_Type}         ${Tag_Price}
    Run Keyword If      '${Bump_Type}' != '${EMPTY}'             Validate Bump In Receipt                 ${Bump_Type}        ${Bump_Price}
    Run Keyword If      '${All_Iran_Packge_Price}' != '${0}'     Validate All Iran Package In Receipt     ${All_Iran_Packge_Price}
    Run Keyword If      '${All_State_Packge_Price}' != '${0}'    Validate All State Package In Receipt    ${All_State_Packge_Price}
    Run Keyword If      '${Tax_Price}' != '${0}'                 Validate Tax In Receipt                  ${Tax_Price}
    ${Total_Price}       Evaluate                      ${Tag_Price} + ${All_State_Packge_Price} + ${All_Iran_Packge_Price} + ${Tax_Price} + ${Bump_Price}
    Validate Total In Receipt             ${Total_Price}

Validate Tag In Receipt
    [Arguments]                        ${Tag_Type}                         ${Tag_Price}
    Page Should Contain Text           ${Tag_Type}                         timeout=5s
    ${Tag_Price_Receipt}               Convert Number To Price             ${Tag_Price}0      ,
    Page Should Contain Text           ${Tag_Price_Receipt}                timeout=5s

Validate Bump In Receipt
    [Arguments]                        ${Bump_Type}                        ${Bump_Price}
    Page Should Contain Text           ${Bump_Type}                        timeout=5s
    ${Bump_Price_Receipt}               Convert Number To Price            ${Bump_Price}0      ,
    Page Should Contain Text           ${Bump_Price_Receipt}               timeout=5s

Validate All Iran Package In Receipt
    [Arguments]                        ${All_Iran_Packge_Price}
    Page Should Contain Text           ${PAID_FEATURE_ALL_IRAN_TXT}       timeout=5s
    ${All_Packge_Price_Receipt}        Convert Number To Price             ${All_Iran_Packge_Price}0      ,
    Page Should Contain Text           ${All_Packge_Price_Receipt}         timeout=5s

Validate All State Package In Receipt
    [Arguments]                        ${All_State_Packge_Price}
    Page Should Contain Text           ${PAID_FEATURE_ALL_STATE_TXT}       timeout=5s
    ${All_Packge_Price_Receipt}        Convert Number To Price             ${All_State_Packge_Price}0      ,
    Page Should Contain Text           ${All_Packge_Price_Receipt}         timeout=5s

Validate Tax In Receipt
    [Arguments]                        ${Tax_Price}
    Page Should Contain Text           ${RECEIPT_TAX_TXT}                  timeout=5s
    ${Tax_Price_Receipt}               Convert Number To Price             ${Tax_Price}0              ,
    Page Should Contain Text           ${Tax_Price_Receipt}                timeout=5s

Validate Total In Receipt
    [Arguments]                        ${Total_Price}
    Page Should Contain Text           ${RECEIPT_TOTAL_PRICE_TXT}          timeout=5s
    ${Total_Price_Receipt}             Convert Number To Price             ${Total_Price}0            ,
    Page Should Contain Text           ${Total_Price_Receipt}              timeout=5s

####################################        Keywords for Selecting Tag      #################################
Check No Payment Summery In Paid Feature For Specific Tag
    [Arguments]                               ${Tag_Type}
    Check No Payment Summery In Paid Feature                ${Tag_Type}

Validate Payment Summery In Paid Feature For Specific Tag And Press Payment
    Validate Payment Summery In Paid Feature
    ...             Tag_Type=${Tag_Type}         Tag_Price=${Tag_Price}     Tax_Price=${Tax_Price}
    Press Payment Button In Paid Feature

Success Payment For Specific Tag
    Success Payment For Some Features       Tag_Type=${Tag_Type}   Tag_Price=${Tag_Price}    Tax_Price=${Tax_Price}

Validate Listing Details Items With Tag
    [Arguments]                     ${Tag_Type}
    Check Listing Title In My Listing Page
    Validate Listing Details Items       ${Category}      ${SubCategory}         ${State}        ${City}       ${Region}
    ...         ${Listings_price}        NewUsed=${NewUsed}                      Tag_Type=${Tag_Type}

Validate Payment Summery In Paid Feature For A Tag And All State And Press Payment
    Validate Payment Summery In Paid Feature     Tag_Type=${Tag_Type}         Tag_Price=${Tag_Price}
    ...                              All_Packge_Price=${All_State_Packge_Price}         Tax_Price=${Tax_Price}
    Press Payment Button In Paid Feature

Success Payment For A Tag And All State
    Success Payment For Some Features       Tag_Type=${Tag_Type}    Tag_Price=${Tag_Price}
    ...                         All_State_Packge_Price=${All_State_Packge_Price}    Tax_Price=${Tax_Price}

####################################        Chip Discount Tag      #################################
Set Listing Limit For Home Appliances Category
    Set Listing Limit For Cat per locations                parentid=${Category_ID}  catid=${SubCategory_ID}  regid=${State_ID}
    ...                                 cityid=${City_ID}  nghid=${Region_ID}       limitcount=${30}         limitprice=${11000}

Post A New Listing In Home Appliances Category
    Post A New Listing            ${Category_ID}        ${Number_Of_Photos}       ${Category}                 ${SubCategory}
    ...         ${State}          ${City}               ${Region}                Chip_Diccount_Price=${Tag_Price}

Validate Selected Chip Discount Tag In Paid Feature
    Validate Status Tag In Paid Feature       ${Tag_Type}           ${Tag_Price}         ${Tax_Price}     selected

Validate Unselected Chip Discount Tag In Paid Feature
    Validate Unselected Tag Type In Paid Feature

Validate Listing Details Items With Chip Discount
    Validate Listing Details Items With Tag         ${Tag_Type}

#############################################        Instant Tag      ############################################
Set Listing Limit For Electronic Category
    Set Listing Limit For Cat per locations                parentid=${Category_ID}  catid=${SubCategory_ID}  regid=${State_ID}
    ...                                 cityid=${City_ID}  nghid=${Region_ID}       limitcount=${30}         limitprice=${11000}

Post A New Listing In Electronics Category
    Post A New Listing            ${SubCategory_ID}        ${Number_Of_Photos}       ${Category}       ${SubCategory}
    ...                           ${State}                 ${City}                   ${Region}         NewUsed=${NewUsed}
    ...                           Sub_SubCategory=${Sub_SubCategory}              Instant_Tag_Price=${Tag_Price}
    ...                           BarCode=${BarCode}

Validate Selected Instant Tag in Paid Feature
    Validate Status Tag In Paid Feature       ${Tag_Type}           ${Tag_Price}         ${Tax_Price}     selected

Validate Unselected Instant Tag In Paid Feature
    Validate Unselected Tag Type In Paid Feature

Validate Unselected Tag Type In Paid Feature
    Validate Status Tag In Paid Feature       ${Tag_Type}           ${Tag_Price}         ${Tax_Price}     unselected
    Check No Payment Summery In Paid Feature For Specific Tag       ${Tag_Type}
