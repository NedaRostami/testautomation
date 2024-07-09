*** Settings ***


*** Variables ***


*** Keywords ***
Clean Up Tests
    Dont See Errors
    Close All Browsers
    Run Keyword If                  '${REMOTE_TEST}' == 'Grid'             Make Metadata

Clean Up Suites
    Dont See Errors
    Close All Browsers
    Run Keyword If                  '${REMOTE_TEST}' == 'Grid'              Make Metadata

Make Metadata
    save video recording Name

save video recording Name
      Run Keyword If             ${Round} == ${1}    Set Test Variable    ${Values}    [${MOB_LOGS}/${PR}/${build}/${videoPattern}_1.mp4 | Round 1]
      ...   ELSE                 Set Test Variable   ${Values}    [${MOB_LOGS}/${PR}/${build}/${videoPattern}_1.mp4 | Round 1] | [${MOB_LOGS}/${PR}/${build}/${videoPattern}_2.mp4 | Round 2]
      Set Suite Metadata         name=Watch Videos   value=${Values}  append=yes  top=False
      Set Test Message           ${Values}   append=yes
