*** Settings ***
Resource        ..${/}..${/}resources${/}PaidFeatureKeywords.resource
Suite Setup      Set Suite Environment
Test Setup       start app
Test Teardown    Close test application For Insert Photos
Test Timeout     10 minutes
Documentation       در این سناریو میخواهیم بعد از تعریف تگ فوری در صفحه ادمین، اگهی را با انتخاب این تگ ثبت کنیم.
...     بعد از ثبت اگهی وارد صفحه پیدفیچر شده و بررسی می کنیم که تگ فوری با قیمت مورد نظر انتخاب شده باشد
...     و فرایند پرداخت را تکمیل می کنیم. در انتها وجود تگ فوری را در صفه جزییات اگهی بررسی می کنیم.
...     نکته قابل توجه انتخاب کتگوری است که باید شناسه کالا برای ان ثبت شود و سناریو به گونه ای نوشته شده است که این فرایند نیز همراه با تگ فوری تست شود.

*** Variables ***

${State}                                        سیستان و بلوچستان
${State_ID}                                     16
${City}                                         زاهدان
${City_ID}                                      577
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

${NewUsed}                                      نو
${BarCode}                                      2901260200033    #https://www.digikala.com/product/dkp-1653948/%D8%AA%D9%84%D9%88%DB%8C%D8%B2%DB%8C%D9%88%D9%86-%D9%81%DB%8C%D9%84%DB%8C%D9%BE%D8%B3-%D9%85%D8%AF%D9%84-40pft5063-%D8%B3%D8%A7%DB%8C%D8%B2-40-%D8%A7%DB%8C%D9%86%DA%86#/tab-params
${BrandName}                                    PHILIPS

${Tag_Type}                                     فوری
${Tag_ID}                                       10
${Tag_Price}                                    12500
${Tax_Price}                                    1125


*** Test Cases ***
Post Listing With Instant Tag
    [Tags]    Instant       Listing

    Check Min Accepted Version Is  5.5.0
    Set Listing Limit For Electronic Category
    Set Packages For Instant Tag
    Post A New Listing In Electronics Category With Barcode
    Validate Selected Instant Tag in Paid Feature
    Validate Payment Summery In Paid Feature For Instant Tag And Press Payment
    Success Payment For Instant Tag Feature
    Validate Listing Details Items With Instant Tag and Barcode


*** Keywords ***
Post A New Listing In Electronics Category With Barcode
    Post A New Listing In Electronics Category

Validate Payment Summery In Paid Feature For Instant Tag And Press Payment
    Validate Payment Summery In Paid Feature For Specific Tag And Press Payment

Success Payment For Instant Tag Feature
    Success Payment For Specific Tag

Validate Listing Details Items With Instant Tag and Barcode
    Check Listing Title In My Listing Page
    Validate Listing Details Items       ${Category}      ${SubCategory}         ${State}        ${City}       ${Region}
    ...         NewUsed=${NewUsed}       Tag_Type=${Tag_Type}            BarCode=${BarCode}         BrandName=${BrandName}
