*** Settings ***
Documentation                           Hybrid Packages Distribution
Resource                                ../../resources/package.resource
Test Setup                              Run Keywords    Open test browser
Test Teardown                           Clean Up Tests


*** Variables ***



*** Test cases ***
Hybrid Packages Distribution Without Shop Package
    [Tags]                              Distribution            Hybrid          notest
    Create Shop In Sheypoor
    Login To ProTools                                           ${Shop_owner_phone}
    Go to                                                       ${SERVER}/pro/real-estate/packages
    Buy Hybrid Packages                                         special-package                         special-package-price
    Validate Shop Package From Protools                         25    10    5    0
    Assign Package To Shop Member                               1     1     1    ${EMPTY}
    Validate Shop Package From Protools                         24    9     4    0
    Delete Assigned Packge
    Validate Shop Package From Protools                         25    10    5    0

Hybrid Packages Distribution With Shop Package
    [Tags]                              Distribution            Hybrid          notest
    Create Shop In Sheypoor
    Login To ProTools                                           ${Shop_owner_phone}
    Enable Shop Package
    Go to                                                       ${SERVER}/pro/real-estate/packages
    Buy Hybrid Packages                                         special-package                         special-package-price
    Validate Shop Package From Protools                         40    20    10    3
    Assign Package To Shop Member                               30    15    8     ${EMPTY}
    Validate Shop Package From Protools                         10    5     2     3
    Delete Assigned Packge
    Validate Shop Package From Protools                         40    20    10    3

*** Keywords ***
