*** Settings ***
Resource        ..${/}..${/}resources${/}common.resource
Suite Setup      Set Suite Environment
Test Setup       start app
Test Teardown    Close test application
Test Timeout     10 minutes

*** Test Cases ***
Test Drawer Menu
    Check Add new listing Link
    Check All Serp
    # Share Sheypoor APP

*** Keywords ***
Check Add new listing Link
    [Tags]    NewListing
    Click Toolbar Account
    Click Toolbar Items               ثبت رایگان آگهی
    FOR    ${INDEX}    IN RANGE    1    5
       ${Status}=    Run Keyword And Return Status    Page Should Contain Element  ${OFFER_NAME}
       Exit For Loop If            ${Status}
       Sleep        3s
    END

Share Sheypoor APP
    [Tags]    ShareAPP
    Click Toolbar Account
    Click Toolbar Items                به‌اشتراک گذاری شیپور
    Wait Until Page Contains           به اشتراک گذاری توسط                  timeout=10
    Press Keycode                      4


Check All Serp
    [Tags]    SerpLink
    click serp link
    Wait Until Page Does Not Contain Element    accessibility_id=${SERP_LINK}    timeout=5s
    ${status} =	Run Keyword And Return Status    Check App is Ready
    Run Keyword If	 ${status} == ${FALSE}     click serp again
    Run Keyword If	 ${status} == ${FALSE}     Check App is Ready

click serp link
    Click Toolbar Account
    Click Toolbar Items             ${SERP_LINK}

click serp again
    Click Toolbar Account
    Click The Link                   بله
    Check App is Ready
    Click Toolbar Account
    Click Toolbar Items             ${SERP_LINK}
