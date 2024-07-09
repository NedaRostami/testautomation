*** Settings ***
Documentation                       Base resource file for all api tests
resource                            ../../resources/all.resource
Variables                           ../variables/Variables.py                   ${trumpet_prenv_id}                 ${api_version}     ${ServerType}
Library                             REST                                        ${SERVER}/api/v${api_version}
Library                             FakerLibrary                                locale=fa_IR
Library                             Collections
Library                             String
Library                             OperatingSystem
Library                             Sheypoor                                    platform=api     env=${trumpet_prenv_id}     general_api_version=${api_version}   ServerType=${ServerType}


*** Variables ***
${ROOT_PATH}                        ${CURDIR}/..
${RESOURCE_IMAGE}                   ${CURDIR}${/}images
${NOT_IMPLEMENTED_MESSAGE}          Endpoint is not implemented in version ${api_version}
&{HEADERS}                          Content-Type=application/json;
&{Listing_Headers}                  Content-Type=Application/json                   User-Agent=Android/8.1 Sheypoor/5.1.2-Debug-PlayStore VersionCode/594 Manufacturer/Samsung Model/Samsung Galaxy S10 E - 8.1 - API 27 - 1080x2280    Referrer=Post_Listing     Phone-Base=True     X-AGENT-TYPE=Android App    Connection=keep-alive
&{Image_Headers}                    Content-Type=Multipart/Form-data
&{Empty_Dictionary}
@{Empty_List}

*** Keywords ***
#################################################  Environment  ############################################################################################
Set Suite Environment
    Set Library Search Order        keywords
    Set Log Level                   Trace
    Set Tags                        v${api_version}

Set Test Environment
    Log Variables                   level=INFO


Clean Up Test
    Run Keyword If Test Failed      Set Tags    failed
    Run Keyword If Test Passed      Set Tags    passed

##################################################    REST  ################################################################
Clean Up Arguments
    [Arguments]                                 @{args}                                 &{kwargs}
    ${length}                                   Get Length                              ${args}
    ${Normal}                                   Run Keyword And Return Status           Should Contain            ${args}[0]     /
    Run Keyword If                              ${Normal}                               Get URL from Args         @{args}        &{kwargs}
    ...  ELSE                                   Get URL from Kwargs                     @{args}                   &{kwargs}

Get URL from Kwargs
    [Arguments]                                 @{args}                                 &{kwargs}
    ${items}                                    Get Dictionary Items                    ${kwargs}
    Set Test Variable                           ${EndPoint}                             ${items}[0]=${items}[1]
    Pop From Dictionary                         ${kwargs}                               ${items}[0]
    Set Test Variable                           ${kwargs}
    Set Test Variable                           ${args}

Get URL from Args
    [Arguments]                                 @{args}                                 &{kwargs}
    ${EndPoint}                                 Remove From List                        ${args}                   0
    Set Test Variable                           ${EndPoint}
    Set Test Variable                           ${kwargs}
    Set Test Variable                           ${args}

Get In Retry
    [Arguments]                                 @{args}                                 &{kwargs}
    Clean Up Arguments                          @{args}                                 &{kwargs}
    Do Method In Loop                           Get                                     ${EndPoint}               @{args}        &{kwargs}

Post In Retry
    [Arguments]                                 @{args}                                 &{kwargs}
    Clean Up Arguments                          @{args}                                 &{kwargs}
    Do Method In Loop                           Post                                    ${EndPoint}               @{args}        &{kwargs}

Do Method In Loop
    [Arguments]                                 ${method}                               ${EndPoint}               @{args}        &{kwargs}
    ${timeout}                                  Pop From Dictionary                     ${kwargs}                 timeout        10
    ${throttle}                                 Set Variable                            ${FALSE}
    FOR   ${i}                                  IN RANGE       3
        ${done}   ${resp}                       Run Keyword And Ignore Error            Run Keyword               ${method}      ${EndPoint}   @{args}      timeout=${timeout}        &{kwargs}
        ${done}                                 Set Variable If                        '${done}' == 'PASS'        ${TRUE}        ${FALSE}
        Exit For Loop If                        ${done}
        Run Keyword If                         '${method}' == 'Get'                     Check Throttling          ${resp}
        Exit For Loop If                        ${throttle}
        Sleep                                   5s
    END
    Run Keyword Unless                          ${done} or ${throttle}                  Fail                      can not do ${method} on ${EndPoint} with @{args} &{kwargs}.
    Run Keyword If                              ${throttle}                             Handle Throttling         ${EndPoint}

Check Throttling
    [Arguments]                                 ${response}
    ${throttle}                                 Run Keyword And Return Status           Should Contain            ${response}    ${messages_throttle_error}
    Set Test Variable                           ${throttle}
    IF                                          ${throttle}
        Set Test Variable                       ${throttle_resp}                        ${response}
    END

Handle Throttling
    [Arguments]                                 ${EndPoint}
    Get Throttle Token
    Get Throttle Code
    Rerun Get Method With Throttle Code         ${EndPoint}

Get Throttle Token
    ${throttle_token}                           Fetch From Right                        ${throttle_resp}          'token':${SPACE}'
    ${throttle_token}                           Fetch From Left                         ${throttle_token}         '
    Set Test Variable                           ${throttle_token}

Get Throttle Code
    ${throttle_code}                            Mock Throttling Get code                ${throttle_token}
    Set Test Variable                           ${throttle_code}

Rerun Get Method With Throttle Code
    [Arguments]                                 ${EndPoint}
    Set Headers                                 {"X-CAPTCHA-TOKEN":"${throttle_token}"}
    Set Headers                                 {"X-CAPTCHA-CODE":"${throttle_code}"}
    Wait Until Keyword Succeeds                 3x    5s
    ...        Get                              ${EndPoint}                             timeout=10

##################################################    Content  ################################################################

Set ${Phone_Number} Phone Number
    ${Phone_Number}                 Convert To Lowercase                            ${Phone_Number}
    ${Random_Phone_Number}          Generate Random String                          7                                                              [NUMBERS]
    ${Random_Phone_Number}          Set Variable                                    0900${Random_Phone_Number}
    ${PHONE_NUMBER}                 Set Variable If                                 '${Phone_Number}' == 'random'                                   ${Random_Phone_Number}          ${Phone_Number}
    Set Suite Variable              ${PHONE_NUMBER}
    Set Test Message                *HTML*<b>Mobile:</b>${PHONE_NUMBER}\n           append=True
    [Return]                        ${PHONE_NUMBER}

###################################################   General    #############################################################################
Login To Service
    [Arguments]                     ${Mobile}=${EMPTY}
    Wait Until Keyword Succeeds     3x                2                             Login Helper            ${Mobile}
    [Return]                        ${Headers}

Login Helper
    [Documentation]                 Fast login with no need of phone number
    ...                             Sends token and verification number to login and get x-ticket
    ...                             Logs in using token and verification code to retrieve x-ticket
    [Arguments]                     ${Mobile}=${EMPTY}
    ${Phone_Number_Exists}          Run Keyword And Return Status                   Variable Should Exist                    ${Phone_Number}
    Run Keyword If                  not ${Phone_Number_Exists} and not "${Mobile}"  Set Random Phone Number
    ...                             ELSE IF              "${Mobile}"                Set ${Mobile} Phone Number
    &{Number}                       Create Dictionary                               username=${Phone_Number}
    Post In Retry                   /auth/state-request                             ${NUMBER}     timeout=${10}  headers=&{HEADERS}      validate=false
    Integer                         response status                                 200
    ${token}                        Get String                                      response body token
    ${Verification_Code}            Mock Login Get Code                             ${Phone_Number}
    ${Verification_Body}            Create Dictionary                               mobilePIN=${Verification_Code}            token=${token}
    Sleep                           3
    Post In Retry                   /auth/number-verification                       ${Verification_Body}      timeout=${10}    headers=${HEADERS}     validate=false
    Integer                         response status                                 200
    ${X_TICKET}                     Get String                                      response body x-ticket
    Set To Dictionary               ${Listing_Headers}                              x-ticket                  ${X_TICKET}
    Set Test Variable               ${Headers}                                      ${Listing_Headers}
    Set Test Variable               ${X_TICKET}                                     ${X_TICKET}
    Set Test Message                *HTML*<b>X_TICKET:</b> ${X_TICKET}\n            append=True
    Log To Console                  ${X_TICKET}                                     ${X_TICKET}
    [Return]                        ${Headers}

###################################################   Listings    #############################################################################
Get Random Listing From Serp
    Get In Retry                    /listings                                       validate=false
    ${Listings}                     Get Array                                       response body listings
    ${Listings_Length}              Get Length                                      ${Listings}
    Run Keyword If                  ${Listings_Length} <= 0                         Fail                            PR doesn't have listings
    ${Random_Int}                   Random Int                                      min=3                           max=${Listings_Length-1}
    [Return]                        ${Listings[${Random_Int}]}

Post a Listing
    [Arguments]                     ${headers}=${Listing_Headers}                   ${image_count}=3         ${Custom_Price}=${EMPTY}       &{kwargs}
    ${Random_Listing}               Random Live Listing                             &{kwargs}
    ${category}                     set Variable                                    ${kwargs.get('category','false')}
    ${catType}                      Get Cat Parent Name in Loop                     ${category}                     ${Random_Listing['categoryID']}
    ${Post_Listing_Data}            Decorate Post Listing Request                   ${Random_Listing}               ${catType}              ${Custom_Price}
    ${Image_List}                   Select Images                                   category=cars                   count=${Image_Count}            listing_id=${Random_Listing['listingID']}
    ${Image_List}                   Upload Images Using Api                         ${Image_List}
    Set To Dictionary               ${Post_Listing_Data}                            images                          ${Image_list}
    Post In Retry                   /listings?flavor\=PlayStore                     ${Post_Listing_Data}            headers=${headers}              validate=false
    Integer                         response status                                 200      201     202
    ${Listing_ID}                   Get String                                      response body listingID
    [Return]                        ${Listing_ID}

Get Cat Parent Name in Loop
    [Arguments]                    ${category}                                     ${categoryID}
    FOR    ${INDEX}   IN RANGE  5
      Return From Keyword If       '${category}' != 'false'                        ${category}
      ${Parent}                    Get Cat Parent Name                             ${categoryID}
      ${NoEmpty}                   Run Keyword And Return Status                   Should Not Be Empty    ${Parent}
      Exit For Loop If             ${NoEmpty}
    END
    Return From Keyword            ${Parent}

Decorate Post Listing Request
    [Documentation]                 Decorates json server's listing into post listing request
    [Arguments]                     ${Random_Listing}                               ${catType}                  ${Custom_Price}=${EMPTY}
    ${Post_Listing_Data}            Create Dictionary
    Set To Dictionary               ${Post_Listing_Data}
    ...                             title                                           ${Random_Listing['title']}
    ...                             description                                     ${Random_Listing['description']}
    ...                             categoryID                                      ${Random_Listing['categoryID']}
    ...                             locationID                                      ${Random_Listing['locationID']}
    ...                             locationType                                    ${Random_Listing['locationType']}
    ...                             attributes                                      ${Random_Listing['attributes']}
    ${Price}                        Set Variable                                    ${Random_Listing.get('price')}
    ${Price_Attribute}              Create Dictionary                               attributeID=1                          attributeValue=${Price}
    ${Custome_Price_Attribute}      Create Dictionary             attributeID=1     attributeValue=${Custom_Price}
    Run Keyword If                  '${Price}' != '0'             Append To List    ${Post_Listing_Data['attributes']}     ${Price_Attribute}
    ...    ELSE IF                  '${Custom_Price}'             Append To List    ${Post_Listing_Data['attributes']}     ${Custome_Price_Attribute}
    ${Post_Listing_Data}            Handle New Used Attribute                       ${Post_Listing_Data}                   ${catType}
    [Return]                        ${Post_Listing_Data}

Handle New Used Attribute
    [Arguments]                     ${Post_Listing_Data}                            ${catType}
    &{attributeValue}               Create Dictionary                               لوازم الکترونیکی=90153    لوازم خانگی=90154    لوازم شخصی=90155    ورزش فرهنگ فراغت=90156     صنعتی، اداری و تجاری=90157    موبایل، تبلت و لوازم=90158
    ${Exist}                        Run Keyword And Return Status                   Dictionary Should Contain Key        ${attributeValue}       ${CatType}
    ${attributeID}                  Run Keyword If    ${Exist}                      Get From Dictionary                  ${attributeValue}       ${CatType}
    ...  ELSE                       Set Variable      false
    ${attributes}                   Set Variable                                    ${Post_Listing_Data.get('attributes')}
    ${New_Used_Attribute}           Create Dictionary                               attributeID=${attributeID}               attributeValue=453188
    Run Keyword If                  '${attributeID}' != 'false'                     Append To List
    ...                             ${Post_Listing_Data['attributes']}              ${New_Used_Attribute}
    [Return]                        ${Post_Listing_Data}
