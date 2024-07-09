*** Settings ***
Resource                                ../versions/v${api_version}/keywords.resource
Suite Setup                             Set Suite Environment
Test Setup                              Set Test Environment
Test Teardown                           Clean Up Test

*** Test Cases ***
Feedback Categories Endpoint
    [Tags]                              all    static-data                     general
    [Setup]                             Expect Response                 ${Feedback_Categories_Schema}
    Request Feedback Categories Endpoint
