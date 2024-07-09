*** Settings ***
Documentation                        Hamrah Mechanic listings
Resource                             ../versions/v${api_version}/keywords.resource
Suite Setup                          Set Suite Environment
Test Setup                           Set Test Environment
Test Teardown                        Clean Up Test

*** Test Cases ***
Post A Mapped Hamrah Mechanic Listing
    [Tags]                  all   paid-features           hamrah-mechanic         notest
    Fail                    These have to be rewritten with new library
    Post a Mapped Car Listing Tehran
    Hamrah Mechanic Should Be Visible

Post A Not Mapped Hamrah Mechanic Listing
    [Tags]                  all   paid-features           hamrah-mechanic         notest
    Fail                    These have to be rewritten with new library
    Post a Normal Car Listing
    Hamrah Mechanic Should Not Be Visible

Post A Mapped Hamrah Mechanic Listing Outsode Tehran
    [Tags]                  all   paid-features           hamrah-mechanic         notest
    Fail                    These have to be rewritten with new library
    Post a Mapped Car Listing Outside Tehran
    Hamrah Mechanic Should Not Be Visible
