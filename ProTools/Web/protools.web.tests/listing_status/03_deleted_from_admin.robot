*** Settings ***
Documentation                                                        Deleted From Admin
Resource                                                             ../../resources/setup.resource
Test Setup                                                           Run Keywords    Open test browser
Test Teardown                                                        Clean Up Tests


*** Variables ***



*** Test cases ***
Change Listing Status Into Deleted
    [Tags]                                                           Listing    Deleted
    Create Shop In Sheypoor
    Login To ProTools                                                ${Shop_owner_phone}
    Create New Listing                                               Land Main Attribute For Rent    1    44099    house    District=n927
    Get Listing Human Readable Id
    Trumpet adv                                                      delete    ${human_readable_id}
    Go to                                                            ${SERVER}/pro/real-estate/files
    Reload Page To Find Text                                         در اینجا فایل خود را ثبت و مدیریت کنید.

*** Keywords ***
