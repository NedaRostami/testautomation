*** Settings ***
Resource        ..${/}..${/}resources${/}common.resource
Suite Setup      Set Suite Environment
Test Setup        start app
Test Teardown     Close test application
Test Timeout     10 minutes


*** Test Cases ***
Check Listing Next Navigation
  [Tags]    Listing   navigation
  Open First Listing
  Set Test Variable    ${Nav0}     ${FirstTitle}
  FOR    ${INDEX}    IN RANGE    1    24
      Is Next Listing Loaded    ${INDEX}
  END
