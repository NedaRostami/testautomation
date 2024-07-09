*** Settings ***
Resource                               ..${/}..${/}resources${/}common.resource
Suite Setup                            Set Suite Environment
#Test Setup                             start app
Test Teardown                          Close test application
Test Timeout                           10 minutes

*** Variables ***
${State}                               استان تهران
${City}                                تهران
${Region}                              آجودانیه
${C1}                                  Hi how are you?
${C2}                                  I am a Customer
${C3}                                  Can you give me a discount?
${C4}                                  Ok thanks I will inform you. Bye
${S1}                                  Hi You?
${S2}                                  nice to meet you
${S3}                                  of course 5%
${S4}                                  bye

*** Test Cases ***
Chat Test
    [Tags]                             Chat     notest
    start app                          ALIAS=Saler
    Set Saler Video metadata
    ${orig timeout}                    Set Appium Timeout	90 seconds
    Add New Nini Listing
    start app                          ALIAS=Customer
    Switch Application                 Saler
    Set Nick Name
    Set Appium Timeout	               ${orig timeout}
    Click Toolbar Account
    Switch Application                 Customer
    Customer Login
    Make Saler busy
    Click Back Button
    Make Saler busy
    Customer open chat of listing
    Make Saler busy
    #TODO   remove below line after next release
    Run Keyword And Ignore Error         Customer register Chat Nickname
    Make Saler busy
    Customer Send first message
    Switch Application                   Saler
    Saler send first message
    Switch Application                   Customer
    Chat message   ${C2}
    Switch Application                   Saler
    Chat message      ${S2}
    Switch Application                   Customer
    Chat message   ${C3}
    Switch Application                   Saler
    Chat message      ${S3}
    Switch Application                   Customer
    Chat message   ${C4}
    Switch Application                   Saler
    Chat message      ${S4}
#Login By Mobile
    #Wait Until Page Contains   چت با صاحب آگهی   timeout=5
    #ارتباط برقرار نیست

*** Keywords ***
Set Saler Video metadata
    Set Test Variable    ${VideoUrlA}     ${APP_LOGS}/${trumpet_prenv_id}/${NAME}.mp4
    Set Suite Metadata    name=Watch Saler
    ...  value=[${VideoUrlA}|${NAME}]
    ...  append=True    top=False

Add New Nini Listing
    Set Listing Limit For Cat per locations   parentid=${43612}  catid=${43616}  regid=${8}  cityid=${301}  nghid=${930}  limitcount=${30}  limitprice=${11000}
    Go To Post Listing Page
    Find Element By Swipe in loop             ${OFFER_NAME}
    Get Random Listing                        43616
    Click Category Spinner
    Scroll The List                        لوازم شخصی
    Scroll The List                        لباس و لوازم کودک و نوزاد
    Input Attribute                        قیمت (تومان)               500000
    Input Title And Decription
    Select Location                        ${State}   ${City}   ${Region}
    Submit Post Listing                    ${FALSE}   ${FALSE}
#    Login By Mobile                        ${MOBILE}
    Login By Mobile                        #${MOBILE}
#    Get AdID And Accept
    Get AdID And Accept Listing
    Check Listing Status in My Listings Page By Click NOTNOW Button
    Log                                    ${listingId}
    Click Back Button
    Wait Until Page Contains Element      ${CAT_ROOT}                         timeout=30
    Validate Home Activity
    Filter Category                        لوازم شخصی    لباس و لوازم کودک و نوزاد
    # Check Listing Title In Serp

Chat message
    [Arguments]                  ${message}
    Input Text                   id=${CONVERSATION_INPUT_TEXT}    ${message}
    click element                id=${CONVERSATION_ACTION}
    Wait Until Page Contains     ${message}   timeout=10

Make Saler busy
    Switch Application           Saler
    @{elements}                  Get Webelements     id=${APP_PACKAGE}:id/offerCard
    Scroll Next                  ${elements}[1]
    Switch Application           Customer

Open Chat from toolbar
    swipe by percent            90   30   90   70   1000
    Click Toolbar Account
    Wait Until Page Contains    ${CHAT_LINK}   10
    Click Toolbar Items         ${CHAT_LINK}

Open Serp Page
    Click Toolbar Account
    Wait Until Page Contains    id=${OfferID}     10

Customer open chat of listing
    Search Saler listing
    Wait Until Page Contains        ${Title_Words}   timeout=15
    click Element    ${CHAT}
    FOR  ${index}  IN RANGE   1   6
       ${status}=	Run Keyword And Return Status   Wait Until Page Contains    چت با صاحب آگهی    timeout=3
       Exit For Loop If    ${status}
       Run Keyword And Ignore Error    click Element   ${CHAT}
    END

Search Saler listing
    click the link      جستجو در شیپور
    #TODO[Tags]    ignore error
    Wait Until Keyword Succeeds    4x    2s    Input Text   id=${SEARCH_FIELD}     ${Title_Words}
    Run Keyword If    ${STABLE}   Press Keycode    66    ELSE    click Element    id=${APP_PACKAGE}:id/searchRightForwardButton
    # Run Keyword And Ignore Error    Input Text   id=${APP_PACKAGE}:id/search_text     ${Title_Words}
    # Press Keycode              66
    Wait Until Page Contains Element   id=${OfferID}
    @{elements}                  Get Webelements     id=${OfferID}
    ${Length}                    Get Length    ${elements}
    FOR   ${INDEX}               IN RANGE    1    ${Length+1}
       ${Title}                  Get Text    ${elements}[${INDEX-1}]
       ${Status}                 Run Keyword And Return Status    Should Be True  '${Title_Words}' == '${Title}'
       Exit For Loop If    ${Status}
       swipe by percent     90   30   90   70   1000
       swipe by percent     90   30   90   70   1000
    END
    Run Keyword If    ${Status}    click Element   ${elements}[0]    ELSE   Fail    Can not find saler listing by search

Find The Chat Listing Title
    FOR    ${INDEX}    IN RANGE           1    10
         Wait Until Page Contains Element   id=${OfferID}
         @{elements}                      Get Webelements     id=${OfferID}
         ${Title}                         Get Text    ${elements}[0]
         ${status}=	Run Keyword And Return Status  Should Be True  '${Title_Words}' == '${Title}'
         Exit For Loop If	               ${status}
         @{elements}                     Get Webelements     id=${OfferID}
         Scroll Next                     ${elements}[0]
         BuiltIn.sleep                   0.5s
    END
    Run Keyword If   ${status}           click Element   ${elements}[0]


Customer register Chat Nickname
    ${Random_String}                     Generate Random String         12
    Wait Until Element Is Visible        ${SINGLE_EDIT_TEXT}    timeout=10
    Input Text                           ${SINGLE_EDIT_TEXT}    ${Random_String}
    Run Keyword And Ignore Error         Hide Keyboard
    click element                        id=${APP_PACKAGE}:id/nickname_start

Customer Send first message
    Refresh Chat page
    Wait Until Page Contains             پیامتان را درج کنید . . .   timeout=5
    tap                                  id=${APP_PACKAGE}:id/conversation_recyclerview
    Chat message                         ${C1}

Customer Login
    BuiltIn.Sleep                        1s
    Click Toolbar Account
    BuiltIn.Sleep                        3s
    Click The Link                       ${MYACCOUNT}
    Login By Mobile
    Wait Until Page Contains Element     ${PROFILE_SETTING}    timeout=5

Set Nick Name
  ${Random_String}                       Generate Random String         12
  Click Toolbar Account
  Click Toolbar Items                    ${USER_SETTINGS}
  Wait Until Page Contains               ویرایش حساب کاربری     timeout=10
  Click The Link                         ویرایش حساب کاربری
  Input Text                             accessibility_id=نام    ${Random_String}
  Run Keyword And Ignore Error           Hide Keyboard
  click element                          id=${APP_PACKAGE}:id/submitProfileButton




Saler send first message
    Open Chat from toolbar
    #Wait Until Page Does Not Contain     ارتباط برقرار نیست   timeout=30
    Refresh Chat page
    Wait Until Page Contains   همه چت‌ها   timeout=5
    click element     id=${APP_PACKAGE}:id/chat_preview_row_last_message
    Wait Until Page Contains    پیامتان را درج کنید . . .   timeout=5
    tap               id=${APP_PACKAGE}:id/conversation_recyclerview
    Chat message      ${S1}

Refresh Chat page
    FOR    ${INDEX}     IN RANGE    1    6
       ${status}      	Run Keyword And Return Status    Wait Until Page Does Not Contain    ارتباط برقرار نیست    timeout=3
       Exit For Loop If    ${status}
       swipe Down       ${3}
    END
    Run Keyword If    not ${status}     Fail    ارتباط برقرار نیست
