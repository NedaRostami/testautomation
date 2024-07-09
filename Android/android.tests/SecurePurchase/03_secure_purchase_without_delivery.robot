*** Settings ***
Resource        ..${/}..${/}resources${/}SecurePurchaseKeywords.resource
Suite Setup      Set Suite Environment
Test Setup       start app
Test Teardown    Close test application For Insert Photos
Test Timeout     10 minutes
Documentation   سناریوی خرید امن بدون ارسال
...    در این سناریو ابتدا یک فروشگاه و یک اگهی خرید اینترنتی دار توسط توابع پایتونی در پشت صحنه ثبت میشود
...    بعد از ثبت اگهی، سناریو از طرف خریدار ادامه پیدا می کند
...    خریدار با جستجو بر حسب عنوان اگهی در صفحه سرپ اگهی ثبت شده مورد نظر را پیدا کرده و وارد فلوی خرید اینترنتی میشود
...    در این مرحله فقط یک گام برای تکمیل خرید اینترنتی وجود دارد که تعداد کالا توسط خریدار مشخص میشود. و خریدار وارد صفحه پرداخت میشود
...    در اخرین گام صفحه چت خریدار با فروشنده ولیدیت میشود که ایتم های مدنظر در ان وجود داشته باشد
...    بقیه مراحل تکمیل خرید اینترنتی هنوز تست اتوماتیک ندارد

*** Variables ***
${State}                                        خوزستان
${City}                                         اهواز
${Region}                                       امانیه
${Sleep_time}                                   2s
${Timeout}                                      10s

${Category}                                     ورزش فرهنگ فراغت
${SubCategory}                                  حیوانات و لوازم
${Category_ID}                                  43619
${Price}                                        1000000
${Kind}                                         ${EMPTY}
${NewUsed}                                      نو
${CheckNewUsed}                                 ${EMPTY}
${Number_Of_Photos}                             3
${Secure_Purchase_Type}                         ${1}               #secure purchase + without delivery

${Number_Goods}                                 1
#${Customer_Name}                                علی علوی


*** Test Cases ***
Secure Purchase Listing Without Delivery Flow
    [Tags]    SecurePurchase      Listing

    Check Min Accepted Version Is  5.7.0
    Post A New Listing With Secure Purchase From a Shop Without Delivery
    Filter Category and SubCategory For Serp Page As a Customer
    Select Listing With Secure Purchase In Serp
    Validate Listing Details Items In Listing Details Page
    Press Secure Purchase Button In Listing Details Page
    Complete Secure Purchase No Delivery With Selecting Number Of Product
    Login By Mobile
    Validate Success Payment And Chat Page Of Customer

#    validate Chat Page Of Customer  پیام مناسب خریدار باید نمایش داده شود .
#    validate Chat Page Of seller  پیام مناسب فروشنده باید نمایش داده شود .
#    press button for sending product for customer by seller in chat page
#    validate customer chat page for changing status
#    press button for receiving product for seller by customer in chat page
#    validate seller chat page for changing status
#    اعتبار سنجی مبلغ واریز شده به حساب فروشنده بر اساس درصد کارمزد.
#
#    کنترل کردن پیام های nps بعد از پروسه تایید ارسال و دریافت ارسال توسط فروشنده و خریدار
#


*** Keywords ***
Post A New Listing With Secure Purchase From a Shop Without Delivery
    Post A New Listing With Secure Purchase In Background
    Trumpet adv           accept          ${listingId}

Complete Secure Purchase No Delivery With Selecting Number Of Product
    Complete Secure Purchase Without Delivery In Checkout                           ${Number_Goods}          ${Price}

Validate Success Payment And Chat Page Of Customer
    Choose Payment Button In Checkout
    Succes Payment From Android App In Secure Purchase
    Validate Chat Page Of Customer                      ${Number_Goods}              ${Price}
