*** Settings ***
Resource                                ../versions/v${api_version}/keywords.resource
Suite Setup                             Set Suite Environment
Test Setup                              Set Test Environment
Test Teardown                           Clean Up Test

*** Test Cases ***
Static Data Endpoint
    [Tags]                              all  static-data                     general
    [Setup]                             Expect Response                 ${Static_Data_Schema}
    Request Static Data Endpoint
