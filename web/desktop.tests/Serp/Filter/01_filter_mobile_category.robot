*** Settings ***
Documentation                                    Advanced search for
...                                              mobile brand and then Delete
...                                              all tags
Test Setup                                       Open test browser
Test Teardown                                    Clean Up Tests
Resource                                         ../../../resources/serp.resource

*** Variables ***
${Cat}                                           موبایل و تبلت
${Brand}                                         اپل | Apple

*** Test Case ***
Search Advanced For Mobile Category
    [Tags]                                       serp    search   mobile
    Go To Serp Page
    Select Mobile and Tablet
    Select Apple Brand
    Input Min Price
    Input Max Price
    Delete Price Tags
    Delete Mobile And Tablet Tag


*** Keywords ***
Select Mobile and Tablet
    Set Selenium Speed                             500ms
    Click Element                                  ${Serp_F_Category_Menu}
    Wait Until Page Contains                       همه گروه‌ها
    Click Link                                     ${Cat}
    Set Serp Breadcrumbs And Validate Position     4                                              ${Cat}
    Set Serp Tag Variable And Validate Position    1                                              ${Cat}


Select Apple Brand
    click element                                  ${Serp_F_Brand_Menu}
    click element                                  ${Serp_F_Brand_By_ID.format(44006)}
    Set Serp Tag Variable And Validate Position    2                                              ${Brand}

Input Max Price
    Input Text                                     ${Serp_F_Max_Price}                             4000000
    Do Enter And Wait Until Page Reloaded	         ${Serp_F_Min_Price}
    Set Serp Tag Variable And Validate Position    4                                               قیمت تا (تومان): ۴,۰۰۰,۰۰۰

Input Min Price
    Input Text	                                   ${Serp_F_Min_Price}                             1000000
    Do Enter And Wait Until Page Reloaded          ${Serp_F_Max_Price}
    Set Serp Tag Variable And Validate Position    3                                               قیمت از (تومان): ۱,۰۰۰,۰۰۰

Delete Price Tags
    Click Element                                  ${Serp_Tag_Close.format(4)}
    Wait Until Page Does Not Contain               قیمت تا (تومان): ۴,۰۰۰,۰۰۰                      timeout=5s
    Click Element                                  ${Serp_Tag_Close.format(3)}
    Wait Until Page Does Not Contain               قیمت از (تومان): ۱,۰۰۰,۰۰۰                      timeout=5s

Delete Mobile And Tablet Tag
    click element                                  ${Serp_Tag_Close.format(2)}
    Wait Until Page Contains                       آگهی های ${Cat} در ${AllIran}                   5s
    click element                                  ${Serp_Tag_Close.format(1)}
    Wait Until Page Contains                       ${IranAllH1}                                    5s


Select label
    [Arguments]                                   ${locator}                                       ${label}
    Wait Until Keyword Succeeds                   3x    2s                                         Select From List By Label    ${locator}    ${label}
