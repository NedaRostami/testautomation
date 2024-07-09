*** Settings ***
Resource        ..${/}..${/}resources${/}PaidFeatureKeywords.resource
Suite Setup      Set Suite Environment
Test Setup       start app
Test Teardown    Close test application For Insert Photos
Test Timeout     10 minutes
Documentation     بعد از ثبت اگهی ،‌ انتخاب پکیج های بروز رسانی و آل ایران و سپس بررسی پیش فاکتوری که در صفحه خرید بسته ها وجود دارد،‌
...        سپس پکیج آل ایران رو به آل استیت تغییر میدیم و مجددا پیش فاکتور را بررسی میکنیم،
...         در صورتی که مبالغ درست باشد به صفحه پرداخت رفته و پرداخت را کامل میکنیم و در صفحه پرداخت هم باید اعداد با پیش فاکتور یکسان باشد.
...         نکته قابل توجه افزایش ۲ برابری برای پکیج آل استیت و ۳ برابری برای پکیج آل ایران است که باید اعمال شود.

*** Variables ***
${State}                                        مازندران
${State_ID}                                     27
${City}                                         ساری
${City_ID}                                      972
${Region}                                       پشت چین دکا
${Region_ID}                                    5122
${Sleep_time}                                   2s
${Timeout}                                      10s

${Category}                                     خدمات و کسب و کار
${Category_ID}                                  43633
${SubCategory}                                  خودرو و موتورسیکلت
${SubCategory_ID}                               44813
${Number_Of_Photos}                             3

${Bump_Type}                                    ۵ بروزرسانی / روزی ۱ بار
${Bump_ID}                                      5:3
${Tax_Price}                                    29691      #  (30000+299900)*0.09    =  29691
${Tax_Price_Second}                             12600      #  (20000+120000)*0.09    =  12600
${Bump_Type_Receipt}                            بروزرسانی (۵ بروزرسانی)

${All_Iran_Packge_Price}                        299900
${All_State_Packge_Price}                       120000
${Bump_Packge_Price}                            10000


*** Test Cases ***
Post Listing With Bump and switch Between All Iran And All State Features
    [Tags]    ALlIran     AllState      bump       Listing   wrongprices

    Check Min Accepted Version Is  5.5.0
    Set Listing Limit For Business Category
    Set Packages For Bump and AllIran and AllState
    Post A New Listing In Sport Category
    Select Bump And All Iran
    Validate Payment Summery In Paid Feature For Bump And All Iran
    Select All State
    Validate Payment Summery In Paid Feature For Bump And All State And Press Payment
    Success Payment For Bump And All State Features


*** Keywords ***
Set Listing Limit For Business Category
    Set Listing Limit For Cat per locations                parentid=${Category_ID}  catid=${SubCategory_ID}  regid=${State_ID}
    ...                                 cityid=${City_ID}  nghid=${Region_ID}       limitcount=${30}         limitprice=${11000}

Post A New Listing In Sport Category
    Post A New Listing                            ${Category_ID}        ${Number_Of_Photos}       ${Category}
    ...                  ${SubCategory}           ${State}              ${City}                   ${Region}

Validate Payment Summery In Paid Feature For Bump And All Iran
    Validate Payment Summery In Paid Feature    Bump_Type=${Bump_Type}   Bump_Price=${Bump_Price_Updated}
    ...                      All_Packge_Price=${All_Iran_Packge_Price}   Tax_Price=${Tax_Price}

Select All State
    Select All Iran OR All State      ${All_Iran_Packge_Price}       ${All_State_Packge_Price}      All_State
    Validate Changing Bump Price Based On All State         ${Bump_Packge_Price}

Validate Payment Summery In Paid Feature For Bump And All State And Press Payment
    Validate Payment Summery In Paid Feature           All_Packge_Price=${All_State_Packge_Price}   Tax_Price=${Tax_Price_Second}
    ...                    Bump_Type=${Bump_Type}      Bump_Price=${Bump_Price_Updated}
    Press Payment Button In Paid Feature

Success Payment For Bump And All State Features
#    Success Payment For Some Features          Tax_Price=${Tax_Price_Second}        Bump_Type=${Bump_Type_Receipt}
#    ...                 Bump_Price‍‍=${Bump_Price_Updated}          All_State_Packge_Price=${All_State_Packge_Price}
    Success Payment For Some Features        ${EMPTY}   0   ${Tax_Price_Second}     ${Bump_Type_Receipt}    ${Bump_Price_Updated}
    ...                                      0              ${All_State_Packge_Price}
