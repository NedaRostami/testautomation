*** Settings ***
Documentation                       Base resource file for protools tests
Resource                            ../../resources/all.resource
Variables                           ../variables/Variables.py                   ${trumpet_prenv_id}        ${protools_version}    ${ServerType}
Library                             FakerLibrary                                locale=fa_IR
Library                             Collections
Library                             String
Library                             OperatingSystem
Library                             REST                                        ${SERVER}/api/protools/v${protools_version}


*** Variables ***
${ROOT_PATH}                        ${CURDIR}/..
${RESOURCE_IMAGE}                   ${CURDIR}${/}images
${Image_Path}                       ${RESOURCE_IMAGE}${/}image1.jpg
&{HEADERS}                          Content-Type=application/json;
&{Listing_Headers}                  Content-Type=Application/json                User-Agent=Android/8.1 Sheypoor/5.1.2-Debug-PlayStore VersionCode/594 Manufacturer/Samsung Model/Samsung Galaxy S10 E - 8.1 - API 27 - 1080x2280    Referrer=Post_Listing     Phone-Base=True     X-AGENT-TYPE=Android App    Connection=keep-alive
&{Attributes}                       location=n888   a68097=440482   a68085=150   a68191=false   category=43607

*** Keywords ***
#################################################  Environment  ############################################################################################
Setup Environment
    Set Test Message                *HTML*<b>Version:</b>${protools_version}\n           append=True
    Set Random Phone Number


Set Test Environment
    [Documentation]                 Defines test environment
      Set Log Level                 Trace
      Set Tags                      v${protools_version}

##################################################    Content  ################################################################
Set ${Phone_Number} Phone Number
    ${Phone_Number}                 Convert To Lowercase                        ${Phone_Number}
    ${Random_Phone_Number}          Generate Random String                      7                                                              [NUMBERS]
    ${Random_Phone_Number}          Set Variable                                0900${Random_Phone_Number}
    ${PHONE_NUMBER}                 Set Variable If                             '${Phone_Number}' == 'random'                                   ${Random_Phone_Number}          ${Phone_Number}
    Set Suite Variable              ${PHONE_NUMBER}
    Set Test Message                *HTML*<b>Mobile:</b>${PHONE_NUMBER}\n       append=True
    [Return]                        ${PHONE_NUMBER}

Title And Description Maker
    Get Random Live Listing
    Set Suite Variable              ${Real_Description}      ${Random_Live_Listing['description']}
    Set Suite Variable              ${Real_Title}            ${Random_Live_Listing['title']}

    ###################################################   General    #############################################################################
Get Verification Code
    [Arguments]                             ${Number}=${PHONE_NUMBER}
    Sleep                                   2s
    # Import Library                          REST                                        ${SERVER}/api/protools/v${protools_version}
    # GET                                     ${SERVER}/mock/getCode?mobile=${Number}    validate=false
    # ${Verification_Code}                    Get String                                 response body code
    ${Verification_Code}                    Mock Login Get Code                          ${Number}
    Should Match Regexp	                    ${Verification_Code}	                     ^\\d{4}$
    Set Test Variable                       ${Verification_Code}

Get and validate Verification Code
     [Arguments]                                ${MobileNo}=${PHONE_NUMBER}
     Wait Until Keyword Succeeds    3x    2s    Get Verification Code    ${MobileNo}
     Sleep              2s

Setup Expect Response
    [Arguments]                             ${Path}
    Setup Environment
    Expect Response                         ${Path}

Login To Service
    [Arguments]                             ${RegisterCategory}                                 ${Default_PHONE_NUMBER}=${PHONE_NUMBER}
    Post In Retry                           /auth/register                                      {"user_type": "${RegisterCategory}","cellphone": "${Default_PHONE_NUMBER}"}                                    validate=false
    Integer                                 response status                                      200
    Get User Token
    Get and validate Verification Code      ${Default_PHONE_NUMBER}
    Post In Retry                           /auth/authorize                                     {"client_id": "CLIENT_ID","client_secret": "CLIENT_SECRET","grant_type": "password","scope": "full","username": "${Token}","password": "${Verification_Code}"}            validate=false
    Integer                                 response status                                      200
    Get User Refresh Token

Get User Token
    ${Token}                                Get String                                          response body token
    Set Suite Variable                      ${Token}                                            ${Token}

Get User Refresh Token
    ${Refresh_Token}                        Get String                                          response body refresh_token
    Set Suite Variable                      ${Refresh_Token}                                    ${Refresh_Token}

Get User Human Readable Id
    ${human_readable_id}                    Get String                                          response body human_readable_id
    Set Suite Variable                      ${human_readable_id}                                ${human_readable_id}


    ###################################################   Listings    #############################################################################
Post and Update a Static Listing in Real Estate
    Set Listing Limit For Cat per locations   parentid=${43603}  catid=${43606}  regid=${8}  cityid=${301}  nghid=${930}  limitcount=${30}  limitprice=${11000}
    &{DICT}                                   Create Dictionary                                   category=43606   location=n930    a68090=8000000   a68092=1000000   a68085=85    a68096=440477    a68133=439414    a92367=455203
    Get Random Listing And Images             ${Dict}
    Post In Retry                             /listings                                           ${Dict}
    Integer                                   response status                                     200
    ${human_readable_id}                      Get String                                          response body human_readable_id
    Set To Dictionary                         ${Dict}                                             a68092=2000000   a68085=98
    Post In Retry                             /listings/${human_readable_id}                      ${Dict}
    Integer                                   response status                                     200

Post and Update a Static Listing in Car Category
    Set Listing Limit For Cat per locations    parentid=${43626}  catid=${43627}  regid=${8}  cityid=${301}  nghid=${1324}  limitcount=${30}  limitprice=${11000}
    &{DICT}                                    Create Dictionary                                   category=44118   location=n1324    a68194=442025   a68101=1390   a68102=2000   a69130=445243   a69140=445308   a69160=445317   a69601=450672
    Get Random Listing And Images              ${Dict}
    Post In Retry                              /listings                                           ${Dict}
    Integer                                    response status                                     200
    ${human_readable_id}                       Get String                                          response body human_readable_id
    Set To Dictionary                          ${Dict}                                             a68101=1394   a68102=15000
    Post In Retry                              /listings/${human_readable_id}                      ${Dict}
    Integer                                    response status

Verify Advertise By ID
    Trumpet adv          accept             ${human_readable_id}

Reject Advertise By ID
    Trumpet adv          reject             ${human_readable_id}

Delete Advertise By ID
    Trumpet adv          delete             ${human_readable_id}


Trumpet adv
    [Arguments]   ${Kind}    ${listingId}
    Wait Until Keyword Returns True    3x    2s     Mock Listing Moderate    ${Kind}     ${listingId}


Wait Until Keyword Returns True
    [Arguments]    ${timeout}    ${retry_interval}    ${name}    @{args}
    Wait Until Keyword Succeeds    ${timeout}    ${retry_interval}    Keyword Should Return True    ${name}    @{args}


Keyword Should Return True
    [Arguments]    ${name}    @{args}
    ${ret_val}=    Run Keyword    ${name}    @{args}
    Should Be Equal    ${ret_val}    ${True}

Get Random Live Listing
    [Arguments]                     @{args}                     &{kwargs}
    ${Random_Live_Listing}          Random Live Listing         @{args}                                 &{kwargs}
    Set Test Variable               ${Random_Live_Listing}      ${Random_Live_Listing}

Get Random Listing Attribute
    [Arguments]                     ${Attr}                     ${Category}=43604
    Get Random Live Listing         ${Category}
    Set Suite Variable              ${Random_Attr}              ${Random_Live_Listing['${Attr}']}
    [Return]                        ${Random_Attr}

Get Random Listing And Images
    [Arguments]                     ${Listing}                  ${Count}=${3}                           ${image_category}=house
    ${Random_Live_Listing}          Random Live Listing         ${Listing['category']}
    ${Image_List}                   Select Images               ${image_category}                       ${Count}            ${Random_Live_Listing['listingID']}
    ${Images}                       Upload Image List           ${Image_List}
    Set Suite Variable              ${Random_Live_Listing}
    Set To Dictionary               ${Listing}                  images                                  ${Images}
    [Return]                        ${Listing}

Upload Image
    [Arguments]                     ${Image}
    post in retry                   /image                      {"image":"${image.base64}"}             validate=false
    Integer                         response status             200
    ${Image_ID}                     Get String                  response body id
    [Return]                        ${Image_ID}

Upload Image List
    [Arguments]                     ${Image_List}
    ${Image_List}                   Convert To List             ${Image_List}
    ${Image_Path_List}              Create List
    FOR         ${I}        IN      @{Image_List}
        ${Image_ID}                 Upload Image                ${I}
        Append To List              ${Image_Path_List}          ${Image_ID}
    END
    [Return]                        ${Image_Path_List}

Get Random Listing
    [Arguments]                     ${SubCatID}     ${attribute_id}=None    ${option_id}=None
    ${Random_Listing}               Random Live Listing                 category=${SubCatID}    attribute_id=${attribute_id}    option_id=${option_id}
    FOR   ${key}       IN                           @{Random_Listing.keys()}
        ${randomKey}     Get From Dictionary        ${Random_Listing}                  ${key}
        Set Suite Variable                          ${Listings_${key}}                   ${randomKey}
    END
###################################################   Shop    #############################################################################
