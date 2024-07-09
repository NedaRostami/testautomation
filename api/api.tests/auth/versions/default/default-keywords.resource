*** Settings ***
Resource                                ../../../../resources/resource.resource

*** Keywords ***
State Request Invalid Phone Number
    Expect Response                     ${ROOT_PATH}/api.tests/auth/versions/v${api_version}/schema/invalid-state-request.json
    Post In Retry                       /auth/state-request                                 {"username": "123456789"}
    String                              response body error errorMessage                    "لطفا یک ایمیل یا شماره موبایل صحیح وارد کنید"
    Integer                             response body error errorCode

Number Verification Valid
    Expect Response                     ${ROOT_PATH}/api.tests/auth/versions/v${api_version}/schema/number-verification.json
    Post In Retry                       /auth/number-verification                           {"token": "${Token}", "mobilePIN": "${Verification_Code}"}
    String                              response body mobileNumber                          ${PHONE_NUMBER}

Number Verification Invalid Token
    Expect Response                     ${ROOT_PATH}/api.tests/auth/versions/v${api_version}/schema/invalid-number-verification.json
    Post In Retry                       /auth/number-verification                           {"token": "${Token}", "mobilePIN": "${Verification_Code}"}
    String                              response body error errorMessage                    "در خواست نامعتبر است"
    Integer                             response body error errorCode

Invalid Number Verification Invalid Verification Code
    Expect Response                     ${ROOT_PATH}/api.tests/auth/versions/v${api_version}/schema/invalid-number-verification.json
    Post In Retry                       /auth/number-verification                           {"token": "${Token}", "mobilePIN": "2569"}
    Integer                             response body error errorCode

State Request Valid
    Expect Response                     ${ROOT_PATH}/api.tests/auth/versions/v${api_version}/schema/state-request.json
    Set Random Phone Number
    Post In Retry                       /auth/state-request                                 {"username": "${PHONE_NUMBER}"}
    String                              response body message                               "یک کد تایید به شماره موبایل شما ارسال شد"
    Get User Token
    ${Verification_Code}                Mock Login Get Code                                 ${Phone_Number}
    Set Test Variable                   ${Verification_Code}

Get User Token
    ${Token}                            Get String                                          response body token
    Set Suite Variable                  ${Token}                                            ${Token}
