*** Settings ***
Documentation                       My listings
Resource                            ../versions/v${api_version}/keywords.resource
Suite Setup                         Set Suite Environment
Test Setup                          Set Test Environment
Test Teardown                       Clean Up Test

*** Test Cases ***
My Listings Logged In
    [Tags]                          all  listings
    Set Random Phone Number
    Login To Service
    Post a Listing                  category=املاک
    Post a Listing                  category=45234
    Expect Response                 ${My_Listings_Schema}
    Get In Retry                    /user/listings                  headers=${Listing_Headers}

My Listings Logged Out
    [Tags]                          all   listings
    Expect Response                 ${My_Listing_Error_Schema}
    Get In Retry                    /user/listings
