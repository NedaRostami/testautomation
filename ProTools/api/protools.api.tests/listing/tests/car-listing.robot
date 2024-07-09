*** Settings ***
Resource                                      ../../../../resources/versions/v${protools_version}-resource.resource
Suite Setup                                   Set Test Environment
Test Setup                                    Setup Environment


*** Variables ***


*** Test Cases ***
ProTools File/Listing
    set static car data
    Login To Service                          car-sale
    Set Headers                               {"X-Ticket":"${Refresh_Token}"}
    Create a File In Car Category
    Post and Update a Static Listing in Car Category
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
set static car data
    ${Car_Attributes}                         Create Dictionary      a69601=450672  a68101=2018  a68102=624   a69130=445303
    ...  a69140=445308   a69150=445097   a69160=445327   a69600=450671   a69602=450678   a69603=[450686,450694,450679]
    ...  a69604=[450699,450697,450698,450696]   a69605=[450706,450707,450709,450705]   category=43627   location=698   price=105000000
    Set Suite Variable                        ${Car_Attributes}

Create a File In Car Category
    Set Listing Limit For Cat per locations   parentid=${43626}  catid=${43627}  regid=${18}  cityid=${698}  nghid=${EMPTY}  limitcount=${30}  limitprice=${11000}
    Expect Response Body                      ${ROOT_PATH}/api/protools.api.tests/listing/versions/v${protools_version}/schema/create-file.json
    Get Random Listing And Images             ${Car_Attributes}                                image_category=cars
    Set To Dictionary                         ${Car_Attributes}
    ${CategoryId}                             Get From Dictionary                              ${Car_Attributes}    category
    Set Test Variable                         ${CategoryId}
    Post In Retry                             /listings                                        ${Car_Attributes}
    Log Variables
    Integer                                   response status                                  200
    Get User Human Readable Id

Get Files/Listings
   Set Headers                               {"X-Ticket":"${Refresh_Token}"}
   Get In Retry                              /listings?active=true&published=false
   Integer                                   response status                                  200

Get File/Listing Details
    Expect Response Body                      ${ROOT_PATH}/api/protools.api.tests/listing/versions/v${protools_version}/schema/get-car-sale-file-details.json
    Get In Retry                              /listings/${human_readable_id}
    ${Title}                                  Get String                                       response body title
    # Should Be Equal                           ${Title}                                         ${Random_Live_Listing['title']}
    Integer                                   response status                                  200

Get File/Listing Details for Edit
   Expect Response Body                     ${ROOT_PATH}/api/protools.api.tests/listing/versions/v${protools_version}/schema/edit-car-sale-file-details.json
   Get In Retry                              /listings/${human_readable_id}/edit
   Integer                                   response status                                  200

Get Form
   Expect Response Body                      ${ROOT_PATH}/api/protools.api.tests/listing/versions/v${protools_version}/schema/get-car-sale-form.json
   Get In Retry                              /listings/form/${CategoryId}                     validate=false
   Integer                                   response status                                  200

Publish File
    ${Random_Live_Listing}                    Random Live Listing                              ${Car_Attributes['category']}            image=${false}
    ${Body}                                   Create Dictionary                                name=${Random_Live_Listing['title']}     description=${Random_Live_Listing['description']}     telephone=${PHONE_NUMBER}
    Expect Response Body                     ${ROOT_PATH}/api/protools.api.tests/listing/versions/v${protools_version}/schema/publish-file.json
    Post In Retry                             /listings/${human_readable_id}/publish           ${Body}
    Integer                                   response status                                  200

Delete Published File
    # Expect Response                           ${ROOT_PATH}/api/protools.api.tests/listing/versions/v${protools_version}/schema/delete-published-file.json
    Clear Expectations
    Delete In Retry                           /listings/${human_readable_id}
    Integer                                   response status                                  403
    # String                                    $.error                                          شما اجازه ی دسترسی به این صفحه را ندارید.

Unpublish Listing
    ${Random_Live_Listing}                    Random Live Listing                              ${Car_Attributes['category']}            image=${false}
    ${Body}                                   Create Dictionary                                name=${Random_Live_Listing['title']}     description=${Random_Live_Listing['description']}     telephone=${PHONE_NUMBER}
    Expect Response Body                     ${ROOT_PATH}/api/protools.api.tests/listing/versions/v${protools_version}/schema/publish-file.json
    Post In Retry                             /listings/${human_readable_id}/publish           ${Body}
    Integer                                   response status                                  200
    ${Body}                                   Create Dictionary                                name=${Random_Live_Listing['title']}     description=${Random_Live_Listing['description']}     telephone=${PHONE_NUMBER}
    Clear Expectations
    Expect Response Body                      ${ROOT_PATH}/api/protools.api.tests/listing/versions/v${protools_version}/schema/unpublish-listing.json
    Post In Retry                             /listings/${human_readable_id}/unpublish         ${Body}
    Integer                                   response status                                  200

Archive File
   Get Random Listing And Images             ${Car_Attributes}                                image_category=cars
   Set To Dictionary                         ${Car_Attributes}
   Post In Retry                             /listings                                        ${Car_Attributes}                          validate=false
   Integer                                   response status                                  200
   Get User Human Readable Id
   Expect Response Body                      ${ROOT_PATH}/api/protools.api.tests/listing/versions/v${protools_version}/schema/archive-file.json
   Post In Retry                             /listings/${human_readable_id}/archive
   Integer                                   response status                                  200

Unarchive File
   Expect Response Body                     ${ROOT_PATH}/api/protools.api.tests/listing/versions/v${protools_version}/schema/unarchive-file.json
   Post In Retry                             /listings/${human_readable_id}/unarchive
   Integer                                   response status                                  200

Delete File
   Expect Response Body                      ${ROOT_PATH}/api/protools.api.tests/listing/versions/v${protools_version}/schema/delete-file.json
   Delete In Retry                                                                            /listings/${human_readable_id}
   Integer                                   response status                                  200
   Delete In Retry                                                                            /listings/${human_readable_id}                  validate=false
   Integer                                   response status                                  404

Delete Archived File
   Set To Dictionary                         ${Car_Attributes}
   Get Random Listing And Images             ${Car_Attributes}                                image_category=cars
   Post In Retry                             /listings                                        ${Car_Attributes}                                validate=false
   Integer                                   response status                                  200
   Get User Human Readable Id
   Post In Retry                             /listings/${human_readable_id}/archive                                                            validate=false
   Integer                                   response status                                  200
   Delete In Retry                           /listings/${human_readable_id}
   Output Schema                             response body                                    ${ROOT_PATH}/api/protools.api.tests/listing/versions/v${protools_version}/schema/delete-archived-file.json
   Integer                                   response status                                  200
   Delete In Retry                           /listings/${human_readable_id}                   validate=false
   Integer                                   response status                                  404
