*** Settings ***
Resource        ..${/}..${/}resources${/}PaidFeatureKeywords.resource
Resource        ..${/}..${/}resources${/}SecurePurchaseKeywords.resource
Suite Setup      Set Suite Environment
Test Setup       start app
Test Teardown    Close test application For Insert Photos
Test Timeout     10 minutes
Documentation       در این سناریو میخواهیم بعد از تعریف تگ تخفیفی در صفحه ادمین، اگهی را با انتخاب این تگ ثبت کنیم.
...     بعد از ثبت اگهی وارد صفحه پیدفیچر شده و بررسی می کنیم که تگ تخفیفی با قیمت مورد نظر انتخاب شده باشد
...     و فرایند پرداخت را تکمیل می کنیم. در انتها وجود تگ تخفیفی را در صفه جزییات اگهی بررسی می کنیم.


*** Variables ***
${Origin}                                       1:14
${Origin_id}                                    14
${origin_city}                                  زنجان
${Destination}                                  2:536
${Destination_id}                               536
${Destination_Name}                             زنجان

${destination_change}                           2:538
${destination_name_change}                      سلطانیه

${Post_Provider}                                5                               #ماهکس
${Provider_Posting_Cost}                        19000
${Post_Provider_Name}                           ماهکس

${State}                                        زنجان
${State_ID}                                     14
${City}                                         زنجان
${City_ID}                                      536
${Region}                                       شهرک کارمندان
${Region_ID}                                    ${EMPTY}
${Sleep_time}                                   2s
${Timeout}                                      10s

${Category}                                     لوازم خانگی
${Category_ID}                                  43608
${SubCategory}                                  دکوراسیون داخلی و روشنایی
${SubCategory_ID}                               44240
${Number_Of_Photos}                             3

${Tag_Type}                                     تخفیفی
${Tag_ID}                                       5
${Tag_Price}                                    5000
${Tax_Price}                                    450

${shop_seller}                                  ${FALSE}
${Show_SP_Popup}                                ${TRUE}
${Has_Delivery_Time}                            ${FALSE}

*** Test Cases ***
Post Listing With Chip Discount Feature
    [Tags]        ChipDiscount       Listing

    Check Min Accepted Version Is  5.5.0
    Set Android Toggles For User SecurePurchase Testing
    Set Posting Cost Based On Origin And Destination Via Admin By Backend
    Set Listing Limit For Home Appliances Category
    Set Packages For Chip Discount
    Post A New Listing In Home Appliances Category
    Validate Selected Chip Discount Tag In Paid Feature
    Validate Payment Summery In Paid Feature For Chip Discount And Press Payment
    Success Payment For Chip Discount Feature
    Validate Listing Details Items With Chip Discount


*** Keywords ***
Validate Payment Summery In Paid Feature For Chip Discount And Press Payment
    Validate Payment Summery In Paid Feature For Specific Tag And Press Payment

Success Payment For Chip Discount Feature
    Success Payment For Specific Tag
