*** Settings ***
Documentation                        Base resource file for protools api tests
Resource                             ../resource.resource
Library                              Sheypoor               platform=api           env=${trumpet_prenv_id}        general_api_version=${general_api_version}    ServerType=${ServerType}


*** Variables ***
${protools_version}                  2
${VName}                             v2
${trumpet_prenv_id}                  staging


*** Keywords ***
##################################################    REST  ################################################################
Clean Up Arguments
   [Arguments]                    @{args}                             &{kwargs}
   ${length}                      Get Length                          ${args}
   ${Normal}                      Run Keyword And Return Status       Should Contain                         ${args}[0]           /
   Run Keyword If                 ${Normal}                           Get URL from Args                      @{args}                             &{kwargs}
   ...  ELSE                      Get URL from Kwargs                 @{args}                                &{kwargs}

Get URL from Kwargs
   [Arguments]                    @{args}                             &{kwargs}
   ${items}                       Get Dictionary Items                ${kwargs}
   Set Test Variable              ${EndPoint}                         ${items}[0]=${items}[1]
   Pop From Dictionary            ${kwargs}                           ${items}[0]
   Set Test Variable              ${kwargs}
   Set Test Variable              ${args}

Get URL from Args
  [Arguments]                    @{args}                              &{kwargs}
  ${EndPoint}                    Remove From List                     ${args}           0
  Set Test Variable              ${EndPoint}
  Set Test Variable              ${kwargs}
  Set Test Variable              ${args}

Get In Retry
  [Arguments]                    @{args}                              &{kwargs}
  Clean Up Arguments             @{args}                              &{kwargs}
  Do Method In Loop              Get                                  ${EndPoint}    @{args}       &{kwargs}

Post In Retry
  [Arguments]                    @{args}                              &{kwargs}
  Clean Up Arguments             @{args}                              &{kwargs}
  Do Method In Loop              Post                                 ${EndPoint}    @{args}       &{kwargs}

Delete In Retry
  [Arguments]                    @{args}                              &{kwargs}
  Clean Up Arguments             @{args}                              &{kwargs}
  Do Method In Loop              DELETE                               ${EndPoint}    @{args}       &{kwargs}

Do Method In Loop
  [Arguments]                   ${method}      ${EndPoint}            @{args}        &{kwargs}
  ${timeout}                    Pop From Dictionary                   ${kwargs}      timeout       10
  ${error}                      Set Variable                          ${false}
  FOR   ${i}                    IN RANGE       3
    ${done}                     Run Keyword And Return Status        Run Keyword     ${method}     ${EndPoint}   @{args}      timeout=${timeout}        &{kwargs}
    Output
    Output Schema               response
    Run Keyword If              not ${done}                          Sleep           2s
    Continue For Loop If        not ${done}
    ${error}                    Run Keyword And Return Status        String          response body error            ${error_throttle_try_later}
    Exit For Loop If            not ${error}
    Sleep                       3s
  END
  Run Keyword If               not ${done} or ${error}               Fail    can not do ${method} on ${EndPoint} with @{args} &{kwargs}
