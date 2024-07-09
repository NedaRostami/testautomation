*** Settings ***
Documentation                           Listing details from serp
Resource                                ../versions/v${api_version}/keywords.resource
Suite Setup                             Set Suite Environment
Test Setup                              Set Test Environment
Test Teardown                           Clean Up Test

*** Test Cases ***
Validate Listing Details
    [Tags]                              all   listings
    [Setup]                             Expect Response                     ${Listing_Details_Schema}
    Select Random Listing From Serp
    Request Listing Details
    Validate Listing Details Response
