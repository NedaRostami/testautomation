*** Settings ***
Documentation                           Activate expired listing
Resource                                ../../resources/setup.resource
Test Setup                              Run Keywords    Open test browser
Test Teardown                           Clean Up Tests


*** Variables ***



*** Test cases ***
Change Listing Status Expired
    [Tags]                                                           Listing    Expired      notest
    Create Shop In Sheypoor
    Login To ProTools                                                ${Shop_owner_phone}
    Set Test Payment Gateway                                         success
    Expire Listing
    Activate Expired Listing With Edit
    Delete Listing
    Expire Listing
    Activate Expired Listing Without Edit

*** Keywords ***
Activate Expired Listing With Edit
    Click By Name                                                    ${ACTIVATION}
    Wait Until Page Contains                                         ویرایش آگهی                          timeout=10s
    Clear Textfield                                                  name
    Input By Name                                                    name                                 ${SPACE}ویرایش آگهی منقضی شده
    Click By Name                                                    ${SUBMIT_FILE}
    Wait Until Page Contains                                         آگهی شما تمدید و ۱ ماه دیگر روی شیپور باقی می‌ماند.                      timeout=10s
    Execute Javascript                                               window.scrollTo(900, 900);
    Wait Until Page Contains Element                                 css:button.payment.pull-right
    Click By Css Selector                                            button.payment.pull-right
    Wait Until Page Contains                                         پرداخت شما با موفقیت انجام شد.                                          timeout=10s
    Click Link                                                       بازگشت به برنامه
    Wait Until Page Contains                                         مدیریت آگهی‌ها                                                           timeout=10s
    Validate Advertise is Verified

Activate Expired Listing Without Edit
    Click By Name                                                    ${ACTIVATION}
    Wait Until Page Contains                                         ویرایش آگهی                          timeout=10s
    Click By Name                                                    ${SUBMIT_FILE}
    Wait Until Page Contains                                         آگهی شما تمدید و ۱ ماه دیگر روی شیپور باقی می‌ماند.                      timeout=10s
    Execute Javascript                                               window.scrollTo(900, 900);
    Wait Until Page Contains Element                                 css:button.payment.pull-right
    Click By Css Selector                                            button.payment.pull-right
    Wait Until Page Contains                                         پرداخت شما با موفقیت انجام شد.                                          timeout=10s
    Click Link                                                       بازگشت به برنامه
    Click To Show Page                                               real-estate          listings        ${LISTINGS_LIST}
    Wait Until Page Contains                                         پذیرفته شد
