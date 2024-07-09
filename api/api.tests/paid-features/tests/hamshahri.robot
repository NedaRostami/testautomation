*** Settings ***
Documentation                        Hamshahri listings
Resource                             ../versions/v${api_version}/keywords.resource
Suite Setup                          Set Suite Environment
Test Setup                           Set Test Environment
Test Teardown                        Clean Up Test

*** Test Cases ***
Post a Job Listing In Tehran And View Hamshahri
    [Tags]                  all   paid-features           hamshahri           notest
    Fail                    These have to be rewritten with new library
    Post A Job Listing Tehran
    Hamshahri Should Be Visible

Post a Job Listing In Outside Tehran And View Hamshahri
    [Tags]                  all   paid-features           hamshahri           notest
    Fail                    These have to be rewritten with new library
    Post A Job Listing Outside Tehran
    Hamshahri Should Not Be Visible
