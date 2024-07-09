*** Settings ***
Resource        ..${/}..${/}resources${/}PaidFeatureKeywords.resource
Resource        ..${/}..${/}resources${/}SecurePurchaseKeywords.resource
Suite Setup      Set Suite Environment
Test Setup       start app
Test Teardown    Close test application For Insert Photos
Test Timeout     10 minutes
Documentation         در این سناریو میخواهیم بعد از تعریف تگ تخفیفی در صفحه ادمین، اگهی را با انتخاب این تگ ثبت کنیم.
...     بعد از ثبت اگهی وارد صفحه پیدفیچر شده و بررسی می کنیم که تگ تخفیفی با قیمت مورد نظر انتخاب شده باشد و خلاصه پرداخت و دکمه پرداخت رو چک می کنیم.
...     در گام بعدی چک باکس تگ تخفیفی را از حالت انتخاب خارج می کنیم و بررسی می کنیم که دکمه پرداخت حذف شود و خلاصه پرداخت وجود نداشته باشد.
...     در انتها هم بررسی می کنیم که تگ تخفیفی در صحفه جزییات اگهی نباشد.


*** Variables ***
${Origin}                                       2:781
${Origin_id}                                    21
${origin_city}                                  کرمان
${Destination}                                  2:781
${Destination_id}                               781
${Destination_Name}                             کرمان

${destination_change}                           2:766
${destination_name_change}                      رفسنجان

${Post_Provider}                                0                               #شیپور
${Provider_Posting_Cost}                        11000
${Post_Provider_Name}                           شیپور

${State}                                        کرمان
${State_ID}                                     21
${City}                                         کرمان
${City_ID}                                      781
${Region}                                       بلوار ادیب، کوچه ادیب ده
${Region_ID}                                    ${EMPTY}
${Sleep_time}                                   2s
${Timeout}                                      10s

${Category}                                     لوازم شخصی
${Category_ID}                                  43612
${SubCategory}                                  بهداشتی، آرایشی، پزشکی
${SubCategory_ID}                               43615
${Number_Of_Photos}                             2

${Tag_Type}                                     تخفیفی
${Tag_ID}                                       5
${Tag_Price}                                    5000
${Tax_Price}                                    450

${shop_seller}                                  ${FALSE}
${Show_SP_Popup}                                ${TRUE}


*** Test Cases ***
Post Listing With Chip Discount And Remove It
    [Tags]        ChipDiscount       Listing

    Check Min Accepted Version Is  5.5.0
    Set Android Toggles For User SecurePurchase Testing
    Set Posting Cost Based On Origin And Destination Via Admin By Backend
    Set Listing Limit For Home Appliances Category
    Set Packages For Chip Discount
    Post A New Listing In Home Appliances Category
    Validate Selected Chip Discount Tag In Paid Feature
    UnSelect Chip Discount In Paid Feature
    Validate Unselected Chip Discount Tag In Paid Feature
    Validate Listing Details Items Without Chip Discount


*** Keywords ***
UnSelect Chip Discount In Paid Feature
    Unselect Tag In Paid Feature              ${Tag_Type}

Validate Listing Details Items Without Chip Discount
    Check Listing Status in My Listings Page By Click NOTNOW Button
    Check Listing Title In My Listing Page
    Validate Listing Details Items       ${Category}      ${SubCategory}         ${State}        ${City}       ${Region}
    ...         ${Listings_price}        NewUsed=${NewUsed}       Tag_Type=${EMPTY}
