*** Settings ***
Documentation                                        In this scenario, after post a car listing as a shop owner,
...                                                  login with a new user and after twice calling the listing phone number,
...                                                  rates the listing seller.
Resource                                             ..${/}..${/}resources${/}common.resource
Suite Setup                                          Set Suite Environment
Test Setup                                           start app
Test Teardown                                        Close test application
Test Timeout                                         10 minutes

*** Variables ***
${vehicles_cat_id}                                   43626
${cat}                                               وسایل نقلیه
${subCat}                                            خودرو
${price}                                             300000000
${state}                                             گیلان
${city}                                              رشت
${region}                                            آشتیانی
${number_of_photos}                                  ${1}
${newUsed}                                           ${EMPTY}
${chip_discount}                                     ${FALSE}
${kind}                                              ${EMPTY}
${seller_type_is_shop_owner}                         1

*** Test Cases ***
Rate To Shop Seller After Call
    [Tags]                                           rate                               shop                    listing                   call
    Confirm That Rating Toggle Is Enabled
    Create A New Shop In Vehicles Category
    Post A New Listing By Shop Owner Phone
    Login to Sheypoor
    Back To Home Page                                1
    Find The Created Listing By Filter
    Call The Listing Phone Number Twice
    Validate That Is On The Rating Page
    Rate And Comment To The Seller
    Approve Comment Via Admin

*** Keywords ***
Create A New Shop In Vehicles Category
    Create Shop In Sheypoor                          Category=${vehicles_cat_id}

Post A New Listing By Shop Owner Phone
    Post Listing In Background Via Python            ${cat}                             ${subCat}               ${price}                  ${state}
    ...                                              ${city}                            ${region}               ${Shop_owner_phone}       ${number_of_photos}
    ...                                              ${newUsed}                         ${chip_discount}        ${kind}
    Trumpet adv                                      accept                             ${listingId}

Call The Listing Phone Number Twice
    Call To Seller In Listing Details Page
    Back To Sheypoor App
    Close NPS Popup
    Call To Seller In Listing Details Page
    Back To Sheypoor App

Call To Seller In Listing Details Page
    Wait Until Page Contains Element                 ${LISTING_DETAILS_CALL_BTN}        timeout=10s
    Click Element                                    ${LISTING_DETAILS_CALL_BTN}
    Wait Until Page Contains                         ${Shop_owner_phone}                timeout=10s

Approve Comment Via Admin
    Approve User Comments                            phone=${Shop_owner_phone}          seller_type=${seller_type_is_shop_owner}
    ...                                              shop_title=${Shop_title}           category=${vehicles_cat_id}

Find The Created Listing By Filter
    Filter By Cat And Search By Listing Title
    IF                                             '${file_version}' >= '6.4.0'
        Validate Going Home With Back Button
        Filter By Cat And Search By Listing Title
    END
    Go To Desired Listing Details Page

Validate Going Home With Back Button
    [Documentation]                                 Tests to go home after searching in the serp page by the back button.
    Click Back Button
    Wait Until Page Contains Element                ${CAT_ROOT}                          timeout=10s
