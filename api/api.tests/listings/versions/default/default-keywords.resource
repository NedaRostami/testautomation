*** Settings ***
Resource                                ../../../../resources/resource.resource


*** Variables ***
${Contact_Listing_Schema}           ${ROOT_PATH}/api.tests/listings/versions/v${api_version}/schema/contact-listing.json
${Favorite_Listing_Schema}          ${ROOT_PATH}/api.tests/listings/versions/v${api_version}/schema/favorite_listing.json
${Get_Favorite_Listings_Schema}     ${ROOT_PATH}/api.tests/listings/versions/v${api_version}/schema/get_favorite_listings.json
${Listing_Details_Schema}           ${ROOT_PATH}/api.tests/listings/versions/v${api_version}/schema/listing-details.json
${My_Listings_Schema}               ${ROOT_PATH}/api.tests/listings/versions/v${api_version}/schema/my-listing.json
${My_Listing_Details_Schema}        ${ROOT_PATH}/api.tests/listings/versions/v${api_version}/schema/my-listing-details.json
${My_Listing_Error_Schema}          ${ROOT_PATH}/api.tests/listings/versions/v${api_version}/schema/my-listing-error.json
${Successful_Listing_Report}        ${ROOT_PATH}/api.tests/listings/versions/v${api_version}/schema/successful_listing_report.json
${Failed_Listing_Report}            ${ROOT_PATH}/api.tests/listings/versions/v${api_version}/schema/failed_listing_report.json
${Serp_Listings_Schema}             ${ROOT_PATH}/api.tests/listings/versions/v${api_version}/schema/serp-listings.json
${Refresh}                          refresh
${Top_3}                            refresh_top3
${Top_3_X2}                         refresh_top3_2x
@{All_Complaint_Types}              1   2   3   4   5   6   7   8   9
@{Some_Complaint_Types}             1   6   8   2   3
@{One_Complaint_Type}               5
@{No_Complaint_Type}                ${Empty}


*** Keywords ***
#   -------------------------------------------- Bumps Listing --------------------------------------------
Set Bump Environment
    Set Test Environment
    Set Random Phone Number
    Login To Service

Post a Listing To Bump
    ${Furniture_Category}           Get Category Object             category=لوازم خانگی
    ${Furniture_Category_ID}        Set Variable                    ${Furniture_Category['categoryID']}
    ${Listing_ID}                   Post a Decoration Listing
    Set Test Variable               ${Listing_ID}

Accept The Listing
    Mock Listing Moderate           accept                          ${Listing_ID}

Validate Top 3
    Sleep                           3                               # Server can't handle it fast!
    Get In Retry                    /listings?categoryID=${Post_Listing['categoryID']}&locationID=${Post_Listing['locationID']}&locationType=${Post_Listing['locationType']}            validate=false
    ${Listings}                     Get Array                       response body listings
    FOR        ${I}        IN      @{Listings}
       Run Keyword If              '${I['listingID']}' == '${Listing_ID}'              Check Is Bumped                 ${I}
    END

Check Is Bumped
    [Arguments]                     ${Listing}
    Should Be True                  ${Listing['isBumped']}

# has a small delay disabled until i can figure it out
Validate Refresh
    Get In Retry                    /listings                       validate=false
    ${Listings}                     Get Array                       response body listings
    ${Status}                       Set Variable                    ${False}
    FOR                             ${I}        IN      @{Listings}
       ${Status}                    Set Variable If                 '${I['listingID']}' == '${Listing_ID}'              ${True}
    END
    Run Keyword If                  not ${Status}                   Fail                Could not find bumped listing

#   -------------------------------------------- Contact Listing --------------------------------------------
Find A Random Listing ID
    ${Random_Listing}               Get Random Listing From Serp
    Set Test Variable               ${Random_Listing_ID}                ${Random_Listing['listingID']}

Get Listing Owner Contact Info Using ${Contact_Method}
    No Operation

#   -------------------------------------------- Favorite Listing --------------------------------------------
Setup Favorite Environment
    Set Test Environment
    Clear Expectations

Favorite A Listing
    ${Random_Listing}               Get Random Listing From Serp
    Post In Retry                   /listings/favorites                                      {"favoriteIds": [${Random_Listing['listingID']}]}
    ...                             headers=${Listing_Headers}
    Integer                         response status                                         200
    Array                           response body favoritedIds                              minItems=1     maxItems=1
    Integer                         response body favoritedIds 0                            ${Random_Listing['listingID']}
    Array                           response body unfavoritedIds                            minItems=0     maxItems=0
    REST.Boolean                    response body success                                   ${True}

Unfavorite A Listing
    ${Random_Listing}               Get Random Listing From Serp
    Post In Retry                   /listings/favorites                                     {"favoriteIds": [${Random_Listing['listingID']}]}
    ...                             headers=${Listing_Headers}                              validate=false
    Post In Retry                   /listings/favorites                                     {"unfavoriteIds":[${Random_Listing['listingID']}]}
    ...                             headers=${Listing_Headers}
    Integer                         response status                                         200
    Array                           response body favoritedIds                              minItems=0     maxItems=0
    Array                           response body unfavoritedIds                            minItems=1     maxItems=1
    Integer                         response body unfavoritedIds 0                          ${Random_Listing['listingID']}
    REST.Boolean                    response body success                                   ${True}

Get Favorite Listing List
    ${Expected_Favorite_Listings}   Create List
    FOR     ${I}        IN RANGE    3
        ${Random_Listing}           Get Random Listing From Serp
        Post In Retry               /listings/favorites                                     {"favoriteIds": [${Random_Listing['listingID']}]}
        ...                         headers=${Listing_Headers}                              validate=false
        Append To List              ${Expected_Favorite_Listings}                           ${Random_Listing['listingID']}
    END
    Set Test Variable               ${Expected_Favorite_Listings}                           ${Expected_Favorite_Listings}
    Get In Retry                    /listings/favorites?q=${Random_Listing['title']}        headers=${Listing_Headers}      validate=false
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

#   -------------------------------------------- Listing Details --------------------------------------------
Select Random Listing From Serp
    ${Random_Listing}               Get Random Listing From Serp
    Set Test Variable               ${Random_Listing}                               ${Random_Listing}

Request Listing Details
    Get In Retry                    /listings/${Random_Listing['listingID']}
    Integer                         response status                                 200
    ${Listing_Details}              Get Object                                      response body

Validate Listing Details Response
    Integer                         response body isSpecial                         ${Random_Listing['isSpecial']}
    Integer                         response body isSpecialInHome                   ${Random_Listing['isSpecialInHome']}
    String                          response body listingID                         ${Random_Listing['listingID']}
    Object                          response body location                          ${Random_Listing['location']}
    String                          response body title                             ${Random_Listing['title']}

#   -------------------------------------------- Report Listing --------------------------------------------
Report Listing As ${mobile} With ${email} About ${issue_ids} With ${comment} Using ${schema_path}
    ${Random_Listing}               Get Random Listing From Serp
    ${Body}                         Create Dictionary
    ...                             mobile=${mobile}                                    email=${email}
    ...                             issueIDs=${issue_ids}                               comment=${comment}
    Expect Response                 ${schema_path}
    Post In Retry                   /listings/${Random_Listing['listingID']}/complaint
    ...                             ${Body}
