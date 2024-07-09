*** Settings ***
resource                     ../../web/resources/common.resource

*** Variables ***
#local tests
${LOCAL_BROWSER}                ${browserName}

#mobile web                     Android Emulator
${deviceName}                   samsung_galaxy_s10_e_8.1
${browserName}                  android
${android_version}              8.1
${platform}                     ANDROID

#appium for chrome
${platformName}                 Android
#${deviceName}                   Android Emulator
${deviceType}                   phone
${deviceOrientation}            portrait
${AppiumBrowserName}            Chrome
${Round}                        1

@{chrome_arguments}             --disable-infobars    --headless    --disable-gpu  --no-first-run  --disable-physical-keyboard-autocorrect   --disable-virtual-keyboard-overscroll  --disable-autofill-keyboard-accessory-view[8]

*** Keywords ***
Set Capabilities
    [Arguments]
    [Documentation]
    ...   Set Capabilities as a list for selenium grid .
    ...   All vars are dynamic and some are in variable files on vars dir as /var/mob.txt
    ${Pattern}                 	Replace String Using Regexp  ${TEST_NAME}_${SUT_NAME}	 ${SPACE}	 _
    Set Test Variable           ${NAME}                      ${Pattern}_${Round}
    Set Test Variable           ${videoPattern}              ${Pattern}
    Set Suite Variable          @{_tmp}
        ...  name:${NAME},
        ...  group:${trumpet_prenv_id},
        ...  cssSelectorsEnabled:true,
        ...  javascriptEnabled:true,
        ...  acceptSslCerts:true,
        ...  handlesAlerts:true,
        ...  webStorageEnabled:true,
        ...  nativeEvents:true,
        ...  locationContextEnabled:false,
        ...  applicationCacheEnabled:true,
        ...  tags:Mobile,
        ...  maxDuration:360,
        ...  commandTimeout:30,
        ...  idleTimeout:30,
        ...  public:public,
        ...  build:${build},
        ...  browserName: ${browserName},
        ...  platform: ${platform},
        ...  platformName: ${platformName},
        ...  version: ${android_version},
        ...  deviceType: ${deviceType},
        ...  deviceOrientation: ${deviceOrientation},
        ...  appPackage:${appPackage},
        ...  appActivity:${appActivity},
        ...  PR:${PR},
        ...  deviceName: ${deviceName}
    Set Suite Variable      ${CAPABILITIES}     ${EMPTY.join(${_tmp})}


Set Local Capabilities
    [Documentation]
    ...   Set Capabilities as a list for selenium grid .
    ...   All vars are dynamic and some are in variable files on vars dir as /var/mob.txt
    ${Pattern}                 	Replace String Using Regexp  ${TEST_NAME}_${SUT_NAME}	 ${SPACE}	 _
    Set Test Variable           ${NAME}                      ${Pattern}_${Round}
    Set Test Variable           ${videoPattern}              ${Pattern}
    Set Suite Variable          @{_tmp}
        ...  name:${NAME},
        ...  group:${trumpet_prenv_id},
        ...  cssSelectorsEnabled:true,
        ...  javascriptEnabled:true,
        ...  acceptSslCerts:true,
        ...  handlesAlerts:true,
        ...  webStorageEnabled:true,
        ...  nativeEvents:true,
        ...  locationContextEnabled:false,
        ...  applicationCacheEnabled:true,
        ...  tags:Mobile,
        ...  maxDuration:360,
        ...  commandTimeout:30,
        ...  idleTimeout:30,
        ...  public:public,
        ...  build:${build},
        ...  browserName: ${browserName},
        ...  platform: ${platform},
        ...  platformName: ${platformName},
        ...  version: ${android_version},
        ...  deviceType: ${deviceType},
        ...  deviceOrientation: ${deviceOrientation},
        ...  appPackage:${appPackage},
        ...  appActivity:${appActivity},
        ...  chromedriverExecutableDir: ${CURDIR}/chromedrivers/,
        ...  chromedriverChromeMappingFile: ${CURDIR}/map.json,
        ...  PR:${PR},
        ...  deviceName: ${deviceName}
    Set Suite Variable      ${CAPABILITIES}     ${EMPTY.join(${_tmp})}

Set Chrome Options
    [Documentation]    Set Chrome options for headless mode
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    : FOR    ${option}    IN    @{chrome_arguments}
    \    Call Method    ${options}    add_argument    ${option}
    [Return]    ${options}


Open Chrome With Options
  [Documentation]  Starts a Chrome browser with specified setting.
  # ${prefs}         Create Dictionary            profile.default_content_setting_values.notifications=1
  ${list}        Create List    proxyproxyType=${EMPTY}  httpProxy=${EMPTY}  ftpProxy=${EMPTY}  sslProxy=${EMPTY}  noProxy=${EMPTY}  class=org.openqa.selenium.Proxy    autodetect=${FALSE}
  ${Proxy}       Create Dictionary    args=${list}
  ${co}          Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys,selenium.webdriver
  Run Keyword If    '${isheadless}' == 'headless'      Call Method    ${co}    add_argument    --headless
  Call Method    ${co}    add_argument    test-type
  Call Method    ${co}    add_argument    --disable-infobars
  Call Method    ${co}    add_argument    --start-maximized
  Call Method    ${co}    add_argument    --no-first-run
  Call Method    ${co}    add_argument    --disable-notifications
  Call Method    ${co}    add_argument    --disable-translate
  Call Method    ${co}    add_argument    --disable-physical-keyboard-autocorrect
  Call Method    ${co}    add_argument    --disable-virtual-keyboard-overscroll
  Call Method    ${co}    add_argument    --disable-new-virtual-keyboard-behavior
  Call Method    ${co}    add_argument    --no-sandbox
  Call Method    ${co}    add_argument    --disable-setuid-sandbox
  Call Method    ${co}    add_argument    --no-default-browser-check
  Call Method    ${co}    add_argument    --enable-features\=NetworkServiceInProcess
  Call Method    ${co}    add_argument    --dns-prefetch-disable
  Call Method    ${co}    add_argument    --disable-dev-shm-usage
  Call Method    ${co}    add_argument    --disable-cache
  Call Method    ${co}    add_argument    --disable-application-cache
  Call Method    ${co}    add_argument    --disable-offline-load-stale-cache
  Call Method    ${co}    add_argument    --disk-cache-size\=0
  Call Method    ${co}    add_argument    --log-level\=3
  Call Method    ${co}    add_argument    --aggressive-cache-discard
  # Call Method    ${co}    add_argument    --window-size\=1920,1080
  #${mobile emulation}=    Create Dictionary    deviceName=${deviceName}
  # Call Method    ${co}    add_experimental_option    mobileEmulation   ${mobile emulation}
  # Call Method    ${co}     add_experimental_option    prefs   ${prefs}
  #Call Method    ${co}    add_argument    --disable-gpu
  ${caps}        Call Method   ${co}   to_capabilities
  Set To Dictionary   ${caps}        name=${NAME}                  PR=${trumpet_prenv_id}    build=${build}
  ...  platformName=${platformName}  browserName=${browserName}    platform=${platform}      idleTimeout=90
  ...  unicodeKeyboard=${TRUE}       resetKeyboard=${TRUE}         deviceName=${deviceName}
  ...  javascriptEnabled=${true}     cssSelectorsEnabled=${true}   version=${android_version}
  Set Create Webdriver     ${caps}   ${co}
  Go to       about:

Test Mobile Web
    ${mobile emulation}=    Create Dictionary    deviceName=${deviceName}
    ${co}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${co}    add_experimental_option    mobileEmulation    ${mobile emulation}
    Call Method    ${co}    add_argument    test-type
    Call Method    ${co}    add_argument    --disable-infobars
    #Call Method    ${co}    add_argument    --headless
    Call Method    ${co}    add_argument    --no-first-run
    Call Method    ${co}    add_argument    --disable-notifications
    Call Method    ${co}    add_argument    --disable-translate
    Call Method    ${co}    add_argument    --disable-physical-keyboard-autocorrect
    Call Method    ${co}    add_argument    --disable-virtual-keyboard-overscroll
    Call Method    ${co}    add_argument    --disable-new-virtual-keyboard-behavior
    Call Method    ${co}    add_argument    --no-sandbox
    Call Method    ${co}    add_argument    --disable-setuid-sandbox
    ${caps}=   Call Method   ${co}  to_capabilities
    Set To Dictionary   ${caps}   name=${NAME}  PR=${trumpet_prenv_id}  cssSelectorsEnabled=${true}   javascriptEnabled=${true}  appPackage=${appPackage}
    ...  platformName=${platformName}  browserName=${browserName}      platform=${platform}    version=${android_version}   deviceName=${deviceName}
    ...  appActivity=${appActivity}    unicodeKeyboard=${TRUE}   resetKeyboard=${TRUE}
    Set Create Webdriver     ${caps}   ${co}
    Go to       about:
    Check Home Page


SET Capabilities Dictionary
  ${caps}=    Create Dictionary      name=${NAME}  PR=${trumpet_prenv_id}  cssSelectorsEnabled=${true}   javascriptEnabled=${true}  appPackage=${appPackage}
  ...  platformName=${platformName}  browserName=${browserName}      platform=${platform}    version=${android_version}   deviceName=${deviceName}
  ...  appActivity=${appActivity}     unicodeKeyboard=${TRUE}   resetKeyboard=${TRUE}
  Set Suite Variable    ${CapabilitiesDic}    ${caps}

Open Google Chrome App
    Open Application    ${MOB_URL}     platformName=${platformName}
    ...   deviceName=${deviceName}     automationName=Appium
    ...   appPackage=${appPackage}   version=${android_version}     platform=${platform}
    ...   browserName=${EMPTY}   appActivity=${appActivity}
    ...   autoGrantPermissions=true
    ...   deviceReadyTimeout = 10  disableAndroidWatchers = true
    AppiumLibrary.Switch To Context   NATIVE_APP
    AppiumLibrary.Click Element       terms_accept
    AppiumLibrary.Click Element       negative_button
    Switch To Context   CHROMIUM

Set Create Webdriver
  [Arguments]    ${DesireCaps}  ${chrome_opt}
  Run Keyword If  '${REMOTE_TEST}' == 'Local'   Create Webdriver  Remote  alias=modHeader  command_executor=${APPIUM_LOCAL}   desired_capabilities=${DesireCaps}
  Run Keyword If   '${REMOTE_TEST}' == 'Grid'   Create Webdriver  Remote  alias=modHeader  command_executor=${MOB_URL}       desired_capabilities=${DesireCaps}

Open Chrome Without Options
  Run Keyword If   '${REMOTE_TEST}' == 'Local'   Open browser   about:   browser=${browserName}  remote_url=${APPIUM_LOCAL}  desired_capabilities=${CAPABILITIES}
  Run Keyword If   '${REMOTE_TEST}' == 'Grid'    Open browser   about:   browser=${browserName}  remote_url=${MOB_URL}      desired_capabilities=${CAPABILITIES}

Open Browser Without Options
  SET Capabilities Dictionary
  Run Keyword If   '${REMOTE_TEST}' == 'Local'   Create Webdriver  Remote  alias=DefBrowser  command_executor=${APPIUM_LOCAL}   desired_capabilities=${CapabilitiesDic}
  Run Keyword If   '${REMOTE_TEST}' == 'Grid'    Create Webdriver  Remote  alias=DefBrowser  command_executor=${MOB_URL}   desired_capabilities=${CapabilitiesDic}

How Create Webdriver
  [Arguments]       ${Webdriver}
  Run Keyword If    ${Webdriver}   Open Chrome With Options   ELSE  Open Chrome Without Options
  # Open Chrome Without Options

Open test browser
    Set Log Level    TRACE
    ${headlessChecker}       Set Variable If    '${HEADLESS}' == 'Yes'    headless    ${EMPTY}
    Set Suite Variable       ${isheadless}       ${headlessChecker}
    Run Keyword If   '${REMOTE_TEST}' == 'Local'     Set Local Capabilities
    ...  ELSE        Set Capabilities
    Set Test Server Environment
    Get Configs
    Test Other

Get Configs
    ${features}        Wait Until Keyword Succeeds    4x    3s               get config                   mobile
    FOR   ${key}       IN                           @{features.keys()}
        ${feature}     Get From Dictionary          ${features}                ${key}
        Set Suite Variable                          ${Toggle_${key}}           ${feature}
    END
    Log Variables    level=INFO


Test Other
    Run Keyword If   '${REMOTE_TEST}' == 'Grid'    Test Grid
    ...  ELSE   Test Local

Test Local
    Run Keyword If   '${browserName}' == 'browser'  Open Browser Without Options   ELSE  How Create Webdriver   ${TRUE}
    Check Home Page

Test Grid
    Run Keyword If   '${browserName}' == 'browser'  Open Browser Without Options   ELSE  How Create Webdriver   ${TRUE}
    Check Home Page

Open Remote Browser
    Run Keyword If   '${REMOTE_TEST}' != 'mobileEmulation'    Test Web
    ...  ELSE    Test Mobile Web
    #...  ff_profile_dir=${FF_PROFILE_DIR}

Test Web
    Run Keyword If   '${browserName}' == 'browser'  Open Browser Without Options   ELSE  How Create Webdriver   ${TRUE}
    ${tags}=     Create List    MobileSite  ${browserName}  ${browserName}${android_version}
    Check Home Page

Test Mobile Web old
    ${mobile emulation}=    Create Dictionary    deviceName=${deviceName}
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_experimental_option    mobileEmulation    ${mobile emulation}
    ${options}=   Call Method   ${options}  to_capabilities
    Create Webdriver    Remote  command_executor=${REMOTE_URL}    desired_capabilities=${options}
    Go to    about:
    ${tags}=     Create List    Mobile  ${browserName}  ${deviceName}  linux   emulation
    Check Home Page

Home Page Should Be Open
      Wait Until Page Contains    همه ایران   timeout=2s
