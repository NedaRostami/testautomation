*** Settings ***
Resource        ..${/}..${/}resources${/}common.resource
Suite Setup      Set Suite Environment
Test Setup       start app     NO-RESET=${TRUE}    FULL-RESET=${FALSE}
Test Teardown    Close test application
Test Timeout     10 minutes

*** Test Cases ***
Check Initial Serp
    [Tags]    serp   reset  notest
    Filter Car In Tehran
    Validate State and Category
    # Background App            10
    Quit Application
    Start Activity    ${APP_PACKAGE}    ${SERP_ACTIVITY}
#    launch Application
    Set Environment Server
    Check App is Ready                           ${SERP_ACTIVITY}
    Validate First Initial Serp

*** Keywords ***
Validate State and Category
  Wait Until Page Contains Element    ${FILTER_COUNT}
  ${ilter_count}                      get text              ${FILTER_COUNT}
  Should Be True                      ${ilter_count} > 0
  Element Should Contain Text         ${TOTAL_NUMBER_TEXT}        آگهی وسایل نقلیه
  Element Should Contain Text         ${REGION_HEADER}      تهران
