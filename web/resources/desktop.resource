*** Settings ***


*** Variables ***


*** Keywords ***
Open test browser
    Set Log Level            TRACE
    Setup Initial Env
    Set Desired Capabilities
    IF    '${NameOfBrowser}' == 'firefox'
        Open browser             about:about       browser=${Browser_Name}  remote_url=${remote_url}   desired_capabilities=${desired_caps}   alias=${ALIAS}
    ELSE
        Set Chrome Options
        Open browser             about:${EMPTY}    browser=${Browser_Name}  remote_url=${remote_url}   desired_capabilities=${desired_caps}   alias=${ALIAS}    options=${options}
    END
    Maximize Browser Window
    Check Home Page

Setup Initial Env
    Set Test Variable        ${testFileNameTemplate}                Sheypoor_{testName}_{browser}_${Round}
    ${videoPattern} 	       Replace String Using Regexp            Sheypoor_${TEST NAME}_${SUT_NAME}_${NameOfBrowser}_${Round}	 ${SPACE}	 _
    Set Test Variable        ${testVideoNAme}                       ${videoPattern}
    ${isheadless}            Set Variable If                        '${HEADLESS}' == 'Yes'             headless    ${EMPTY}
    Set Suite Variable       ${isheadless}
    ${RecordVideoChecker}    Set Variable If                        '${RecordV}' == 'Yes'              ${TRUE}    ${FALSE}
    Set Suite Variable       ${RECORDVIDEO}                         ${RecordVideoChecker}
    Set Suite Variable       ${Browser_Name}                        ${isheadless}${NameOfBrowser}
    Set Test Server Environment
    Get Configs
    ${ALIAS}                 Set Variable If                        ${Second}                          Second          Main
    ${remote_url}            Set Variable If                       '${REMOTE_TEST}' == 'Grid'          ${WEB_URL}      ${FALSE}
    Set Suite Variable       ${remote_url}
    Set Suite Variable       ${ALIAS}

Set Desired Capabilities
    &{browser_logging}       Create Dictionary                                  browser=ALL
    &{desired_caps}          Create Dictionary                                  name=${TEST NAME}_${SUITE NAME}
    ...                      build=${build}                                     idleTimeout=90
    ...                      recordVideo=${RECORDVIDEO}                         cssSelectorsEnabled=${true}
    ...                      javascriptEnabled=${true}                          screenResolution=1920x1080
    ...                      tz=Asia/Tehran                                     testFileNameTemplate=${testVideoNAme}
    ...                      goog:loggingPrefs=${browser_logging}
    Set Suite Variable       ${desired_caps}

Set Chrome Options
    ${prefs}                 Create Dictionary                                  profile.password_manager_enabled=${FALSE}
    ...                      credentials_enable_service=${FALSE}
    ${options}               Catenate      SEPARATOR=
    ...                      add_experimental_option("prefs", ${prefs});
    ...                      add_experimental_option("excludeSwitches", ['enable-automation']);
    ...                      add_argument("test-type");
    ...                      add_argument("--disable-infobars");
    ...                      add_argument("--start-maximized");
    ...                      add_argument("--no-first-run");
    ...                      add_argument("--disable-notifications");
    ...                      add_argument("--disable-translate");
    ...                      add_argument("--disable-physical-keyboard-autocorrect");
    ...                      add_argument("--disable-virtual-keyboard-overscroll");
    ...                      add_argument("--disable-new-virtual-keyboard-behavior");
    ...                      add_argument("--no-sandbox");
    ...                      add_argument("--disable-setuid-sandbox");
    ...                      add_argument("--no-default-browser-check");
    ...                      add_argument("--enable-features\=NetworkServiceInProcess");
    ...                      add_argument("--dns-prefetch-disable");
    ...                      add_argument("--disable-dev-shm-usage");
    ...                      add_argument("--disable-cache");
    ...                      add_argument("--disable-application-cache");
    ...                      add_argument("--disable-offline-load-stale-cache");
    ...                      add_argument("--disk-cache-size\=0");
    ...                      add_argument("--log-level\=3");
    ...                      add_argument("--aggressive-cache-discard");
    ...                      add_argument("--window-size\=1920,1080")
    Set Suite Variable       ${options}

Get Configs
    ${features}              Wait Until Keyword Succeeds    4x    3s                   get config              web
    FOR   ${key}             IN                             @{features.keys()}
        ${feature}           Get From Dictionary            ${features}                ${key}
        Set Suite Variable   ${Toggle_${key}}               ${feature}
    END
    Log Variables      level=INFO

Open Firefox With Options
  [Documentation]     Starts a Firefox browser with specified setting.
  ${random_string}    generate random string  3
  ${path}             Catenate    SEPARATOR=\\    ${TEMPDIR}  ${random_string}
  ${profile}          create profile   ${path}
  Run Keyword If  '${REMOTE_TEST}' == 'Local'   Open browser   about:home   browser=${Browser_Name}  desired_capabilities=${CAPABILITIES}    ff_profile_dir=${profile}
  Run Keyword If   '${REMOTE_TEST}' == 'Grid'   Open browser   about:home   browser=${Browser_Name}  remote_url=${WEB_URL}     desired_capabilities=${CAPABILITIES}    ff_profile_dir=${profile}

Open Chrome With Options
  [Documentation]               Starts a Chrome browser with specified setting.
  ${prefs}                      Create Dictionary            profile.default_content_setting_values.notifications=1
  # ${proxy_server}               Set Variable                 127.0.0.1:8123
  # ${ProxyCap}                   Create Dictionary    proxyType=manual  httpProxy=${proxy_server}  ftpProxy=${proxy_server}  sslProxy=${proxy_server}  noProxy=${EMPTY}  class=org.openqa.selenium.Proxy    autodetect=${FALSE}
  ${co}                         Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys,selenium.webdriver
  Run Keyword If                '${isheadless}' == 'headless'      Call Method    ${co}    add_argument    --headless
  Call Method                   ${co}    add_argument    test-type
  Call Method                   ${co}    add_argument    --disable-infobars
  Call Method                   ${co}    add_argument    --start-maximized
  Call Method                   ${co}    add_argument    --no-first-run
  Call Method                   ${co}    add_argument    --disable-notifications
  Call Method                   ${co}    add_argument    --disable-translate
  Call Method                   ${co}    add_argument    --disable-physical-keyboard-autocorrect
  Call Method                   ${co}    add_argument    --disable-virtual-keyboard-overscroll
  Call Method                   ${co}    add_argument    --disable-new-virtual-keyboard-behavior
  Call Method                   ${co}    add_argument    --no-sandbox
  Call Method                   ${co}    add_argument    --disable-setuid-sandbox
  Call Method                   ${co}    add_argument    --no-default-browser-check
  Call Method                   ${co}    add_argument    --enable-features\=NetworkServiceInProcess
  Call Method                   ${co}    add_argument    --dns-prefetch-disable
  Call Method                   ${co}    add_argument    --disable-dev-shm-usage
  Call Method                   ${co}    add_argument    --disable-cache
  Call Method                   ${co}    add_argument    --disable-application-cache
  Call Method                   ${co}    add_argument    --disable-offline-load-stale-cache
  Call Method                   ${co}    add_argument    --disk-cache-size\=0
  Call Method                   ${co}    add_argument    --log-level\=3
  Call Method                   ${co}    add_argument    --aggressive-cache-discard
  Call Method                   ${co}    add_argument    --window-size\=1920,1080
  Call Method                   ${co}    add_experimental_option    prefs   ${prefs}
  # Call Method                   ${co}    add_argument    --disable-blink-features\=BlockCredentialedSubresources
  #${mobile emulation}          Create Dictionary    deviceName=${deviceName}
  # Call Method                  ${co}    add_experimental_option    mobileEmulation   ${mobile emulation}
  #Call Method                   ${co}    add_argument    --disable-gpu
  ${caps}                       Call Method               ${co}   to_capabilities
  Set To Dictionary            ${caps}                    name=${TEST NAME}_${SUT_NAME}   build=${build}   idleTimeout=90
  ...  recordVideo=${RECORDVIDEO}                         cssSelectorsEnabled=${true}    javascriptEnabled=${true}
  ...  screenResolution=1920x1080                         tz=Asia/Tehran   testFileNameTemplate=${testFileNameTemplate}
  Set Create Webdriver     ${caps}                        ${co}
  Go to       about:


Set Create Webdriver
  [Arguments]                     ${DesireCaps}  ${chrome_opt}
  Run Keyword If                  '${REMOTE_TEST}' == 'Local'   Create Webdriver  Chrome  alias=modHeader  desired_capabilities=${DesireCaps}
  Run Keyword If                  '${REMOTE_TEST}' == 'Grid'    Create Webdriver  Remote  alias=modHeader  command_executor=${WEB_URL}    desired_capabilities=${DesireCaps}

Open Browser Without Options
  ${ALIAS}                        Set Variable If    ${Second}       Second   Main
  ${About}                        Set Variable If   '${NameOfBrowser}' == 'firefox'   about    ${EMPTY}
  Run Keyword If                  '${REMOTE_TEST}' == 'Local'   Open browser   about:${About}   browser=${Browser_Name}  desired_capabilities=${CAPABILITIES}    alias=${ALIAS}
  Run Keyword If                  '${REMOTE_TEST}' == 'Grid'    Open browser   about:${About}   browser=${Browser_Name}  remote_url=${WEB_URL}    desired_capabilities=${CAPABILITIES}   alias=${ALIAS}

How Create Webdriver
  [Arguments]                     ${Webdriver}
  Run Keyword If                  ${Webdriver}   Open Browser With Options   ELSE   Open Browser Without Options
  #Open Browser Without Options

Open Browser With Options
   Run Keyword If                  '${NameOfBrowser}' == 'firefox'   Open Firefox With Options   ELSE    Open Chrome With Options


Test Local
    How Create Webdriver   ${ByOption}
    Maximize Browser Window
    Check Home Page

Test Grid
    How Create Webdriver      ${ByOption}
    Maximize Browser Window
    Check Home Page

Open Remote Browser
    #${ff default caps}    Evaluate    sys.modules['selenium.webdriver'].common.desired_capabilities.DesiredCapabilities.FIREFOX    sys,selenium.webdriver
    #Set To Dictionary    ${ff default caps}    marionette=${True}
    Run Keyword If           '${REMOTE_TEST}' != 'mobileEmulation'    Test Web
    ...  ELSE                Test Mobile Web
    #...  ff_profile_dir=${FF_PROFILE_DIR}

Test Web
    How Create Webdriver       ${FALSE}
    Maximize Browser Window
    ${tags}=     Create List   Desktop  ${Browser_Name}  ${Browser_Name}${browser_version}
    Check Home Page

Test Mobile Web
    ${mobile emulation}     Create Dictionary    deviceName=${deviceName}
    ${co}                   Evaluate         sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
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
    ${caps}                 Call Method     ${co}  to_capabilities
    Set To Dictionary       ${caps}         name=${NAME}  PR=${trumpet_prenv_id}  cssSelectorsEnabled=${true}   javascriptEnabled=${true}  platformName=${platformName}  browserName=${Browser_Name}      platform=${platform}    version=${browser_version}   deviceName=${deviceName}   appPackage=${appPackage}   appActivity=${appActivity}   unicodeKeyboard=${TRUE}   resetKeyboard=${TRUE}
    Set Create Webdriver    ${caps}         ${co}
    Go to       about:
    Check Home Page

Test Mobile Web old
    ${mobile emulation}        Create Dictionary    deviceName=${deviceName}
    ${options}                 Evaluate             sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method                ${options}           add_experimental_option    mobileEmulation    ${mobile emulation}
    ${options}                 Call Method          ${options}  to_capabilities
    Create Webdriver           Remote               command_executor=${REMOTE_URL}    desired_capabilities=${options}
    Go to    about:
    #${tags}=     Create List    Mobile  ${Browser_Name}  ${deviceName}  linux   emulation
    Check Home Page

Home Page Should Be Open
      Wait Until Page Contains                      نیازمندیهای رایگان شیپور     10s
      #Title Should Be        شیپور - نیازمندیهای رایگان خرید و فروش، استخدام و خدمات
      Check Backend Errors                          failure=${TRUE}
