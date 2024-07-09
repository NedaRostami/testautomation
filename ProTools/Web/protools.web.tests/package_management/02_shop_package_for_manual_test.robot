*** Settings ***
Documentation                                      Create Shop Package And Listings For Members
Resource                                           ../../resources/package.resource
Test Setup                                         Run Keywords    Open test browser
Test Teardown                                      Clean Up Tests


*** Variables ***



*** Test cases ***
Package Distribution For Manual Testing
    [Tags]                                          package     distribution
    Create Shop In Sheypoor
    Login To ProTools                               ${Shop_owner_phone}
    Enable Shop Package
    Go to                                           ${SERVER}/pro/real-estate/listings
    Create Some Listings                            2
    Post Listing As a Diffrent Shop Member          0    1       ${Consultant_Phones}
    Post Listing As a Diffrent Shop Member          1    1       ${Consultant_Phones}
    Post Listing As a Diffrent Shop Member          0    1       ${Secretary_Phones}

*** Keywords ***
