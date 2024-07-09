*** Settings ***
Documentation                                Auto Approve Accepted Listing
Resource                                     ../../resources/setup.resource
Test Setup                                   Run Keywords    Open test browser
Test Teardown                                Clean Up Tests


*** Variables ***


*** Test cases ***
Change Listing Status by Auto Approve
    [Tags]                                    Listing                              Auto              Approve
    Create Shop In Sheypoor
    Login To ProTools                         ${Shop_owner_phone}
    Auto Approve Listing

*** Keywords ***
Auto Approve Listing
    Create New Listing                        Land Main Attribute For Rent    1    44099    house    District=n3568
    ${human_readable_id}                      Validate Advertise is Verified
    Activate Accepted Listing With Edit

Activate Accepted Listing With Edit
    Validate Click By Name is Done            ${EDIT}                              ویرایش آگهی
    Input Text                                css:textarea                         ${SPACE}ویرایش برای پذیرفتن اتوماتیک
    Validate Click By Name is Done            ${SUBMIT_FILE}                       پذیرفته شد
    Click To Show Page                        real-estate                          listings         ${LISTINGS_LIST}
