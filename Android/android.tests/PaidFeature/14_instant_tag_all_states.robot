*** Settings ***
Resource        ..${/}..${/}resources${/}PaidFeatureKeywords.resource
Suite Setup      Set Suite Environment
Test Setup       start app
Test Teardown    Close test application For Insert Photos
Test Timeout     10 minutes
Documentation       در این سناریو میخواهیم بعد از تعریف تگ فوری در صفحه ادمین، اگهی را بدون انتخاب این تگ ثبت کنیم.
...     بعد از ثبت اگهی وارد صفحه پیدفیچر شده و بررسی می کنیم که تگ فوری با قیمت مورد نظر وجود داشته باشد اما نباید انتخاب شده باشد
...     در گام بعدی تگ فوری و بسته همه استان را انتخاب کرده و مقادیر خلاصه پرداخت را با مقادیر انتخاب شده مقایسه می کنیم.
...     درگام بعدی فرایند پرداخت را تکمیل می کنیم. در انتها وجود تگ فوری را در صفه جزییات اگهی بررسی می کنیم.

*** Variables ***

${State}                                        یزد
${State_ID}                                     31
${City}                                         یزد
${City_ID}                                      1111
${Region}                                       ${EMPTY}
${Region_ID}                                    ${EMPTY}
${Sleep_time}                                   2s
${Timeout}                                      10s

${Category}                                     لوازم الکترونیکی
${Category_ID}                                  43596
${SubCategory}                                  صوتی و تصویری
${SubCategory_ID}                               43601
${Sub_SubCategory}                              تلویزیون
${Sub_SubCategory_ID}                           50015
${Number_Of_Photos}                             3

${NewUsed}                                      در حد نو

${Tag_Type}                                     فوری
${Tag_ID}                                       10
${Tag_Price}                                    12500
${Tax_Price}                                    11925

${All_Iran_Packge_Price}                        300000
${All_State_Packge_Price}                       120000



*** Test Cases ***
Post Listing With Instant Tag And All State
    [Tags]    Instant       Listing

    Check Min Accepted Version Is  5.5.0
    Set Listing Limit For Electronic Category
    Set Packages For Instant Tag
    Post A New Listing In Electronics Category
    Validate Unselected Instant Tag In Paid Feature
    Select Instant Tag And All State
    Validate Payment Summery In Paid Feature For Instant Tag And All State And Press Payment
    Success Payment For Instant Tag And All State
    Validate Listing Details Items With Instant Tag


*** Keywords ***
Set Packages For Instant Tag
    Set Tag Price           catid=${Category_ID}   regionId=${State_ID}   price=${Tag_Price}   tagid=${Tag_ID}
    Set All Iran Price      catid=${Category_ID}   regionId=${State_ID}   price=${All_Iran_Packge_Price}
    Set All State Price     catid=${Category_ID}   regionId=${State_ID}   price=${All_State_Packge_Price}

Post A New Listing In Electronics Category
    Post A New Listing            ${SubCategory_ID}        ${Number_Of_Photos}       ${Category}       ${SubCategory}
    ...                           ${State}                 ${City}                   ${Region}         NewUsed=${NewUsed}
    ...                           Sub_SubCategory=${Sub_SubCategory}                 Instant_Tag_Price=${0}
    ...                           BarCode=${BarCode}

Select Instant Tag And All State
    Select Tag In Paid Feature           ${Tag_Type}
    Select All Iran OR All State         ${All_Iran_Packge_Price}       ${All_State_Packge_Price}          All_State

Validate Payment Summery In Paid Feature For Instant Tag And All State And Press Payment
    Validate Payment Summery In Paid Feature For A Tag And All State And Press Payment

Success Payment For Instant Tag And All State
    Success Payment For A Tag And All State

Validate Listing Details Items With Instant Tag
    Check Listing Title In My Listing Page
    Validate Listing Details Items       ${Category}      ${SubCategory}         ${State}        ${City}       ${Region}
    ...         NewUsed=${NewUsed}       Tag_Type=${Tag_Type}
