*** Settings ***
Documentation                                    add a new listing for moblile New User
...                                              while not logged in
...                                              Mobile Registeration
...                                              check the moderatin to accept it.
Test Setup                                       Open test browser
Test Teardown                                    Clean Up Tests
Library                                          SeleniumLibrary
Resource                                         ../../resources/setup.resource
Library                                          OperatingSystem

*** variables ***
${State}                                         مرکزی
${City}                                          اراک
${Region}                                        ${empty}

*** Test Case ***
Add Mobile Listing
    [Tags]                                         listing details   leads_and_views
    Run Keyword unless                             ${Toggle_leads} and ${Toggle_views}          Pass Execution    Leads And View Is OFF
    Go To Post Listing Page
    Post A New Listing                             ${1}   44096   43597  44014   logged_in=${FALSE}
    Login OR Register In Listing By New Mobile
    Verify Post Listing Is done
    Check My Listing
    Check My Listing Image Count                  1
    Login Trumpet Admin Page
    Verify Advertise By ID in trumpet
    Check My Ads Has been Verified
    Check Leads And View

*** Keywords ***
Check Leads And View
    Click Link                                    ${Title_Words}
    Wait Until Page Is Loaded
    Wait Until Page Contains Element              ${LD_Leads_View}         timeout=3s
    Page Should Contain Element                   ${LD_Graph_Bar}
    Page Should Contain                           ${LD_General_Review}
    Page Should Contain                           ${LD_Display_On_Page}
    Page Should Contain Link                      ${LD_Review_Growth}
