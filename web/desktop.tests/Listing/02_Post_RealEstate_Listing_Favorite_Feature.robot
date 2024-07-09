*** Settings ***
Documentation                                  add a new listing with One image New User
...                                            while not logged in
...                                            Mobile Registeration
...                                            check the moderatin to accept it.
...                                            Logout's the tests
Test Setup                                     Open test browser
Test Teardown                                  Clean Up Tests
Resource                                       ../../resources/setup.resource


*** variables ***
${State}                                       اصفهان
${City}                                        اصفهان
${Region}                                      لادان


*** Test Cases ***
Post RealEstate Listing And Favorite/Unfavorite Listing
    [Tags]                                      Listing             RealEstate
    Go To Post Listing Page
    Post A New Listing                          ${8}     43603     43606        logged_in=${FALSE}
    Login OR Register In Listing By New Mobile
    Verify Post Listing Is done
    Check My Listing
    Check My Listing Image Count                8
    Check My Ads Has been Verified
    Click Link                                  ${AllAdvs}
    Wait Until Page Contains                    ${IranAllH1}
    Wait Until Page Is Loaded
    ${passed}                                   Run Keyword And Return Status    Wait Until Keyword Returns Passed   5                2    Page Should Contain    ${Title_Words}
    Run Keyword If	                            not ${passed}                    Search Listing                      ${Title_Words}
    Favorite
    Go To Serp And Unfavorite The Listing


*** Keywords ***
Favorite
    Click By Css Selector                       [data-save-item="${AdsId}"]
    Sleep    2s
    go to                                       ${SERVER}/session/favourites
    wait until page contains                    ${Title_Words}

Go To Serp And Unfavorite The Listing
    Click Link                                  ${AllAdvs}
    Wait Until Page Contains                    ${IranAllH1}
    Search Listing                              ${Title_Words}
    Click By Css Selector                       [data-save-item="${AdsId}"]
