*** Settings ***
Resource        ..${/}..${/}resources${/}common.resource
Suite Setup      Set Suite Environment
Test Setup       start app
Test Teardown    Close test application
Test Timeout     10 minutes

*** Variables ***

*** Test Cases ***
Check location Auto Detection
    [Tags]    Location   notest
    Set Geo Location                    35.69439    51.42151        1189
    Call Automatic Location
    Validate First Initial Serp        تهران
    Check Esfahan
    Check Shiraz


*** Keywords ***
Call Automatic Location
    Click Element                           ${REGION_HEADER}
    Element Should Contain Text             ${LOCATION_HEADER_TITLE}         لیست استان‌ها
    Element Should Contain Text             ${ALL_LOCATIONS_TITLE}            همه ایران
    Wait Until Page Contains Element        ${LOCATION_AUTO_FINDER}
    Click Element                           ${LOCATION_AUTO_FINDER}
    Sleep                                   5s

Check Esfahan
    Quit Application
    launch Application
    Set Geo Location                32.6462     51.6805     1000
    Set Environment Server
    Check Return Activity
    Call Automatic Location
    Validate First Initial Serp      اصفهان

Check Shiraz
    Quit Application
    launch Application
    Set Geo Location                29.5999     52.5506     1000
    Set Environment Server
    Check Return Activity
    Call Automatic Location
    Validate First Initial Serp      شیراز
