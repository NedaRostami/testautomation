*** Settings ***
Documentation                                       add a new listing with One image New User
...                                                 while not logged in
...                                                 Email Registeration
...                                                 check the moderatin to accept it.
...                                                 Logout's the tests
Test Setup                                          Run Keywords    Open test browser     Close App Alert
Test Teardown                                       Clean Up Tests
Resource                                            ..${/}..${/}resources${/}androidBrowser.resource
Test Timeout                                        10 minutes

*** Test Cases ***
Add New Listing Min By New Email
    [Tags]                                         Listing
    Go To                                          ${SERVER}/listing/new
    Wait Until Page Contains Element               id=item-form-description
    Post A New Listing                             No-Image  43626  43627   43976  model=a68143    model_id=440665     logged_in=${FALSE}
    Login OR Register In Listing By New Mobile
    Verify Post Listing Is done
    Check My Listing
    Verify Advertise By ID
    Check My Ads Has been Verified
