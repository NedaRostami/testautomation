*** Settings ***
Resource                                      ../../../../resources/versions/v${protools_version}-resource.resource
Suite Setup                                   Set Test Environment
Test Setup                                    Setup Environment


*** Variables ***


*** Test Cases ***
Delete File And Listings In Diffrent Scenarioes
    [Tags]                                    notest
    Login To Service                          real-estate
    Set Headers                               {"X-Ticket":"${Refresh_Token}"}
    Set Listing Limit For Cat per locations   parentid=${43603}  catid=${43607}  regid=${8}  cityid=${301}  nghid=${888}  limitcount=${30}  limitprice=${11000}
    Delete Archived File
    Delete Unarchived File
    Delete Accepted Published File
    Delete In Review Published File
    Delete Accepted Unublished File
    Delete In Review Unublished File
    Delete Rejected File

*** Keywords ***
Create a File In Real Estate Category
    Post In Retry                             /listings                                         ${Attributes}       validate=false
    Integer                                   response status                                   200
    Get User Human Readable Id

Delete Archived File
    Post In Retry                             /listings                                        ${Attributes}
    Integer                                   response status                                  200
    Get User Human Readable Id
    Post In Retry                             /listings/${human_readable_id}/archive
    Integer                                   response status                                  200
    Delete In Retry                           /listings/${human_readable_id}
    Integer                                   response status                                  200

Delete Unarchived File
    Create a File In Real Estate Category
    Post In Retry                             /listings                                        ${Attributes}                            validate=false
    Integer                                   response status                                  200
    Get User Human Readable Id
    Post In Retry                             /listings/${human_readable_id}/archive
    Integer                                   response status                                  200
    Post In Retry                             /listings/${human_readable_id}/unarchive
    Integer                                   response status                                  200
    Delete In Retry                           /listings/${human_readable_id}
    Integer                                   response status                                  200

Delete Accepted Published File
    Create a File In Real Estate Category
    ${Random_Live_Listing}                    Random Live Listing                              ${Attributes['category']}                image=${false}
    ${Body}                                   Create Dictionary                                name=${Random_Live_Listing['title']}     description=${Random_Live_Listing['description']}     telephone=${PHONE_NUMBER}
    Expect Response                           ${EXECDIR}/auto-tests/ProTools/api/protools.api.tests/schema/create-file.json
    Post In Retry                             /listings/${human_readable_id}/publish           ${Body}
    Integer                                   response status                                  200
    Verify Advertise By ID
    Delete In Retry                           /listings/${human_readable_id}                   validate=false
    Integer                                   response status                                  403

Delete In Review Published File
    Create a File In Real Estate Category
    ${Random_Live_Listing}                    Random Live Listing                              ${Attributes['category']}                image=${false}
    ${Body}                                   Create Dictionary                                name=${Random_Live_Listing['title']}     description=${Random_Live_Listing['description']}     telephone=${PHONE_NUMBER}
    Expect Response                           ${EXECDIR}/auto-tests/ProTools/api/protools.api.tests/schema/create-file.json
    Post In Retry                             /listings/${human_readable_id}/publish           ${Body}
    Integer                                   response status                                  200
    Delete In Retry                           /listings/${human_readable_id}                   validate=false
    Integer                                   response status                                  403

Delete Accepted Unublished File
    Create a File In Real Estate Category
    ${Random_Live_Listing}                    Random Live Listing                              ${Attributes['category']}                image=${false}
    ${Body}                                   Create Dictionary                                name=${Random_Live_Listing['title']}     description=${Random_Live_Listing['description']}     telephone=${PHONE_NUMBER}
    Expect Response                           ${EXECDIR}/auto-tests/ProTools/api/protools.api.tests/schema/create-file.json
    Post In Retry                             /listings/${human_readable_id}/publish           ${Body}
    Integer                                   response status                                  200
    Verify Advertise By ID
    ${Body}                                   Create Dictionary                                name=${Random_Live_Listing['title']}     description=${Random_Live_Listing['description']}     telephone=${PHONE_NUMBER}
    Expect Response                           ${EXECDIR}/auto-tests/ProTools/api/protools.api.tests/schema/unpublish-acc-pub.json
    Post In Retry                             /listings/${human_readable_id}/unpublish         ${Body}                                  validate=false
    Integer                                   response status                                  200
    Delete In Retry                           /listings/${human_readable_id}                   validate=false
    Integer                                   response status                                  404

Delete In Review Unublished File
    Create a File In Real Estate Category
    ${Random_Live_Listing}                    Random Live Listing                              ${Attributes['category']}                image=${false}
    ${Body}                                   Create Dictionary                                name=${Random_Live_Listing['title']}     description=${Random_Live_Listing['description']}     telephone=${PHONE_NUMBER}
    Expect Response                           ${EXECDIR}/auto-tests/ProTools/api/protools.api.tests/schema/create-file.json
    Post In Retry                             /listings/${human_readable_id}/publish           ${Body}
    Integer                                   response status                                  200
    ${Body}                                   Create Dictionary                                name=${Random_Live_Listing['title']}     description=${Random_Live_Listing['description']}     telephone=${PHONE_NUMBER}
    Expect Response                           ${EXECDIR}/auto-tests/ProTools/api/protools.api.tests/schema/unpublish.json
    Post In Retry                             /listings/${human_readable_id}/unpublish         ${Body}
    Integer                                   response status                                  200
    Delete In Retry                           /listings/${human_readable_id}                   validate=false
    Integer                                   response status                                  403

Delete Rejected File
    Create a File In Real Estate Category
    ${Random_Live_Listing}                    Random Live Listing                              ${Attributes['category']}                image=${false}
    ${Body}                                   Create Dictionary                                name=${Random_Live_Listing['title']}     description=${Random_Live_Listing['description']}     telephone=${PHONE_NUMBER}
    Expect Response                           ${EXECDIR}/auto-tests/ProTools/api/protools.api.tests/schema/create-file.json
    Post In Retry                             /listings/${human_readable_id}/publish           ${Body}
    Integer                                   response status                                  200
    Reject Advertise By ID
    Delete In Retry                           /listings/${human_readable_id}                   validate=false
    Integer                                   response status                                  403
