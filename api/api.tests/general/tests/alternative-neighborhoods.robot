*** Settings ***
Resource                                ../versions/v${api_version}/keywords.resource
Suite Setup                             Set Suite Environment
Test Setup                              Set Test Environment
Test Teardown                           Clean Up Test

*** Test Cases ***
Alternative Neighborhoods Endpoint
    [Tags]                              general   all
    [Setup]                             Expect Response                                         ${Alternative_Neighborhoods_Schema}
    Request Alternative Neighborhoods Endpoint
