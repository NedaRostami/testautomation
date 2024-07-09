*** Settings ***
Documentation                  Test headers on Server
Test Teardown                  Clean Up Test
Resource                       ../../resources/setup.resource

*** Variables ***
${logo}                        img/logo.png
${Serp}                        %D8%A7%DB%8C%D8%B1%D8%A7%D9%86
${jScript}                     js/app.min.js

*** Test Cases ***
Header Test on NOPR
  [Tags]                       header   notest
  Run Keyword If	             '${trumpet_prenv_id}' != 'staging'   Set URL Server   ELSE   Set staging Server
  Run Keyword If               '${SERVER_KIND}' == 'NOPR'   Checking Header    ELSE   Pass Execution   NOPR
  #Checking Header

*** Keywords ***
Checking Header
  Open test browser
  Get Image Attribute
  Set Test Variable             ${SERVERNAME}    ${EXACTDOMAIN}
  Set Test Variable             @{GETURLS}       ${THUMBNAIL}     ${jScript}   ${logo}  ${Serp}
  Create API Context
  FOR      ${GETURL}            IN   @{GETURLS}
    log    ${GETURL}
    Check Header Value in loop   ${GETURL}
  END

Check Header Value in loop
  [Arguments]    ${URL}
  FOR    ${INDEX}              IN RANGE    1    20
    ${X-Cache}                 Get Header Value     X-Cache    ${URL}
    Run Keyword If             '${X-Cache}' == 'HIT'    Set Test Message 	*HTML* after <b>${INDEX} </b> times <b>X-Cache</b> for <b>${URL}</b> is <b>HIT</b></br>   append=True
    Exit For Loop If	         '${X-Cache}' == 'HIT'
    BuiltIn.Sleep              1s
  END
  Run Keyword If               '${X-Cache}' == 'MISS'    Run Keyword And Continue On Failure  Fail	 *HTML*after 10 times refreshomg page (0.5s) <b>X-Cache</b> for <b>${URL}</b> is <b>MISS</b>

Get Header Value
  [Arguments]                   ${header}            ${URL}
  ${resp}                       GET On Session       ${SERVERNAME}        /${URL}
  Should Be Equal As Strings	         ${resp.status_code}	 200
  &{Headers}                    Set Variable         ${resp.headers}
  ${final}                      Evaluate             $Headers.get("${header}")
  [return]                      ${final}

Get Image Attribute
  go to                                                   ${SERVER}/%D8%A7%DB%8C%D8%B1%D8%A7%D9%86?wi=1
  Wait Until Element Contains                             xpath=//*[@id="breadcrumbs"]/ul/li[2]                        همه ایران
  Set Test Variable    ${IMG_ELEMENT}                     //*[starts-with(@id,'listing')]/div[1]/a/span/img
  ${imgsrc}   SeleniumLibrary.Get Element Attribute       xpath:${IMG_ELEMENT}  src
  Should Not Contain    ${imgsrc}                         placeholders                                                 msg=None
  ${img}   Fetch From Right                               ${imgsrc}                                                    ${Pserver}/
  Set Test Variable                                       ${THUMBNAIL}                                                 ${img}

Clean Up Test
    Run Keyword If   '${SERVER_KIND}' == 'NOPR'   Clean Up Tests    ELSE   Pass Execution   NOPR
