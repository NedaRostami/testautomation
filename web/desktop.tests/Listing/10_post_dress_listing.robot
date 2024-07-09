*** Settings ***
Documentation                                                 Post a listing with hide seller phone number,
...                                                           and validate it on serp and listing details page.
Test Setup                                                    Open test browser
Test Teardown                                                 Clean Up Tests
Resource                                                      ../../resources/setup.resource

*** Variables ***
${state}                                                      19                    #قم
${city}                                                       712                   #قم
${region}                                                     4144                  #آزادگان

*** Test Case ***
Post Listing In Dress With Hide Phone Number
    [Tags]                                                    hide phone number     serp                  Listing                        listing details
    Go To Post Listing Page
    Add Dress Listing With Hidden Phone Number
    Logout User
    Verify Hidden Phone Number In Serp
    Verify Hidden Phone Number In Listing Details

*** Keywords ***
Add Dress Listing With Hidden Phone Number
    Post A New Listing                                        ${1}                  43612                 43613                          state=${state}
    ...                                                       city=${city}          region=${region}      hide_seller_phone=${TRUE}      logged_in=${FALSE}
    Login OR Register In Listing By New Mobile
    Verify Post Listing Is done
    Check My Listing
    Check My Listing Image Count                              1
    Verify Advertise By ID

Verify Hidden Phone Number In Serp
    Find Created Listing On Serp
    Verify That Call Button Is Not In Listing

Find Created Listing On Serp
    Go To                                                     ${SERVER}/قم/آزادگان/لوازم-شخصی/لباس-کیف-کفش?q=${Title_Words}
    Wait Until Page Contains Element                          ${Serp_L_Article.format("${AdsId}")}                                       timeout=15s
    ...                                                       error=The listing was not found on the serp page.

Verify That Call Button Is Not In Listing
    Page Should Not Contain Element                           ${Serp_L_Call_Btn.format("${AdsId}")}
    ...                                                       message=The listing with hide phone number should not be have call button.

Verify Hidden Phone Number In Listing Details
    Go To Listing Details Page
    Verify That Call Button Is Not In Seller Details
    Verify That Phone Number Is Not In Listing Description

Verify That Call Button Is Not In Seller Details
    Page Should Not Contain Element                           ${LD_Call_Btn}
    ...                                                       message=The listing with hide phone number should not be have call button.

Verify That Phone Number Is Not In Listing Description
    Page Should Not Contain Element                           ${LD_Description} >> css:[content="call"]
    ...                                                       message=The listing with hide phone number should not be have call info.
