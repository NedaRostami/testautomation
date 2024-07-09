*** Settings ***
Documentation                        Test serp navigation
Test Setup                           Open test browser
Test Teardown                        Clean Up Tests
Resource                             ../../resources/setup.resource

*** Variables ***


*** Test Cases ***
Listing Deatail Performance
  [Tags]                              nav   serp
  Click Link                          ${AllAdvs}
  Wait Until Page Contains            ${IranAllH1}                        timeout=10s
  ${Title}                            get text                            ${Serp_All_L_Title}
  @{list_titles}  	                  Create List	                        ${Title}
  Set Test Variable                   @{list_titles}                      @{list_titles}
  click element                       ${Serp_All_L_Title}
  Wait Until Page Contains Element    ${LD_Item_Detail_Header}            timeout=15s
  Check Next listing

*** Keywords ***
Check Next listing
  FOR    ${INDEX}    IN RANGE    1    25
    Click Link                        ${LD_Next_Listing}
    Wait Until Page Is Loaded
    ${Title}                          Get Text                            ${LD_Item_Detail_Header}
    Append To List                    ${list_titles}   ${Title}
    ${status}                         Run Keyword And Return Status       Should Not Be Equal  @{list_titles}${INDEX-1}  @{list_titles}${INDEX}
    Run Keyword Unless                ${status}              Fail         Next listing can not be loaded
  END
