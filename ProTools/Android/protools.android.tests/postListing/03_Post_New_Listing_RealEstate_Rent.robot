*** Settings ***
#               ثبت آگهی فروش آپارتمان
Documentation     Create Real Estate File
Resource        ..${/}..${/}resources${/}common.resource
Test Setup       Run Keywords                  Open App   Login App
Test Teardown    Close test application
Test Timeout     10 minutes


*** Variables ***


*** Test Cases ***
Create Real Estate Listing In Residences Rent
    [Tags]                               Post_a_Listing       Sale
    Click By Description                 hamburger
    Click By Text                        ثبت آگهی و فایل
    Image Picker                         2
    Category Select                      categorizing      خرید خانه و آپارتمان     نوع ملک    آپارتمان
    Location Select                      مکان     استان تهران    تهران    آرژانتین
    Real Estate Sale Attributes
    Click By Scroll                      افزودن جزئیات بیشتر
    Sale More Details Attributes
    Click By Description                 register-button
    Wait Until Page Contains             فایل شما با موفقیت ثبت شد
    Click By Text                        آگهی کردن این فایل
    Input Description                    description
    Click By Description                 register-advertisement
    Wait Until Page Contains             آگهی شما با موفقیت ثبت شد


*** Keywords ***
