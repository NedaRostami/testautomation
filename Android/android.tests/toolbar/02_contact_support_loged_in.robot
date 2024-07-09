*** Settings ***
Resource        ..${/}..${/}resources${/}common.resource
Suite Setup      Set Suite Environment
Test Setup       start app
Test Teardown    Close test application
Test Timeout     10 minutes

*** Test Cases ***
Contact Support logined
    [Tags]               toolbar      contact support
    Login to Sheypoor
    Back To Home Page    1
    Go To Contact Support Page
    Send A Message To Support
