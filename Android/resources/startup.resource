*** Settings ***
Variables                      ../vars/vars.py
Variables                      ../vars/androidvars.py
Variables                      ..${/}vars/Variables.py                              ${file_version}
Resource                       ../../resources/application.resource
Resource                       versions${/}${file_version}.resource

*** Variables ***

*** Keywords ***
Set Suite Environment
    Set Log Level                Trace
    @{VERSIONS_SORT}             Create List
    # ${VERSIONS_LIST}            run                            ls ${CURDIR}${/}versions -1 | sed -e 's/\.resource$//'
    # @{VERSIONS_LIST}            Split String                     ${VERSIONS_LIST}         ${\n}
    @{VERSIONS_LIST}              OperatingSystem.List Files In Directory          ${CURDIR}${/}versions      *.resource
    Reverse List                  ${VERSIONS_LIST}
    FOR  ${version}   IN          @{VERSIONS_LIST}
      ${version}                  Remove String                                     ${version}                .resource
      Append To List              ${VERSIONS_SORT}                                  ${version}
    END
    Set Library Search Order      @{VERSIONS_SORT}
    Set Android Test Kind
    Get Configs

Get FCM Token
    Wait Until Page Contains Element     id=com.sheypoor.mobile.debug:id/fragmentDebugFcm
    Click element                        id=com.sheypoor.mobile.debug:id/fragmentDebugFcm
    Sleep                                3s
    ${Token}                             get the clipboard
    Set Test Variable                    ${TOKEN}           ${Token}
    Log                                  ${TOKEN}

Close test application
    Run Keyword And Ignore Error         Finish Teardown Tasks

Finish Teardown Tasks
    # Run Keyword And Ignore Error         Remove Application              com.sheypoor.mobile
    # Run Keyword And Ignore Error         adb shell                       pm uninstall -k com.sheypoor.mobile
    Run Keyword If	                    '${REMOTE_TEST}' == 'Grid'       Find Docker Name
    Run Keyword If Test Failed           On failure Setups
    Run Keyword If Test Passed           On Pass Setups
    # Run Keyword And Ignore Error         Repeat Keyword                  2 times              Click Home Button
    # ${checker}                           Check System UI
    # IF                                   ${checker}
    #     Set Test Message                 System UI Crash                 append=yes
    #     Fail                             System UI Crash
    # END
    Close all applications
    Set App file Metadata
    Run Keyword If                      '${REMOTE_TEST}' == 'Grid'       Close Connection



Create List by ID
  [Arguments]                            ${ID}
  @{Elements}                            get webelements                  ${ID}
  @{list}                                Create List
  FOR      ${elem}          IN           @{Elements}
       ${ListText}                       get text                         ${elem}
       Append To List                    ${list}                          ${ListText}
  END
  [Return]                               ${list}

Get Push Notifications
  open notifications shade
  Sleep             3s
  ${titles}         Create List by ID      id=android:id/title
  ${texts}          Create List by ID      id=android:id/text
  Log               ${titles}
  Log               ${texts}
  Capture Custom App Screenshots
  Click Back Button

Get Logfiles
    Run Keyword If          '${DOCKERNAME}' != 'No'          Set Logcat file
    Run Keyword If          '${DOCKERNAME}' != 'No'          Get Appium Log file

Set Logcat file
    # ${َAppiumID}             Get Appium SessionId
    Start Command           docker exec -i ${DOCKERNAME} adb logcat -t 10000 -d
    ${Logcat}               Read Command Output	   return_stdout=True	 return_stderr=False   return_rc=False
    Create File	            ${EXECDIR}/Reports/logcat-${NAME}.txt	 ${Logcat}
    Set Test Message        *HTML*<a href='logcat-${NAME}.txt'>LogCat</a>   append=yes
    Set Suite Metadata    name=See LogCat
    ...  value=[logcat-${NAME}.txt|LogCat${Round}]
    ...  append=True    top=False
    # Start Command           docker exec -i ${DOCKERNAME} adb logcat -c

Get bugreport file
    #/var/lib/docker/qa/vids/${APP_DOCKER_NAME}
    # Set Client Configuration              timeout=60
    Start Command          docker exec -i ${DOCKERNAME} mkdir /tmp/video/${PR}/${jenkinsID}/bugreport
    Start Command          docker exec -i ${DOCKERNAME} adb bugreport /tmp/video/${PR}/${jenkinsID}/bugreport/${NAME}
    Sleep    20
    # Start Command         docker exec -i ${DOCKERNAME} ls /tmp/video/${PR}/${build}/bugreport/${NAME}.zip
    # ${bugreport}          Read Command Output	   return_stdout=True	 return_stderr=False   return_rc=False
    Set Suite Metadata    name=See bugreport
    ...  value=[${APP_LOGS}/${PR}/${jenkinsID}/bugreport/${NAME}.zip|bugreport${Round}]
    ...  append=True    top=False

Get Appium Log file
    Start Command           docker exec -i ${DOCKERNAME} tail -1000 /var/log/supervisor/appium.log
    ${AppiumLog}            Read Command Output	   return_stdout=True	 return_stderr=False   return_rc=False
    Create File	            ${EXECDIR}/Reports/${NAME}-${Round}-AppiumLog.txt	 ${AppiumLog}
    Set Test Message        *HTML*<a href='${NAME}-${Round}-AppiumLog.txt'>AppiumLog</a>   append=yes
    # Set Suite Metadata      name=See AppiumLog
    # ...  value=[${NAME}-${Round}-AppiumLog.txt|AppiumLog${Round}]
    # ...  append=True    top=False


CPU and Memory Utilisation
    [Documentation]         Find the CPU consumption & memory used in the mobile device
    Start Command           docker exec -i ${DOCKERNAME} adb shell top -t -n 2 -d 5 | grep ${APP_PACKAGE}
    ${CPU}                  Read Command Output	   return_stdout=True	 return_stderr=False   return_rc=False
    Start Command           docker exec -i ${DOCKERNAME} adb shell cat /proc/meminfo
    ${mem}                  Read Command Output	   return_stdout=True	 return_stderr=False   return_rc=False
    Start Command           docker exec -i ${DOCKERNAME} adb shell dumpsys meminfo com.sheypoor.mobile.debug
    ${meminfo}              Read Command Output	   return_stdout=True	 return_stderr=False   return_rc=False
    ${MEMORY}               Set Variable    OverALL:${\n}${mem}${\n}${\n}${\n}meminfo for com.sheypoor.mobile.debug${\n}${meminfo}
    Log Many                CPU usage:${\n}${CPU}${\n}      Memory usage:${\n}${MEMORY}
    Create File	            ${EXECDIR}/Reports/CPU-${NAME}-${Round}.txt	   ${CPU}
    Create File	            ${EXECDIR}/Reports/MEMORY-${NAME}-${Round}.txt	 ${MEMORY}
    Set Suite Metadata      name=CPU and Memory
    ...  value=[CPU-${NAME}-${Round}.txt|CPU${Round}] | [MEMORY-${NAME}-${Round}.txt|MEMORY${Round}]
    ...  append=True    top=False

Set App file Metadata
    Set Suite Metadata      name=APK
    ...  value=[${APP_ANDROID}|${APP_ANDROID}]
    ...  append=True    top=False

On failure Setups
    Run Keyword And Ignore Error      Get Source
    Run Keyword And Ignore Error      Capture Custom App Screenshots
    Run Keyword If                    '${REMOTE_TEST}' == 'Grid'     Get Logfiles
    Run Keyword If                    '${REMOTE_TEST}' == 'Grid' and '${DOCKERNAME}' != 'No'    CPU and Memory Utilisation
    # Run Keyword If                   '${REMOTE_TEST}' == 'Grid' and '${DOCKERNAME}' != 'No'    Get bugreport file

On Pass Setups
    # Run Keyword And Ignore Error     Capture Custom App Screenshots
    # Run Keyword If                   '${REMOTE_TEST}' == 'Grid'     Get Logfiles
    Log To Console                    Passed

# Set Grid Video metadata
#     find test video names
#     Run Keyword If                 ${VideoCount} == ${0}    Set Suite Metadata    name=Watch Video (nv)   value=[${APP_LOGS}/${PR}/${build}/${videoPattern}_1.mp4|${videoPattern}_1.mp4]   append=True   top=False
#     ...  ELSE                      Set Suite Meta Data Links
#
# Set Suite Meta Data Links
#     FOR    ${INDEX}    IN RANGE    1                           ${VideoCount+1}
#      ${VideoNames}   Get Line      ${stdout}                   ${INDEX-1}
#      Set Suite Variable            ${Video${INDEX}}            ${VideoNames}
#      Set Test Variable             ${VideoUrl${INDEX}}         ${APP_LOGS}/${PR}/${build}/${Video${INDEX}}
#      Set Suite Metadata            name=Watch Video ${INDEX}   value=[${VideoUrl${INDEX}}|${Video${INDEX}}]   append=True   top=False
#     END
#
# find test video names
#     FOR    ${INDEX}                IN RANGE    5
#       Sleep      5s
#       ${stdout}   	               Execute Command	  ls -t ${APP_LOGS_PATH}/AndroidApp/${PR}/${build} | grep -i "${videoPattern}"
#       ${isEmpty}                   Run Keyword And Return Status     Should Not Contain    ${stdout}    mp4
#       Continue For Loop If         ${isEmpty}
#     END
#     ${Lines}                       Get Line Count               ${stdout}
#     Set Suite Variable             ${stdout}                    ${stdout}
#     Set Suite Variable             ${VideoCount}                ${Lines}

SSH Login to HUB
    Open Connection              ${HUB_SERVER}
    ${Key}   Set Variable If    '${REMOTE_TEST}' == 'Grid'       ${APP_SSH_KEY_PATH}      ${CURDIR}${/}id_rsa
    ${output}         Login With Public Key   ${HUB_USER}   ${Key}
    Should Contain    ${output}                 Last login

swipe fast Horizontally
  ${width}      Get Window Width
  ${height} 	  Get Window Height
  ${width}      Convert To Integer     ${width}
  ${height}     Convert To Integer     ${height}
  ${x1}         Evaluate    ${width} * 0.7
  ${x2}         Evaluate    ${width} * 0.3
  ${y1}         Evaluate    ${height} * 0.7
  ${y2}         Evaluate    ${height} * 0.7
  ${x1}         Convert To Number    ${x1}  0
  ${x2}         Convert To Number    ${x2}  0
  ${y1}         Convert To Number    ${y1}  0
  ${y2}         Convert To Number    ${y2}  0
  swipe         ${x1}  ${y1}  ${x2}  ${y2}  ${1000}

Swipe Element Horizontally
  [arguments]   ${Locator}
  ${Size}       Get Element Size       ${Locator}
  ${width}      Get From Dictionary	   ${Size}	    width
  ${width}      Convert To Integer     ${width}
  ${height} 	  Get From Dictionary	   ${Size}	    height
  ${height}     Convert To Integer     ${height}
  ${Location}   Get Element Location   ${Locator}
  ${top}      	Get From Dictionary	   ${Location}	 y
  ${top}        Convert To Integer     ${top}
  ${left}     	Get From Dictionary	   ${Location}	 x
  ${left}       Convert To Integer     ${left}
  ${x1}         Evaluate    ${width} * 0.95 + ${left}
  ${x2}         Evaluate    ${width} * 0.05 + ${left}
  ${y1}         Evaluate    ${height} * 0.5 + ${top}
  ${y2}         Evaluate    ${height} * 0.5 + ${top}
  ${x1}         Convert To Number    ${x1}  0
  ${x2}         Convert To Number    ${x2}  0
  ${y1}         Convert To Number    ${y1}  0
  ${y2}         Convert To Number    ${y2}  0
  swipe         ${x1}  ${y1}  ${x2}  ${y2}  ${1000}

Swipe Down
  [Arguments]     ${repeat}=${1}
  ${width}      Get Window Width
  ${height} 	  Get Window Height
  ${width}      Convert To Integer     ${width}
  ${height}     Convert To Integer     ${height}
  ${x1}         Evaluate    ${width} * 0.5
  ${x2}         Evaluate    ${width} * 0.5
  ${y1}         Evaluate    ${height} * 0.5
  ${y2}         Evaluate    ${height} * 0.8
  FOR    ${INDEX}    IN RANGE    1    ${repeat}
       swipe         ${x1}  ${y1}  ${x2}  ${y2}  ${1000}
       Sleep         200ms
  END

Flick Down
  [Arguments]     ${repeat}=${1}
  ${width}      Get Window Width
  ${height} 	  Get Window Height
  ${width}      Convert To Integer     ${width}
  ${height}     Convert To Integer     ${height}
  ${x1}         Evaluate    ${width} * 0.5
  ${x2}         Evaluate    ${width} * 0.5
  ${y1}         Evaluate    ${height} * 0.5
  ${y2}         Evaluate    ${height} * 0.8
  FOR    ${INDEX}    IN RANGE    1    ${repeat}
       Flick         ${x1}  ${y1}  ${x2}  ${y2}  ${1000}
       Sleep         200ms
  END

Flick Up
  [Arguments]     ${repeat}=${1}
  ${width}      Get Window Width
  ${height} 	  Get Window Height
  ${width}      Convert To Integer     ${width}
  ${height}     Convert To Integer     ${height}
  ${x1}         Evaluate    ${width} * 0.5
  ${x2}         Evaluate    ${width} * 0.5
  ${y1}         Evaluate    ${height} * 0.8
  ${y2}         Evaluate    ${height} * 0.5
  FOR    ${INDEX}    IN RANGE    1    ${repeat}
       Flick         ${x1}  ${y1}  ${x2}  ${y2}  ${1000}
       Sleep         200ms
  END

Flick Right
  [Arguments]     ${repeat}=${1}
  ${width}      Get Window Width
  ${height} 	  Get Window Height
  ${width}      Convert To Integer     ${width}
  ${height}     Convert To Integer     ${height}
  ${x1}         Evaluate    ${width} * 0.5
  ${x2}         Evaluate    ${width} * 0.8
  ${y1}         Evaluate    ${height} * 0.5
  ${y2}         Evaluate    ${height} * 0.5
  FOR    ${INDEX}    IN RANGE    1    ${repeat}
       Flick         ${x1}  ${y1}  ${x2}  ${y2}  ${1000}
       Sleep         200ms
  END

Swipe Right
  [Arguments]     ${repeat}=${1}
  ${width}      Get Window Width
  ${height} 	  Get Window Height
  ${width}      Convert To Integer     ${width}
  ${height}     Convert To Integer     ${height}
  ${x1}         Evaluate    ${width} * 0.5
  ${x2}         Evaluate    ${width} * 0.8
  ${y1}         Evaluate    ${height} * 0.5
  ${y2}         Evaluate    ${height} * 0.5
  FOR    ${INDEX}    IN RANGE    1    ${repeat}
       swipe         ${x1}  ${y1}  ${x2}  ${y2}  ${1000}
       Sleep         200ms
  END

Swipe Up
  [Arguments]     ${repeat}=${1}
  ${width}      Get Window Width
  ${height} 	  Get Window Height
  ${width}      Convert To Integer     ${width}
  ${height}     Convert To Integer     ${height}
  ${x1}         Evaluate    ${width} * 0.3
  ${x2}         Evaluate    ${width} * 0.3
  ${y1}         Evaluate    ${height} * 0.85
  ${y2}         Evaluate    ${height} * 0.15
  FOR    ${INDEX}    IN RANGE    1    ${repeat}
       swipe         ${x1}  ${y1}  ${x2}  ${y2}  ${250}
       Sleep         200ms
  END

Get Element Center Coordinate
  [Arguments]                          ${element}
  ${Size}       Get Element Size       ${element}
  ${width}      Get From Dictionary	   ${Size}	width
  ${width}      Convert To Integer     ${width}
  ${height} 	  Get From Dictionary	   ${Size}	height
  ${height}     Convert To Integer     ${height}
  ${Location}   Get Element Location   ${element}
  ${top}      	Get From Dictionary	   ${Location}	y
  ${top}        Convert To Integer     ${top}
  ${left}     	Get From Dictionary	   ${Location}	x
  ${left}       Convert To Integer     ${left}
  ${w1}         Evaluate    ${width} / 2
  ${h1}         Evaluate    ${height} / 2
  ${x1}         Evaluate    ${left} + ${w1}
  ${y1}         Evaluate    ${top} + ${h1}
  @{EL_INFO}    Create List     ${x1}  ${y1}
  [return]      @{EL_INFO}

Swipe Up Element To Top
    [Arguments]       ${element}
    ${Location}       Get Element Location   ${element}
    ${top}      	    Get From Dictionary	   ${Location}  	y
    ${top}            Convert To Integer     ${top}
    ${left}     	    Get From Dictionary	   ${Location}	  x
    ${left}           Convert To Integer     ${left}
    ${x1}             Evaluate               ${left} + 100
    ${y1}             Evaluate               ${top} - 5
    Swipe             ${x1}    ${y1}    ${x1}    ${400}
