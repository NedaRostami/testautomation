*** Settings ***
Documentation                                       Shop Management
Resource                                            ../../resources/package.resource
Test Setup                                          Run Keywords    Open test browser
Test Teardown                                       Clean Up Tests


*** Variables ***



*** Test cases ***
Package Distribution
    [Tags]                                          package                             distribution
    Create Shop In Sheypoor
    Login To ProTools                               ${Shop_owner_phone}
    Enable Shop Package
    Go to                                           ${SERVER}/pro/real-estate/listings
    Validate Shop Package From Protools             15    10    5    3
    Assign Package To Shop Member                   1     1     1    1
    Validate Shop Package From Protools             14    9     4    2
    Delete Assigned Packge
    Validate Shop Package From Protools             15    10    5    3

*** Keywords ***
