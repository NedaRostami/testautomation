*** Settings ***
Documentation                        Paid feature bump listings
Resource                             ../versions/v${api_version}/keywords.resource
Suite Setup                          Set Suite Environment
Test Setup                           Set Test Environment
Test Teardown                        Clean Up Test

*** Test Cases ***
Paid Feature Bump Should Be Visible In Tehran
    [Tags]                  all  paid-features           paid-feature-bump           notest
    Fail                    These have to be rewritten with new library
    Post A Bump Listing Tehran


Paid Feautre Bump Should Be Visible Outside Tehran
    [Tags]                  all   paid-features           paid-feature-bump           notest
    Fail                    These have to be rewritten with new library
    Post A Bump Listing Outside Tehran
