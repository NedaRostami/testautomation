*** Settings ***
Resource        ..${/}..${/}resources${/}common.resource
Suite Setup      Set Suite Environment
Test Setup       start app
Test Teardown    Close test application
Test Timeout     10 minutes

*** Test Cases ***
Call Support
    [Tags]                            toolbar                contact support
    Click Toolbar Account
    Click Toolbar Items               ${CONTACT_SUPPORT}
    Wait Until Page Contains          کمک نیاز دارید؟       timeout=10
    FOR  ${INDEX}  IN RANGE  0  3
       Run Keyword And Ignore Error   Click The Link                   تماس با شیپور
       ${status}                      Run Keyword And Return Status    Wait Until Page Contains      545       timeout=6
       Exit For Loop If               ${status}
    END

Sheypoor Rules
    [Tags]    Rules                   toolbar
    Check Sheypoor Rules Page
    Wait Until Page Contains          توافق نامه کاربری    timeout=10

Check Notifications
    [Tags]    Notifications           toolbar
    Click Toolbar Account
    Click Toolbar Items               اعلانات
    Wait Until Page Contains          هنوز هیچ اعلانی برای شما وجود ندارد       timeout=5

*** keywords ***
