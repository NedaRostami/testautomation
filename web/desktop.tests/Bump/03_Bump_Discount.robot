*** Settings ***
Documentation                                    Bump a listing with Discount Code
...                                              Check Gallery view,Bump with 100% coupon
...                                              Verify Bump is First in Listing
...                                              Verify Number of Listing in Vitrin
Resource                                         ../../resources/bumps.resource
Test Setup                                       Test Setup Init
Test Teardown                                    Clean Up Tests
Test Template                                    Bump ${BumpeType} with Discount Code by ${Price} and validator ${ValidatorText}


*** Variables ***
${CatID}                                         43633
${SubCatID}                                      43637
${BrandID}                                       ${EMPTY}
${CatName}                                       خرید و فروش عمده
${state_name}                                    خراسان رضوی
${State_Id}                                      11
${city_name}                                     مشهد
${City_Id}                                       444
${region_name}                                   آبکوه
${Region_Id}                                     3844

*** Test Cases ***
Bump a listing By Discount Code
    [Tags]                    Bump                    BumpDiscount
    group_refresh             ${bump_group_refresh}   ${PF_Bump_Header}
    group_top3                ${bump_group_top3}      ${PF_Vitrin_Update_24}

*** Keywords ***
Bump ${BumpeType} with Discount Code by ${Price} and validator ${ValidatorText}
    Set Test Variable                                 ${BumpeType}
    ${DiscountType}                                   Set Variable If    '${BumpeType}' == 'group_refresh'      refresh_once    refresh_1day1x
    Create Discount Code                              ${DiscountType}
    Post a listing
    Click Button                                      ${ML_Increase_View_Listing.format('${AdsId}')}
    Run Keyword And Ignore Error                      Wait Until Page Contains Element          xpath://*[@id="popup-secure-purchase-activation" and contains(@class, 'open')]    timeout=5s
    Run Keyword And Ignore Error                      Click Button                              ${PF_Cancel_Btn}
    Wait Until Page Contains                          ${PF_Bump_Header}                                              timeout=5s
    Add zaleniumMessage Cookie                        wrong Discount
    ${BumpSelectButtons}                              Get WebElements                      ${PF_Bump_Slider_Selector}
    Check Wrong Discount Code                         ${BumpSelectButtons}[${${BumpeType}_BumpSelectButton}]      #کد تخفیف اشتباه
    Add zaleniumMessage Cookie                        try bump ${BumpeType} Discount
    Select Bump Button and Apply Discount             ${BumpSelectButtons}[${${BumpeType}_BumpSelectButton}]      ${Price}    ${Random_Code}    ${Price}
    Wait Until Page Contains                          ${PF_Successful_Payment}
    Page Should Not Contain                           ${PF_Order_Error}
    Validate Invoice Form With Coupon
    Run Keyword If  '${BumpeType}' != 'group_refresh'
    ...  Wait Until Keyword Succeeds    5x    2s      Disabled Bump    ${PF_Bump_Header}   ${SubCatID}
    Click Link                                        ${AllAdvs}
    Verify Bump is in Top 3 in Serp
