*** Settings ***
Resource                                ../default/default-keywords.resource

*** Keywords ***
Get Listing Owner Contact Info Using ${Contact_Method}
    Pass Execution                  ${NOT_IMPLEMENTED_MESSAGE}

Validate Listing Details Response
    String                          response body listingID                         ${Random_Listing['listingID']}
    String                          response body title                             ${Random_Listing['title']}

Validate Post a Listing
    [Arguments]                     ${Listing_ID}
    Get In Retry                    /user/listings              headers=${Listing_Headers}
    ${Listings}                     Get Array                   response body listings
    ${Status}                       Set Variable                ${False}
    FOR         ${I}       IN       @{Listings}
        ${Status}                   Set Variable If             "${I['listingID']}" == "${Listing_ID}"       ${True}
    END
    Run Keyword If                  ${Status} == ${False}       Fail            Could not validate listing
