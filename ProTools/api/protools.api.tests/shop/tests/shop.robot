*** Settings ***
Resource                                      ../../../../resources/versions/v${protools_version}-resource.resource
Suite Setup                                   Set Test Environment
Test Setup                                    Setup Environment


*** Variables ***


*** Test Cases ***
Protools Shop
    [Tags]                                    shop      file    publish     listinglimit
    Create Shop In Sheypoor
    Login To Service                          real-estate                                     ${Shop_owner_phone}
    Expect Response Body                      ${ROOT_PATH}/api/protools.api.tests/shop/versions/v${protools_version}/schema/get-shop-info.json
    Set Headers                               {"X-Ticket":"${Refresh_Token}"}
    Get Shop Info
    Get Shop Listings
    Update Shop Slogan
    Update Shop Contact Info
    Update Shop Contact Info

*** Keywords ***
Generate Random String To Clear Cache
    ${Random_String}                          Generate Random String                          10          20
    Set Suite Variable                        ${Random_String}                                ${Random_String}

Get Shop Info
    Get In Retry                              /shop
    Integer                                   response status                                  200

Get Shop Listings
    Set Listing Limit For Cat per locations   parentid=${43603}  catid=${43607}  regid=${8}  cityid=${301}  nghid=${888}  limitcount=${30}  limitprice=${11000}
    Get Random Listing And Images             ${Attributes}
    Post In Retry                             /listings                                        ${Attributes}                           validate=false
    Integer                                   response status                                  200
    Get User Human Readable Id
    Get In Retry                              /listings/${human_readable_id}                                                           validate=false
    Integer                                   response status                                  200
    ${Title}                                  Get String                                       response body title
    Should Be Equal                           ${Title}                                         اجاره اداری 150 متر در اختیاریه
    ${Random_Live_Listing}                    Random Live Listing                              ${Attributes['category']}                image=${false}
    ${Body}                                   Create Dictionary                                name=${Random_Live_Listing['title']}     description=${Random_Live_Listing['description']}     telephone=${PHONE_NUMBER}
    Post In Retry                             /listings/${human_readable_id}/publish           ${Body}                                  validate=false
    Integer                                   response status                                  200
    Verify Advertise By ID
    Sleep                                     10s
    Generate Random String To Clear Cache
    Expect Response Body                      ${ROOT_PATH}/api/protools.api.tests/shop/versions/v${protools_version}/schema/get-shop-listings.json
    Get In Retry                              /shop/listings?r=${Random_String}
    Integer                                   response status                                  200
    String                                    response body items 0 title                      "${Random_Live_Listing['title']}"

Update Shop Slogan
    ${Body}                                   Create Dictionary                                slogan=${Random_Live_Listing['title']}
    Post In Retry                             /shop/slogan                                     ${Body}                          validate=false
    Integer                                   response status                                  200
    Expect Response Body                      ${ROOT_PATH}/api/protools.api.tests/shop/versions/v${protools_version}/schema/update-slogan.json
    Get In Retry                              /shop
    Integer                                   response status                                  200
    String                                    response body slogan                             "${Random_Live_Listing['title']}"

Update Shop Contact Info
    ${Telephones}                             Create List                                      ${PHONE_NUMBER}
    ${Social_Instagram}                       Create Dictionary                                type=instagram                   url=@protools
    ${Social_Telegram}                        Create Dictionary                                type=telegram                    url=@sheypro
    ${Social_Networks}                        Create List                                      ${Social_Instagram}              ${Social_Telegram}
    ${Body}                                   Create Dictionary                                working_time=فقط روزهای تعطیل   email=test@protools.com                 website=http://sheypoor.com
    ...                                       address=بلوار نلسون ماندلا - بعد از خروجی همت  telephones=${Telephones}          social_networks=${Social_Networks}      latitude=85.01      longitude=22.23
    Post In Retry                             /shop/contact                                    ${Body}                          validate=false
    Integer                                   response status                                  200
    Get In Retry                              /shop
    Integer                                   response status                                  200
    String                                    response body email                             "test@protools.com"
