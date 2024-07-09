*** Settings ***
Resource                                    ../../../../resources/versions/v${protools_version}-resource.resource
Suite Setup                                 Set Test Environment
Test Setup                                  Setup Environment


*** Variables ***
${CLIENT_ID}                                CLIENT_ID                                                # Not Important
${CLIENT_SECRET}                            CLIENT_SECRET                                            # Not Important


*** Test Cases ***
Protools Login
    [Tags]                                  api        login
    Register Request Valid
    Register Request Invalid Phone Number
    Authenticate by Password
    Authenticate by Invalid Password
    Authenticate by Refresh Token

*** Keywords ***
Register Request Valid
    Expect Response Body                    ${ROOT_PATH}/api/protools.api.tests/auth/versions/v${protools_version}/schema/register.json
    Post In Retry                           /auth/register                                      {"user_type": "real-estate","cellphone": "${PHONE_NUMBER}"}
    Integer                                 response status                                     200
    String                                  response body cellphone                             "${PHONE_NUMBER}"
    Get User Token
    Get and validate Verification Code

Register Request Invalid Phone Number
    Expect Response Body                    ${ROOT_PATH}/api/protools.api.tests/auth/versions/v${protools_version}/schema/invalid-register-request.json
    Post In Retry                           /auth/register                                      {"user_type": "real-estate","cellphone": "123456789"}
    String                                  response body errors 0 reason                       "لطفا یک شماره تلفن صحیح وارد کنید"
    String                                  response body errors 0 source                       cellphone


Authenticate by Password
    Expect Response Body                    ${ROOT_PATH}/api/protools.api.tests/auth/versions/v${protools_version}/schema/authenticate-by-password.json
    Post In Retry                           /auth/authorize                                      {"client_id": "CLIENT_ID","client_secret": "CLIENT_SECRET","grant_type": "password","scope": "full","username": "${Token}","password": "${Verification_Code}"}
    Get User Refresh Token

Authenticate by Invalid Password
    Expect Response Body                    ${ROOT_PATH}/api/protools.api.tests/auth/versions/v${protools_version}/schema/authenticate-by-invalid-password.json
    Post In Retry                           /auth/authorize                                      {"client_id": "CLIENT_ID","client_secret": "CLIENT_SECRET","grant_type": "password","scope": "full","username": "${Token}","password": "1234"}
    String                                  response body errors 0 reason                        "کد تایید صحیح نمی باشد"
    String                                  response body errors 0 source                        password


Authenticate by Refresh Token
    Clear Expectations
    Post In Retry                           /auth/authorize                                      {"grant_type": "refresh_token","refresh_token": "${Refresh_Token}"}
    Integer                                 response status                                      401
