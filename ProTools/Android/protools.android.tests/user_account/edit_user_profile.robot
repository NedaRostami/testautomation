*** Settings ***
#                 اجاره آپارتمان
Documentation     Edit User Account
...               In Flats Rent
Resource        ..${/}..${/}resources${/}common.resource
Test Setup       Run Keywords                  Open App   Login App
Test Teardown    Close test application
Test Timeout     10 minutes


*** Variables ***


*** Test Cases ***
Create Real Estate Listing In Flats Rent
    [Tags]                      Edit    User_Account
    Click By Description        hamburger
    Click By Text               محمد پارسا
    Click By Text               ویرایش حساب کاربری
    Click By Text               
    Input By Text               نام    فاطمه قربانی
    Click By Text               
    Click By Text               ثبت تغییرات
    Wait Until Page Contains    خروج




*** Keywords ***
