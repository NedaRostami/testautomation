*** Settings ***
Documentation                                    Bump a listing Unsuccessfully
...                                              Check Gallery view
...                                              Verify Bump is First in Listing
...                                              Verify Number of Listing in Vitrin
Resource                                         ../../resources/bumps.resource
Test Setup                                       Test Setup Init
Test Teardown                                    Clean Up Tests
Test Template                                    Bump a listing Unsuccessfully For ${BumpeType} by ${Price}

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
Bump a listing Unsuccessfully
    [Tags]                                        Bump   BumpUnsuccessfully
    group_top3                                    ${bump_group_top3}
    group_refresh                                 ${bump_group_refresh}

*** Keywords ***
Bump a listing Unsuccessfully For ${BumpeType} by ${Price}
    Set Test Variable                              ${BumpeType}
    Set Test Variable                              ${Price}
    Set Test Payment Gateway                       failure
    Post a listing
    Click Button                                   ${ML_Increase_View_Listing.format('${AdsId}')}
    Run Keyword And Ignore Error                   Wait Until Page Contains Element          xpath://*[@id="popup-secure-purchase-activation" and contains(@class, 'open')]    timeout=5s
    Run Keyword And Ignore Error                   Click Button                              ${PF_Cancel_Btn}
    Run Keyword If    	                           ${Toggle_paid-features-bumps}                                     Validate Page Is In PF view
    Run Keyword If                                 ${in_Bump_Pf_view}                                                Bumping Unsuccessfully IN Paid Feature
    ...  ELSE                                      Bumping Unsuccessfully Without Paid Feature

Bumping Unsuccessfully Without Paid Feature
    Add zaleniumMessage Cookie                     try bump ${BumpeType} Unsuccessfully
    ${BumpSelectButtons}                           Get WebElements                                                   ${PF_Bumps_Btn_Selector}
    Bump Listing                                   ${BumpSelectButtons}[${${BumpeType}_BumpSelectButton}]            ${Price}
    Wait Until Page Contains                       ${PF_Unsuccessful_Payment}                                                     timeout=10s
    Click Link                                     ${PF_Return_To_View_Increase}
    Wait Until Page Contains                       ${PF_Bump_Header}                                                      timeout=10s
    Verify Packages Rules

Bumping Unsuccessfully IN Paid Feature
    Add zaleniumMessage Cookie                     try bump ${BumpeType} Unsuccessfully
    Wait Until Page Contains                       ${PF_Update_Order}                                      timeout=10s
    ${BumpSelectButtons}                           Get WebElements                                                   ${PF_Bump_Slider_Selector}
    Bump Listing in Paid Feature                   ${BumpSelectButtons}[${${BumpeType}_BumpSelectButton}]            ${Price}
    Wait Until Page Contains                       ${PF_Unsuccessful_Payment}                                      timeout=10s
