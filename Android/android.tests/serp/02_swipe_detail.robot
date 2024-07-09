*** Settings ***
Resource                                            ..${/}..${/}resources${/}common.resource
Suite Setup                                         Set Suite Environment
Test Setup                                          start app
Test Teardown                                       Close test application
Test Timeout                                        10 minutes

*** Test Cases ***
Swipe loop
  [Tags]                                            serp                        navigation            detail
  Check Home Page List Is Loaded
  Swipe Up                                          ${200}
  Open First Listing In This Section
  Click Back Button
  Wait Until Page Contains Element                  id=${OfferInSerpID}         timeout=5s

*** Keywords ***
Open First Listing In This Section
    Wait Until Page Contains Element                id=${OfferInSerpID}         timeout=15s
    @{Listings_title}                               Get Webelements             id=${OfferInSerpID}
    ${Title}                                        Get Text                    ${Listings_title}[0]
    Should Not Be Empty                             ${Title}
    Set Test Variable                               ${FirstTitle}               ${Title}
    Swipe Down                                      ${2}
    Click Element                                   ${Listings_title}[0]
    Validate That Is On The Listing Details Page    ${FirstTitle}
