*** Settings ***
Documentation                                 Using amp technology
...                                           in serp and details pages
Test Setup                                    Open test browser
Test Teardown                                 Clean Up Tests
Resource                                      ../../resources/setup.resource

*** Variables ***

***Test Case***
AMP in serp and details pages
    [Tags]                                    amp      units     listingdetails
    Click Link                                ${AllAdvs}
    Wait Until Page Contains                  ${IranAllH1}                      timeout=10s
    ${Random}                                 Generate Random String            9               [LOWER]
    Go To                                     ${SERVER}/amp/ایران?${Random}
    Wait Until Page Contains                  ${IranAllH1}                      timeout=10s
    Page Should Not Contain                   ${lost_message}
    Click Element                             ${Units_First_Listing}
    Wait Until Page Contains Element          ${LD_Choose_Favorite}             timeout=5s
    ${AdTitle} =  Get Text                    ${LD_Item_Detail_Header}
    ${URL} =  Get Location
    ${amp} =  Replace String                  ${URL}                            ${SERVER}       ${SERVER}/amp
    Go To    ${amp}
    Page Should Not Contain                   ${lost_message}
    SeleniumLibrary.Element Text Should Be    ${LD_Item_Detail_Header}          ${AdTitle}
