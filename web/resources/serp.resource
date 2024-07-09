*** Settings ***
Resource                                         setup.resource

*** Variables ***
${MaxNumOfAds}                                   ${24}

*** Keywords ***
Set Serp Tag Variable And Validate Position
    [Arguments]                                  ${index}                                      ${Txt}
    ${Tag_selector}                              Set Variable                                  ${Serp_Tag.format(${index},'${Txt}')}
    Wait Until Page Contains Element             ${Tag_selector}                               timeout=5s

Set Serp Breadcrumbs And Validate Position
    [Arguments]                                  ${index}                                      ${Txt}
    ${Breadcrumbs_selector}                      Set Variable                                  ${Serp_B_li.format(${index},'${Txt}')}
    Wait Until Page Contains Element             ${Breadcrumbs_selector}                       timeout=5s

Check Num Of Listings In Serp
    [Arguments]                                  ${Elements}
    ${Element_Length}                            Get Length                                     ${Elements}
    Run Keyword If                               ${Element_Length} == ${0}                      Fail     No Listings found.
    ${Existence_Sp_Box}                          Run Keyword And Return Status                  Page Should Contain Element
    ...                                          ${Serp_Sp_Section}
    IF                                           ${Existence_Sp_Box}
    ${Sp_Box_Listings}                           SeleniumLibrary.Get Element Count              ${Serp_Sp_Section_All_L}
    ${NumOfSerpAds}                              Evaluate                                       ${MaxNumOfAds} - ${Sp_Box_Listings}
    ELSE
    ${NumOfSerpAds}                              Set Variable                                   ${MaxNumOfAds}
    END
    Run Keyword If                               ${Element_Length} > ${NumOfSerpAds}            Fail     The number of Listings on the page is more than ${MaxNumOfAds}.
