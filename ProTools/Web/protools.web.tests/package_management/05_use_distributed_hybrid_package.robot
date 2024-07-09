*** Settings ***
Documentation                           Use Distributed Hybrid Package
...                                     And Validate The Rest Of The Package
Resource                                ../../resources/package.resource
Resource                                ../../resources/bump.resource
Test Setup                              Run Keywords    Open test browser
Test Teardown                           Clean Up Tests


*** Variables ***



*** Test Cases ***
Use Distributed Hybrid Package
    [Tags]                              Distribution            Hybrid          Kick            notest
    Create Shop In Sheypoor
    Login To ProTools                                           ${Shop_owner_phone}
    Enable Shop Package
    Go to                                                       ${SERVER}/pro/real-estate/packages
    Buy Hybrid Packages                                         special-package                         special-package-price
    Validate Shop Package From Protools                         40    20    10    3
    Assign Package To Shop Member                               1     1     1     ${EMPTY}
    Validate Shop Package From Protools                         39    19    9     3
    Log Out Protools
    Login To ProTools                                           ${Consultant_Phones[0]}
    Validate Shop Package From Protools                         1     1     1     0
    Buy Hybrid Packages                                         simple-package-refresh                 simple-package-refresh-price
    Validate Shop Package From Protools                         26    1     1     0
    Create Some Listings                                        2
    Bump Some Listings                                          refresh-title
    Log Out Protools
    Login To ProTools                                           ${Shop_owner_phone}
    Validate Shop Package From Protools                         39    19    9     3
    Delete Assigned Packge
    Validate Shop Package From Protools                         39    20    10    3

*** Keywords ***
Bump Some Listings
    [Arguments]                                                 ${Bump_Type}
    Set Test Payment Gateway                                    success
    Wait Until Page Contains Element                            name:${BUMP}
    ${Elements}                                                 SeleniumLibrary.Get Element Count     name:${BUMP}
    FOR       ${item}    IN RANGE    0    ${Elements}
      Click By Name                       ${BUMP}
      Wait Until Page Contains            بسته مورد نظر را انتخاب کنید            timeout=10s
      Sleep                               2s
      Click Element                       name:${Bump_Type}
      Click By Name                       ${APPLY_BUMP}
      Wait Until Page Contains            بسته با موفقیت اعمال شد.                timeout=10s
      Wait Until Page Does Not Contain    بسته با موفقیت اعمال شد.                timeout=10s
    END
