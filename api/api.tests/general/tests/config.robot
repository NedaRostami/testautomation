*** Settings ***
Resource                                ../versions/v${api_version}/keywords.resource
Suite Setup                             Set Suite Environment
Test Setup                              Set Test Environment
Test Teardown                           Clean Up Test

*** Test Cases ***
Config Endpoint
    [Tags]                              all     general                 static-data
    [Setup]                             Expect Response                 ${Config_Schema}
    Request Config Endpoint
