*** Settings ***
Resource        ..${/}..${/}resources${/}PaidFeatureKeywords.resource
Suite Setup      Set Suite Environment
Test Setup       start app
Test Teardown    Close test application For Insert Photos
Test Timeout     10 minutes
Documentation       در این سناریو میخواهیم بعد از تعریف بسته های بامپ ، ال ایران و آل استیت در صفحه ادمین، اگهی را ثبت کنیم.
...     بعد از ثبت اگهی وارد صفحه پیدفیچر شده و بسته بامپ و ال ایران را با هم خرید می کنیم
...     در این حالت بعد از انتخاب ال ایران باید قیمت بامپ سه برابر شود. سپس فاکتور پرداخت را بررسی کرده
...     و در صورت درست بودن همه اعداد وارد مرحله پرداخت شده و خرید را تکمیل می کنیم.
...      بعد از خرید بار اول، مجدد وارد صفحه پیدفیچر شده و همان بسته ال ایران و بامپ را انتخاب می کنیم
...     اما این بار قیمت بسته بامپ باید قبل از انتخاب ال ایران، سه برابر مقدار تعریف شده باشد.
...     باز هم بعد از بررسی فاکتور و در صورت صحت ان مرحله پرداخت را تکمیل و ان را بررسی می کنیم.

*** Variables ***
${State}                                        قزوین
${State_ID}                                     18
${City}                                         قزوین
${City_ID}                                      703
${Region}                                       ملاصدرا
${Region_ID}                                    ${EMPTY}
${Sleep_time}                                   2s
${Timeout}                                      10s

#${State}                                        سمنان
#${State_ID}                                     15                 # Semnan Province
#${City}                                         گرمسار
#${City_ID}                                      558
#${Region}                                       ${EMPTY}
#${Region_ID}                                    ${EMPTY}
#${Sleep_time}                                   2s
#${Timeout}                                      10s

${Category}                                     لوازم الکترونیکی
${Category_ID}                                  43596
${SubCategory}                                  لوازم کامپیوتر و پرینتر
${SubCategory_ID}                               44200
${Number_Of_Photos}                             3


${Bump_Type}                                    ۱ بار بروزرسانی
${Bump_ID}                                      5:1
${Bump_Type_Receipt}                            بروزرسانی (۱ بار بروزرسانی)
${All_Iran_Packge_Price}                        299900
${All_State_Packge_Price}                       120000
${Bump_Packge_Price}                            5000
${Tax_Price}                                    28341


*** Test Cases ***
Post Listing With 2 Times Buy All Iran and Bump Features
    [Tags]    ALlIran    bump       Listing   wrongprices

    Check Min Accepted Version Is  5.5.0
    Set Listing Limit For Electronic Category
    Set Packages For Bump and AllIran and AllState
    Post A New Listing In Electronic Category
    Select Bump And All Iran
    Validate Payment Summery In Paid Feature For Bump And All Iran And Press Payment
    Success Payment For Bump And All Iran Features
    Select Bump And All Iran For Second Time
    Validate Payment Summery In Paid Feature For Bump And All Iran And Press Payment
    Success Payment For Bump And All Iran Features


*** Keywords ***
Set Listing Limit For Electronic Category
    Set Listing Limit For Cat per locations                parentid=${Category_ID}  catid=${SubCategory_ID}  regid=${State_ID}
    ...                                 cityid=${City_ID}  nghid=${Region_ID}       limitcount=${30}         limitprice=${11000}

Post A New Listing In Electronic Category
    Post A New Listing                            ${Category_ID}        ${Number_Of_Photos}       ${Category}
    ...                  ${SubCategory}           ${State}              ${City}                   ${Region}

Select Bump And All Iran For Second Time
    Open Paid Feature Page
    Update Bump Price
    Select Bump                       ${Bump_Type}                   ${Bump_Packge_Price}
    Select All Iran OR All State      ${All_Iran_Packge_Price}       ${All_State_Packge_Price}      All_Iran
    ${Bump_Price_text}                Convert Number To Price        ${Bump_Packge_Price}
    ${Bump_Price_text}                Set Variable                   ${Bump_Price_text}${SPACE}تومان
    Page Should Contain Element By ID And Text                       ${PAID_FEATURE_BUMP_PRICE}          ${Bump_Price_text}
