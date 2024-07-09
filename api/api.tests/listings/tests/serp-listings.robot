*** Settings ***
Documentation                       Serp listings
Resource                            ../versions/v${api_version}/keywords.resource
Suite Setup                         Set Suite Environment
Test Setup                          Set Test Environment
Test Teardown                       Clean Up Test

*** Test Cases ***
Serp Listings No Filters
    [Tags]                          api             listings
    [Setup]                         Expect Response                         ${Serp_Listings_Schema}
    Get In Retry                    /listings
    Integer                         response status                         200

Serp Listings Category Filter
    [Tags]                          api             listings
    [Setup]                         Expect Response                         ${Serp_Listings_Schema}
    Get In Retry                    /listings?categoryID=43606
    Integer                         response status                         200

Serp Listings Model Filter
    [Tags]                          api             listings
    [Setup]                         Expect Response                         ${Serp_Listings_Schema}
    Get In Retry                    /listings?categoryID=43973&m68142=440655
    Integer                         response status                         200

Serp Listings Province Filter
    [Tags]                          api             listings
    [Setup]                         Expect Response                         ${Serp_Listings_Schema}
    Get In Retry                    /listings?locationID=8&locationType=0
    Integer                         response status                         200

Serp Listings City Filter
    [Tags]                          api             listings
    [Setup]                         Expect Response                         ${Serp_Listings_Schema}
    Get In Retry                    /listings?locationID=301&locationType=1
    Integer                         response status                         200

Serp Listings District Filter
    [Tags]                          api             listings
    [Setup]                         Expect Response                         ${Serp_Listings_Schema}
    Get In Retry                    /listings?locationID=993&locationType=2
    Integer                         response status                         200

Serp Listings All Filters
    [Tags]                          api             listings
    [Setup]                         Expect Response                         ${Serp_Listings_Schema}
    Get In Retry                    /listings?categoryID=43606&m68142=440655&locationID=8&locationType=0
    Integer                         response status                         200
