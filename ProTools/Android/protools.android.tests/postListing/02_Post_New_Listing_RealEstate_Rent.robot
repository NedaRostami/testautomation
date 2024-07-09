*** Settings ***
#                ثبت آگهی رهن تجاری و مغازه
Documentation     Create Real Estate File
Resource        ..${/}..${/}resources${/}common.resource
Test Setup       Run Keywords                  Open App   Login App
Test Teardown    Close test application
Test Timeout     10 minutes


*** Variables ***


*** Test Cases ***
Create Real Estate Listing In Residences Rent
    [Tags]                               Post_a_Listing       Rent
    Click By Description                 hamburger
    Click By Text                        ثبت آگهی و فایل
    Image Picker                         1
    Category Select                      categorizing      اجاره اداری و تجاری       نوع ملک    تجاری و مغازه
    Location Select                      مکان     استان البرز    کرج    باغستان
    Common.Commercial Rent Attributes
    Click By Scroll                      افزودن جزئیات بیشتر
    Common.Commercial Rent More Details Attributes
    Click By Description                 register-button
    Wait Until Page Contains             فایل شما با موفقیت ثبت شد
    Click By Text                        آگهی کردن این فایل
    Input Description                    description
    Click By Description                 register-advertisement
    Wait Until Page Contains             آگهی شما با موفقیت ثبت شد



*** Keywords ***
