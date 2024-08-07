*** Settings ***
#                ثبت فایل رهن و اجاره خانه
Documentation     Edit Real Estate File
Resource        ..${/}..${/}resources${/}common.resource
Test Setup       Run Keywords                  Open App   Login App
Test Teardown    Close test application
Test Timeout     10 minutes


*** Variables ***


*** Test Cases ***
Create Real Estate Listing In Residences Rent
    [Tags]                                 Edit_a_Listing       Rent
    Create Shop In Sheypoor
    Login App                              ${Shop_owner_phone}
    Click By Description                   hamburger
    Click By Text                          ثبت آگهی و فایل
    Insert Photos                          4
    Category Select                        categorizing      اجاره خانه و آپارتمان
    Property Type Select                   ویلا
    Location Select                        مکان     تهران       تهران           آرژانتین
    Real Estate Rent Attributes
    More Details Attributes
    Click By Text                          ذخیره
    Owner Info Attributes
    Click By Text                          ذخیره
    Wait Until Page Contains               فایل شما با موفقیت ثبت شد


*** Keywords ***
Edit File Images
    Click By Text
