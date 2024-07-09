*** Settings ***
Documentation                                         User Phone Book Actions
Resource                                              ../../resources/setup.resource
Test Setup                                            Run Keywords    Open test browser
Test Teardown                                         Clean Up Tests


*** Variables ***


*** Test cases ***
Protools Phone Book Actions
    [Tags]                                            Phone_Book       Add        Edit       Delete
    Create Shop In Sheypoor
    Login To ProTools                                 ${Shop_owner_phone}
    Add New Member To Phone Book                      2
    Edit Phon Book Member                             0
    Delete Phone Book Member                          1

*** Keywords ***
Add New Member To Phone Book
    [Arguments]                                       ${Number}
    @{Members_Name}                                   Create List
    Click To Show Page                                real-estate          phone-book            list-item-phone-book
    Wait Until Page Contains                          در اینجا شماره تلفن‌ مشتریان و همکاران خود را ذخیره کنید.    timeout=10s
    FOR    ${INDEX}    IN RANGE    0                  ${Number}
      Click By Name                                   add-new-contact
      ${Faker_Name}                                   Create Phone Book Member
      Append To List                                  ${Members_Name}           ${Faker_Name}
      Input By Name                                   name                      ${Faker_Name}
      Input By Name                                   telephone                 ${Faker_Phone_Number}
      Choose Multi Select Attributes                  userType-trigger                            5      10      15
      Click By Name                                   apply-action
      Wait Until Page Contains                        مخاطب با موفقیت ذخیره شد                    timeout=10s
      Wait Until Page Does Not Contain                مخاطب با موفقیت ذخیره شد                    timeout=10s
    END
    Set Test Variable                                 ${Members_Name}

Edit Phon Book Member
    [Arguments]                                       ${Number_Of_Member}
    Click By Text                                     ${Members_Name}[${Number_Of_Member}]
    Click By Name                                     edit-contact
    Clear Textfield                                   name
    Input By Name                                     name                      شیپور
    Clear Textfield                                   telephone
    Input By Name                                     telephone                 ۰۲۱۵۴۵۸۷
    Choose Multi Select Attributes                    userType-trigger          5      10
    Click By Name                                     apply-action
    Wait Until Page Contains                          مخاطب با موفقیت ویرایش شد                   timeout=10s
    Wait Until Page Does Not Contain                  مخاطب با موفقیت ویرایش شد                   timeout=10s
    Wait Until Page Does Not Contain                  ${Members_Name}[${Number_Of_Member}]

Delete Phone Book Member
    [Arguments]                                       ${Number_Of_Member}
    Click By Text                                     ${Members_Name}[${Number_Of_Member}]
    Click By Name                                     delete-contact
    Wait Until Page Contains                          آیا از حذف مخاطب اطمینان دارید؟
    Click By Name                                     ${CONFIRM_ACCEPT}
    Wait Until Page Contains                          مخاطب با موفقیت حذف شد                      timeout=10s
    Wait Until Page Does Not Contain                  مخاطب با موفقیت حذف شد                      timeout=10s
    Wait Until Page Does Not Contain                  ${Members_Name}[${Number_Of_Member}]
