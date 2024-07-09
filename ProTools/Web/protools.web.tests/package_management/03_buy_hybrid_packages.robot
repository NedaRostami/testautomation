*** Settings ***
Documentation                           Buy Hybrid Packages
Resource                                ../../resources/package.resource
Test Setup                              Run Keywords    Open test browser
Test Teardown                           Clean Up Tests


*** Variables ***



*** Test Cases ***
Hybrid Packages With Shop Package
    [Tags]                              package                 Hybrid             notest
    Create Shop In Sheypoor
    Login To ProTools                                           ${Shop_owner_phone}
    Enable Shop Package
    Go to                                                       ${SERVER}/pro/real-estate/packages
    Buy Hybrid Packages                                         special-package                         special-package-price
    Validate Shop Package From Protools                         40    20    10    3
    Buy Hybrid Packages                                         simple-package-refresh                  simple-package-refresh-price
    Validate Shop Package From Protools                         65    20    10    3

Hybrid Packages Without Shop Package
    [Tags]                              package                 Hybrid             notest
    Create Shop In Sheypoor
    Login To ProTools                                           ${Shop_owner_phone}
    Go to                                                       ${SERVER}/pro/real-estate/packages
    Buy Hybrid Packages                                         special-package                         special-package-price
    Validate Shop Package From Protools                         25    10    5    0
    Buy Hybrid Packages                                         simple-package-refresh                  simple-package-refresh-price
    Validate Shop Package From Protools                         50    10    5    0

*** Keywords ***
