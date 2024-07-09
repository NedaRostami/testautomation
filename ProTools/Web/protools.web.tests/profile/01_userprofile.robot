*** Settings ***
Documentation                           Check And Edit User Profile
Resource                                ../../resources/setup.resource
Test Setup                              Run Keywords    Open test browser
Test Teardown                           Clean Up Tests


*** Variables ***


*** Test cases ***
Add New Listing In Real Estate Category
    [Tags]                              Profile               Edit           UserProfile    notest
    Create Shop In Sheypoor
    Login To ProTools                               ${Shop_owner_phone}
    Validate Profile Phone Before Edit
    Edit Profile Name

*** Keywords ***
Validate Profile Phone Before Edit
    Convert Shop Manager Phone Number To Persian
    Wait Until Page Contains Element    name:profile-name
    ${Profile_Phone}                     Get Text                             name:profile-name
    ${Profile_Phone}                     Fetch From Left                      ${Profile_Phone}        \n
    ${Profile_Phone}                     Normalize Phone Number               ${Profile_Phone}
    # ${Profile_Phone}                     Remove String                        ${Profile_Phone}        امتیاز
    Should Be Equal                     ${Profile_Phone}                      ${Shop_owner_phone}

Edit Profile Name
    Click By Name                       profile
    Run Keyword And Ignore Error        Close Secure Popup
    Wait Until Page Contains Element    name:edit_profile
    Click By Name                       edit_profile
    Wait Until Page Contains Element    name:name                            timeout=10s
    Input By Name                       name                                 کاربر تست
    Textfield Value Should Be           name:phonenum                       ${Shop_owner_phone}
    Click By Name                       ${SUBMIT_FILE}

Convert Shop Manager Phone Number To Persian
    ${Shop_owner_phone}                 Convert Digits                       ${Shop_owner_phone}                En2Fa
    Set Test Variable                   ${Shop_owner_phone}                  ${Shop_owner_phone}
