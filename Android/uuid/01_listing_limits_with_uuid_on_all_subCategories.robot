*** Settings ***
Documentation                                             Get listing limits per each subcategory and random location,
...                                                       then post listings as many as limits count by unique uuid and a random phone number,
...                                                       then post another listing by the same uuid and another random phone number and expected to receive listing limits message.
Resource                                                  ../resources/common.resource
Library                                                   DataDriver                                  dialect=excel
...                                                       encoding=utf_8                              optimize_pabot=Binary
Test Teardown                                             Remove Registered Listings
Test Template                                             Test Listing Limits With uuid

*** Variables ***
${listing_limit_msg}                                      تعداد آگهی شما در گروه‌بندی مورد نظر بیشتر از تعداد مجاز رایگان است. برای ثبت آگهی بروی ثبت نهایی آگهی کلیک نمایید.

*** Test Cases ***
Test Listing Limits With uuid On All SubCategories

*** Keywords ***
Test Listing Limits With uuid
    [Arguments]                                           ${cat_name}                                 ${subCat_name}
    ...                                                   ${cat_id}                                   ${subCat_id}
    Set Cat And subCat As Test Variables                  ${cat_name}                                 ${subCat_name}
    ...                                                   ${cat_id}                                   ${subCat_id}
    Generate Random Location
    Get Listing Limits From Admin
    Post Random Listing One More Than Limits Count

Set Cat And subCat As Test Variables
    [Arguments]                                           ${cat_name}                                 ${subCat_name}
    ...                                                   ${cat_id}                                   ${subCat_id}
    Set Test Variable                                     ${cat_name}
    Set Test Variable                                     ${subCat_name}
    Set Test Variable                                     ${cat_id}
    Set Test Variable                                     ${subCat_id}

Generate Random Location
    ${location}                                           Get Random Location Name And ID
    Set Test Variable                                     ${region_name}                              ${location}[province_name]
    Set Test Variable                                     ${region_id}                                ${location}[province_id]
    Set Test Variable                                     ${city_name}                                ${location}[city_name]
    Set Test Variable                                     ${city_id}                                  ${location}[city_id]

Get Listing Limits From Admin
    [Documentation]
    ${limit_count}                                        Get Limits Deep By Cat And Location         ${cat_id}                     ${region_id}
    ...                                                   ${subCat_id}                                ${city_id}
    IF                                                    ${limit_count} == ${NONE}
        Set Tags                                          no limits
        Skip                                              There are no post listing limits on [category: ${cat_name}, subCategory: ${subCat_name}, province: ${region_name}, city: ${city_name}, Even All Iran]
    END
    Set Test Variable                                     ${limit_count}

Post Random Listing One More Than Limits Count
    Generate Random Unique uuid
    Post Random Listing As Many As Limits Count
    Post Another Listing By Another Phone Number

Generate Random Unique uuid
    ${uuid}                                               Evaluate                                    uuid.uuid1()
    ${uuid}                                               Convert To String                           ${uuid}
    Set Test Variable                                     ${uuid}

Post Random Listing As Many As Limits Count
    Mobile Generator A
    ${listings_id}    ${response_msgs}                    Post Listings With uuid In Background       ${Random_User_Mobile_A}       ${subCat_id}
    ...                                                   ${region_name}                              ${city_name}                  ${city_id}
    ...                                                   ${1}                                        ${uuid}                       ${limit_count}
    Set Test Variable                                     ${registered_listings_id}                   ${listings_id}
    Validate Listing Registration Without Limits          ${response_msgs}

Post Another Listing By Another Phone Number
    Mobile Generator A
    ${listing_id}    ${response_msg}                      Post Listings With uuid In Background       ${Random_User_Mobile_A}       ${subCat_id}
    ...                                                   ${region_name}                              ${city_name}                  ${city_id}
    ...                                                   ${1}                                        ${uuid}                       ${1}
    Append To List                                        ${registered_listings_id}                   ${listing_id}[0]
    Validate Listing Registration Has Limits              ${response_msg}[0]


Validate Listing Registration Without Limits
    [Arguments]                                           ${resp_msgs}
    FOR     ${resp_msg}           IN                      @{resp_msgs}
        Should Contain                                    ${resp_msg}                                 شناسه آگهی:
    END

Validate Listing Registration Has Limits
    [Arguments]                                           ${resp_msg}
    Should Be Equal                                       ${resp_msg}                                 ${listing_limit_msg}

Remove Registered Listings
    ${listing_is_registered}                              Run Keyword And Return Status               Variable Should Exist         ${registered_listings_id}
    Run Keyword If                                        ${listing_is_registered}
    ...                                                   Delete Listings                             ${registered_listings_id}
