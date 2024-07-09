*** Settings ***
Resource                                ../../../../resources/resource.resource

*** Variables ***
${Alternative_Neighborhoods_Schema}     ${ROOT_PATH}/api.tests/general/versions/v${api_version}/schema/alternative-neighborhood.json
${App_Version}                          ${ROOT_PATH}/api.tests/general/versions/v${api_version}/schema/app-version.json
${Categories_Schema}                    ${ROOT_PATH}/api.tests/general/versions/v${api_version}/schema/categories.json
${Category_Suggest_Schema}              ${ROOT_PATH}/api.tests/general/versions/v${api_version}/schema/category-suggest.json
${Complaint_Types_Schema}               ${ROOT_PATH}/api.tests/general/versions/v${api_version}/schema/complaint-types.json
${Config_Schema}                        ${ROOT_PATH}/api.tests/general/versions/v${api_version}/schema/config.json
${Deep_Link_Schema}                     ${ROOT_PATH}/api.tests/general/versions/v${api_version}/schema/deep-link.json
${Feedback_Categories_Schema}           ${ROOT_PATH}/api.tests/general/versions/v${api_version}/schema/feedback-categories.json
${Locations_Schema}                     ${ROOT_PATH}/api.tests/general/versions/v${api_version}/schema/locations.json
${Static_Data_Schema}                   ${ROOT_PATH}/api.tests/general/versions/v${api_version}/schema/static-data.json
${Static_Data_Version_Schema}           ${ROOT_PATH}/api.tests/general/versions/v${api_version}/schema/static-data-version.json


*** Keywords ***
Request Alternative Neighborhoods Endpoint
    Get In Retry                        /general/alt-district?cityId=301&q=امام
    Integer                             response status                                         200

Request App Version Endpoint
    Get In Retry                        /general/app/version
    Integer                             response status                                         200

Request Categories Endpoint
    Get In Retry                        /general/categories
    Integer                             response status                                         200

Request Category Suggest Endpoint
    Get In Retry                        /general/category-suggest?q=پراید
    integer                             response status                                         200

Request Complaint Types Endpoint
    Get In Retry                        /general/complaint-types
    Integer                             response status                                         200

Request Config Endpoint
    Get In Retry                        /general/config
    Integer                             response status                                         200

Request Deep Link Endpoint
    Get In Retry                        /general/deep-link?url=/تهران
    Integer                             response status                                         200

Request Feedback Categories Endpoint
    Get In Retry                        /general/feedback/categories
    Integer                             response status                                         200

Request Locations Endpoint
    Get In Retry                        /general/locations
    Integer                             response status                                         200

Request Static Data Endpoint
    Get In Retry                        /general/static-data
    Integer                             response status                                         200

Request Static Data Version Endpoint
    Get In Retry                        /general/static-data/version
    Integer                             response status                                         200
