*** Settings ***
Resource                                    ../../../../resources/versions/v${protools_version}-resource.resource
Suite Setup                                 Set Test Environment
Test Setup                                  Setup Environment


*** Variables ***



*** Test Cases ***
Get User Profile
    Login To Service                        real-estate
    Set Headers                             {"X-Ticket":"${Refresh_Token}"}
    Set Headers                             {"source":"protools"}
    Get In Retry                            /profile
    String                                  response body cellphone                            ${PHONE_NUMBER}
    Integer                                 response status                                    200
    Edit User profile
    Expect Response Body                    ${ROOT_PATH}/api/protools.api.tests/profile/versions/v${protools_version}/schema/profile.json
    Get In Retry                            /profile
    String                                  response body full_name                            ProTools Test

*** Keywords ***
Edit User profile
    Post In Retry                           /profile                                           {"full_name": "ProTools Test"}
    Integer                                 response status                                    200
