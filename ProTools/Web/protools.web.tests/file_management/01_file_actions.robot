*** Settings ***
Documentation                                File Management Actions
Resource                                     ../../resources/setup.resource
Test Setup                                   Run Keywords    Open test browser
Test Teardown                                Clean Up Tests


*** Variables ***
${property_type_menu}                        a68097
${property_type}                             440482
${mortgage}                                  a68091
${rent}                                      a68093

*** Test cases ***
Check File Management Actions
    Create Shop In Sheypoor
    Login To ProTools                               ${Shop_owner_phone}
    Create New File                                 Office Rent Main Attribute For Rent    1    43607    house          District=n4592
    Validate File Is Registered
    Delete File
    Create New File                                 Office Rent Main Attribute For Rent    1    43607    house
    Validate File Is Registered
    File Management Actions Validations
    Edit File
    Archive File
    Post Listing From File Management

*** Keywords ***
Delete File
    Validate Click By Name is Done      ${EDIT}                               ویرایش فایل
    Click Element                       //button[@name="form-delete-action"]/span[text()='حذف']
    Wait Until Page Contains            آیا از حذف فایل اطمینان دارید؟       timeout=5s
    Click By Name                       ${CONFIRM_ACCEPT}
    Wait Until Page Does Not Contain    آیا از حذف فایل اطمینان دارید؟        timeout=10s
    Wait Until Page Contains            در اینجا فایل خود را ثبت و مدیریت کنید.       timeout=10s

Office Rent Main Attribute For Rent
    Choose Single Select Attributes     ${property_type_menu}      ${property_type}
    Input By Name                       ${AREA}                    20
    Input Price                         ${mortgage}                ${rent}         Mortgage_Price=50000000        Rent_Price=2000000


File Management Actions Validations
    Wait Until Page Contains Element   name:${EDIT}                           timeout=5s
    Page Should Contain Element        name:${EDIT}
    Page Should Contain Element        name:${ARCHIVE}
    Page Should Contain Element        name:${ADVERTISE}

Edit File
    Validate Click By Name is Done      ${EDIT}                               ویرایش فایل
    Clear Textfield                     ${AREA}
    Input By Name                       ${AREA}             25
    Clear Textfield                     ${rent}
    Clear Textfield                     ${mortgage}
    Input Price                         ${mortgage}                ${rent}         Mortgage_Price=90000000        Rent_Price=1000000
    # Validate Click By Name is Done      ${SUBMIT_FILE}              اجاره اداری ۲۵ متر در آسمان
    Validate Click By Name is Done      ${SUBMIT_FILE}             اجاره اداری 25 متر در آسمان
    Page Should Contain                 آگهی نشده
    Click To Show Page     real-estate          files            ${FILES_LIST}

Archive File
    Validate Click By Name is Done     ${ARCHIVE}                             آیا از بایگانی کردن این فایل مطمئن هستید؟
    Validate Click By Name is Done     ${CONFIRM_ACCEPT}                      فایل موردنظر شما بایگانی شد
    Wait Until Page Does Not Contain   فایل موردنظر شما بایگانی شد            timeout=10s
    Reload Page To Find Text           در اینجا فایل خود را ثبت و مدیریت کنید.
    Click By Name                      ${INACTIVE_TAB}
    Wait Until Page Contains Element   name:${RE_OPEN}                        timeout=10s
    Validate Click By Name is Done     ${RE_OPEN}                             فایل مورد نظر شما باز شد
    Wait Until Page Does Not Contain   فایل مورد نظر شما باز شد               timeout=10s

Post Listing From File Management
    Click By Name                      ${ACTIVE_TAB}
    Reload Page
    Validate Click By Name is Done     ${ADVERTISE}                            عنوان آگهی
    Input Text                         ${LISTING_DESCRIPTION}        ${Faker_Description}
    # Input By Name                      telephone                     ${Faker_Phone_Number}
    Handle Phone Number Field          ${Shop_owner_phone}
    Register Advertise                 ${ADD_ACTION}
    Reload Page To Find Element        ${ADVERTISED}
    Wait Until Page Contains          پذیرفته شد                        timeout=5s
    Get Listing Human Readable Id
