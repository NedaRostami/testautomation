*** Settings ***
Documentation                                                        Activate rejeted listing
Resource                                                             ../../resources/setup.resource
Test Setup                                                           Run Keywords    Open test browser
Test Teardown                                                        Clean Up Tests


*** Variables ***



*** Test cases ***
Change Listing Status Rejected
    [Tags]                                                           Listing                         Rejected
    Create Shop In Sheypoor
    Login To ProTools                                                ${Shop_owner_phone}
    Reject Listing
    Activate Rejected Listing



*** Keywords ***
Reject Listing
    Create New Listing                                               Land Main Attribute For Rent    1    44099    house    District=n4804
    ${human_readable_id}                                             Validate Advertise is Rejected
    Rejected Listing Is Displayed In Inactive Tab

Rejected Listing Is Displayed In Inactive Tab
    Click To Show Page                                               real-estate                          listings     ${LISTINGS_LIST}
    Click By Name                                                    ${INACTIVE_TAB}
    Wait Until Page Contains                                         رد شد

Activate Rejected Listing
    Validate Click By Name is Done                                   ${EDIT}                              ویرایش آگهی
    Clear Textfield                                                  name
    Input By Name                                                    name                                 ${SPACE}ویرایش آگهی رد شده
    FOR    ${INDEX}    IN RANGE    5
      Click By Name                                                  ${SUBMIT_FILE}
      ${status}           Run Keyword And Return Status              Wait Until Page Contains             درحال بازبینی           timeout=5s
      Exit For Loop If    ${status}
    END
    Click To Show Page                          real-estate          listings                             ${LISTINGS_LIST}
    Validate Advertise is Verified
