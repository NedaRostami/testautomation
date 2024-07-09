*** Settings ***
library               REST
Library               Sheypoor              platform=api     env=${trumpet_prenv_id}  general_api_version=${general_api_version}  ServerType=${ServerType}
Library               smoke_test

*** Variables ***
${Round}               ${2}
${Expected}            ${1}

*** Test Cases ***
Warm Up SUT
    Set Log Level        Trace
    Warm Up PR
    set init setup


*** Keywords ***
set init setup
    Mock Toggle Set       web            post-moderation                         ${1}
    Mock Toggle Set       mobile         post-moderation                         ${1}
    Mock Toggle Set       android        post-moderation                         ${1}
    Mock Toggle Set       ios            post-moderation                         ${1}
    Mock Toggle Set       web            bump                                    ${1}
    Mock Toggle Set       mobile         bump                                    ${1}
    Mock Toggle Set       android        bump                                    ${1}
    Mock Toggle Set       ios            bump                                    ${1}
    Mock Toggle Set       web            secure-purchase                         ${1}
    Mock Toggle Set       web            user-secure-purchase-in-post-listing    ${1}
    Mock Toggle Set       web            shop-secure-purchase-in-post-listing    ${1}
    Mock Toggle Set       mobile         user-secure-purchase-in-post-listing    ${0}
    Mock Toggle Set       mobile         shop-secure-purchase-in-post-listing    ${0}
    Mock Toggle Set       android        user-secure-purchase-in-post-listing    ${1}
    Mock Toggle Set       android        shop-secure-purchase-in-post-listing    ${1}
    Set Payment Gateway   success

Warm Up PR
    ${passed}             Set Variable       ${0}
    Log To Console        ${\n}
    FOR   ${I}            IN RANGE          ${Round}
      ${status}           Run Keyword And Return Status    run smoke test   ${trumpet_prenv_id}    ${general_api_version}  ${ServerType}
      ${passed}           Set Variable If    ${status}     ${passed+1}      ${passed}
      Log To Console      round ${I+1} of WARM UP status is ${status} and total passed:${passed}
      Exit For Loop If    ${passed} == ${Expected}
    END
    Run Keyword Unless    ${status}     Fail     Smoke tests in warm up failed after ${Round} retry
