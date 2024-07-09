*** Settings ***
Documentation                           Check Listing breadcrumbs and Tags
Test Setup                              Open test browser
Test Teardown                           Clean Up Tests
Resource                                ../../../resources/setup.resource

*** Variables ***

${First_Listing_Title_Selector}         xpath=//article[1]//h2/a
${Listing_Location_Selector}            xpath=//section//span[@class='small-text']

${HOME}                                 xpath=//*[@id="breadcrumbs"]/ul/li[1]/a
${FirstBC}                              xpath=//*[@id="breadcrumbs"]/ul/li[2]
${SecondBC}                             xpath=//*[@id="breadcrumbs"]/ul/li[3]
${ThirdBC}                              xpath=//*[@id="breadcrumbs"]/ul/li[4]
${FourthBC}                             xpath=//*[@id="breadcrumbs"]/ul/li[5]
${TAG1}                                 xpath=//*[@id="tags"]/span[1]
${TAG2}                                 xpath=//*[@id="tags"]/span[2]
${Close2}                               xpath=//*[@id="tags"]/span[2]/span
${Close1}                               xpath=//*[@id="tags"]/span/span


*** Test Cases ***
‌Check Breadcrumbs And Tags
    [Tags]                              notest   serp
    Go To Homepage
    Click On First Listing
    Check Breadcrumbs
    Click On Subcategory From Breadcrumbs
    Remove Sub Category Tag
    Validate Filter Title
    Go Back And Set Vars Again
    Click On Category From Breadcrumbs
    Remove Category Tag
    Validate Filter Title
    Go Back
    wait until page loading is finished
    Click On City From Breadcrumbs
    Remove City Tag
    Validate Filter Title
    Go Back
    wait until page loading is finished
    Click On Province From Breadcrums
    Remove Province Tag
    Validate Filter Title


*** keywords ***
Go Back And Set Vars Again
    Go Back
    wait until page loading is finished
    Check Breadcrumbs

Go To Homepage
    Click Link                              ${AllAdvs}
    Wait Until Page Contains                ${IranAllH1}

Click On First Listing
    ${Listing_Title}                        Get Text                            ${First_Listing_Title_Selector}
    Click Link                              ${First_Listing_Title_Selector}
    Wait Until Page Contains                ${Listing_Title}                    timeout=5s

Check Breadcrumbs
    ${Breadcrumb_Category}                  Set Variable                        ${NONE}
    ${Breadcrumb_Sub_Category}              Set Variable                        ${NONE}
    ${Breadcrumb_Brand}                     Set Variable                        ${NONE}
    ${Breadcrumb_Province}                  Set Variable                        ${NONE}
    ${Breadcrumb_City}                      Set Variable                        ${NONE}
    ${Breadcrumb_District}                  Set Variable                        ${NONE}
    ${Breadcrumb_Category_Index}            Set Variable                        ${0}
    ${Breadcrumb_Sub_Category_Index}        Set Variable                        ${0}
    ${Listing_Location}                     Get Text                            ${Listing_Location_Selector}
    ${Total_Breadcrumbs}                    Get Webelements                     //nav[@id='breadcrumbs']//li/a
    ${Total_Breaccrumbs_Count}              Get Length                          ${Total_Breadcrumbs}
    ${Last_Tier_Location}                   Fetch From Right                    ${Listing_Location}                         ،
    ${Last_Tier_Location_Breadcrumb}        Set Variable                        //nav[@id='breadcrumbs']//li/a[contains(text(),'${Last_Tier_Location}')]/parent::li
    ${Location_Breadcrumbs}                 Get Webelements                     ${Last_Tier_Location_Breadcrumb}/preceding-sibling::li
    ${Location_Breadcrumbs_Count}           Get Length                          ${Location_Breadcrumbs}
    FOR     ${I}    ${V}    IN ENUMERATE    @{Total_Breadcrumbs}
        ${Breadcrumb_Province}              Set Variable If                     ${I} == ${1} and ${I} <= ${Location_Breadcrumbs_Count}                              ${V}        ${Breadcrumb_Province}
        Set Test Variable                   ${Breadcrumb_Province}              ${Breadcrumb_Province}
        ${Breadcrumb_City}                  Set Variable If                     ${I} == ${2} and ${I} <= ${Location_Breadcrumbs_Count}                              ${V}        ${Breadcrumb_City}
        Set Test Variable                   ${Breadcrumb_City}                  ${Breadcrumb_City}
        ${Breadcrumb_District}              Set Variable If                     ${I} == ${3} and ${I} <= ${Location_Breadcrumbs_Count}                              ${V}        ${Breadcrumb_District}
        Set Test Variable                   ${Breadcrumb_District}              ${Breadcrumb_District}
        ${Breadcrumb_Category_Index}        Set Variable If                     ${I} > ${Location_Breadcrumbs_Count} and '${Breadcrumb_Category}' == 'None'         ${I}        ${Breadcrumb_Category_Index}
        ${Breadcrumb_Category}              Set Variable If                     ${I} > ${Location_Breadcrumbs_Count} and '${Breadcrumb_Category}' == 'None'         ${V}        ${Breadcrumb_Category}
        Set Test Variable                   ${Breadcrumb_Category}              ${Breadcrumb_Category}
        ${Breadcrumb_Sub_Category_Index}    Set Variable If                     ${I} > ${Location_Breadcrumbs_Count} and '${Breadcrumb_Sub_Category}' == 'None' and ${Breadcrumb_Category_Index + 1} == ${I}      ${I}        ${Breadcrumb_Sub_Category_Index}
        ${Breadcrumb_Sub_Category}          Set Variable If                     ${I} > ${Location_Breadcrumbs_Count} and '${Breadcrumb_Sub_Category}' == 'None' and ${Breadcrumb_Category_Index + 1} == ${I}      ${V}        ${Breadcrumb_Sub_Category}
        Set Test Variable                   ${Breadcrumb_Sub_Category}          ${Breadcrumb_Sub_Category}
        ${Breadcrumb_Brand}                 Set Variable If                     ${I} > ${Location_Breadcrumbs_Count} and '${Breadcrumb_Brand}' == 'None' and ${Breadcrumb_Sub_Category_Index + 1} == ${I}         ${V}        ${Breadcrumb_Brand}
        Set Test Variable                   ${Breadcrumb_Brand}                 ${Breadcrumb_Brand}
    END
    Set Test Variable                       ${Breadcrumb_Category_Element}      ${Breadcrumb_Category}
    Set Test Variable                       ${Breadcrumb_Sub_category_Element}  ${Breadcrumb_Sub_Category}
    Set Test Variable                       ${Breadcrumb_Brand_Element}         ${Breadcrumb_Brand}
    Set Test Variable                       ${Breadcrumb_Province_Element}      ${Breadcrumb_Province}
    Set Test Variable                       ${Breadcrumb_City_Element}          ${Breadcrumb_City}
    Set Test Variable                       ${Breadcrumb_District_Element}      ${Breadcrumb_District}
    Run Keyword And Ignore Error            Set Category Breadcrumbs
    Run Keyword And Ignore Error            Set Location Breadcrumbs

Click On Subcategory From Breadcrumbs
    Click Element                           ${Breadcrumb_Sub_Category_Element}
    FOR         ${I}            IN          ${Breadcrumb_Category}              ${Breadcrumb_Sub_Category}      ${Breadcrumb_Province}      ${Breadcrumb_City}  ${Breadcrumb_District}
        Run Keyword If                      '${I}' != 'None'                    Element Should Contain
        ...                                 xpath=//nav[@id='breadcrumbs']      ${I}
    END

Remove Sub Category Tag
    Click Element                           xpath=//span[@class='tag ' and contains(text(), '${Breadcrumb_Sub_Category}')]/span

Validate Filter Title
    Run Keyword If                          '${Breadcrumb_District}' != 'None'
    ...                                     Wait Until Page Contains            همه آگهی ها در ${Breadcrumb_City}       timeout=5s       ELSE IF
    ...                                     '${Breadcrumb_City}' == '${Breadcrumb_Province}'
    ...                                     Wait Until Page Contains            همه آگهی ها در ${Breadcrumb_Province}                           timeout=5s       ELSE IF
    ...                                     '${Breadcrumb_City}' != 'None'
    ...                                     Wait Until Page Contains            همه آگهی ها در ${Breadcrumb_City}، ${Breadcrumb_Province}       timeout=5s       ELSE
    ...                                     Wait Until Page Contains            همه آگهی ها در ${Breadcrumb_Province}                           timeout=5s

Click On Category From Breadcrumbs
    Click Element                           ${Breadcrumb_Sub_Category_Element}
    FOR         ${I}            IN          @{Breadcrumbs}
        Run Keyword If                      '${I}' != 'None'                    Element Should Contain
        ...                                 xpath=//nav[@id='breadcrumbs']      ${I}
    END

Set Location Breadcrumbs
    ${Breadcrumb_Province}                  Get Text                            ${Breadcrumb_Province}
    Set Test Variable                       ${Breadcrumb_Province}              ${Breadcrumb_Province}
    ${Breadcrumb_City}                      Get Text                            ${Breadcrumb_City}
    Set Test Variable                       ${Breadcrumb_City}                  ${Breadcrumb_City}
    ${Breadcrumb_District}                  Get Text                            ${Breadcrumb_District}
    Set Test Variable                       ${Breadcrumb_District}              ${Breadcrumb_District}

Set Category Breadcrumbs
    ${Breadcrumb_Category}                  Get Text                            ${Breadcrumb_Category}
    Set Test Variable                       ${Breadcrumb_Category}              ${Breadcrumb_Category}
    ${Breadcrumb_Sub_Category}              Get Text                            ${Breadcrumb_Sub_Category}
    Set Test Variable                       ${Breadcrumb_Sub_Category}          ${Breadcrumb_Sub_Category}
    ${Breadcrumb_Brand}                     Get Text                            ${Breadcrumb_Brand}
    Set Test Variable                       ${Breadcrumb_Brand}                 ${Breadcrumb_Brand}
