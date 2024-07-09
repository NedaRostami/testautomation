*** Settings ***
Documentation                                       Edit Listing Images
...                                                 In Real Estate Category
Resource                                            ../../resources/setup.resource
Test Setup                                          Run Keywords    Open test browser
Test Teardown                                       Clean Up Tests


*** Variables ***
${property_type_menu}                               a68096
${property_type}                                    440477
${building_age_menu}                                a92367
${building_age}                                     455205
${room_num_menu}                                    a68133
${room_num}                                         439416
${parking_lot}                                      a69191
${warehouse}                                        a69193
${elevator}                                         a69195
${convertable}                                      a68190
${mortgage}                                         a68090
${rent}                                             a68092

*** Test cases ***
Edit Listing Images
    [Tags]                                          Listing   New   Rent
    Create Shop In Sheypoor
    Login To ProTools                               ${Shop_owner_phone}
    Create New Listing                              Real Estate Main Attribute For Rent    1    43606    house   District=n4728
    Validate Advertise is Verified
    Delete And Upload New Images

*** Keywords ***
Real Estate Main Attribute For Rent
    Choose Single Select Attributes                 ${property_type_menu}              ${property_type}
    Choose Single Select Attributes                 ${building_age_menu}               ${building_age}
    Click By Name                                   ${parking_lot}
    Click By Name                                   ${warehouse}
    Click By Name                                   ${elevator}
    Input By Name                                   ${AREA}                            90
    Choose Single Select Attributes                 ${room_num_menu}                   ${room_num}
    Input Price                                     ${mortgage}                        ${rent}                 Mortgage_Price=50000000        Rent_Price=2000000
    Click By Name                                   ${convertable}

Delete And Upload New Images
    Validate Click By Name is Done                  ${EDIT}                            ویرایش آگهی
    Wait Until Page Contains Element                name:form-delete-action            timeout=10s
    Click By Name                                   form-delete-action
    Confirm Delete PopUp
    Wait Until Page Does Not Contain Element        //img[@alt="file img"]             timeout=3s
    Upload Images                                   house           2
    FOR    ${INDEX}    IN RANGE    3
      Execute JavaScript                            window.scrollTo(0,0)
      Click By Name                                 ${SUBMIT_FILE}
      ${status}    Run Keyword And Return Status    Wait Until Page Contains           درحال بازبینی           timeout=5s
      Exit For Loop If    ${status}
    END
    Validate Advertise is Verified



Confirm Delete PopUp
    Wait Until Page Contains Element                //button[@name="confirm-accept-action"]                    timeout=10s
    Click Element                                   //button[@name="confirm-accept-action"]
