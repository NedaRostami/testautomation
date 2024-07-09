*** Settings ***
resource                                               ../../resources/static.resource
Suite Setup                                            Create Initial Data
Test Setup                                             Set Test Environment
Test Template                                          Validate Seo Rules of ${data}
Force Tags                                             Seo
Test Teardown                                          TearDown Tasks

*** Variables ***
${Type}                                                location

*** Test Cases ***
Validate Seo Description And Title For Locations
    [Tags]                                             location
    FOR        ${data}     IN      @{random_data}
      ${data}
    END

*** Keywords ***
Validate Seo Rules of ${data}
    Set Test Variable                                   ${data}
