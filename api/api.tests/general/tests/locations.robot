*** Settings ***
Resource                                ../versions/v${api_version}/keywords.resource
Suite Setup                             Set Suite Environment
Test Setup                              Set Test Environment
Test Teardown                           Clean Up Test

*** Test Cases ***
Locations Endpoint
    [Tags]                              all   static-data                     general
    [Setup]                             Expect Response                 ${Locations_Schema}
    Request Locations Endpoint
