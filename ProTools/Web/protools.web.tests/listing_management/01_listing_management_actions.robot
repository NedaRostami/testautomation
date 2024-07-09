*** Settings ***
Documentation                           Listing Management Actions
Resource                                ../../resources/setup.resource
Test Setup                              Run Keywords    Open test browser
Test Teardown                           Clean Up Tests


*** Variables ***
${property_type_menu}                   a68095
${property_type}                        440475

*** Test cases ***
Check Listing Management Actions
    [Tags]                              Listing                                 Management
    Create Shop In Sheypoor
    Login To ProTools                   ${Shop_owner_phone}
    Create New Listing                  Office Sales Main Attribute For Rent    1    43605    house   District=n1183
    Validate Advertise is Verified
    Click To Show Page                  real-estate                             listings              ${LISTINGS_LIST}
    Listing Management Actions Validations
    Edit Listing
    Delete Listing From Listing Management
    Activate Deleted Listing From Listing Management
    Delete Listing From Listing Details
    Activate Deleted Listing From Listing Details

*** Keywords ***
Office Sales Main Attribute For Rent
    Choose Single Select Attributes     ${property_type_menu}                   ${property_type}
    Input By Name                       ${AREA}                                 45
    Input Price

Listing Management Actions Validations
    Wait Until Page Contains Element    name:listing-item-0                     timeout=10s
    Page Should Contain Element         name:${STATISTICS}
    Page Should Contain Element         name:${EDIT}
    Page Should Contain Element         name:${DELETE}
    Page Should Contain Element         name:${BUMP}

Edit Listing
    Validate Click By Name is Done      ${EDIT}                                 ویرایش آگهی
    Clear Textfield                     ${AREA}
    Input By Name                       ${AREA}                                 58
    Clear Textfield                     name
    Input Text                          name:name                               فروش اداری 58 متری با قیمت مناسب
    Validate Click By Name is Done      ${SUBMIT_FILE}                          درحال بازبینی
    Page Should Contain                 فروش اداری 58 متری با قیمت مناسب
    Page Should Contain                 58
    Validate Advertise is Verified
    Click To Show Page                  real-estate                             listings        ${LISTINGS_LIST}
    Reload Page To Find Text            پذیرفته شد

Delete Listing From Listing Management
    Validate Click By Name is Done      ${DELETE}                               از انصراف اطمینان دارید؟
    Click By Name                       ${CONFIRM_ACCEPT}
    Wait Until Page Does Not Contain    از انصراف اطمینان دارید؟                                                   timeout=10s
    Wait Until Page Contains            لغو انتشار با موفقیت انجام شده است                                        timeout=10s
    Reload Page To Find Text            در اینجا آگهی خود را ثبت و مدیریت کنید.                 #بعدا پاک بشه

Delete Listing From Listing Details
    Validate Click By Name is Done      delete-action                           لغو انتشار با موفقیت انجام شده است
    Wait Until Page Does Not Contain    لغو انتشار با موفقیت انجام شده است                                        timeout=10s

Activate Deleted Listing From Listing Management
    FOR       ${INDEX}    IN RANGE    0    3
      Click By Name                     ${INACTIVE_TAB}
      ${Status}                         Run Keyword And Return Status           Wait Until Page Contains Element     ${ACTIVATION}                 timeout=10s
      Exit For Loop If                  ${status}
    END
    Validate Click By Name is Done      ${ACTIVATION}                           ویرایش آگهی
    Validate Click By Name is Done      ${SUBMIT_FILE}                          پذیرفته شد

Activate Deleted Listing From Listing Details
    Validate Click By Name is Done      ${ADVERTISE}                            ویرایش آگهی
    Wait Until Page Contains Element    name:${AREA}                            timeout=10s
    Scroll Element Into View            ${AREA}
    Clear Textfield                     ${AREA}
    Input By Name                       ${AREA}                                 38
    Clear Textfield                     name
    Input Text                          name:name                               فروش اداری 38 متری مناسب
    Validate Click By Name is Done      ${SUBMIT_FILE}                          فروش اداری 38 متری مناسب
    Validate Advertise is Verified
    Reload Page To Find Text            پذیرفته شد
