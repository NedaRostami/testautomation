*** Settings ***
Documentation                                add a new listing with One image logged in
...                                          while Valid User (Mobile OR Email) logged in
...                                          check the moderatin to accept it.
...                                          Logout's the tests
Test Setup                                   Run Keywords    Open test browser     Close App Alert
Test Teardown                                Clean Up Tests
Resource                                     ..${/}..${/}resources${/}androidBrowser.resource
Test Timeout                                 10 minutes

*** Test Cases ***
Add New Listing Min LoggedIn By Mobile
  [Tags]                                        Listing
  Login OR Register By Random OR New Mobile     ${Auth_Session_Position}
  Go To                                         ${SERVER}/listing/new
  Wait Until Page Contains Element              id:item-form-description
  Post A New Listing                            No-Image  43619   43625  tel=${Random_User_Mobile_B}
  Verify Post Listing Is done
  Check My Listing
  Verify Advertise By ID
  Check My Ads Has been Verified
