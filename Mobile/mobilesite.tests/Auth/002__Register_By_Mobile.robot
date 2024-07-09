*** Settings ***
Documentation     Registration   And Login  and Logout by  Email Or Mobile
Resource         ..${/}..${/}resources${/}androidBrowser.resource
Test Setup       Run Keywords    Open test browser     Close App Alert
Test Teardown    Clean Up Tests
Test Timeout     10 minutes

*** Test Cases ***
Register By New Mobile B
  [Tags]               Register New MobileB
  Login OR Register By Random OR New Mobile        ${Auth_Session_Position}
  Logout User
  
