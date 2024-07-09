*** Settings ***
Resource        ..${/}..${/}resources${/}PaidFeatureKeywords.resource
Suite Setup      Set Suite Environment
Test Setup       start app
Test Teardown    Close test application For Insert Photos
Test Timeout     10 minutes
Documentation       در این سناریو میخواهیم بعد از تعریف بسته های بامپ ، ویترین، ال ایران و آل استیت در صفحه ادمین، اگهی را ثبت کنیم.
...     بعد از ثبت اگهی وارد صفحه پیدفیچر شده و برای بار اول بسته ویترین و ال استیت را با هم خرید می کنیم
...     در این حالت بعد از انتخاب ال استیت باید قیمت ویترین دوبرابر شود. بعد از پرداخت مجدد وارد صفحه پیدفیچر میشویم.
...     و در این حالت قیمت بسته بامپ باید دوبرابر مقدار تعریف شده در صفحه ادمین باشد.
...      این بار بسته بامپ و ال استیت را انتخاب کرده و
...     بعد از ان رسید را بررسی کرده و در صورت درست بودن مبالغ وارد مراحل پرداخت میشویم و پروسه را تکمیل می کنیم


*** Variables ***
${State}                                        گیلان
${State_ID}                                     26
${City}                                         رشت
${City_ID}                                      920
${Region}                                       آب و برق
${Region_ID}                                    6990
${Sleep_time}                                   2s
${Timeout}                                      10s

${Category}                                     موبایل، تبلت و لوازم
${Category_ID}                                  44096
${SubCategory}                                  لوازم موبایل
${SubCategory_ID}                               43602
${Number_Of_Photos}                             3

${Bump_Type}                                    ۱ بار بروزرسانی
${Bump_ID}                                      5:1
${Bump_Type_Receipt}                            بروزرسانی (۱ بار بروزرسانی)

${Vitrin_Type}                                  ۷ روزه + ۷ بروزرسانی
${Vitrin_ID}                                    6:8
${Vitrin_Type_Receipt}                          ویترین + بروزرسانی (۷ روزه)

${Tax_Price}                                    16200        # (60000+120000)*0.09    =  16200
${Tax_Price_Second}                             11700       # (10000+120000)*0.09    =  11700

${All_Iran_Packge_Price}                        299900
${All_State_Packge_Price}                       120000
${Vitrin_Packge_Price}                          30000
${Bump_Packge_Price}                            5000


*** Test Cases ***
Post Listing With 2 Times Buy All State and Bump+Vitrin Features
    [Tags]    AllState    Vitrin    bump   Listing   wrongprices

    Check Min Accepted Version Is  5.5.0
    Set Listing Limit For Mobile Category
    Set Packages For Bump and Vitrin and AllIran and AllState
    Post A New Listing In Mobile Category
    Select Vitrin And All State
    Validate Payment Summery In Paid Feature For Vitrin And All State And Press Payment
    Success Payment For Vitrin And All State Features
#   Comment:  We choose Bump pakage because customer dont allow to buy a vitrin package for the second time.
    Select Bump And All State
    Validate Payment Summery In Paid Feature For Bump And All State And Press Payment
    Success Payment For Bump And All State Features


*** Keywords ***
Set Listing Limit For Mobile Category
    Set Listing Limit For Cat per locations                parentid=${Category_ID}  catid=${SubCategory_ID}  regid=${State_ID}
    ...                                 cityid=${City_ID}  nghid=${Region_ID}       limitcount=${30}         limitprice=${11000}

Post A New Listing In Mobile Category
    Post A New Listing                            ${Category_ID}        ${Number_Of_Photos}       ${Category}
    ...                  ${SubCategory}           ${State}              ${City}                   ${Region}

Select Bump And All State
    Open Paid Feature Page
    Update Bump Price
    Select Bump                       ${Bump_Type}          ${Bump_Price_Updated}
    Select All Iran OR All State      ${All_Iran_Packge_Price}       ${All_State_Packge_Price}     All_State
    ${Bump_Price_text}                Convert Number To Price   ${Bump_Price_Updated}
    ${Bump_Price_text}                Set Variable              ${Bump_Price_text}${SPACE}تومان
    Page Should Contain Element By ID And Text                  ${PAID_FEATURE_BUMP_PRICE}          ${Bump_Price_text}

Update Bump Price
    ${Bump_Price_Updated}             Evaluate                  2 * ${Bump_Packge_Price}
    Set Suite Variable                ${Bump_Price_Updated}     ${Bump_Price_Updated}

Validate Payment Summery In Paid Feature For Bump And All State And Press Payment
    Validate Payment Summery In Paid Feature    All_Packge_Price=${All_State_Packge_Price}  Tax_Price=${Tax_Price_Second}
    ...             Bump_Type=${Bump_Type}    Bump_Price=${Bump_Price_Updated}
    Press Payment Button In Paid Feature

Success Payment For Bump And All State Features
    Success Payment For Some Features       ${EMPTY}    0   ${Tax_Price_Second}   ${Bump_Type}     ${Bump_Price_Updated}
    ...              0        ${All_State_Packge_Price}
