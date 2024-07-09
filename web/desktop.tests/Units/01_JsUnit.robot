*** Settings ***
Metadata                                    VERSION     0.1
Test Setup                                  Open test browser
Test Teardown                               Clean Up Tests
Resource                                    ../../resources/setup.resource

*** Variables ***

*** Test Cases ***
JsUnit Test
    [Documentation]                         Check the JsUnit test result
    [Tags]                                  units
    Go To                                   ${SERVER}/scripts/tests
    Wait Until Page Contains Element        ${Units_Js_Failures}                         timeout=10s
    ${Units_Js_Failures}                    Get Text                                    ${Units_Js_Failures}
    ${Units_Js_Passes}                      Get Text                                    ${Units_Js_Passes}
    Run Keyword If                          ${Units_Js_Failures} >= 2     JsUnitFail    ${Units_Js_Failures}   ${Units_Js_Passes}

*** Keywords ***
JsUnitFail
    [Arguments]                             ${JsFailuresCount}                          ${JsPassesCount}
    ${response}                             Execute Javascript    return jQuery('.test.fail').eq(0).parents('.suite').children('h1').eq(0).text() + ': ' + jQuery('.test.fail h2').eq(0).text()
    Set Test Variable                       ${FailureTxt}                               ${response}
    capture custom screenshots
    Fail                                    JS unit tests failed (fail:${JsFailuresCount} - Pass:${JsPassesCount}).the first error is: ${FailureTxt}
