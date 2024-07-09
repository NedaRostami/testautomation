*** Settings ***
Documentation                                      First install the latest stable debug version app,
...                                                then we update to the new develop version.
Resource                                           ..${/}..${/}resources${/}common.resource
Suite Setup                                        Set Suite Environment
Test Setup                                         Init Variables
Test Teardown                                      Check App Teardown Keyword
Test Timeout                                       10 minutes

*** Test Cases ***
Validate Sheypoor Application Update
    [Tags]                                         update app                        toolbar
    Choose Skip By Stable And Downgrade Status
    Install And Run The Latest Version
    Exit The Sheypoor App
    Update Application To New Version
    Run New Application Version
    Check App Version Is New Version

*** Keywords ***
Init Variables
    Set Test Variable                              ${stable_version}                 ${apk_version}
    Set Test Variable                              ${new_version}                    ${file_version}
    IF                                            '${REMOTE_TEST}' == 'Grid'
        Set Grid Appium Variables
    ELSE
        Set Local Appium Variables
    END

Choose Skip By Stable And Downgrade Status
    ${skip}                                        Set Variable If                  '${stable_version}' >= '${new_version}'
    ...                                            ${TRUE}                           ${FALSE}
    Set Test Variable                              ${app_is_not_open}                ${skip}
    Skip If                                        ${skip}

Set Grid Appium Variables
    Set Test Variable                              ${new_version_app_path}           ${file_url_Grid}
    Set Test Variable                              ${file_url_Grid}                  http://trumpetbuild.mielse.com:8001/android_build/v${stable_version}/debug/Sheypoor-PlayStoreDebug.apk

Set Local Appium Variables
    Set Test Variable                              ${new_version_app_path}           ${CURDIR}/Sheypoor-PlayStoreDebug${new_version}.apk
    Set Test Variable                              ${APK_PATH}                       Sheypoor-PlayStoreDebug${stable_version}.apk

Check App Version
    [Arguments]                                    ${version}
    Click Toolbar Account
    Element Text Should Be                         ${TOOLBAR_APP_VERSION}            app version ${version}

Check App Teardown Keyword
    Run Keyword Unless                             ${app_is_not_open}                Close test application

Update Application To New Version
    Set Test Variable                              ${APP_ANDROID}                    ${new_version_app_path}
    Install App And open

Run New Application Version
    Set Environment Server
    Validate First Initial Serp

Check App Version Is New Version
    Check App Version                              ${new_version}

Check App Version Is Stable Version
    Check App Version                              ${stable_version}

Install And Run The Latest Version
    start app
    Check App Version Is Stable Version

Exit The Sheypoor App
    Quit Application
