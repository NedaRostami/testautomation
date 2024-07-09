*** Settings ***
Documentation                        Sort Newest
Test Setup                           Open test browser
Test Teardown                        Clean Up Tests
Resource                             ../../resources/serp.resource

*** Test Cases ***
Sort Newest Listings
    [Tags]                           sort    serp
    Go To Serp Page
    Change Serp sort                 n
    Append Items to List
    Time Comparison                  <

*** Keywords ***
Append Items to List
    ${DateList}                      Create List
    Set Test Variable                ${Date_List}             ${DateList}
    ${Date_Elements}                 Get WebElements          ${Serp_ALL_L_Date}
    Check Num Of Listings In Serp    ${Date_Elements}
    FOR     ${i}   IN                @{Date_Elements}
       ${Date}                       SeleniumLibrary.Get Element Attribute    ${i}    datetime
       Append To List                ${Date_List}             ${Date}
    END

Time Comparison
    [Arguments]                      ${Operator}
    ${Counter}                       Get Length               ${Date_List}
    FOR    ${i}                      IN RANGE                 ${Counter-1}
      Should Not Be True             '${Date_List}[${i}]' ${Operator} '${Date_List}[${i+1}]'
    END
