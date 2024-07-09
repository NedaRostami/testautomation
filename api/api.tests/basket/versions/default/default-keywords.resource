*** Settings ***
Resource                                ../../../../resources/resource.resource


*** Keywords ***
Request Basket Endpoint
    [Arguments]                         ${Listing_Id}
    Get In Retry                        /basket/${Listing_Id}           headers=${Listing_Headers}
    Output	                            response
#    Output	                            response body

Check Version
    Pass Execution                      ${NOT_IMPLEMENTED_MESSAGE}
