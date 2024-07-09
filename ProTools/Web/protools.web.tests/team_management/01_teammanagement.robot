*** Settings ***
Documentation                           Team Management
Resource                                ../../resources/setup.resource
Test Setup                              Run Keywords    Open test browser
Test Teardown                           Clean Up Tests


*** Variables ***
${role_drop_down}                       document.getElementsByName('role')[0].parentElement.children[0].click()



*** Test cases ***
Team Management
    [Tags]                              Team                                    Management
    Create Shop In Sheypoor
    Login To ProTools                   ${Shop_owner_phone}
    Add New Colleague                   expert                                  secretary
    Delete Colleagues
    Add New Colleague                   secretary                               expert
    Delete Colleagues

*** Keywords ***
