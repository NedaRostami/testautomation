*** Settings ***
Documentation                           Unsuccessfull Bump From Listing Management
Resource                                ../../resources/bump.resource
Test Setup                              Run Keywords    Open test browser       Create Shop In Sheypoor      Login To ProTools
Test Teardown                           Clean Up Tests
Test Template                           Bump a listing Unsuccessfully For ${BumpeType} by ${Bump_Price}


*** Variables ***


*** Test cases ***
Bump Listing From Protools Unsuccessfully
    [Tags]                              Bump    Unsuccessfully    notest
    refresh                             ${refresh}
    refresh_top3                        ${refresh_24}
    refresh_top3_2x                     ${refresh_48}


*** Keywords ***
