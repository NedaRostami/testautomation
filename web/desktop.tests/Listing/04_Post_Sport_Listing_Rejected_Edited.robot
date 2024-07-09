*** Settings ***
Documentation                                             add a new listing with One image logged in
...                                                       while Valid User (Mobile) logged in
...                                                       check the moderatin reject it. then edit and add image
...                                                       Logout's the tests
Test Setup                                                Open test browser
Test Teardown                                             Clean Up Tests
Resource                                                  ../../resources/setup.resource


*** Variables ***
${state_id}                                          16        # سیستان و بلوچستان
${city_id}                                           577       # زاهدان
${region}                                            خیابان دانشگاه-کوچه دانشگاه ۱۶


*** Test Cases ***
Post Sport Listing and Rejected Listing Edited By image
    [Tags]                                                Listing                           reject
    Login OR Register By Random OR New Mobile             ${Auth_Session_Position}
    Go To Post Listing Page
    Post A New Listing                                    No-Image   43619   43625  state=${state_id}  city=${city_id}  region=${region}  tel=${Random_User_Mobile_B}
    Verify Post Listing Is done
    Check My Listing
    Reject Advertise By ID
    Check My Ads Has been Rejected
    Go to                                                 ${SERVER}/listing/edit/${AdsId}
    Attach Listing Image                                  ${1}                              43619
    Sleep                                                 2s
    Submit post listings                                  ${TRUE}                           ${TRUE}
    Login Trumpet Admin Page
    Wait Until Page Contains                              داشبورد
    Go To                                                 ${SERVER}/trumpet/listing/search?phone=${Random_User_Mobile_B}
    Wait Until Page Contains                              جستجوی آگهی ها                    timeout=10s
    Page Should Not Contain                               db.listing
