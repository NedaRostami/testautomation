*** Settings ***
Documentation                               Add New Apartment Rent Listing
...                                         In Real Estate Category
Resource                                    ../../resources/setup.resource
Test Setup                                  Run Keywords    Open test browser
Test Teardown                               Clean Up Tests



*** Variables ***
${building_direction_menu}                   a69252-trigger
${building_direction}                        checkbox-450081
${unit_direction_menu}                       a69257-trigger
${unit_direction}                            checkbox-450091
${parking_menu}                              a69262
${parking}                                   450101
${floor_num}                                 a69267
${unit_num}                                  a69272
${resident_status_menu}                      a69277
${resident_status}                           450111
${deed_type_menu}                            a69282
${deed_type}                                 450120
${land_area}                                 a69287
${villa_type_menu}                           a69292
${villa_type}                                450133
${property_type_menu}                        a68096
${property_type}                             440477
${building_age_menu}                         a92367
${building_age}                              455206
${other_facilities}                          a69297-trigger
${balcony}                                   checkbox-450140
${yard}                                      checkbox-450141
${open}                                      checkbox-450142
${furnished}                                 checkbox-450145
${room_num_menu}                             a68133
${room_num}                                  439416
${parking_lot}                               a69191
${warehouse}                                 a69193
${elevator}                                  a69195
${convertable}                               a68190
${mortgage}                                  a68090
${rent}                                      a68092

*** Test Cases ***
Add New Listing In Real Estate Category For Rent
    [Tags]                                   Listing   New   Rent
    Create Shop In Sheypoor
    Login To ProTools                        ${Shop_owner_phone}
    Create New Listing                       Real Estate Main Attribute For Rent    3    43606    house    Input Real Estate More Detail Attributes For Rent    District=n5262
    Validate Advertise is Verified

*** Keywords ***
Input Real Estate More Detail Attributes For Rent
    Click By Name                            افزودن جزئیات بیشتر
    Choose Multi Select Attributes           ${building_direction_menu}         ${building_direction}
    Choose Multi Select Attributes           ${unit_direction_menu}             ${unit_direction}
    Choose Single Select Attributes          ${parking_menu}                    ${parking}
    Input By Name                            ${floor_num}                       3
    Input By Name                            ${unit_num}                        1
    Choose Single Select Attributes          ${resident_status_menu}            ${resident_status}
    Choose Single Select Attributes          ${deed_type_menu}                  ${deed_type}
    Input By Name                            ${land_area}                       120
    Choose Single Select Attributes          ${villa_type_menu}                 ${villa_type}
    Sleep                                    1s
    Choose Multi Select Attributes           ${other_facilities}                ${balcony}           ${yard}          ${furnished}
    Click By Name                            ${ADD_ACTION}

Real Estate Main Attribute For Rent
    Choose Single Select Attributes          ${property_type_menu}              ${property_type}
    Choose Single Select Attributes          ${building_age_menu}               ${building_age}
    Click By Name                            ${parking_lot}
    Click By Name                            ${warehouse}
    Click By Name                            ${elevator}
    Input By Name                            ${AREA}                            90
    Choose Single Select Attributes          ${room_num_menu}                   ${room_num}
    Input Price                              ${mortgage}                        ${rent}         Mortgage_Price=50000000        Rent_Price=2000000
    Click By Name                            ${convertable}
