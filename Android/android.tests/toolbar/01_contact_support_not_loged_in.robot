*** Settings ***
Resource        ..${/}..${/}resources${/}common.resource
Suite Setup      Set Suite Environment
Test Setup       start app
Test Teardown    Close test application
Test Timeout     10 minutes

*** Test Cases ***
Contact Support NOT logined
    [Tags]                                toolbar                                    contact support
    Go To Contact Support Page
    Send A Message To Support             logged_in=${FALSE}
