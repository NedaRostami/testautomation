*** Settings ***
Documentation                       Bump and validate bumped listings
Resource                            ../versions/v${api_version}/keywords.resource
Suite Setup                         Set Suite Environment
Test Setup                          Set Bump Environment
Test Teardown                       Clean Up Test
*** Test Cases ***
Refresh Bump
    [Tags]                          all   bumps       notest
    Post A Listing To Bump
    Accept The Listing
    Mock Listing Bump               ${Listing_ID}                   ${X_Ticket}                 ${Refresh}

Top 3 Bump
    [Tags]                          all   bumps       notest
    Post A Listing To Bump
    Accept The Listing
    Mock Listing Bump               ${Listing_ID}                   ${X_Ticket}                 ${Top_3}
    Validate Top 3

Top 3 X2 Bump
    [Tags]                          all   bumps       notest
    Post A Listing To Bump
    Accept The Listing
    Mock Listing Bump               ${Listing_ID}                   ${X_Ticket}                 ${Top_3_X2}
    Validate Top 3
