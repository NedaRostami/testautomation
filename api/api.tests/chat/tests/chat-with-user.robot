*** Settings ***
Resource                            ../versions/v${api_version}/keywords.resource
Suite Setup                         Set Suite Environment
Test Setup                          Set Test Environment
Test Teardown                       Clean Up Test

*** Test Cases ***
Check Chat Endpoints As Two Users
    [Tags]                          all            chat
    Login As User One
    Login As User Two
    Post a Listing As User One
    Get Chat ID
    Get Listing Chat Info
    Get Chat Suggestions
    Get Chat Report Reasons
