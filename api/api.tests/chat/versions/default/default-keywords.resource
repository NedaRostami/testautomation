*** Settings ***
Resource                            ../../../../resources/resource.resource

*** Variables ***
${Chat_Info_Schema}                 ${ROOT_PATH}/api.tests/chat/versions/v${api_version}/schema/chat-info.json
${Chat_ID_Schema}                   ${ROOT_PATH}/api.tests/chat/versions/v${api_version}/schema/chat-id.json
${Chat_Suggestions_Schema}          ${ROOT_PATH}/api.tests/chat/versions/v${api_version}/schema/chat-suggestion.json
${Chat_Report_Reason_Schema}        ${ROOT_PATH}/api.tests/chat/versions/v${api_version}/schema/chat-report-reason.json
${Chat_Report_User_Schema}          ${ROOT_PATH}/api.tests/chat/versions/v${api_version}/schema/chat-report-user.json
${Chat_Settings_Schema}             ${ROOT_PATH}/api.tests/chat/versions/v${api_version}/schema/chat-settings.json


*** Keywords ***
Update Chat Settings With Notifications ${Notification}, Chat Enabled ${Enabled} And Nickname ${Nickname}
    Login To Service
    ${Chat_Settings}                Create Dictionary                   chatNotifications=${Notification}
    ...                             isChatEnabled=${Enabled}            nickname=${Nickname}
    Post In Retry                   /chat/settings                      ${Chat_Settings}            headers=${Headers}
    Integer                         response status                     200

Login As User One
    ${User_One_Number}              Set Random Phone Number
    ${User_One_Headers}             Login To Service                    ${User_One_Number}
    Set Test Variable               ${User_One_Number}                  ${User_One_Number}
    Set Test Variable               ${User_One_Headers}                 ${User_One_Headers}

Login As User Two
    ${User_Two_Number}              Set Random Phone Number
    ${User_Two_Headers}             Login To Service                    ${User_Two_Number}
    Set Test Variable               ${User_Two_Number}                  ${User_Two_Number}
    Set Test Variable               ${User_Two_Headers}                 ${User_Two_Headers}

Post a Listing As User One
    ${Listing_ID}                   Post A Listing                      headers=${User_One_Headers}
    Mock Listing Moderate           accept                              ${Listing_ID}
    Set Test Variable               ${Listing_ID}                       ${Listing_ID}

Get Chat ID
    Expect Response                 ${Chat_ID_Schema}
    Get In Retry                    /listings/${Listing_ID}/contact/chat?referrer=1
    Integer                         response status                     200
    ${Chat_ID}                      Get String                          response body contactInfo
    Set Test Variable               ${Chat_ID}                          ${Chat_ID}

Get Listing Chat Info
    Expect Response                 ${Chat_Info_Schema}
    Get In Retry                    /chat/listings/${Listing_Id}        headers=${User_Two_Headers}
    Integer                         response status                     200
    Integer                         response body listingID             ${Listing_ID}

Get Chat Suggestions
    Expect Response                 ${Chat_Suggestions_Schema}
    Get In Retry                    /chat/suggestions                   headers=${User_Two_Headers}
    Integer                         response status                     200

Get Chat Report Reasons
    Expect Response                 ${Chat_Report_Reason_Schema}
    Get In Retry                    /chat/report/reasons                headers=${User_Two_Headers}
    Integer                         response status                     200
    ${Reason_Id_List}               Get Array                           response body
