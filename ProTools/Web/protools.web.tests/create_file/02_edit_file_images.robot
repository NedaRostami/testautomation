*** Settings ***
Documentation                                              Edit File Images
...                                                        In Real Estate Category
Resource                                                   ../../resources/setup.resource
Test Setup                                                 Run Keywords    Open test browser
Test Teardown                                              Clean Up Tests



*** Variables ***
${property_type_menu}                                       a68094
${property_type}                                            440470
${building_age_menu}                                        a92368
${building_age}                                             455206
${room_num_menu}                                            a68133
${room_num}                                                 439416
${parking_lot}                                              a69190
${warehouse}                                                a69192
${elevator}                                                 a69194

*** Test cases ***
Edit File Images
    [Tags]                                                  File   Edit   Sale
    Create Shop In Sheypoor
    Login To ProTools                                       ${Shop_owner_phone}
    Create New File                                         Input Real Estate Main Attribute For Sale    1    43604    house
    Validate File Is Registered
    Delete And Upload New Images

*** Keywords ***
Input Real Estate Main Attribute For Sale
    Choose Single Select Attributes                         ${property_type_menu}              ${property_type}
    Choose Single Select Attributes                         ${building_age_menu}               ${building_age}
    Input By Name                                           ${AREA}                            165
    Choose Single Select Attributes                         ${room_num_menu}                   ${room_num}
    Input Price
    Click By Name                                           ${parking_lot}
    Click By Name                                           ${warehouse}
    Click By Name                                           ${elevator}

Delete And Upload New Images
    Validate Click By Name is Done                          ${EDIT}                             ویرایش فایل
    Wait Until Page Contains Element                        name:form-delete-action             timeout=10s
    Click By Name                                           form-delete-action
    Confirm Delete PopUp
    Wait Until Page Does Not Contain Element                //img[@alt="file img"]              timeout=3s
    Upload Images                                           house           2
    Execute JavaScript                                      window.scrollTo(0,0)
    FOR    ${INDEX}    IN RANGE    3
      Click By Name                                         ${SUBMIT_FILE}
      ${status}        Run Keyword And Return Status        Wait Until Page Contains            آگهی نشده           timeout=5s
      Exit For Loop If    ${status}
    END
    Wait Until Page Contains Element                        name:${ADVERTISE}

Confirm Delete PopUp
    Wait Until Page Contains Element                        //button[@name="confirm-accept-action"]                  timeout=10s
    Click Element                                           //button[@name="confirm-accept-action"]
