*** Settings ***
Resource                                      ../../../../resources/versions/v${protools_version}-resource.resource
Suite Setup                                   Set Test Environment
Test Setup                                    Setup Environment


*** Variables ***



*** Test Cases ***
Get Team Members
    [Tags]                                     Team       Add_Member       Kick_Member
    Expect Response Body                      ${ROOT_PATH}/api/protools.api.tests/team/versions/v${protools_version}/schema/get-team-info.json
    Create Shop In Sheypoor
    Login To Service                          real-estate                                      ${Shop_owner_phone}
    Set Headers                               {"X-Ticket":"${Refresh_Token}"}
    Validate Get Team Members
    Add And Kick Team Member

*** Keywords ***
Get Cellphones From Response
    FOR    ${INDEX}    IN RANGE       0       3
      ${Member_List}                          Get Array                                        response body groups ${INDEX} members
      ${Phone_Number_List}                    Get Values From List                             ${Member_List}        cellphone
      List Should Not Contain Value           ${Phone_Number_List}                             ${PHONE_NUMBER}
    END

Validate Member Is Added
    Expect Response Body                      ${ROOT_PATH}/api/protools.api.tests/team/versions/v${protools_version}/schema/add-member.json
    Post In Retry                             /team/add                                        {"cellphone": "${PHONE_NUMBER}", "role":"secretary"}
    Integer                                   response status                                  200
    Get In Retry                              /team                                            validate=false
    # String                                    response body groups 1 members 1 cellphone       ${PHONE_NUMBER}
    ${A}                                      String                                           response body groups 1 members 0 cellphone
    ${B}                                      String                                           response body groups 1 members 1 cellphone
    ${secretary_members}                      Create List                                      ${A}[0]   ${B}[0]
    Append To List                            ${Secretary_Phones}                              ${PHONE_NUMBER}
    Compare lists                             ${secretary_members}	                           ${Secretary_Phones}

Validate Duplicate Phone Number Can Not Be Added
    Post In Retry                             /team/add                                        {"cellphone": "${PHONE_NUMBER}", "role":"secretary"}           validate=false
    Integer                                   response status                                  400
    String                                    response body error                              کاربری با این شماره در این فروشگاه وجود دارد.

Validate Member Is Kicked
    Expect Response Body                      ${ROOT_PATH}/api/protools.api.tests/team/versions/v${protools_version}/schema/kick-member.json
    Set Headers                               {"source":"protools"}
    Post In Retry                             /team/kick                                       {"cellphone": "${PHONE_NUMBER}"}
    Integer                                   response status                                  200
    Get In Retry                              /team                                            validate=false
    Get Cellphones From Response

Validate Get Team Members
    Get In Retry                              /team
    Integer                                   response status                                  200
    String                                    response body groups 0 title                     مدیر
    String                                    response body groups 0 members 0 cellphone       ${Shop_owner_phone}
    String                                    response body groups 1 title                     منشی
    String                                    response body groups 1 members 0 cellphone       ${Secretary_Phones[0]}
    String                                    response body groups 2 title                     مشاور
    # String                                    response body groups 2 members 0 cellphone       ${Consultant_Phones[0]}
    # String                                    response body groups 2 members 1 cellphone       ${Consultant_Phones[1]}
    ${A}                                      String                                           response body groups 2 members 0 cellphone
    ${B}                                      String                                           response body groups 2 members 1 cellphone
    ${cons_members}                           Create List                                      ${A}[0]   ${B}[0]
    Compare lists                             ${cons_members}	                               ${Consultant_Phones}

Add And Kick Team Member
    Validate Member Is Added
    Validate Duplicate Phone Number Can Not Be Added
    Validate Member Is Kicked

Compare lists
   [arguments]                                ${A}        ${B}
   Sort List                                  ${A}
   Sort List                                  ${B}
   Lists Should Be Equal	                    ${A}        ${B}
