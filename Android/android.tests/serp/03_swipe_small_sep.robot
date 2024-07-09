*** Settings ***
Resource                   ..${/}..${/}resources${/}common.resource
Suite Setup                Set Suite Environment
Test Setup                 start app
Test Teardown              Close test application
Test Timeout               10 minutes

*** Variables ***
${Category}               خدمات و کسب و کار
${SubCategory}            همه دسته‌های خدمات و کسب و کار

*** Test Cases ***
Swipe Up Down In Short Filtered Serp
  [Tags]                   serp   crash    filtered  notfound
  Check Home Page List Is Loaded
  Little Filtering
  FOR    ${INDEX}    IN RANGE    1    3
     Swipe Up         ${10}
     Swipe Down       ${10}
  END


*** Keywords ***
Little Filtering
    [Tags]                               Android Filtering
    Filter Category                      ${Category}                      ${SubCategory}
    Wait Until Page Contains Element     ${CATEGORY_HEADER}               timeout=5s
    Element Should Contain Text          ${CATEGORY_HEADER}               ${Category}
    Click Filter
    Filter Location
    Wait Until Page Contains Element     ${FILTER_BUTTON}
    Click Element                        ${FILTER_BUTTON}
    Validate Result

Validate Result
    Element Should Contain Text           ${TOTAL_NUMBER_TEXT}    خدمات و کسب و کار
    Element Should Contain Text           ${REGION_HEADER}       تهران
    Page Should Contain Text              تهران
