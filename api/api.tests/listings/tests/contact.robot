*** Settings ***
Documentation                       Contact a listing owner using different methods
Resource                            ../versions/v${api_version}/keywords.resource
Suite Setup                         Set Suite Environment
Test Setup                          Set Test Environment
Test Teardown                       Clean Up Test
Test Template                       Get Listing Owner Contact Info Using ${Contact_Method}

*** Test Cases ***
Contact Listing Using Different Methods
    [Tags]                          all   listings
    [Setup]                         Expect Response                     ${Contact_Listing_Schema}
    call
    chat
    sms
    email
