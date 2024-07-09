*** Settings ***
Resource                            ../versions/v${api_version}/keywords.resource
Suite Setup                             Set Suite Environment
Test Setup                              Set Test Environment
Test Teardown                           Clean Up Test

*** Test Cases ***
Categories Endpoint
    [Tags]                          all    general                         static-data
    [Setup]                         Expect Response                 ${Categories_Schema}
    Request Categories Endpoint
