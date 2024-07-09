*** Settings ***
Resource                                ../default/default-keywords.resource


*** Keywords ***
Validate Listing Details Response
    String                          response body listingID                         ${Random_Listing['listingID']}
    String                          response body title                             ${Random_Listing['title']}

Get Listing Owner Contact Info Using ${Contact_Method}
    Pass Execution                  ${NOT_IMPLEMENTED_MESSAGE}
