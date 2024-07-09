*** Settings ***
resource                                               ../../resources/seo.resource
Suite Setup                                            Create Initial Data
Test Setup                                             Set Test Environment
Force Tags                                             Seo
Test Teardown                                          TearDown Tasks

*** Variables ***
${Type}                                                add_new

*** Test Cases ***
Validate Seo Description And Title For Post Listing
    [Tags]                                             post_listing
    Log Variables
    Get The Title Description And Header From Page
    Set The Seo Rules Values
    Validate Title Seo Rules
    Validate Description Seo Rules
    Validate Header Seo Rules

*** Keywords ***
Create Initial Data
    ${URL}                                              Create Suitable URL           listing      new
    ${data}                                             Create List                   All          All      ${URL}
    Set Suite Variable                                  ${data}

Set The Seo Rules Values
    ${title_exp}     ${desc_exp}                        ${h1_exp}                     Set Expected Variables    Type=${Type}
    Set Test Variable                                   ${title_exp}
    Set Test Variable                                   ${desc_exp}
    Set Test Variable                                   ${h1_exp}
    Set Test Variable                                   ${Type}
