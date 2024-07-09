*** Settings ***
Documentation                       Favorite Listing
Resource                            ../versions/v${api_version}/keywords.resource
Suite Setup                         Set Suite Environment
Test Setup                          Setup Favorite Environment
Test Teardown                       Clean Up Test
*** Test Cases ***
Favorite Listing Logged In
    [Tags]                          all  favorite
    Set Random Phone Number
    Login To Service
    Expect Response                 ${Favorite_Listing_Schema}
    Favorite A Listing

Unfavorite Listing Logged In
    [Tags]                           all   favorite
    Set Random Phone Number
    Login To Service
    Expect Response                 ${Favorite_Listing_Schema}
    Unfavorite A Listing

Get Favorite Listings
    [Tags]                          all  favorite
    Set Random Phone Number
    Login To Service
    Expect Response                 ${Get_Favorite_Listings_Schema}
    Get Favorite Listing List
    Validate Favorite Listings
