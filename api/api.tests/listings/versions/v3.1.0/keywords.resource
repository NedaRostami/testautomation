*** Settings ***
Resource                                ../default/default-keywords.resource


*** Keywords ***
Get Random Listing From Serp
    Get In Retry                    /listings                                   validate=false
    ${Listings}                     Get Array                                   response body ls
    ${Listings_Length}              Get Length                                  ${Listings}
    ${Random_Int}                   Random Int                                  min=3                           max=${Listings_Length-1}
    [Return]                        ${Listings[${Random_Int}]}

#   -------------------------------------------- Bumps --------------------------------------------
Validate Top 3
    Sleep                           3                               # Server can't handle it fast!
    Get In Retry                    /listings?categoryID=${Post_Listing['categoryID']}&locationID=${Post_Listing['locationID']}&locationType=${Post_Listing['locationType']}            validate=false
    ${Listings}                     Get Array                                   response body ls
    FOR                             ${I}        IN      @{Listings}
       Run Keyword If              '${I['id']}' == '${Listing_ID}'             Check Is Bumped                 ${I}
    END
Check Is Bumped
    [Arguments]                     ${Listing}
    Should Be True                  ${Listing['b']}

#   -------------------------------------------- Contact Listing --------------------------------------------
Find A Random Listing ID
    ${Random_Listing}               Get Random Listing From Serp
    Set Test Variable               ${Random_Listing_ID}                ${Random_Listing['id']}

Get Listing Owner Contact Info Using ${Contact_Method}
    Pass Execution                  ${NOT_IMPLEMENTED_MESSAGE}

#   -------------------------------------------- Favorite Listing --------------------------------------------
Favorite A Listing
    ${Random_Listing}               Get Random Listing From Serp
    Post In Retry                   /listings/favorites                                      {"favoriteIds": [${Random_Listing['id']}]}
    ...                             headers=${Listing_Headers}
    Integer                         response status                                         200
    Array                           response body favoritedIds                              minItems=1     maxItems=1
    Integer                         response body favoritedIds 0                            ${Random_Listing['id']}
    Array                           response body unfavoritedIds                            minItems=0     maxItems=0
    REST.Boolean                    response body success                                   ${True}

Unfavorite A Listing
    ${Random_Listing}               Get Random Listing From Serp
    Post In Retry                   /listings/favorites                                     {"favoriteIds": [${Random_Listing['id']}]}
    ...                             headers=${Listing_Headers}                              validate=false
    Post In Retry                   /listings/favorites                                     {"unfavoriteIds":[${Random_Listing['id']}]}
    ...                             headers=${Listing_Headers}
    Integer                         response status                                         200
    Array                           response body favoritedIds                              minItems=0     maxItems=0
    Array                           response body unfavoritedIds                            minItems=1     maxItems=1
    Integer                         response body unfavoritedIds 0                          ${Random_Listing['id']}
    REST.Boolean                    response body success                                   ${True}

Get Favorite Listing List
    ${Expected_Favorite_Listings}   Create List
    FOR     ${I}        IN RANGE    3
        ${Random_Listing}           Get Random Listing From Serp
        Post In Retry               /listings/favorites                                     {"favoriteIds": [${Random_Listing['id']}]}
        ...                         headers=${Listing_Headers}                              validate=false
        Append To List              ${Expected_Favorite_Listings}                           ${Random_Listing['id']}
    END
    Set Test Variable               ${Expected_Favorite_Listings}                           ${Expected_Favorite_Listings}
    Get In Retry                    /listings/favorites                                     headers=${Listing_Headers}      validate=false
    Integer                         response status                                         200
    ${Favorite_Listings}            Get Array                                               response body
    Set Test Variable               ${Favorite_Listings}                                    ${Favorite_Listings}

Validate Favorite Listings
    ${Favorite_Listing_Ids}         Create List
    FOR     ${I}        IN          @{Favorite_Listings}
        Append To List              ${Favorite_Listing_Ids}                                 ${I['listingID']}
    END
    Remove Duplicates               ${Expected_Favorite_Listings}
    Remove Duplicates               ${Favorite_Listing_Ids}
    Sort List                       ${Favorite_Listing_Ids}
    Sort List                       ${Expected_Favorite_Listings}
    Lists Should Be Equal           ${Expected_Favorite_Listings}                           ${Favorite_Listing_ids}

#   -------------------------------------------- Post a Listing --------------------------------------------
Validate Post a Listing
    [Arguments]                     ${Listing_ID}
    Get In Retry                    /user/listings              headers=${Listing_Headers}
    ${Listings}                     Get Array                   response body listings
    ${Status}                       Set Variable                ${False}
    FOR         ${I}       IN       @{Listings}
        ${Status}                   Set Variable If             "${I['id']}" == "${Listing_ID}"       ${True}
    END
    Run Keyword If                  ${Status} == ${False}       Fail            Could not validate listing

#   -------------------------------------------- Report Listing --------------------------------------------
Report Listing As ${mobile} With ${email} About ${issue_ids} With ${comment} Using ${schema_path}
    ${Random_Listing}               Get Random Listing From Serp
    ${Body}                         Create Dictionary
    ...                             mobile=${mobile}                                    email=${email}
    ...                             issueIDs=${issue_ids}                               comment=${comment}
    Expect Response                 ${schema_path}
    Post In Retry                   /listings/${Random_Listing['id']}/complaint         ${Body}

#   -------------------------------------------- Listing Details --------------------------------------------
Request Listing Details
    Get In Retry                    /listings/${Random_Listing['id']}
    Integer                         response status                                 200
    ${Listing_Details}              Get Object                                      response body

Validate Listing Details Response
    String                          response body title                             ${Random_Listing['title']}
