*** Settings ***
Documentation                                    Advanced search and filter for real estate
...                                              validate all tags and breadcrumbs
Test Setup                                       Open test browser
Test Teardown                                    Clean Up Tests
Resource                                         ../../../resources/serp.resource

***Variables***




*** Test Cases ***
Search Advancde For Real Estate To Rent
    [Tags]                                        serp  search  real estate
    Go To Serp Page
    Select Rent Category and Validate It
    Input Mortgage Prices
    Input Rent Prices
    Select Property Type
    Input Area Size
    choice Room Numbers
    Choose Location

*** Keywords ***
Select Rent Category and Validate It
    Click Element                                  ${Serp_F_Category_Menu}
    Click Element                                  ${Serp_F_Main_Category.format('املاک')}
    Wait Until Page Contains Element               ${Serp_F_Category_Subs.format('رهن و اجاره خانه و آپارتمان')}
    Click Element                                  ${Serp_F_Category_Subs.format('رهن و اجاره خانه و آپارتمان')}
    Set Serp Breadcrumbs And Validate Position     2                                                                همه ایران
    Set Serp Breadcrumbs And Validate Position     4                                                                رهن و اجاره خانه و آپارتمان
    Set Serp Tag Variable And Validate Position    1                                                                رهن و اجاره خانه و آپارتمان
    Set Selenium Speed                             100ms

choice Room Numbers
    Select From List By Value                      ${Serp_F_Re_Num_Of_Rooms}        439414              #تعداد اتاق
    Set Serp Tag Variable And Validate Position    9                                تعداد اتاق: ۱

Input Area Size
    Input Min Size                                #حداقل متراژ
    Input Max Size                                #حداکثر متراژ

Input Rent Prices
    Input Min Rent                                #حداقل اجاره
    Input Max Rent                                #حداکثر اجاره

Input Mortgage Prices
    Input Mortgage Min Price                      #حداقل رهن
    Input Mortgage Max Price                      #حداکثر رهن

Select Property Type
    Select From List By Value                      ${Serp_F_Re_Type}    440477                         #نوع ملک
    Set Serp Tag Variable And Validate Position    6                   نوع ملک: آپارتمان

Select label
  [Arguments]    ${locator}      ${label}
  Wait Until Keyword Succeeds    3x    2s          Select From List By Label               ${locator}      ${label}

Input Mortgage Min Price
    Input Text	                                   ${Serp_F_Re_Min_Mortgage}               10000000
    Do Enter And Wait Until Page Reloaded          ${Serp_F_Re_Min_Mortgage}
    Set Serp Tag Variable And Validate Position    2                                       حداقل رهن: ۱۰,۰۰۰,۰۰۰ تومان

Input Mortgage Max Price
    Input Text                                     ${Serp_F_Re_Max_Mortgage}               200000000
    Do Enter And Wait Until Page Reloaded	         ${Serp_F_Re_Max_Mortgage}
    Set Serp Tag Variable And Validate Position    3                                       حداکثر رهن: ۲۰۰,۰۰۰,۰۰۰ تومان


Input Min Rent
    Input Text                                     ${Serp_F_Re_Min_Rent}                   500000
    Do Enter And Wait Until Page Reloaded          ${Serp_F_Re_Min_Rent}
    Set Serp Tag Variable And Validate Position    4                                       حداقل اجاره: ۵۰۰,۰۰۰ تومان


Input Max Rent
    Input Text                                     ${Serp_F_Re_Max_Rent}                   20000000
    Do Enter And Wait Until Page Reloaded          ${Serp_F_Re_Max_Rent}
    Set Serp Tag Variable And Validate Position    5                                       حداکثر اجاره: ۲۰,۰۰۰,۰۰۰ تومان


Input Min Size
    Input Text                                     ${Serp_F_Re_Min_Area}                    100
    Do Enter And Wait Until Page Reloaded          ${Serp_F_Re_Min_Area}
    Set Serp Tag Variable And Validate Position    7                                        حداقل متراژ: ۱۰۰

Input Max Size
    Input Text                                     ${Serp_F_Re_Max_Area}                    500
    Do Enter And Wait Until Page Reloaded          ${Serp_F_Re_Max_Area}
    Set Serp Tag Variable And Validate Position    8                                        حداکثر متراژ: ۵۰۰


Choose Location
    Click Element                                  ${Serp_F_Location_Menu}
    Click Element                                  ${Serp_F_Location_Province.format(8)}
    Wait Until Page Contains                       همه‌ی استان تهران                          timeout=3s
    Click Element                                  ${Serp_F_Location_City.format(301)}
    Set Serp Breadcrumbs And Validate Position     2                                         تهران
    Set Serp Breadcrumbs And Validate Position     3                                         تهران
    Set Serp Tag Variable And Validate Position    1                                         شهر: تهران
    Click Element                                  ${Serp_F_District_Menu}
    Click Element                                  ${Serp_F_Location_District.format(928)}   #آپادانا - خرمشهر
    Click Element                                  ${Serp_F_Location_District.format(1047)}  #خرمشهر - نواب
    Click Button                                   انتخاب ۲ محله
    Set Serp Tag Variable And Validate Position    2                                         محله: آپادانا - خرمشهر، خرمشهر - نواب
    Set Serp Breadcrumbs And Validate Position     4                                         آپادانا - خرمشهر
    Page Should Contain Element                    ${Serp_F_Section_Subs}
