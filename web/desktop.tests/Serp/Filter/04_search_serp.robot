*** Settings ***
Documentation                                          Search for some keywords in serp
Test Setup                                             Open test browser
Test Teardown                                          Clean Up Tests
Resource                                               ../../../resources/serp.resource

*** Test Cases ***
Search In Serp By Input Data And URL
    [Tags]                                             serp  search
    Read Search Words From File
    Search Some Keywords In Serp
    Search Some Keywords By URL

*** Keywords ***
Search Some Keywords In Serp
    Go To Serp Page
    FOR  ${item}  IN  @{Se_keys}
      Search Some Keywords                              ${item}
      Set Serp Tag Variable And Validate Position       1            جستجو: ${item}
    END

Search Some Keywords By URL
    Go To Serp Page
    FOR  ${item}  IN   @{Se_keys}
      Search By URL                                     ${item}
      Set Serp Tag Variable And Validate Position       1            جستجو: ${item}
    END

Read Search Words From File
    ${contents}                 OperatingSystem.Get File            ${CURDIR}${/}searches.txt
    @{Se_keys}                  Split to lines                      ${contents}
    Set Test Variable           ${Se_keys}

Search By URL
    [Arguments]                 ${query}
    go to                       ${SERVER}/ایران?q=${query}
    ${status}                   Run Keyword And Return Status       Wait Until page contains             نتایج جستجو برای ${query}           timeout=5s
    Run Keyword Unless          ${status}                           Page Should Contain                  متاسفانه نتیجه‌ای پیدا نشد
