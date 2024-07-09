 *** Settings ***
Documentation                           Check Seo Rules for description and Title
Test Setup                              Open test browser
Test Teardown                           Clean Up Tests
Resource                                ../../resources/setup.resource

*** Variables ***
${Meta_Description_Selector}            //meta[@name='description']
@{Brand_List}                           رنو     سمند        پیکان       پراید       پژو     رانا        مزدا
@{Location_List}                        سیف-آباد        ایوانکی         استان-تهران         تهران


*** Test Cases ***
Validate Seo Description And Title In Car Category
    [Tags]                              seo             notest
    Apply Searches And Validate Description and Title

*** Keywords ***
Apply Searches And Validate Description and Title
    Add Brand To Url

Create URL
    [Arguments]                         ${Brand}                ${Location}
    ${URL}                              Set Variable            ${SERVER}/${Location}/وسایل-نقلیه/خودرو/${Brand}
    Set Test Variable                   ${URL}

Add Brand To Url
    FOR        ${Brand}        IN       @{Brand_List}
      Add Location To Url               ${Brand}
    END

Add Location To Url
    [Arguments]                         ${Brand}
    FOR        ${Location}     IN       @{Location_List}
      Create URL                        ${Brand}        ${Location}
      Validate Brand Page Meta Description            ${Brand}                ${Location}
      Validate Brand Page Title         ${Brand}                ${Location}
    END

Validate Brand Page Meta Description
    [Arguments]                         ${Brand}                ${Location}
    Go To                               ${URL}
    Validate Meta Description           ${Brand}                ${Location}

Validate Brand Page Title
    [Arguments]                         ${Brand}                ${Location}
    Validate Title                      ${Brand}                ${Location}

Validate Meta Description
    [Arguments]                         ${Brand}                ${Location}
    ${Meta_Description_Text}            SeleniumLibrary.Get Element Attribute   ${Meta_Description_Selector}                       content
    ${Meta_Description_Text}            clean up spaces                         ${Meta_Description_Text}
    ${Pattern}                          Create Regex Pattern                    ${Brand}                                           ${Location}
    ${Pattern}                          clean up spaces                         ${Pattern}
    Should Match Regexp                 ${Meta_Description_Text}                ${Pattern}                                         message=Seo description did not match the provided pattern

Validate Title
    [Arguments]                         ${Brand}                                ${Location}
    ${Title_Text}                       Get Title
    ${Title_Text}                       clean up spaces                         ${Title_Text}
    ${Pattern}                          Create Title Regex Pattern              ${Brand}                                           ${Location}
    ${Pattern}                          clean up spaces                         ${Pattern}
    Should Match Regexp                 ${Title_Text}                           ${Pattern}                                          message=Seo Title did not match the provided pattern

Create Regex Pattern
    [Arguments]                         ${Brand}                                ${Location}
    ${Location}                         Set Variable                            ${Location.replace('-', ' ')}
    # ${Regex_Pattern}                    Set Variable                            خرید و فروش ${Brand}: شامل بیش از \\d+ آگهی خودرو ${Brand} کارکرده و صفر با قیمت های مناسب در ${Location} را باما در شیپور ببینید.
    ${Regex_Pattern}                    Set Variable                            خرید و فروش ماشین ${Brand} : \\d+ آگهی جدید خودرو ${Brand} دست دوم و نو به قیمت روز در ${Location} را باما در شیپور ببینید.

    [Return]                            ${Regex_Pattern}

clean up spaces
    [Arguments]                         ${txt}
    ${noSpaceTxt}                       Replace String                          ${txt}              ${SPACE}${SPACE}${SPACE}    ${SPACE}
    ${noSpaceTxt}                       Replace String                          ${noSpaceTxt}       ${SPACE}${SPACE}            ${SPACE}
    [Return]                            ${noSpaceTxt}


Create Title Regex Pattern
    [Arguments]                         ${Brand}                                ${Location}
    ${Location}                         Set Variable                            ${Location.replace('-', ' ')}
    ${Regex_Pattern}                    Set Variable                            خرید و فروش و قیمت ${Brand} در ${Location} - شیپور
    [Return]                            ${Regex_Pattern}
