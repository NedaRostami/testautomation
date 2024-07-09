*** Settings ***
Documentation                        Listing details from serp
Resource                             ../versions/v${api_version}/keywords.resource
Suite Setup                          Set Suite Environment
Test Setup                           Set Test Environment
Test Teardown                        Clean Up Test
Test Template                        Post a ${Category} Listing Category

*** Test Cases ***
Post A Listing In Industrial Category
    [Tags]                          all   post-a-listing
    صنعتی، اداری و تجاری
