*** Settings ***
Documentation                                 Test All Trumpet Page performance
Test Setup                                    Open test browser
Test Teardown                                 Run Keywords    wait until page loading is finished      Clean Up Tests
Resource                                      ../../resources/setup.resource

*** Variables ***
${ConfirmBtn}                                 xpath=//*[@id="reviewForm_1"]/fieldset/form/div[1]/div[3]/div[9]/div[1]/button


*** Test Cases ***
ChecK Trumpet Performance
  [Tags]                                      Trumpet  Performance  notest
  Add New Listing Min LoggedIn By Mobile
  Login Trumpet Admin Page
  Wait Until Page Contains                    داشبورد
  Go to Moderation and calculate loading time
  ${element}                                  get webelements      css:button.btn.btn-success.btn-lg.btn-block
  FOR   ${button}                             IN      @{element}
      ${enabled}                              Run Keyword And Return Status   Element Should Be Enabled    ${button}
      Continue For Loop If                    not ${enabled}
      click element                           ${button}
      Sleep    1s
  END
  Run Keyword If                              not ${enabled}    click element        //*[@id="reviewForm_2"]/fieldset/form/div[1]/div[3]/div[9]/div[1]/button
  Get Confirm Time


*** Keywords ***
Go to Moderation and calculate loading time
  FOR    ${INDEX}    IN RANGE    0    5
    Run Keyword And Ignore Error              Click Link    پیش فرض
    ${loaded}  	                              Run Keyword And Return Status      Wait Until Page Contains element         css:button.btn.btn-success.btn-lg.btn-block          timeout=10s
    Exit For Loop If                          ${loaded}
  END
    Run Keyword If                            ${loaded}    Calculate Loading time
    ...  ELSE   Fail                          can not go to moderation page


Get Confirm Time
  ${Start}                          	        Get Current Date	result_format=epoch
  FOR    ${INDEX}                             IN RANGE    1    500
    ${FormClass}                              SeleniumLibrary.Get Element Attribute    id:reviewForm_1  class
    ${passed}                       	        Run Keyword And Return Status   Should Contain  ${FormClass}  bg-success
    Exit For Loop If                          ${passed}
    BuiltIn.Sleep                             20ms
  END
  ${Finish}                         	        Get Current Date	result_format=epoch
  ${Timer}                                    Evaluate   (${Finish} - ${Start}) * 1000
  Set Test Message                            <b>Confirm Time</b>:${Timer}ms</br> 	append=yes
  Run Keyword If                              ${Timer} > 2000    Fail	  Long time to confirm
  Log                                         ${Timer}

Add New Listing Min LoggedIn By Mobile
  [Tags]    Listing
  Login OR Register By Random OR New Mobile     ${Auth_Session_Position}
  FOR    ${INDEX}    IN RANGE    1    5
    Go To Post Listing Page
    Post A New Listing                          ${1}   43619  43625  tel=${Random_User_Mobile_B}
    Verify Post Listing Is done
    Check My Listing
    Check My Listing Image Count                1
  END


Calculate Loading time
  Performance Timing                           Total page load time    loadEventEnd        navigationStart
  Performance Timing                           Request response time   responseEnd         requestStart
  Performance Timing                           page render time        domComplete         domLoading
  Performance Timing                           DNS                     domainLookupEnd     domainLookupStart
  Performance Timing                           Connect                 connectEnd          connectStart
  Performance Timing                           TTFB                    responseStart       connectEnd
  Performance Timing                           frontEnd                loadEventStart      responseEnd

Performance Timing
  [Arguments]                                  ${NAME}  ${First}  ${Second}
  ${TestTime}                                  Execute Javascript  return window.performance.timing.${First} - window.performance.timing.${Second};
  ${HTML}                                      Set Variable If   '${NAME}' == 'Total page load time'   *HTML*   ${EMPTY}
  Set Test Message                             ${HTML}<b>${NAME}</b>:${TestTime}ms</br> 	append=yes
