*** Settings ***
Resource                                ../default/default-keywords.resource

*** Keywords ***
Validate Post a Listing
    [Arguments]                     ${Listing_ID}
    Get In Retry                    /user/listings              headers=${Listing_Headers}
    ${Listings}                     Get Array                   response body listings
    ${Status}                       Set Variable                ${False}
    FOR         ${I}       IN       @{Listings}
        ${Status}                   Set Variable If             "${I['listingID']}" == "${Listing_ID}"       ${True}
    END
    Run Keyword If                  ${Status} == ${False}       Fail            Could not validate listing