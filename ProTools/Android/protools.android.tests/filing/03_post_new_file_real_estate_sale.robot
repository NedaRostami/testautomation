*** Settings ***
#                ثبت فایل فروش آپارتمان
Documentation     Create Real Estate File
Resource        ..${/}..${/}resources${/}common.resource
Test Setup       Run Keywords                  Open App   Login App
Test Teardown    Close test application
Test Timeout     10 minutes


*** variables ***


*** Test cases ***
Create Real Estate Listing In Residences Rent
    [Tags]                               Post_a_Listing       Sale
    Create Shop In Sheypoor
    Login App                              ${Shop_owner_phone}
    Click By Description                   hamburger
    Click By Text                          ثبت آگهی و فایل
    Insert Photos                          2
    Category Select                        categorizing      فروش خانه و آپارتمان
    Property Type Select                   آپارتمان
    Location Select                        مکان     تهران       تهران           آرژانتین
    Real Estate Rent Attributes
    More Details Attributes
    Click By Text                          ذخیره
    Owner Info Attributes
    Click By Text                          ذخیره
    Wait Until Page Contains               فایل شما با موفقیت ثبت شد

*** Keywords ***
