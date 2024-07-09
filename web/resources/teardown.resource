*** Settings ***


*** Variables ***


*** Keywords ***
Clean Up Tests
    Run Keyword If Test Failed     On failure Setups
    Run Keyword If Test Passed     On Pass Setups
    Close All Browsers
    Final Grid Proccessing

On failure Setups
    Set Test Message               ${Browser_Name} 	append=yes
    Run Keyword And Ignore Error   capture custom screenshots
    Run keyword if                 '${REMOTE_TEST}' == 'Grid'    Add Cookie         zaleniumTestPassed    false

On Pass Setups
    # Dont See Errors
    Set Test Message               ${Browser_Name} 	append=yes
    Run keyword if                 '${REMOTE_TEST}' == 'Grid'    Add Cookie         zaleniumTestPassed    true


Final Grid Proccessing
    IF                             ${RECORDVIDEO}
      Set Test Variable            ${Values}                     [${WEB_LOGS}/${build}/${testVideoNAme}.mp4 | ${testVideoNAme}.mp4]
      Set Suite Metadata           name=Watch Videos             value=${Values}  append=yes  top=False
      Set Test Message             ${Values}                     append=yes
    END
