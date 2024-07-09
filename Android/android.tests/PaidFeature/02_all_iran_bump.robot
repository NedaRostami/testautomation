*** Settings ***
Resource                                        ..${/}..${/}resources${/}PaidFeatureKeywords.resource
Suite Setup                                     Set Suite Environment
Test Setup                                      start app
# Test Teardown                                   Close test application
Test Timeout                                    10 minutes
Documentation                                   در این سناریو میخواهیم بعد از تعریف بسته های بامپ ، ال ایران و آل استیت در صفحه ادمین، اگهی را ثبت کنیم.
...                                             بعد از ثبت اگهی وارد صفحه پیدفیچر شده و بسته بامپ و ال ایران را با هم خرید می کنیم
...                                             در این حالت بعد از انتخاب ال ایران باید قیمت بامپ سه برابر شود. سپس فاکتور پرداخت را بررسی کرده
...                                             و در صورت درست بودن همه اعداد وارد مرحله پرداخت شده و خرید را تکمیل می کنیم.

*** Variables ***
${State}                                        لرستان
${State_ID}                                     25
${City}                                         اشترینان
${City_ID}                                      873
${Region}                                       ${EMPTY}
${Region_ID}                                    ${EMPTY}
${Sleep_time}                                   2s
${Timeout}                                      10s

${Category}                                     ورزش فرهنگ فراغت
${Category_ID}                                  43619
${SubCategory}                                  کلکسیونی
${SubCategory_ID}                               44113
${Number_Of_Photos}                             3
${Price}                                        1000000
${Kind}                                         ${EMPTY}
${NewUsed}                                      نو
${CheckNewUsed}                                 OK

${Bump_Type}                                    ۱ بار بروزرسانی
${Bump_ID}                                      5:1
${Bump_Type_Receipt}                            بروزرسانی (۱ بار بروزرسانی)
${Tax_Price}                                    53982                           # (299900+299900)*0.09 = 53982

${All_Iran_Packge_Price}                        299900
${All_State_Packge_Price}                       120000
${Bump_Packge_Price}                            5000


*** Test Cases ***
Post Listing With All Iran and Bump Features
    [Tags]                                      ALlIran                         bump                      Listing
    Check Min Accepted Version Is  5.5.0
    Set Listing Limit For Sport Category
    Set Packages For Bump and AllIran and AllState
    Post A New Listing In Sport Category
    Login to Sheypoor For User With Listing             ${Random_User_Mobile_A}
    Go To Paid Feature Page From My Listing
    Select Bump And All Iran
    Validate Payment Summery In Paid Feature For Bump And All Iran And Press Payment
    Success Payment For Bump And All Iran Features
    Go To Paid Feature Page From My Listing
    Validate That All Iran Package Is Not Displayed

*** Keywords ***
Set Listing Limit For Sport Category
    Set Listing Limit For Cat per locations                parentid=${Category_ID}  catid=${SubCategory_ID}  regid=${State_ID}
    ...                                 cityid=${City_ID}  nghid=${Region_ID}       limitcount=${30}         limitprice=${11000}

Post A New Listing In Sport Category
    Post A new Listing By Random Mobile By Api And Accept

Validate That All Iran Package Is Not Displayed
    Page Should Not Contain Element By ID And Text         ${PAID_FEATURE_TITLE_TXT_VIEW}              ${PAID_FEATURE_ALL_IRAN_TXT}
    Page Should Not Contain Element By ID And Text         ${PAID_FEATURE_TITLE_TXT_VIEW}              ${PAID_FEATURE_ALL_TXT}
