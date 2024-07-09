*** Settings ***
Resource                                      ../../../../resources/versions/v${protools_version}-resource.resource
Suite Setup                                   Set Test Environment
Test Setup                                    Setup Environment


*** Variables ***


*** Test Cases ***
Unpublish File And Listings In Diffrent Scenarioes
    [Tags]                                    notest
    Login To Service                          real-estate
    Set Headers                               {"X-Ticket":"${Refresh_Token}"}
    Set Listing Limit For Cat per locations   parentid=${43603}  catid=${43607}  regid=${8}  cityid=${301}  nghid=${888}  limitcount=${30}  limitprice=${11000}
    Unpublish In Review Published File
    Unpublish Accepted Published File
    Unpublish Rejected File

*** Keywords ***
Unpublish In Review Published File
    Post In Retry                             /listings                                        ${Attributes}         validate=false
    Integer                                   response status                                  200
    Get User Human Readable Id
    ${Random_Live_Listing}                    Random Live Listing                              ${Attributes['category']}                image=${false}
    ${Body}                                   Create Dictionary                                name=${Random_Live_Listing['title']}     description=${Random_Live_Listing['description']}     telephone=${PHONE_NUMBER}
    Expect Response                           ${EXECDIR}/auto-tests/ProTools/api/protools.api.tests/schema/create-file.json
    Post In Retry                             /listings/${human_readable_id}/publish           ${Body}
    Integer                                   response status                                  200
    Expect Response                           ${EXECDIR}/auto-tests/ProTools/api/protools.api.tests/schema/unpublish.json
    Post In Retry                             /listings/${human_readable_id}/unpublish         ${Body}
    Integer                                   response status                                  200

Unpublish Accepted Published File
    Post In Retry                             /listings                                        ${Attributes}         validate=false
    Integer                                   response status                                  200
    Get User Human Readable Id
    ${Random_Live_Listing}                    Random Live Listing                              ${Attributes['category']}                image=${false}
    ${Body}                                   Create Dictionary                                name=${Random_Live_Listing['title']}     description=${Random_Live_Listing['description']}     telephone=${PHONE_NUMBER}
    Expect Response                           ${EXECDIR}/auto-tests/ProTools/api/protools.api.tests/schema/create-file.json
    Post In Retry                             /listings/${human_readable_id}/publish           ${Body}
    Integer                                   response status                                  200
    Verify Advertise By ID
    Expect Response                          ${EXECDIR}/auto-tests/ProTools/api/protools.api.tests/schema/unpublish-acc-pub.json
    Post In Retry                             /listings/${human_readable_id}/unpublish         ${Body}
    Integer                                   response status                                  200

Unpublish Rejected File
    Post In Retry                             /listings                                        ${Attributes}         validate=false
    Integer                                   response status                                  200
    Get User Human Readable Id
    ${Random_Live_Listing}                    Random Live Listing                              ${Attributes['category']}                image=${false}
    ${Body}                                   Create Dictionary                                name=${Random_Live_Listing['title']}     description=${Random_Live_Listing['description']}     telephone=${PHONE_NUMBER}
    Expect Response                           ${EXECDIR}/auto-tests/ProTools/api/protools.api.tests/schema/create-file.json
    Post In Retry                             /listings/${human_readable_id}/publish           ${Body}
    Integer                                   response status                                  200
    Reject Advertise By ID
    Expect Response                           ${EXECDIR}/auto-tests/ProTools/api/protools.api.tests/schema/unpublish-acc-pub.json
    Post In Retry                             /listings/${human_readable_id}/unpublish         ${Body}
    Integer                                   response status                                  200
