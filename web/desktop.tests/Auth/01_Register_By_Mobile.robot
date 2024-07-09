*** Settings ***
Documentation                            Registration, Login And Logout by Mobile
Test Setup                               Open test browser
Test Teardown                            Clean Up Tests
Resource                                 ../../resources/setup.resource


*** Test Cases ***
Register By New Mobile B
    [Tags]                               register   login  auth
    Mobile Generator B
    Login OR Register By Mobile          ${Random_User_Mobile_B}         ${Auth_Session_Position}
    Logout User
