*** Settings ***
Documentation                       Report a listing
Resource                            ../versions/v${api_version}/keywords.resource
Suite Setup                         Set Suite Environment
Test Setup                          Set Test Environment
Test Teardown                       Clean Up Test
Test Template                       Report Listing As ${phone_number} With ${email} About ${issue_ids} With ${comment} Using ${schema_path}

*** Test Cases ***
Report Listing All Parameters Valid Phone Number No Email
    [Tags]                          api         listings
    09213176895                     \                   ${All_Complaint_Types}          Testing Report Listing          ${Successful_Listing_Report}

Report Listing Some Parameters Valid Phone Number No Email
    [Tags]                          api         listings
    09213176895                     \                   ${Some_Complaint_Types}         Testing Report Listing          ${Successful_Listing_Report}

Report Listing One Parameter Valid Phone Number No Email
    [Tags]                          api         listings
    09213176895                     \                   ${One_Complaint_Type}           Testing Report Listing          ${Successful_Listing_Report}

Report Listing Some Parameters Valid Phone Number Valid Email
    [Tags]                          api         listings
    09213176895                     qa@mielse.com       ${All_Complaint_Types}          Testing Report Listing          ${Successful_Listing_Report}

Report Listing Some Parameters Valid Phone Number Invalid Email
    [Tags]                          api         listings
    09213176895                     www.tabbat.com      ${All_Complaint_Types}          Testing Report Listing          ${Failed_Listing_Report}

Report Listing Some Parameters Invalid Phone Number Valid Email
    [Tags]                          api         listings
    091234785                       www.tabbat.com      ${All_Complaint_Types}          Testing Report Listing          ${Failed_Listing_Report}
