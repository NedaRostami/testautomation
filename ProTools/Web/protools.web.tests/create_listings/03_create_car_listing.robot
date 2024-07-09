*** Settings ***
Documentation                           Add New Car Sale Listing
...                                     In Real Estate Category
Resource                                ../../resources/setup.resource
Test Setup                              Run Keywords    Open test browser
Test Teardown                           Clean Up Tests

*** Variables ***



*** Test cases ***
Add New Car Sale Listing In Category
    [Tags]                              Listing   New   Sale   notest
    Create Shop In Sheypoor             43627
    Login To ProTools                   ${Shop_owner_phone}               sheypoor-cars
    Create New Listing                  Input Car Main Attribute For Sale    1    43627      cars    Input Car More Detail Attributes   District=n4728
    Validate Advertise is Verified      cars
*** Keywords ***
