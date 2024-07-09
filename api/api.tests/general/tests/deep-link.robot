*** Settings ***
Resource                                ../versions/v${api_version}/keywords.resource
Suite Setup                             Set Suite Environment
Test Setup                              Set Test Environment
Test Teardown                           Clean Up Test

*** Test Cases ***
Deep Link Endpoint
    [Tags]                              all     general
    [Setup]                             Expect Response                         ${Deep_Link_Schema}
    Request Deep Link Endpoint
