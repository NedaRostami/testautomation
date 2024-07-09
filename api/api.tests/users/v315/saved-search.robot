*** Settings ***
Resource                            resources/user-resource.resource
Suite Setup                         Set Test Environment
Test Setup                          Set Bump Environment
Test Teardown                       Clean Up Test

*** Test Cases ***
Add A New Saved Search Validate and Delete
    [Tags]                                  all   notest
    Login To Service
    Create Saved Search                     searchTerm=پراید آبی&count=20&categoryID=43627
    Post Saved Search                       ${Saved_Search}
    Sleep                                   1
    Get User Saved Searches
    Posted Saved Search Should Be In List   پراید آبی                           ${Fetched_Saved_Searches}
    Get Saved Search Id                     پراید آبی                           ${Fetched_Saved_Searches}
    Delete Saved Search                     ${Saved_Search_Id}
    Sleep                                   1
    Get User Saved Searches
    Saved Search Should Be Deleted          ${Posted_Saved_Search}              ${Fetched_Saved_Searches}

*** Keywords ***
