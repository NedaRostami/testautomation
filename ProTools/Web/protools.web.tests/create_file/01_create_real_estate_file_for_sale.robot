*** Settings ***
Documentation                                Add New Apartment Sale File
...                                          In Real Estate Category
Resource                                     ../../resources/setup.resource
Test Setup                                   Run Keywords    Open test browser
Test Teardown                                Clean Up Tests



*** Variables ***
${building_direction_menu}                   a69202-trigger
${building_direction}                        checkbox-450000
${unit_direction_menu}                       a69207-trigger
${unit_direction}                            checkbox-450013
${parking_menu}                              a69212
${parking}                                   450021
${floor_num}                                 a69217
${unit_num}                                  a69222
${resident_status_menu}                      a69227
${resident_status}                           450032
${deed_type_menu}                            a69232
${deed_type}                                 450040
${land_area}                                 a69237
${villa_type_menu}                           a69242
${villa_type}                                450053
${property_type_menu}                        a68094
${property_type}                             440470
${building_age_menu}                         a92368
${building_age}                              455206
${other_facilities}                          a69247-trigger
${balcony}                                   checkbox-450060
${yard}                                      checkbox-450061
${open}                                      checkbox-450062
${furnished}                                 checkbox-450065
${room_num_menu}                             a68133
${room_num}                                  439416
${parking_lot}                               a69190
${warehouse}                                 a69192
${elevator}                                  a69194

*** Test Cases ***
Create A Real Estate File For Sale
    [Tags]                                   File              New              Sale
    Create Shop In Sheypoor
    Login To ProTools                        ${Shop_owner_phone}
    Create New File                          Input Real Estate Main Attribute For Sale    1    43604    house    Input Real Estate More Detail Attributes  District=n888
    Validate File Is Registered

*** Keywords ***
Input Real Estate Main Attribute For Sale
    Choose Single Select Attributes          ${property_type_menu}              ${property_type}
    Choose Single Select Attributes          ${building_age_menu}               ${building_age}
    Input By Name                            ${AREA}                            165
    Choose Single Select Attributes          ${room_num_menu}                   ${room_num}
    Input Price
    Click By Name                            ${parking_lot}
    Click By Name                            ${warehouse}
    Click By Name                            ${elevator}

Input Real Estate More Detail Attributes
    Click By Name                            افزودن جزئیات بیشتر
    Choose Multi Select Attributes           ${building_direction_menu}         ${building_direction}
    Choose Multi Select Attributes           ${unit_direction_menu}             ${unit_direction}
    Choose Single Select Attributes          ${parking_menu}                    ${parking}
    Input By Name                            ${floor_num}                       4
    Input By Name                            ${unit_num}                        2
    Choose Single Select Attributes          ${resident_status_menu}            ${resident_status}
    Choose Single Select Attributes          ${deed_type_menu}                  ${deed_type}
    Input By Name                            ${land_area}                       5000
    Choose Single Select Attributes          ${villa_type_menu}                 ${villa_type}
    Sleep                                    1s
    Choose Multi Select Attributes           ${other_facilities}                ${balcony}             ${yard}         ${furnished}
    Click By Name                            ${ADD_ACTION}
