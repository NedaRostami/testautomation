*** Settings ***
Resource        ..${/}..${/}resources${/}PaidFeatureKeywords.resource
Suite Setup      Set Suite Environment
Test Setup       start app
Test Teardown    Close test application For Insert Photos
Test Timeout     10 minutes
Documentation       در این سناریو میخواهیم بعد از تعریف بسته های بامپ ، ال ایران و آل استیت در صفحه ادمین، اگهی را ثبت کنیم.
...     بعد از ثبت اگهی وارد صفحه پیدفیچر شده و بسته بامپ و ال استیت را با هم خرید می کنیم
...     در این حالت بعد از انتخاب ال استیت باید قیمت بامپ دوبرابر شود. سپس فاکتور پرداخت را بررسی کرده
...     و در صورت درست بودن همه اعداد وارد مرحله پرداخت شده و خرید را تکمیل می کنیم.

*** Variables ***
${State}                                        ایلام
${State_ID}                                     6
${City}                                         ایوان
${City_ID}                                      240
${Region}                                       خیابان مطهر-کوچه ورعی
${Region_ID}                                    ${EMPTY}
${Sleep_time}                                   2s
${Timeout}                                      10s

#${State}                                        یزد
#${State_ID}                                     31
#${City}                                         ندوشن
#${City_ID}                                      1108
#${Region}                                       ${EMPTY}
#${Region_ID}                                    ${EMPTY}
#${Sleep_time}                                   2s
#${Timeout}                                      10s

${Category}                                     صنعتی، اداری و تجاری
${Category_ID}                                  43631
${SubCategory}                                  دیگر
${SubCategory_ID}                               44807
${Number_Of_Photos}                             3

${Bump_Type}                                    ۱ بار بروزرسانی
${Bump_ID}                                      5:1
${Bump_Type_Receipt}                            بروزرسانی (۱ بار بروزرسانی)

${All_Iran_Packge_Price}                        299900
${All_State_Packge_Price}                       120000
${Bump_Packge_Price}                            5000
${Tax_Price}                                    11700       # (10000+120000)*0.09    =  11700


*** Test Cases ***
Post Listing With All State and Bump Features
    [Tags]    AllState    bump       Listing   wrongprices

    Check Min Accepted Version Is  5.5.0
    Set Listing Limit For Industrial Category
    Set Packages For Bump and AllIran and AllState
    Post A New Listing In Industrial Category
    Select Bump And All State
    Validate Payment Summery In Paid Feature For Bump And All State And Press Payment
    Success Payment For Bump And All State Features


*** Keywords ***
Set Listing Limit For Industrial Category
    Set Listing Limit For Cat per locations                parentid=${Category_ID}  catid=${SubCategory_ID}  regid=${State_ID}
    ...                                 cityid=${City_ID}  nghid=${Region_ID}       limitcount=${30}         limitprice=${11000}

Post A New Listing In Industrial Category
    Post A New Listing                            ${Category_ID}        ${Number_Of_Photos}       ${Category}
    ...                  ${SubCategory}           ${State}              ${City}                   ${Region}
