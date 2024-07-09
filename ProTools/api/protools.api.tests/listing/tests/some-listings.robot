*** Settings ***
Resource                                      ../../../../resources/versions/v${protools_version}-resource.resource
Suite Setup                                   Set Test Environment
Test Setup                                    Setup Environment


*** Variables ***


*** Test Cases ***
Create Some Listings In Real Estate Category
    Create Shop In Sheypoor And Get Members Phone Numbers
    Create Some Listings                      4                                                 ${Shop_owner_phone}
    Create Some Listings                      3                                                 ${Consultant_Phones[0]}
    Create Some Listings                      2                                                 ${Consultant_Phones[1]}
    Create Some Listings                      1                                                 ${Secretary_Phones[0]}

*** Keywords ***
Create Shop In Sheypoor And Get Members Phone Numbers
    Create Shop In Sheypoor
    ${Consultant_Phones}                      Get Values From List                               ${Shop_Consultant_List}                  phone
    Set Test Variable                         ${Consultant_Phones}
    ${Secretary_Phones}                       Get Values From List                               ${Shop_Secretary_List}                   phone
    Set Test Variable                         ${Secretary_Phones}

Create Some Listings
    [Arguments]                               ${Repeat}                                          ${Phone_Number}
    Login To Service                          real-estate                                        ${Phone_Number}
    Set Headers                               {"X-Ticket":"${Refresh_Token}"}
    Set Listing Limit For Cat per locations   parentid=${43603}  catid=${43607}  regid=${8}  cityid=${301}  nghid=${888}  limitcount=${30}  limitprice=${11000}
    FOR    ${INDEX}     IN RANGE    0         ${Repeat}
      Create a File In Real Estate Category
      ${Title}                                  Get String                                       response body title
      Should Be Equal                           ${Title}                                         اجاره اداری 150 متر در اختیاریه
      ${Random_Live_Listing}                    Random Live Listing                              ${Attributes['category']}                image=${false}
      ${Body}                                   Create Dictionary                                name=${Random_Live_Listing['title']}     description=${Random_Live_Listing['description']}     telephone=${PHONE_NUMBER}
      Post In Retry                             /listings/${human_readable_id}/publish           ${Body}
      Integer                                   response status                                  200
      Verify Advertise By ID
    END

Create a File In Real Estate Category
    Get Random Listing And Images             ${Attributes}                                      3
    Post In Retry                             /listings                                          ${attributes}
    Integer                                   response status                                    200
    Get User Human Readable Id
    Get In Retry                              /listings/${human_readable_id}
    Integer                                   response status                                    200
