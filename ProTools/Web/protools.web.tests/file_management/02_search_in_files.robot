*** Settings ***
Documentation                                Search In Protools Files
Resource                                     ../../resources/setup.resource
Test Setup                                   Run Keywords    Open test browser
Test Teardown                                Clean Up Tests


*** Variables ***
${property_type_menu}                        a68094
${property_type}                             440470
${building_age_menu}                         a92368
${building_age}                              455206
${room_num_menu}                             a68133
${room_num}                                  439416
${parking_lot}                               a69190
${warehouse}                                 a69192
${elevator}                                  a69194

*** Test cases ***
Search In Protools Files
    [Tags]                                          File   Search
    Create Shop In Sheypoor
    Login To ProTools                               ${Shop_owner_phone}
    Create Files For Searches
    Search In Files

*** Keywords ***
Create Files For Searches
    Create Some Files                               2
    Create New File                                 Input Real Estate Main Attribute For Sale    1    43604    house
    Validate File Is Registered

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
    Input By Name                                  search-input-html                  165
    Wait Until Page Does Not Contain Element       name:file-item-1                   timeout=10s
    Wait Until Page Contains Element               name:file-item-0                   timeout=10s
    # Clear Textfield                                search-input-html
    click Element                                  name:clear-search
    Wait For Condition                             return window.document.readyState === "complete"   timeout=15s
    Wait Until Page Does Not Contain Element       name:clear-search                  timeout=5s
    Wait Until Keyword Succeeds                    5x   5s                            Input By Name         search-input-html       فروش زمین
    Wait Until Page Contains Element               name:file-item-1            timeout=10s
    Page Should Contain Element                    name:file-item-0
    Page Should Not Contain Element                برای جست‌و‌جوی شما هیچ موردی یافت نشد
    Page Should Not Contain Element                name:file-item-2
