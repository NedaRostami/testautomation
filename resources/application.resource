*** Settings ***
Resource                              all.resource
Library                               AppiumLibrary                         timeout=30      run_on_failure=Capture Custom App Screenshots
Library                               String
Library                               Collections
Library                               OperatingSystem
Library                               DateTime
Library                               SSHLibrary                            encoding=cp1256
Library                               Process
Library                               Sheypoor                              platform=android                         env=${trumpet_prenv_id}    general_api_version=${general_api_version}   ServerType=${ServerType}

*** Variables ***
${noreset}                            ${FALSE}
${fullreset}                          ${TRUE}
${unicodeKeyboard}                    ${TRUE}
${resetKeyboard}                      ${TRUE}
${APKNAME}                            ${APP_PACKAGE}
${QA}                                 No
${ALIAS}                              4723
${Round}                              1
${DOCKERNAME}                         No

*** Keywords ***
start app
    [Arguments]                       ${ALIAS}=4723                         ${NO-RESET}=${noreset}                   ${FULL-RESET}=${fullreset}
    Set Arguments As Test Variables   ${ALIAS}                              ${NO-RESET}                              ${FULL-RESET}
    Generate Video Pattern
    Run Keyword If                    '${REMOTE_TEST}' == 'Grid'            Make Video Metadata
    # Delete App Release Force Update
    Set APPIUM Server
    Setup Variables By Versions
    Open App By Caps
    Set Environment Server
    Check App is Ready
    IF                                ${IS_SHEYPOOR}
      Validate First Initial Serp
    END
    Empty Pictures Directory From Device

Set Arguments As Test Variables
    [Arguments]                       ${ALIAS}                              ${NO-RESET}                              ${FULL-RESET}
    Set Test Variable                 ${ALIAS}
    Set Test Variable                 ${NO-RESET}
    Set Test Variable                 ${FULL-RESET}

Make Video Metadata
    Save Video Recording Name

Generate Video Pattern
    ${Pattern}                 	      Replace String Using Regexp           ${TEST_NAME}_${ALIAS}_${SUT_NAME}	       ${SPACE}	 _
    Set Test Variable                 ${videoPattern}                       ${Pattern}
    Set Test Variable                 ${NAME}                               ${Pattern}_${Round}

Save Video Recording Name
    ${Values}                         Set Variable If                       ${Round} == ${1}
    ...                               [${APP_LOGS}/${PR}/${build}/${videoPattern}_1.mp4 | Round 1]
    ...                               [${APP_LOGS}/${PR}/${build}/${videoPattern}_1.mp4 | Round 1] | [${APP_LOGS}/${PR}/${build}/${videoPattern}_2.mp4 | Round 2]
    Set Suite Metadata                name=Watch Videos                     value=${Values}       append=True     top=False
    Set Test Message                  ${Values}                             append=True

Set APPIUM Server
    IF                                '${REMOTE_TEST}' == 'Grid'
      Set Grid APPIUM
    ELSE
      Set Local APPIUM
    END

Set Grid APPIUM
    Set Global Variable               ${APPIUM}                             ${APP_URL}
    Set Global Variable               ${APP_ANDROID}                        ${file_url_Grid}
    Set Global Variable               ${BROSER_NAME}                        android

Set Local APPIUM
    Set Global Variable               ${APPIUM}                             ${APPIUM_LOCAL}                          #http://127.0.0.1:4723/wd/hub
    Set Global Variable               ${APP_ANDROID}                        ${CURDIR}/${APK_PATH}
    Set Global Variable               ${BROSER_NAME}                        android
    Set Global Variable               ${unicodeKeyboard}                    ${TRUE}
    Set Global Variable               ${resetKeyboard}                      ${TRUE}
    Set Global Variable               ${FULL-RESET}                         ${FALSE}
    Set Global Variable               ${NO-RESET}                           ${FALSE}

Setup Variables By Versions
    Set Suite Metadata                name=File Version                     value=${file_version}                     append=True       top=False
    ${CheckStable}                    Run Keyword And Return Status         Should Contain                           ${APP_ANDROID}    android_build
    ${STABLE}                         Set Variable If                       ${CheckStable}                           ${TRUE}           ${FALSE}
    Set Global Variable               ${STABLE}                             ${STABLE}

Open App By Caps
    Install App And open
    IF                                ${IS_SHEYPOOR}
      Run Keyword If                 '${ALIAS}' == 'Seller'                 Make Customer Busy                # chat/02
      Set Location Service
      Check System UI
    END

Set Location Service
    adb shell              settings put secure location_providers_allowed +network
    ${STATUS}              Run Keyword And Return Status             Wait Until Page Contains Element    id=android:id/button1    timeout=2
    Run Keyword If         ${STATUS}                                 accept Alert                        Agree
    Set Geo Location       35.7544      51.4153   1400

Check System UI
    ${STATUS}              Run Keyword And Return Status    Wait Until Page Contains Element    id=android:id/aerr_close    timeout=5
    # Run Keyword If         ${STATUS}                      accept Alert                        Close app
    Run Keyword If         ${STATUS}                        click element                       id=android:id/aerr_close
    [return]               ${STATUS}

Install App And open
    ${tags}                           Create List                           Android  ${AVDname}  ${APP_PACKAGE}  ${FILE_VERSION}
    log                               ${APPIUM}
    Open Application                  ${APPIUM}                             alias=${ALIAS}                           platformName=${PLATFORM_NAME_ANDROID}
    ...   device=${AVDname}           app=${APP_ANDROID}                    automationName=${AUTOMATION_NAME}        deviceName=${deviceName}
    ...   version=${android_version}  appActivity=${SPLASH_ACTIVITY}        appPackage=${APP_PACKAGE}                appWaitActivity=${SPLASH_ACTIVITY}
    ...   platform=ANDROID            public=public                         build=${jenkinsID}                       uiautomator2ServerInstallTimeout=40000
    ...   adbExecTimeout=50000        tags=${tags}                          PR=${PR}                                 AndroidMobileCapabilityType.AUTO_GRANT_PERMISSIONS=${TRUE}
    ...   newCommandTimeout=90        deviceReadyTimeout=30                    AndroidMobileCapabilityType.ACCESS_FINE_LOCATION=${TRUE}
    ...   name=${NAME}                autoGrantPermissions=${TRUE}          isHeadless=${TRUE}                       remoteAppsCacheLimit=0
    ...   gpsEnabled=${TRUE}          resetKeyboard=${resetKeyboard}        unicodeKeyboard=${unicodeKeyboard}       uiautomator2ServerLaunchTimeout=60000
    ...   noReset=${NO-RESET}         fullReset=${FULL-RESET}               ignoreUnimportantViews=${FALSE}          deviceOrientation=${DEVICE_ORIENTATION}
    ...   idleTimeout=15              commandTimeout=20                     disableAndroidWatchers=${TRUE}           platformVersion=${android_version}
    ${currentAct}                     get Activity

Get Configs
    ${features}                       Wait Until Keyword Succeeds           4x    3s                                 get config            ${config_platform}
    FOR   ${key}                      IN                                    @{features.keys()}
        ${feature}                    Get From Dictionary                   ${features}                              ${key}
        Set Suite Variable            ${Toggle_${key}}                      ${feature}
    END
    Log Variables

Find Docker Name
    SSH Login to HUB
    Get Docker Name
    # Run Keyword If          '${DOCKERNAME}' == 'No'             Fail                  can not find docker name
    # Run Keyword If          '${DOCKERNAME}' == ''               Fail                  can not find docker name
    Set Suite Metadata       name=Docker Name                   value=${DOCKERNAME}   append=True                   top=False
    # ${Docker_VNC}           Execute Command      docker inspect --format='{{(index (index .NetworkSettings.Ports "6080/tcp") 0).HostPort}}' $(docker ps --format "{{.ID}}" --filter name=${DOCKERNAME})
    # log to console          http://${HUB_SERVER}:${Docker_VNC}

Get Docker Name
    # ${result}               Execute Command           bash ${SERVICE_PATH} GetDockerName ${NAME} ${APP_DOCKER_NAME}   return_stdout=True	 return_stderr=False   return_rc=False
    FOR  ${i}   IN RANGE    3
      Start Command           bash ${SERVICE_PATH} GetDockerName ${NAME} ${APP_DOCKER_NAME}
      ${result}               Read Command Output	   return_stdout=True	 return_stderr=False   return_rc=False
      ${Valid}                Run Keyword And Return Status    Should Contain    ${result}    ${APP_DOCKER_NAME}
      Exit For Loop If        ${Valid}
    END
    Set Test Variable       ${DOCKERNAME}    ${result}
    # Import Library           Process
    # ${result}               Run Process   bash   ${SERVICE_PATH}    GetDockerName ${NAME} ${APP_DOCKER_NAME}    timeout=10s
    # Set Test Variable       ${DOCKERNAME}    ${result.stdout}

Check App is Ready
  [Arguments]                         ${Activity}=${HOME_ACTIVITY}
  ${Start}                          	Get Current Date	result_format=epoch
  FOR    ${INDEX}                     IN RANGE    0    20
       ${act}                         Get Activity
       Exit For Loop If               '${act}' == '${Activity}'
       Sleep                          3s
  END
  ${Finish}                         	Get Current Date	result_format=epoch
  ${Timer}                            Evaluate                              ${Finish} - ${Start}
  Run Keyword If                      ${Timer} > 60                         Fail	  Long time to Load ${Timer}s

Set Environment Server
  Wait Until Page Contains Element    ${STAGING_BUTTON}      timeout=10
  IF                                  '${trumpet_prenv_id}' == 'Live'
    Go To Live Server
  ELSE IF                             '${trumpet_prenv_id}' == 'staging'
    Go To Staging Server
  ELSE IF                             '${ServerType}' == 'SheypoorX'
    Go To SheypoorX Server
  ELSE IF                             '${ServerType}' == 'ProTools'
    Go To ProTools Server
  ELSE
    Go To PR Server
  END

Go To Live Server
    Set Live Server
    Wait Until Keyword Succeeds       10x   1s   Click Element              ${LIVE_BUTTON}

Go To PR Server
    Set PR Server
    Input Text                        ${INPUT_PR_NUMBER}                    ${trumpet_prenv_id}
    Wait Until Keyword Succeeds       10x   1s   Click Element              ${PR_BUTTON}

Go To Staging Server
    Set staging Server
    Wait Until Keyword Succeeds       10x   1s   Click Element              ${STAGING_BUTTON}

Go To SheypoorX Server
    Set SheypoorX Server
    #TODO:Android team must make app tesatable for shx
    Skip                                Android team must make app tesatable for shx domain

Go To ProTools Server
    Set ProTools Server
    #TODO:ProTool team must make app tesatable for shx
    Skip                                ProTool team must make app tesatable for protool domain

Empty Pictures Directory From Device
    adb shell                           rm -rf /mnt/sdcard/Pictures/

Set Android Test Kind
    ${IS_SHEYPOOR}                     Run Keyword And Return Status       Should Contain       ${APP_PACKAGE}     sheypoor
    ${IS_ALOONAK}                      Run Keyword And Return Status       Should Contain       ${APP_PACKAGE}     protoolsmobileapp
    ${config_platform}                 Set Variable If                     ${IS_SHEYPOOR}       android            aloonak
    Set Suite Variable                 ${IS_SHEYPOOR}
    Set Suite Variable                 ${IS_ALOONAK}
    Set Suite Variable                 ${config_platform}

Capture Custom App Screenshots
    ${Time}                            Get Current Date	                    result_format=epoch
    # Capture Page Screenshot            ${OUTPUT DIR}${TEST_NAME}_${ALIAS}_${Time}.png
    Capture Page Screenshot
