*** Settings ***
Resource                                    ../../../../resources/versions/v${protools_version}-resource.resource
Suite Setup                                 Set Test Environment
Test Setup                                  Setup Environment


*** Variables ***



*** Test Cases ***
Upload Base64 Image To ProTools
    Get a Random Image
    Login To Service                        real-estate
    Set Headers                             {"X-Ticket":"${Refresh_Token}"}
    Post In Retry                           /image                      {"image":"${image.base64}"}
    Integer                                 response status             200
    ${image_id}                             Get String                  response body id
    Set Suite Variable                      ${image_id}                 ${image_id}
    Should End With                         ${image_id}                 .jpg

Get Image In ProTools
    Get In Retry                            /image/${image_id}
    Integer                                 response status             200

*** Keywords ***
Get a Random Image
    ${Image_List}                           Select Images               category=house
    ${Image}                                Set Variable                ${Image_List[0]}
    Set Test Variable                       ${Image}                    ${Image}
