*** Settings ***
Resource        ..${/}..${/}resources${/}SecurePurchaseKeywords.resource
Suite Setup      Set Suite Environment
Test Setup       start app
Test Teardown    Close test application For Insert Photos
Test Timeout     10 minutes
Documentation   سناریوی خرید امن همراه با ارسال توسط فروشنده
...    در این سناریو ابتدا باید یک فروشگاه تعریف شود که امکان خرید اینترنتی همراه با ارسال توسط فروشنده را داشته باشد
...    سپس توسط یکی از مشاورین فروشگاه یک آگهی ثبت می شود که در این حالت باید بعد از ثبت اگهی ، اگهی دارای امکان خرید اینترنتی باشد
...    بعد از ثبت اگهی فروشنده از اپلیکیشن خارج میشود و سناریو از طرف خریدار ادامه پیدا می کند
...    خریدار با جستجو بر حسب عنوان اگهی در صفحه سرپ اگهی ثبت شده مورد نظر را پیدا کرده و وارد فلوی خرید اینترنتی میشود
...    بعد از تکمیل گامهای خرید اینترنتی توسط خریدار ، و لاگین توسط خریدار پرداخت تکمیل میشود
...    در اخرین گام صفحه چت خریدار با فروشنده ولیدیت میشود که ایتم های مدنظر در ان وجود داشته باشد
...    بقیه مراحل تکمیل خرید اینترنتی هنوز تست اتوماتیک ندارد


*** Variables ***
#  اگر شهر به زنجان تغییر پیدا کنه باید هزینه ارسال به تهران هم در سناریو تغییر کند
${State}                                        تهران          #        زنجان
${City}                                         تهران     #    زنجان
${Region}                                       آجودانیه       #   ${EMPTY}
${Sleep_time}                                   2s
${Timeout}                                      10s

${Category}                                     لوازم شخصی
${SubCategory}                                  لباس ، کیف و کفش
${Category_ID}                                  43612
${Price}                                        1000000
${Kind}                                         زنانه
${NewUsed}                                      نو
${CheckNewUsed}                                 OK
${Delivery_Price_City}                          7000
${Delivery_Price_State}                         8000
${Delivery_Price_Country}                       9000

${Secure_Purchase_Type}                         ${2}               #secure purchase + Post
${Number_Of_Photos}                             3

${Customer_Name}                                علی علوی
${Customer_Lat}                                 35.754409956742165      # lat/lng: (35.75440641962015,51.415340043604374)    lat/lng: (35.754409956742165,51.415348425507545)
${Customer_Lat_4}                               35.7544
${Customer_Long}                                51.415348425507545
${Customer_Long_4}                              51.4153
${Customer_Alt}                                 1182
${Customer_State}                               تهران       #based on lat and long
# ${Customer_Address_Total}                       تهران، محله ونک (کاووسيه)، بلوار نلسون ماندلا، ژوبین، پلاک 20، واحد 14
${Customer_Address_Total}                       تهران، بل جردن، خ. زوبین، بوستان آب و آتش، پلاک 20، واحد 14
${Customer_Address}                             تهران، بل جردن، خ. زوبین
${Customer_House_Num}                           20
${Customer_Unit_Num}                            14
${Number_Goods}                                 1

${Default_Lat}                                  35.7000
${Default_Long}                                 51.4000


*** Test Cases ***
Secure Purchase With Delivery Flow
    [Tags]    SecurePurchase      Listing    notest
    Check Min Accepted Version Is  5.6.0
    Post A New Listing With Secure Purchase From a Shop With Devilery
    Filter Category and SubCategory For Serp Page As a Customer
    Select Listing With Secure Purchase In Serp
    Validate Listing Details Items In Listing Details Page With Devilery
    Press Secure Purchase Button In Listing Details Page
    Complete Secure Purchase Steps and Fill Address
    Login By Mobile
    Validate Success Payment And Chat Page Of Customer


*** Keywords ***
Post A New Listing With Secure Purchase From a Shop With Devilery
    Create Shop With Delivery
    Post Listing By Backend
    Trumpet adv           accept          ${listingId}

Validate Listing Details Items In Listing Details Page With Devilery
    Validate Listing Details Items In Listing Details Page
    Validate Details Of Transportation Cost And Time In Listing Details Page
    ...             ${State}         ${Delivery_Price_City}      ${Delivery_Price_State}      ${Delivery_Price_Country}

Complete Secure Purchase Steps and Fill Address
    Validate Step One In Checkout Page
    Validate Step Two In Checkout Page
    Validate Step Three In Checkout Page

Validate Step One In Checkout Page
    Validate Steps Structure For Step One
    Validate Contents Of Step One In Checkout           ${Listings_title}           ${Price}       ${Shop_title}       ${Number_Goods}         محاسبه در مرحله بعدی
    Validate And Press Next Step Button In Step One

Validate Step Two In Checkout Page
    Validate Steps Structure For Step Two
    Validate Contents Of Step Two In Checkout           ${Price}                    ${Number_Goods}
    Input Name And Address of Customer
    Set Delivery Time
    Validate And Press Next Step Button In Step Two

Input Name And Address of Customer
    Input Attribute By Id                               ${INPUT_EDIT_TXT}           ${Customer_Name}
    Input Address In Checkout Page

Input Address In Checkout Page
    Set Test Variable                                   ${Default_Lat}
    Set Test Variable                                   ${Default_Long}
    Open Map To Choose Address In Checkout
    Choose Current Location Of Customer On Map
    Complete Address In Delivery Page
    Validate Address And Delivery Price In Step Two     ${Customer_Address_Total}   ${Delivery_Price_City}

Choose Current Location Of Customer On Map
    Set Geo Location       ${Customer_Lat}              ${Customer_Long}            ${Customer_Alt}
    Sleep     2s
    Select Current Location Of Device For Address On Map        # use this keyword because of emulator
    Sleep     2s
    Select Current Location Of Device For Address On Map
    Sleep     5s
    Validate Current Location On Map By Lat-Long        ${Customer_Lat_4}           ${Customer_Long_4}
    Moving Pin On Map and Return To Current Location
    Confirm Location On Map

Moving Pin On Map and Return To Current Location
    Swipe Up            2
    Sleep               1s
    Flick Down          4
    Sleep               1s
    Swipe Right         2
    Sleep               1s
    Select Current Location Of Device For Address On Map
    Sleep               5s
    Validate Current Location On Map By Lat-Long        ${Customer_Lat_4}            ${Customer_Long_4}

Complete Address In Delivery Page
    Validate Delivery Address Page                      ${Customer_State}
    Input Delivery Address Detail                       ${Customer_Address}          ${Customer_House_Num}     ${Customer_Unit_Num}

Validate Step Three In Checkout Page
    Validate Steps Structure For Step Three
    Validate Listing Details In Step Three Of Checkout  ${Listings_title}            ${Price}        	       ${Number_Goods}              ${Shop_title}
    Validate Customer Info For Step Three               ${Customer_Name}             ${Customer_Address}
    Validate Receipt For Step Three In Checkout         ${Number_Goods}              ${Price}                  ${Delivery_Price_City}
    Choose Payment Button In Step Three

Validate Success Payment And Chat Page Of Customer
    Choose Payment Button In Step Three
    Succes Payment From Android App In Secure Purchase
    Validate Chat Page Of Customer                      ${Number_Goods}              ${Price}                  ${Delivery_Price_City}
