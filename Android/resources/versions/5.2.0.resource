*** Settings ***
Resource                                 5.1.2.resource

*** Variables ***


*** Keywords ***
Check Listing Title In My Listing Page
    # Run Keyword If                        ${Toggle_leads} and ${Toggle_views}     Validate When Leads And Views Is On
    Wait Until Page Contains Element      ${myAdDetailTitle}                      10s
    ${Title}           Get Text           ${myAdDetailTitle}
    Should Contain     ${Title}           ${Title_Words}
    Page Should Contain Element           ${myAdImage}
    Page Should Contain Element           ${OFFER_STATUS}
    Element Should Contain Text           ${OFFER_STATUS}                              ${APPROVED_MESSAGE}
    Find Element By Swipe Up              ${myAdDetailTitle}
    # scroll to top                         ${myAdDetailTitle}    0
    click element                         ${myAdDetailTitle}
    Close LeadS And View Slide
    Page Should Contain Text              انقضاء
    Page Should Contain Text              روز باقیمانده
    Page Should Contain Text              مشاهده جزئیات کامل آگهی
    Run Keyword If                        ${Toggle_leads} and ${Toggle_views}         Check Leads and View
    click element                         ${myAdDetailTitle}

Validate When Leads And Views Is On
    Find Text By Swipe in loop            افزایش بازدید
    Find Text By Swipe in loop            بازدید در ۲۴ ساعت اخیر
    Page Should Contain Text              بازدید کل
    Page Should Contain Text              تماس

Check Leads and View
    Find Text By Swipe in loop            نفر این آگهی را دیده اند
    Find Text By Swipe in loop            روزهای قبل
    Find Text By Swipe in loop            افزایش بازدید
    Find Text By Swipe in loop            تماس
    click Element                         ${adapterLeadsAndViewsHeaderUp}
    Find Text By Swipe in loop            بازدید این آگهی
    Find Text By Swipe in loop            این آگهی در صفحه
    Page Should Contain Text              مشاهده همه بسته‌ها
    Close LeadS And View Slide
