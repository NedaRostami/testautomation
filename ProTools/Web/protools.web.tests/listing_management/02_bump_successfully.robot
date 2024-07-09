*** Settings ***
Documentation                           Bump From Listing Management And Listing Details
Resource                                ../../resources/bump.resource
Test Setup                              Run Keywords    Open test browser       Create Shop In Sheypoor      Login To ProTools
Test Teardown                           Clean Up Tests
Test Template                           Bump a listing In Protools Successfully For ${BumpeType} by ${Bump_Price}

*** Variables ***


*** Test cases ***
Bump Listing From Protools
    [Tags]                              Bump    BumpSuccessfully    notest
    refresh                             ${refresh}
    refresh_top3                        ${refresh_24}
    refresh_top3_2x                     ${refresh_48}


*** Keywords ***
