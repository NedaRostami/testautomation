*** Settings ***
Documentation                                       add a new listing for furniture
...                                                 New User while logged in
...                                                 Mobile Registeration
...                                                 check the moderatin to accept it.
...                                                 check mobile number field
...                                                 to be more than 3 character
Test Setup                                          Open test browser
Test Teardown                                       Clean Up Tests
Resource                                            ../../resources/setup.resource


*** variables ***
${state_id}                                         10                          # خراسان جنوبی
${city_id}                                          366                         # بیرجند
${region}                                           خیابان معلم


*** Test Case ***
Post Furniture Listing
    [Tags]                                          Listing                     Furniture
    Login OR Register By Random OR New Mobile       ${Auth_Session_Position}
    Go To Post Listing Page
    Post A New Listing                              ${1}    43608    43609  state=${state_id}    city=${city_id}    region=${region}  tel=${Random_User_Mobile_B}
    Verify Post Listing Is done
    Check My Listing
    Check My Listing Image Count                    1
    Login Trumpet Admin Page
    Verify Advertise By ID in trumpet
    Check My Ads Has been Verified
