*** Settings ***
Resource                                      ../../../../resources/versions/v${protools_version}-resource.resource
Suite Setup                                   Set Test Environment
Test Setup                                    Setup Environment


*** Variables ***


*** Test Cases ***
ProTools File/Listing
    [Tags]                                    file    publish     listinglimit
    Set Listing Limit For Cat per locations   parentid=${43603}  catid=${43607}  regid=${8}  cityid=${301}  nghid=${888}  limitcount=${30}  limitprice=${11000}
    Login To Service                          real-estate
    Set Headers                               {"X-Ticket":"${Refresh_Token}"}
    Create a File In Real Estate Category
    Post and Update a Static Listing in Real Estate
    Get Files/Listings
    Get File/Listing Details
    Get File/Listing Details for Edit
    Get Form
    Publish File
    Delete Published File
    Unpublish Listing
    Archive File
    Unarchive File
    Delete File
    Delete Archived File

*** Keywords ***
Create a File In Real Estate Category
    Expect Response                           ${ROOT_PATH}/api/protools.api.tests/listing/versions/v${protools_version}/schema/create-file.json
    ${CategoryId}                             Get From Dictionary                              ${attributes}    category
    Set Test Variable                         ${CategoryId}
    Get Random Listing And Images             ${Attributes}                                     3
    Post In Retry                             /listings                                         ${attributes}
    Integer                                   response status                                   200
    Get User Human Readable Id

Get Files/Listings
    Expect Response                           ${ROOT_PATH}/api/protools.api.tests/listing/versions/v${protools_version}/schema/get-real-estate-file.json
    Get In Retry                              /listings?active=true&published=false
    Integer                                   response status                                  200

Get File/Listing Details
    Expect Response                           ${ROOT_PATH}/api/protools.api.tests/listing/versions/v${protools_version}/schema/get-real-estate-file-details.json
    Get In Retry                              /listings/${human_readable_id}                   validate=false
    ${Title}                                  Get String                                       response body title
    Should Be Equal                           ${Title}                                         اجاره اداری 150 متر در اختیاریه
    Integer                                   response status                                  200

Get File/Listing Details for Edit
    Expect Response                           ${ROOT_PATH}/api/protools.api.tests/listing/versions/v${protools_version}/schema/edit-real-estate-file-details.json
    Get In Retry                              /listings/${human_readable_id}/edit
    Integer                                   response status                                  200

Get Form
    Expect Response                           ${ROOT_PATH}/api/protools.api.tests/listing/versions/v${protools_version}/schema/get-real-estate-form.json
    Get In Retry                              /listings/form/${CategoryId}
    Integer                                   response status                                  200

Publish File
    ${Random_Live_Listing}                    Random Live Listing                              ${Attributes['category']}                image=${false}
    ${Body}                                   Create Dictionary                                name=${Random_Live_Listing['title']}     description=${Random_Live_Listing['description']}     telephone=${PHONE_NUMBER}
    Expect Response                           ${ROOT_PATH}/api/protools.api.tests/listing/versions/v${protools_version}/schema/publish-real-estate-file.json
    Post In Retry                             /listings/${human_readable_id}/publish           ${Body}
    Integer                                   response status                                  200

Delete Published File
    # Expect Response                           ${ROOT_PATH}/api/protools.api.tests/listing/versions/v${protools_version}/schema/delete-published-file.json
    Clear Expectations
    Delete In Retry                           /listings/${human_readable_id}
    Integer                                   response status                                  403
    # String                                    $.error                                          شما اجازه ی دسترسی به این صفحه را ندارید.

Unpublish Listing
    ${Random_Live_Listing}                    Random Live Listing                              ${Attributes['category']}                image=${false}
    ${Body}                                   Create Dictionary                                name=${Random_Live_Listing['title']}     description=${Random_Live_Listing['description']}     telephone=${PHONE_NUMBER}
    Expect Response                           ${ROOT_PATH}/api/protools.api.tests/listing/versions/v${protools_version}/schema/publish-real-estate-file.json
    Post In Retry                             /listings/${human_readable_id}/publish           ${Body}
    Integer                                   response status                                  200
    ${Body}                                   Create Dictionary                                name=${Random_Live_Listing['title']}     description=${Random_Live_Listing['description']}     telephone=${PHONE_NUMBER}
    Clear Expectations
    Expect Response                           ${ROOT_PATH}/api/protools.api.tests/listing/versions/v${protools_version}/schema/unpublish-real-estate-file.json
    Post In Retry                             /listings/${human_readable_id}/unpublish         ${Body}
    Integer                                   response status                                  200

Archive File
    Get Random Listing And Images             ${Attributes}
    Post In Retry                             /listings                                        ${attributes}                            validate=false
    Integer                                   response status                                  200
    Get User Human Readable Id
    Expect Response                           ${ROOT_PATH}/api/protools.api.tests/listing/versions/v${protools_version}/schema/archive-real-estate-file.json
    Post In Retry                             /listings/${human_readable_id}/archive
    Integer                                   response status                                  200

Unarchive File
    Expect Response                           ${ROOT_PATH}/api/protools.api.tests/listing/versions/v${protools_version}/schema/unarchive-real-estate-file.json
    Post In Retry                             /listings/${human_readable_id}/unarchive
    Integer                                   response status                                  200

Delete File
    Expect Response                           ${ROOT_PATH}/api/protools.api.tests/listing/versions/v${protools_version}/schema/delete-real-estate-file.json
    Delete In Retry                           /listings/${human_readable_id}
    Integer                                   response status                                  200
    Delete In Retry                           /listings/${human_readable_id}                   validate=false
    Integer                                   response status                                  404

Delete Archived File
    Get Random Listing And Images             ${Attributes}
    Post In Retry                             /listings                                        ${attributes}                                validate=false
    Integer                                   response status                                  200
    Get User Human Readable Id
    Post In Retry                             /listings/${human_readable_id}/archive                                                         validate=false
    Integer                                   response status                                  200
    Delete In Retry                           /listings/${human_readable_id}
    Expect Response                           ${ROOT_PATH}/api/protools.api.tests/listing/versions/v${protools_version}/schema/delete-archived-file.json
    Integer                                   response status                                  200
    Delete In Retry                           /listings/${human_readable_id}                   validate=false
    Integer                                   response status                                  404
