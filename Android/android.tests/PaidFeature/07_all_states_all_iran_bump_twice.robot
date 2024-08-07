*** Settings ***
Resource        ..${/}..${/}resources${/}PaidFeatureKeywords.resource
Suite Setup      Set Suite Environment
Test Setup       start app
Test Teardown    Close test application For Insert Photos
Test Timeout     10 minutes
Documentation     مرحله اول خرید ال استیت و بروز رسانی ---> قیمت بروزرسانی ۲ برابر ---->
...     مرحله دوم خرید ال ایران و بروزرسانی ----> قیمت بروز رسانی در ابتدا ۲ برابر را نشان بده ولی بعد از انتخاب ال ایران باید به ۳ برابر تغییر کنه
...     به دلیل عدم پیاده سازی کد این سناریو در حالت notest میماند.

*** Variables ***
${State}                                        آذربایجان شرقی
${State_ID}                                     1
${City}                                         تبریز
${City_ID}                                      12
${Region}                                       استادان
${Region_ID}                                    4513
${Sleep_time}                                   2s
${Timeout}                                      10s

${Category}                                     صنعتی، اداری و تجاری
${Category_ID}                                  43631
${SubCategory}                                  تجهیزات و لوازم کافه و رستوران
${SubCategory_ID}                               44802
${Number_Of_Photos}                             3

${Bump_Type}                                    ۱۰ بروزرسانی / ۳ روز ۱ بار
${Bump_ID}                                      5:4
${Bump_Type_Receipt}                            بروزرسانی (۱۰ بروزرسانی)

${All_Iran_Packge_Price}                        299900
${All_State_Packge_Price}                       120000
${Bump_Packge_Price}                            20000

${Tax_Price}                                    14400       # (40000+120000)*0.09    =  14400
${Tax_Price_Second}                             32391       # (60000+299900)*0.09    =  32391


*** Test Cases ***
#TODO: After developing code, remove notest tag from this scenario
Post Listing With 2 Times Buy All State and Bump And Then All Iran and Bump
    [Tags]    ALlIran    bump       Listing     AllState    notest

    Check Min Accepted Version Is  5.5.0
    Set Listing Limit For Industrial Category
    Set Packages For Bump and AllIran and AllState
    Post A New Listing In Industrial Category
    Select Bump And All State
    Validate Payment Summery In Paid Feature For Bump And All State And Press Payment
    Success Payment For Bump And All State Features
    Select Bump And All Iran
    Validate Payment Summery In Paid Feature For Bump And All Iran And Press Payment
    Success Payment For Bump And All Iran Features


*** Keywords ***
Set Listing Limit For Industrial Category
    Set Listing Limit For Cat per locations                parentid=${Category_ID}  catid=${SubCategory_ID}  regid=${State_ID}
    ...                                 cityid=${City_ID}  nghid=${Region_ID}       limitcount=${30}         limitprice=${11000}

Post A New Listing In Industrial Category
    Post A New Listing                            ${Category_ID}        ${Number_Of_Photos}       ${Category}
    ...                  ${SubCategory}           ${State}              ${City}                   ${Region}

Validate Payment Summery In Paid Feature For Bump And All State And Press Payment
    Validate Payment Summery In Paid Feature    Bump_Type=${Bump_Type_Receipt}   Bump_Price=${Bump_Price_Updated}
    ...                      All_Packge_Price=${All_State_Packge_Price}   Tax_Price=${Tax_Price}
    Press Payment Button In Paid Feature

Success Payment For Bump And All State Features
    Success Payment For Some Features       Bump_Type=${Bump_Type_Receipt}           Bump_Price‍‍=${Bump_Price_Updated}
    ...                  All_State_Packge_Price=${All_State_Packge_Price}    Tax_Price=${Tax_Price}

Select Bump And All Iran
    Open Paid Feature Page
    Select Bump                       ${Bump_Type}                   ${Bump_Price_Updated}
    Select All Iran OR All State      ${All_Iran_Packge_Price}       ${All_State_Packge_Price}     All_Iran
    Validate Changing Bump Price Based On All Iran                   ${All_Iran_Packge_Price}



Validate Payment Summery In Paid Feature For Bump And All Iran And Press Payment
    Validate Payment Summery In Paid Feature    Bump_Type=${Bump_Type_Receipt}   Bump_Price=${Bump_Price_Updated}
    ...                      All_Packge_Price=${All_Iran_Packge_Price}   Tax_Price=${Tax_Price_Second}
    Press Payment Button In Paid Feature

Success Payment For Bump And All Iran Features
    Success Payment For Some Features       Bump_Type=${Bump_Type_Receipt}           Bump_Price‍‍=${Bump_Price_Updated}
    ...                  All_Iran_Packge_Price=${All_Iran_Packge_Price}      Tax_Price=${Tax_Price_Second}
