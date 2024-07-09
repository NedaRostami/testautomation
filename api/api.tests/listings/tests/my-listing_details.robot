*** Settings ***
Documentation                       My listings
Resource                            ../versions/v${api_version}/keywords.resource
Suite Setup                         Set Suite Environment
Test Setup                          Set Test Environment
Test Teardown                       Clean Up Test

*** Test Cases ***
My Listing Details Logged In
    [Tags]                          all  listings
    Set Random Phone Number
    Login To Service
    ${Listing_Id}                   Post a Listing
    Expect Response                 ${My_Listing_Details_Schema}
    Get In Retry                    /user/listings/${Listing_ID}    headers=${Listing_Headers}
    Set Suite Variable               ${Listing_ID}

My Listing Details Logged Out
    [Tags]                          all  listings
    Set Random Phone Number
    Login To Service
    ${Listing_Id}                   Post a Listing                  category=لوازم شخصی
    Expect Response                 ${My_Listing_Error_Schema}
    Get In Retry                    /user/listings/${Listing_ID}
