*** Settings ***
Documentation                                      Shop Management
Resource                                           ../../resources/package.resource
Test Setup                                         Run Keywords    Open test browser
Test Teardown                                      Clean Up Tests

*** Variables ***




*** Test cases ***
Shop Listings Filter And Validation
    [Tags]                                          notest
    Create Shop In Sheypoor
    Login To ProTools                               ${Shop_owner_phone}
    Create Shop Listings
    Shop Listings Page Validation


*** Keywords ***
Create Shop Listings
    Create Some Listings                            1
    Enable Shop Package
    Go to                                           ${SERVER}/pro/real-estate/listings
    Post Listing As a Diffrent Shop Member          0    1    ${Consultant_Phones}
    ${human_readable_id}                            Post Listing As a Diffrent Shop Member          1    1    ${Consultant_Phones}
    Set Test Variable                               ${Consultant_hri}           ${human_readable_id}
    Post Listing As a Diffrent Shop Member          0    1    ${Secretary_Phones}

Shop Listings Page Validation
    Click By Name                                   list-item-moderator-listing-management
    Reload Page To Find Element                     listing-item-0
    FOR    ${INDEX}    IN RANGE    0    3
      Execute Javascript                              document.getElementsByName('colleagues-list')[0].parentElement.children[0].click()
      Sleep    2s
      Wait Until Page Contains Element                name:member_${Consultant_Phones[1]}             timeout=10s
      Click By Name                                   member_${Consultant_Phones[1]}
      Wait Until Page Contains Element                listing-item-0                    timeout=10s
      ${url}                                          Get Element Attribute             name:listing-item-0     href
      ${hri}                                          Get Regexp Matches     ${url}     [\\/](\\d{8,10})     1
      ${status}                                       Run Keyword And Return Status     Should Be Equal             ${Consultant_hri}                 ${hri}[0]
      Exit For Loop If                                ${status}
    END
