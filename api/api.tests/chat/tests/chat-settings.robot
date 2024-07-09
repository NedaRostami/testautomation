*** Settings ***
Resource                            ../versions/v${api_version}/keywords.resource
Suite Setup                         Set Suite Environment
Test Setup                          Set Test Environment
Test Teardown                       Clean Up Test
Test Template                       Update Chat Settings With Notifications ${Notification}, Chat Enabled ${Enabled} And Nickname ${Nickname}

*** Test Cases ***
Change Chat Settings
    [Tags]                          all             chat
    [Setup]                         Expect Response                     ${Chat_Settings_Schema}
    ${True}                         ${True}                             آل پاچینو
    ${False}                        ${True}                             جیمز هتفیلد
    ${False}                        ${False}                            محمد حبیبی
    ${True}                         ${False}                            آلیسا وایت گلاز
