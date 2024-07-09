*** Settings ***
Resource        ..${/}..${/}resources${/}PaidFeatureKeywords.resource
Suite Setup      Set Suite Environment
Test Setup       start app
Test Teardown    Close test application For Insert Photos
Test Timeout     10 minutes
Documentation       در این سناریو میخواهیم بعد از تعریف تگ تخفیفی در صفحه ادمین، اگهی را بدون انتخاب این تگ ثبت کنیم.
...     بعد از ثبت اگهی وارد صفحه پیدفیچر شده و بررسی می کنیم که تگ تخفیفی با قیمت مورد نظر وجود داشته باشد اما نباید انتخاب شده باشد
...     در گام بعدی تگ تخفیفی و بسته همه استان را انتخاب کرده و مقادیر خلاصه پرداخت را با مقادیر انتخاب شده مقایسه می کنیم.
...     درگام بعدی فرایند پرداخت را تکمیل می کنیم. در انتها وجود تگ تخفیفی را در صفه جزییات اگهی بررسی می کنیم.


*** Variables ***
${State}                                        مازندران
${State_ID}                                     27
${City}                                         آمل
${City_ID}                                      951
${Region}                                       بلوار منفرد
${Region_ID}                                    7247
${Sleep_time}                                   2s
${Timeout}                                      10s

${Category}                                     لوازم خانگی
${Category_ID}                                  43608
${SubCategory}                                  دکوراسیون داخلی و روشنایی
${SubCategory_ID}                               44240
${Number_Of_Photos}                             3

${NewUsed}                                      در حد نو

${Tag_Type}                                     تخفیفی
${Tag_ID}                                       5
${Tag_Price}                                    5000
${Tax_Price}                                    11250      # (5000+120000) * 0.09 =  11250

${All_Iran_Packge_Price}                        299900
${All_State_Packge_Price}                       120000


*** Test Cases ***
Post Listing And Buy Chip Discount And All State
    [Tags]        ChipDiscount       Listing    wrongprices

    Check Min Accepted Version Is  5.5.0
    Set Listing Limit For Home Appliances Category
    Set Packages For Chip Discount and All Iran and All State
    Post A New Listing In Home Appliances Category
    Validate Unselected Chip Discount Tag In Paid Feature
    Select Chip Discount Tag And All State
    Validate Payment Summery In Paid Feature For Chip Discount And All State And Press Payment
    Success Payment For Chip Discount And All State
    Validate Listing Details Items With Chip Discount


*** Keywords ***
Set Packages For Chip Discount and All Iran and All State
    Set Tag Price           catid=${Category_ID}   regionId=${State_ID}   price=${Tag_Price}   tagid=${Tag_ID}
    Set All Iran Price      catid=${Category_ID}   regionId=${State_ID}   price=${All_Iran_Packge_Price}
    Set All State Price     catid=${Category_ID}   regionId=${State_ID}   price=${All_State_Packge_Price}

Post A New Listing In Home Appliances Category
    Post A New Listing            ${Category_ID}        ${Number_Of_Photos}       ${Category}                 ${SubCategory}
    ...         ${State}          ${City}               ${Region}      NewUsed=${NewUsed}          Chip_Diccount_Price=${0}

Select Chip Discount Tag And All State
    Select Tag In Paid Feature           ${Tag_Type}
    Select All Iran OR All State         ${All_Iran_Packge_Price}       ${All_State_Packge_Price}          All_State

Validate Payment Summery In Paid Feature For Chip Discount And All State And Press Payment
    Validate Payment Summery In Paid Feature For A Tag And All State And Press Payment

Success Payment For Chip Discount And All State
    Success Payment For A Tag And All State
