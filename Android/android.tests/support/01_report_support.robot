*** Settings ***
Resource        ..${/}..${/}resources${/}common.resource
Suite Setup      Set Suite Environment
Test Setup       start app
Test Teardown    Close test application
Test Timeout     10 minutes

*** Test Cases ***
Report Post listing
    [Tags]    support           notest
#    Description Faker
#    Title Faker
    Go To Post Listing Page
    click element                       accessibility_id=پشتیبانی
    wait until page contains            به کمک احتیاج دارید؟
    click the link                      ارسال پیام
    Input Attribute                     ایمیل شما       qa@mielse.Comment
    click the link                      انتخاب گروه‌بندی
    wait until page contains            سوال در خصوص ثبت آگهی
    click the link                      سوال در خصوص ثبت آگهی
    Input Attribute                     عنوان     ${Title_Words}
    Input Attribute                     پیام شما    ${Title_Description}
    Input Attribute                     شماره موبایل      09001000000
    Submit report

*** Keywords ***
Submit report
    Find Element By Swipe in loop        id=com.sheypoor.mobile:id/submit
    click the link                       ارسال
    # wait until page contains             پیام شما با موفقیت ارسال شد
    Wait Until Page Contains Element     ${OFFER_NAME}
