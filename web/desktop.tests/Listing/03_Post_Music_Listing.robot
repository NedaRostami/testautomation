*** Settings ***
Documentation                                      add a new listing with One image logged in
...                                                while Valid User (Mobile) logged in
...                                                check the moderatin to accept it.
...                                                Logout's the tests
Test Setup                                         Open test browser
Test Teardown                                      Clean Up Tests
Resource                                           ../../resources/setup.resource


*** variables ***
${state_id}                                         4      # اصفهان
${city_id}                                          127    # اصفهان
${region_id}                                        3793   # لادان


*** Test Cases ***
Post Music Listing
    [Tags]                                         Listing                     music
    Login OR Register By Random OR New Mobile      ${Auth_Session_Position}
    Go To Post Listing Page
    Post A New Listing                             ${1}   43619   43625  state=${state_id}    city=${city_id}    region=${region_id}   tel=${Random_User_Mobile_B}
    Verify Post Listing Is done
    Check My Listing
    Check My Listing Image Count                   1
    Verify Advertise By ID in trumpet
    Check My Ads Has been Verified
