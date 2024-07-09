*** Settings ***
Documentation                                        Edit Shop From Protools
Resource                                             ../../resources/setup.resource
Test Setup                                           Run Keywords    Open test browser
Test Teardown                                        Clean Up Tests


*** Variables ***




*** Test Cases ***
Edit Shop From Sheypoor
    [Tags]                                           Shop                     Edit
    Create Shop In Sheypoor
    Login To ProTools                                ${Shop_owner_phone}
    Click By Name                                    ${PROTOOLS_SHOP}
    Edit Shop images                                 edit-logo-image          0
    Edit Shop images                                 edit-header-image        1
    Validate Shop Attributes
    Edit About Shop
    Edit Shop Contact
    Edit Shop Slogan

*** Keywords ***
Validate Shop Attributes
    Wait Until Page Contains                         درباره فروشگاه
    Page Should Contain                              ${Shop_title}
    Page Should Contain                              ${Shop_tag_line}
    Page Should Contain                              ${Shop_working_time}
    Page Should Contain                              ${Shop_Email}
    Page Should Contain                              ${Shop_Website}
    Page Should Contain                              ${Shop_Address}
    Page Should Contain                              ${Shop_Description}
    Page Should Contain                              مشاهده در شیپور

Edit About Shop
    Validate Click By Name is Done                   edit-about               ویرایش توضیحات فروشگاه
    Clear Textfield                                  about
    Input By Name                                    about                    با کادری مجرب و متعهد آماده خدمت رسانی به مشتریان عزیز
    Click By Name                                    save-action
    Wait Until Page Does Not Contain Element         name:cancel-action       timeout=10s

Edit Shop Contact
    Validate Click By Name is Done                   edit-contact             ویرایش اطلاعات تماس فروشگاه
    Clear Textfield                                  working_time
    Input By Name                                    working_time             9 صبح تا 12 شب
    Clear Textfield                                  telephones.0
    Input By Name                                    telephones.0             88608860
    Clear Textfield                                  email
    Input By Name                                    email                    test@gmail.com
    Clear Textfield                                  website
    Input By Name                                    website                  www.test.com
    Clear Textfield                                  address
    Input By Name                                    address                  بلوار افریقا - بعد از خروجی همت - نبش کوچه زاگرس
    Click By Name                                    save-action
    Wait Until Page Does Not Contain Element         name:cancel-action       timeout=10s

Edit Shop Slogan
    Validate Click By Name is Done                   edit-slogan              ویرایش شعار فروشگاه
    Clear Textfield                                  slogan
    Input By Name                                    slogan                   صداقت در معاملات
    Click By Name                                    save-action
    Wait Until Page Does Not Contain Element         name:cancel-action       timeout=10s

Edit Shop images
    [Arguments]                                      ${Image_Type}            ${Image_Index}
    ${Images}                                        Select Images            house                    2
    ${Images}                                        Convert To List          ${Images}
    Click Element                                    name:${Image_Type}
    Wait Until Page Contains                         افزودن تصویر جدید       timeout=10s
    Choose File                                      name:pick-image          ${Images[${Image_Index}].file_path}
    Click By Name                                    accept-crop
    Wait Until Page Does Not Contain                 ویرایش عکس
    Wait Until Page Contains                         عکس شما با موفقیت ثبت شد، پس از بررسی توسط ادمین نمایش داده می‌شود                timeout=10s
    Wait Until Page Does Not Contain                 عکس شما با موفقیت ثبت شد، پس از بررسی توسط ادمین نمایش داده می‌شود                timeout=10s
