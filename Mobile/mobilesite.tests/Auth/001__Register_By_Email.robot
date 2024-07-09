*** Settings ***
Resource         ..${/}..${/}resources${/}androidBrowser.resource
Test Setup       Run Keywords    Open test browser     Close App Alert
Test Teardown    Clean Up Tests
Test Timeout     10 minutes
*** Test Cases ***
Register By New Email A and New Mobile A
  [Tags]                                 Register New EmailA            notest
  Email Generator A
  Mobile Generator A
  # Fill Register User By New Email        ${Random_User_Email_A}       ${Random_User_Mobile_A}
