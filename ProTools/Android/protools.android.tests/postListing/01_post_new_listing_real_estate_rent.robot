*** Settings ***
#                ثبت آگهی رهن و اجاره آپارتمان
Documentation     Create Real Estate File
Resource        ../../resources/common.resource
Test Setup       Run Keywords                  Open App
Test Teardown    Close test application
Test Timeout     10 minutes


*** Variables ***


*** Test Cases ***
Create Real Estate Listing In Residences Rent
    [Tags]                                 Post_a_Listing       Rent
    # Create Shop In Sheypoor
    # Login App                              ${Shop_owner_phone}
    Login App Temperory HardCode
    Click By Description                   hamburger
    Click By Text                          ثبت آگهی و فایل
    # Insert Photos                          1
    Category Select                        categorizing      اجاره خانه و آپارتمان
    Property Type Select                   خانه
    Location Select                        مکان     تهران       تهران           آرژانتین
    Real Estate Rent Attributes
    # More Details Attributes
    # Click By Text                          ذخیره
    # Owner Info Attributes
    Click By Text                          ذخیره
    Wait Until Page Contains               فایل شما با موفقیت ثبت شد
    Click By Text                         آگهی کردن این فایل
    Input Description                     description
    Click By Description                  register-advertisement
    Wait Until Page Contains              آگهی شما با موفقیت ثبت شد

*** Keywords ***
Login App Temperory HardCode
    Set Environment Server
    Click By Description        entering
    Wait Until Page Contains    لطفا شماره همراه خود را وارد نمایید           timeout=10s
    Input Random Mobile         09006000000
    Input Text     accessibility_id=codeField_1   1
    Sleep    500ms
    Input Text     accessibility_id=codeField_2   2
    Sleep    500ms
    Input Text     accessibility_id=codeField_3   3
    Sleep    500ms
    Input Text     accessibility_id=codeField_4   4
    Sleep    500ms
    Wait Until Page Contains    شما تاکنون آگهی ثبت نکرده‌اید                  timeout=10s
