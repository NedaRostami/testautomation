*** Settings ***
Documentation                                      Search In Protools Listings
Resource                                           ../../resources/setup.resource
Test Setup                                         Run Keywords    Open test browser
Test Teardown                                      Clean Up Tests


*** Variables ***
${property_type_menu}                              a68094
${property_type}                                   440470
${building_age_menu}                               a92368
${building_age}                                    455206
${room_num_menu}                                   a68133
${room_num}                                        439416
${parking_lot}                                     a69190
${warehouse}                                       a69192
${elevator}                                        a69194

*** Test cases ***
Search In Protools Listings
    [Tags]                                         Listings                           Search
    Create Shop In Sheypoor
    Login To ProTools                              ${Shop_owner_phone}
    Create Listings For Searches
    Search In Files

*** Keywords ***
Create Listings For Searches
    Create Some Listings                           2
    Create New Listing                             Input Real Estate Main Attribute For Sale    1    43604    house    District=n1046
    Validate Advertise is Verified
    Click To Show Page                             real-estate                        listings        ${LISTINGS_LIST}

Input Real Estate Main Attribute For Sale
    Choose Single Select Attributes                ${property_type_menu}              ${property_type}
    Choose Single Select Attributes                ${building_age_menu}               ${building_age}
    Input By Name                                  ${AREA}                            165
    Choose Single Select Attributes                ${room_num_menu}                   ${room_num}
    Input Price
    Click By Name                                  ${parking_lot}
    Click By Name                                  ${warehouse}
    Click By Name                                  ${elevator}

Search In Files
    Input By Name                                  search-input-html                  ${Listings_Title}
    Wait Until Page Does Not Contain Element       name:listing-item-1                timeout=10s
    Wait Until Page Contains Element               name:listing-item-0                timeout=10s
    Clear Textfield                                search-input-html
    # click Element                                  name:clear-search
    # Wait For Condition                             return window.document.readyState === "complete"   timeout=15s
    # Wait Until Page Does Not Contain Element       name:clear-search    timeout=5s
    Wait Until Page Contains Element               name:listing-item-1                timeout=5s
    Page Should Contain Element                    name:listing-item-2
    Page Should Contain Element                    name:listing-item-0
    Page Should Not Contain Element                برای جست‌و‌جوی شما هیچ موردی یافت نشد
