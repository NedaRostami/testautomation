*** Settings ***
Documentation                                      add a new listing with One image New User
...                                                while not logged in
...                                                Email Registeration
...                                                check the moderatin to accept it.
...                                                Logout's the tests
Test Setup                                         Run Keywords    Open test browser     Close App Alert
Test Teardown                                      Clean Up Tests
Resource                                           ..${/}..${/}resources${/}androidBrowser.resource
Test Timeout                                       10 minutes

*** Test Cases ***
Add RealEstate Max By New Mobile
    [Tags]                                         Listing
    Go To                                          ${SERVER}/listing/new
    Wait Until Page Contains Element               id=item-form-description
    Post A New Listing                             No-Image  43603  43606   logged_in=${FALSE}
    Login OR Register In Listing By New Mobile
    Verify Post Listing Is done
    Check My Listing
    Verify Advertise By ID
    Check My Ads Has been Verified
