*** Settings ***
Documentation                                      add a new listing for moblile New User
...                                                while not logged in
...                                                Mobile Registeration
...                                                check the moderatin to accept it.
Test Setup                                         Open test browser
Test Teardown                                      Clean Up Tests
Library                                            SeleniumLibrary
Resource                                           ../../resources/setup.resource
Library                                            OperatingSystem


*** variables ***
${state_id}                                          27        # مازندران
${city_id}                                           955       # بهشهر
${region_id}                                         7568      # خنک جام


*** Test Case ***
Post Mobile Listing
    [Tags]                                         Listing              mobile
    Go To Post Listing Page
    Post A New Listing                             ${1}  44096   43597  44014  ${state_id}  ${city_id}  ${region_id}  logged_in=${FALSE}
    Login OR Register In Listing By New Mobile
    Verify Post Listing Is done
    Check My Listing
    Check My Listing Image Count                   1
    Login Trumpet Admin Page
    Verify Advertise By ID in trumpet
    Check My Ads Has been Verified
