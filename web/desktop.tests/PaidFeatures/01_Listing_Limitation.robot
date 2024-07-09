*** Settings ***
Documentation                                      add a new car listing with One image New User
...                                                while not logged in
...                                                Mobile Registeration
...                                                check the moderatin to accept it.
...                                                fav and unfav listing
Test Setup                                         Open test browser
Test Teardown                                      Clean Up Tests
Resource                                           ../../resources/setup.resource

*** Variables ***
${Listing_Limit}                                   ۱
${Listing_Limit_en}                                1
${Listing_limit_duration}                          ۳۰
${Limit_price}                                     5000

*** Test Cases ***
Check Listing Limit In Musics
    [Tags]                                         Listing     music      limitlisting   paid_features
    Set Cat Listing Limit                          ورزش فرهنگ فراغت     انواع ساز و آلات موسیقی     ${Listing_Limit_en}     ${Limit_price}
    Login OR Register By Random OR New Mobile      ${Auth_Session_Position}
    Add Music Listings
    Add Music Listings                             ${True}
    Set Cat Listing Limit                          ورزش فرهنگ فراغت     انواع ساز و آلات موسیقی     30   5000

*** Keywords ***
Add Music Listings
    [Arguments]                                    ${Limit}=${FALSE}
    Go To Post Listing Page
    Post A New Listing                             ${1}  43619  43625  tel=${Random_User_Mobile_B}
    Run Keyword If    ${Limit}                     Check Limited Category       ELSE     Validate Post Listing

Check Limited Category
    ${without_paidFeauture}                        Set Variable                شما در طی ${Listing_limit_duration} روز، مجاز به ثبت ${Listing_Limit} آگهی در گروه بندی خودرو هستید. برای ثبت آگهی بعدی لطفا اقدام به پرداخت مبلغ زیر بنمایید.
    ${with_paidFeauture}                           Set Variable                شما به سقف ${Listing_Limit} آگهی در دوره‌ی ${Listing_limit_duration} روزه رسیده‌اید.
    ${post_listing_limit_message}                  Set Variable if             ${Toggle_paid-features}             ${with_paidFeauture}        ${without_paidFeauture}
    ${post_listing_limit_message}                  replace string              ${post_listing_limit_message}      \u200c   ${space}
    ${Page_txt}                                    get text                    ${PF_LL_Title}
    ${Page_txt}                                    replace string              ${Page_txt}      \u200c   ${space}
    Should Be Equal                                ${post_listing_limit_message}          ${Page_txt}
    Wait Until Page Contains                       ${Listing_limit_message1}   timeout=5    error=Limit Listing Problem
    Check My Listing With Limit
    Check My Listing Image Count                   1
    Verify Advertise By ID in trumpet
    Check My Ads Has been Verified

Validate Post Listing
    Verify Post Listing Is done
    Check My Listing
    Check My Listing Image Count                   1
    Verify Advertise By ID in trumpet
    Check My Ads Has been Verified
