*** Settings ***
Resource                                      ../../../../resources/versions/v${protools_version}-resource.resource
Suite Setup                                   Set Test Environment
Test Setup                                    Setup Environment


*** Variables ***


*** Test Cases ***
Phone Book In ProTools
    Create Shop In Sheypoor
    Login To Service                          real-estate                                      ${Shop_owner_phone}
    Set Headers                               {"X-Ticket":"${Refresh_Token}"}
    GET User Phone Book
    GET Phone Book Type
    Add Member To Phone Book
    Edit Phone Book
    Delete Member From Phone Book
    Search In Phone Book

*** Keywords ***
GET User PhoneBook
    Get In Retry                              /phonebook
    Integer                                   response status                                  200

GET Phone Book Type
    Expect Response Body                      ${ROOT_PATH}/api/protools.api.tests/phone_book/versions/v${protools_version}/schema/phone_book_type.json
    Get In Retry                              /phonebook/type
    Integer                                   response status                                  200

Add Member To Phone Book
    Expect Response Body                      ${ROOT_PATH}/api/protools.api.tests/phone_book/versions/v${protools_version}/schema/phone_book_add_member.json
    Create Phone Book Member
    Post In Retry                             /phonebook/add                                   {"name":"${Faker_Name}", "telephone":"${Faker_Phone_Number}", "pin":"true", "userType":[15]}
    Integer                                   response status                                  200
    String                                    response body message                           مخاطب با موفقیت ذخیره شد

Create Phone Book Member
    ${Faker_Name}                             FakerLibrary.Name
    Set Test Variable                         ${Faker_Name}
    ${Faker_Phone_Number}                     Generate Random String                           8             [NUMBERS]
    Set Test Variable                         ${Faker_Phone_Number}                            021${Faker_Phone_Number}

Edit Phone Book
    Expect Response Body                      ${ROOT_PATH}/api/protools.api.tests/phone_book/versions/v${protools_version}/schema/phone_book_edit_member.json
    Add Member To Phone Book
    Get In Retry                              /phonebook                                       validate=false
    ${Id}                                     Get Integer                                      response body 0 id
    ${UserId}                                 Get Integer                                      response body 0 userId
    Post In Retry                             /phonebook/edit/${Id}                            {"name":"${Faker_Name}", "telephone":"${Faker_Phone_Number}", "userId":${UserId}, "pin":true, "userType":[10]}
    Integer                                   response status                                  200
    String                                    response body message                            مخاطب با موفقیت ویرایش شد

Delete Member From Phone Book
    Expect Response Body                      ${ROOT_PATH}/api/protools.api.tests/phone_book/versions/v${protools_version}/schema/phone_book_delete_member.json
    Add Member To Phone Book
    Get In Retry                              /phonebook                                       validate=false
    ${Id}                                     Get Integer                                      response body 0 id
    Delete In Retry                           /phonebook/delete/${Id}
    Integer                                   response status                                  200
    String                                    response body message                            مخاطب با موفقیت حذف شد

Search In Phone Book
    @{Members}                                Create List
    FOR  ${index}  IN RANGE   0   5
      Add Member To Phone Book
      Append To List                          ${Members}               ${Faker_Name}
    END
    Get In Retry                              /phonebook?q=${Members[2]}                       validate=false
    ${FilteredName}                           Get String                                       response body 0 name
    Should Be Equal                           ${Members[2]}            ${FilteredName}
    [Return]                                  @{Members}
