*** Settings ***
Resource                                ../../../../resources/resource.resource


*** Variables ***
${Post_A_Listing_Schema}            ${ROOT_PATH}/api.tests/post_listing/versions/v${api_version}/schema/post_a_listing.json

*** Keywords ***
#   -------------------------------------------- Post a Listing --------------------------------------------
Post a ${Category} Listing Category
    Set Random Phone Number
    Login To Service
    Post a Listing                  category=${category}
    Integer                         response status             minimum=200     maximum=202
    ${Post_Listing_Message}         Get String                  response body message
    ${Listing_ID}                   Get String                  response body listingID
    Run Keyword If                  "تعداد مجاز رایگان" not in """${Post_Listing_Message}"""
    ...                             Validate Post a Listing     ${Listing_ID}
    Mock Listing Moderate           accept                      ${Listing_ID}

Validate Post a Listing
    [Arguments]                     ${Listing_ID}
    Get In Retry                    /user/listings              headers=${Listing_Headers}
    ${Listings}                     Get Array                   response body
    ${Status}                       Set Variable                ${False}
    FOR         ${I}       IN       @{Listings}
        ${Status}                   Set Variable If             "${I['listingID']}" == "${Listing_ID}"       ${True}
    END
    Run Keyword If                  ${Status} == ${False}       Fail            Could not validate listing
