*** Settings ***
Resource                               ../versions/v${api_version}/keywords.resource
Suite Setup                             Set Suite Environment
Test Setup                              Set Test Environment
Test Teardown                           Clean Up Test

*** Test Cases ***
App Version Endpoint
    [Tags]                              all   general     static-data
    # TODO:  add app version data in moderation before test
    Run Keyword If                      '${api_version}' > '3.1.7'          Pass Execution     not tested    notest
    [Setup]                             Expect Response                 ${App_Version}
    Request App Version Endpoint

# TODO: Add different headers for different platforms
