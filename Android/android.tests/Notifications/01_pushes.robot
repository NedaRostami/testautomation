*** Settings ***
Resource        ..${/}..${/}resources${/}common.resource
Suite Setup      Set Suite Environment
Test Setup       start app
Test Teardown    Close test application
Test Timeout     10 minutes

*** Variables ***
# ${TOKEN}           dSTwPdaBNGQ:APA91bESDG1frQDYRnnKmsDy18Jk-ygmUQDcuJQLSUjsf0qtfgvKUCOCJWAT0fe1_9Pz2zXLLkvUwo9kvHmrAQGfRxYEtXaQsYi_SXXpU48xYjA7KHmoffsDEnpspOXqzDkwHuqYD2XP
*** Test Cases ***
Android Push Notifications
    [Tags]                  Notifications      notest
    ${Push}                 send push notification      ${TOKEN}
    Log                     ${Push.status_code}
    Log                     ${Push.content}
    Should Not Contain      ${Push.content}    NotRegistered
    Get Push Notifications

*** Keywords ***
Send Push Notification2
  Import Resource	    ${EXECDIR}/web/resources/setup.resource
  Set Capabilities
  Open browser   about:   browser=chrome  remote_url=${WEB_URL}  desired_capabilities=${CAPABILITIES}
  Fill Register User By Mobile            ${Random_User_Mobile_A}
  Go To                                   ${SERVER}/session/mySavedSearches?debug=1
  Wait Until Page Contains                     جستجوهای من    timeout=10
  ${PushID}      get text                 //*[@id="my-saved-searches"]/div[1]/p
  Go To       ${SERVER}/trumpet/mock/saved-search-notification/${PushID}

check Push
  @{Pushes}    Get Webelements   id=android:id/title
  FOR   ${Push}   IN   @{Pushes}
     ${text}	  Get Text	  ${Push}
     Capture Custom App Screenshots
  END

Set Capabilities
  [Documentation]
  ...   Set Capabilities as a list for selenium grid .
  ...   All vars are dynamic and some are in variable files on vars dir as /var/ch.txt
  Set Suite Variable    @{_tmp}
      ...  name:${SUITE NAME}_${SUT_NAME},
      ...  build:${build},
      ...  group:${trumpet_prenv_id},
      ...  cssSelectorsEnabled:true,
      ...  javascriptEnabled:true,
      ...  locationContextEnabled:false,
      ...  browserName:chrome,
      ...  screenResolution:1280x720,
      ...  tz:Asia/Tehran,
      ...  platform:LINUX,
      ...  platformName:LINUX,
      ...  recordVideo:${RECORDVIDEO} ,
      ...  version:59
  Set Suite Variable      ${CAPABILITIES}     ${EMPTY.join(${_tmp})}
