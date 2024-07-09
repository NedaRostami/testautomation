*** Settings ***
Resource                                    ../../../../resources/versions/v${protools_version}-resource.resource
Suite Setup                                 Set Test Environment
Test Setup                                  Setup Environment


*** Variables ***



*** Test Cases ***
Get User Profile
    Expect Response Body                    ${ROOT_PATH}/api/protools.api.tests/config/versions/v${protools_version}/schema/car-config.json
    Get In Retry                            /config?ut=car-sale
    Integer                                 response status                                    200

*** Keywords ***
