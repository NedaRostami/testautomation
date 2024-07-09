*** Settings ***
Documentation                       Listing details from serp
Resource                            ../versions/v${api_version}/keywords.resource
Suite Setup                         Set Suite Environment
Test Setup                          Set Test Environment
Test Teardown                       Clean Up Test

*** Test Cases ***
Leads And Views Endpoint Availability
    [Tags]                          all  notest
    Post A Listing As Seller
    Get In Retry                    /listings/${Listing_Id}
    Get In Retry                    listings/stats/${Listing_Id}/1      headers=${Listing_Headers}

*** Keywords ***
Post a Listing As Seller
    ${Listing}                      Post A Listing                      phone_number=${Phone_Number}                count=1
    ${Listing}                      Set Variable                        ${Listing[0]}
    Set Test Variable               ${Listing_Id}                       ${Listing}
