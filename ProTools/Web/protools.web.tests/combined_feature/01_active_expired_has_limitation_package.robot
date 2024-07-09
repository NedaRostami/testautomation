*** Settings ***
Documentation                           Add a combined feature type for extendable listings
Resource                                ../../resources/package.resource
Test Setup                              Run Keywords    Open test browser
Test Teardown                           Clean Up Tests

*** Variables ***



*** Test cases ***
Active Expired Listing With Limitation Package Credit
    [Tags]                              Activation            Limitation          notest
    Create Shop In Sheypoor
    Login To ProTools                                           ${Shop_owner_phone}
    Enable Shop Package
    Go to                                                       ${SERVER}/pro/real-estate/listings
    Expire Listing
    Activate Edited Expired Listing With Credit
    Expire Listing
    Activate Expired Listing Without Credit
    Validate Activated Listing Is Top Of The List
    Login To Sheypoor And Check Listing Is Top Of The List

*** Keywords ***
Activate Edited Expired Listing With Credit
    Click By Name                                                    ${ACTIVATION}
    Wait Until Page Contains                                         ویرایش آگهی                          timeout=10s
    Clear Textfield                                                  name
    Input By Name                                                    name                                 ${SPACE}ویرایش آگهی منقضی شده
    Click By Name                                                    ${SUBMIT_FILE}
    Wait Until Page Contains                                         درحال بازبینی                        timeout=10s
    Validate Advertise is Verified
    Validate Shop Package From Protools                              15    10    5    2

Activate Expired Listing Without Credit
    Click By Name                                                    ${ACTIVATION}
    Wait Until Page Contains                                         ویرایش آگهی                          timeout=10s
    Click By Name                                                    ${SUBMIT_FILE}
    Wait Until Page Contains                                         پذیرفته شد                           timeout=10s
    Validate Shop Package From Protools                              15    10    5    1

Validate Activated Listing Is Top Of The List
    ${human_readable_id}                                             Get Listing Human Readable Id        1
    Mock Listing Expire                                              2day       ${human_readable_id}
    Expired Listing Is Displayed In Inactive Tab
    Click By Name                                                    ${ACTIVATION}
    Wait Until Page Contains                                         ویرایش آگهی                          timeout=10s
    Click By Name                                                    ${SUBMIT_FILE}
    Wait Until Page Contains                                         پذیرفته شد                           timeout=10s
    Go to                                                            ${SERVER}/pro/real-estate/listings
    Wait Until Page Contains Element                                 name:listing-item-0
    ${Text}                                                          Get Text                             name:listing-item-0
    Should Contain                                                   ${Text}                              ویرایش آگهی منقضی شده
    Validate Shop Package From Protools                              15    10    5    0

Login To Sheypoor And Check Listing Is Top Of The List
    Go To                                                            ${SERVER}/session/myListings
    Wait Until Page Contains                                         لطفا برای ورود یا ثبت نام شماره تلفن همراه یا آدرس پست الکترونیکی خود را وارد کنید.                   timeout=10s
    FOR    ${INDEX}    IN RANGE    0    4
      Input By Name                                                  username                             ${Shop_owner_phone}
      Click Button                                                   ${Login_OR_Register_Btn}
      Wait Until Page Contains                                       کد چهار رقمی پیامک شده به           timeout=10s
      Get and validate Verification Code                             ${Shop_owner_phone}
      Input Text                                                     id:code                             ${Verification_Code}
      Click Button                                                   تائید نهایی و ورود به شیپور
      ${Status}      Run Keyword And Return Status      Wait Until Page Contains        آگهی های من      timeout=10s
      Exit For Loop If       ${Status}
    END
    Item Is Top Of The Serp

Item Is Top Of The Serp
    Wait Until Page Contains                                         ویرایش آگهی منقضی شده
    ${Items}                                                         Get WebElements                     css:.serp-item.list
    ${Top_Items}                                                     Get Text                            ${Items[0]}
    Should Contain                                                   ${Top_Items}                        ویرایش آگهی منقضی شده
