*** Settings ***
Documentation                           Add New Car Sale File
...                                     In Real Estate Category
Resource                                ../../resources/setup.resource
Test Setup                              Run Keywords    Open test browser
Test Teardown                           Clean Up Tests



*** Variables ***


*** Test cases ***
Add New Car Sale File In Category
    [Tags]                              File   New   Sale   notest
    Create Shop In Sheypoor             43627
    Login To ProTools                   ${Shop_owner_phone}                  sheypoor-cars
    Create New File                     Input Car Main Attribute For Sale    1    43627      cars    Input Car More Detail Attributes   District=n888
    Validate File Is Registered         cars

*** Keywords ***
