*** Settings ***
Documentation                                       Shop Management
Resource                                            ../../resources/setup.resource
# Test Setup                                        Run Keywords    Open test browser
# Test Teardown                                     Clean Up Tests

*** Variables ***




*** Test Cases ***
Shop Listings Filter And Validation
    [Tags]    shop    notest
    Set Log Level                                   Trace
    Repeat Create Shop                              1


*** Keywords ***
Repeat Create Shop
    [Arguments]                                     ${Repeat}
    Repeat Keyword                                  ${Repeat}     Test Create Shop Multiple times


Test Create Shop Multiple times
   Create Shop In Sheypoor
   Log To Console    ${Shop_Slug}${\n}
