*** Settings ***
Resource                                      ../../../../resources/versions/v${protools_version}-resource.resource
Suite Setup                                   Set Test Environment
Test Setup                                    Setup Environment


*** Variables ***


*** Test Cases ***
ProTools File Bank
    [Tags]                                    notest
    Login To Service                          real-estate
    Set Headers                               {"X-Ticket":"${Refresh_Token}"}
    Set Headers                               {"source":"protools"}
    Get File Bank Packages
    Select File Bank Packages
    Buy File Bank Packages
    Get File Bank Purchased
    Filter Purchased Files
    Save Purchased File To File Management

*** Keywords ***
Get File Bank Packages
    Get In Retry                              /filebank
    Integer                                   response status                                  200
    String                                    response body 0 packageId                        1
    String                                    response body 0 packageName                      انتخاب کل یک شهر
    String                                    response body 0 packageDescription               بسته فایلینگ کل یک شهر
    String                                    response body 1 packageId                        2
    String                                    response body 1 packageName                      انتخاب هفت محله از یک شهر
    String                                    response body 1 packageDescription               بسته فایلینگ هفت محله از یک شهر
    String                                    response body 2 packageId                        3
    String                                    response body 2 packageName                      انتخاب سه محله از یک شهر
    String                                    response body 2 packageDescription               بسته فایلینگ سه محله از یک شهر

Select File Bank Packages
    Post In Retry                             /filebank/package/select                        {"packageId":"3","filter":{"typeId":"301","typeChildCount":"3","typeChildId":[931,933]}}
    Integer                                   response status                                  200
    String                                    response body 0 packageId                        3
    String                                    response body 0 ruleName                        اشتراک یک ماهه

Buy File Bank Packages
    Post In Retry                             /filebank/package/buy                           {"packageId":"3","ruleId":"5","duration":"30","detail":"تهران > تهران آذربایجان,آرژانتین","filter":{"typeId":"301","typeChildId":[931,933]}}
    Integer                                   response status                                  200
    String                                    response body url                                format=url
    ${url}                                    Get String                                       response body url
    Set Test Variable                         ${url}

Get File Bank Purchased
    Pay Successfuly The Payment link
    Get In Retry                              /filebank/package/purchased
    Integer                                   response status                                  200
    ${slug}                                   Get String                                       response body 0 slug
    Set Test Variable                         ${slug}
    String                                    response body 0 packageId                        3
    String                                    response body 0 packageName                      بسته فایلینگ سه محله از یک شهر

Pay Successfuly The Payment link
    Import Library                            SeleniumLibrary
    Open Browser                              ${url}                                            headlesschrome
    Wait Until Page Contains                  پرداخت شما با موفقیت انجام شد                     timeout=30s

Filter Purchased Files
    Get In Retry                              /filebank/package/listing/filter/${slug}
    Integer                                   response status                                  200
    ${files}                                  Array                                            response body items
    Set Test Variable                         ${files}

Save Purchased File To File Management
    Post In Retry                             /filebank/save/file                              ${files}
    Integer                                   response status                                  200
    String                                    response body message                            به مدیریت فایل افزوده شد
