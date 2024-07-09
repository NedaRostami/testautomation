*** Settings ***
Resource        ..${/}..${/}resources${/}common.resource
Suite Setup      Set Suite Environment
Test Setup       start app
Test Teardown    Close test application
Test Timeout     10 minutes

*** Variables ***
${URLA}          https://staging.mielse.com/%DA%86%D8%B1%D9%85-%D8%A7%D8%B5%D9%87%D8%A7%D9%86-%D9%85%DB%8C%D8%AF%D8%A7%D9%86-%D8%A7%D8%B3%D8%AA%D8%AE%D8%B1-%D8%AF%D8%A7%D8%B1-%D9%85%D8%AF%D9%84-67780557.html

*** Test Cases ***
check deepLink functionality
    [Tags]    deepLink       notest
    # Initalize
    # Install App             ${APP_ANDROID}       ${APP_PACKAGE}
    # Go To Url               ${URLA}
    deep Link                 ${URLA}                     ${APP_PACKAGE}
    Sleep                     30s

*** Keywords ***
Initalize
    Set Log Level    TRACE
    ${Pattern}=	Replace String Using Regexp  ${TEST_NAME}_${ALIAS}_${SUT_NAME}	 ${SPACE}	 _
    Set Test Variable          ${videoPattern}            ${Pattern}
    Set Test Variable          ${NAME}                    ${Pattern}_${Round}
    Set APPIUM Server
    Setup Variables By Versions
    ${ServerURL}               Set Variable If    '${trumpet_prenv_id}' != 'staging'   pr${trumpet_prenv_id}     ${trumpet_prenv_id}
    Set Global Variable        ${SERVER}        https://${ServerURL}.${Domian}
    Set Global Variable        ${MockSERVER}    https://${ServerURL}.${Domian}
