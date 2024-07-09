*** Settings ***
Resource                                ../versions/v${api_version}/keywords.resource
Suite Setup                             Set Suite Environment
Test Setup                              Set Test Environment
Test Teardown                           Clean Up Test

*** Test Cases ***
Login
    [Tags]                              all            login
    State Request Valid
    State Request Invalid Phone Number
    Number Verification Valid
    Number Verification Invalid Token
    Invalid Number Verification Invalid Verification Code
