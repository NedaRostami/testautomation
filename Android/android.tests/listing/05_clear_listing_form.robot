*** Settings ***
Documentation                                              Fill Listing Form Then Clear It
Resource                                                   ..${/}..${/}resources${/}common.resource
Suite Setup                                                Set Suite Environment
Test Setup                                                 start app
Test Teardown                                              Close test application For Insert Photos


*** variables ***
${State}                                                   البرز
${City}                                                    کرج
${Region}                                                  باغستان
${tv_cat_id}                                               50015
${price_value}                                             ۷۵۰۰۰۰۰
${stuff_status}                                            در حد نو


*** Test Case ***
Fill and Clear Listing Fields
    [Tags]                                                 Listing                        Clear
    Go To Post Listing Page
    Fill Listing Form For Electronic Category
    Coming Back From The Post Listing Page
    Go To Post Listing Page And Check Msg
    Check Post Listing Page Information
    Clear Listing Form
    Click Post Listing Button
    Check Error Message In Listing Page


*** Keywords ***
Fill Listing Form For Electronic Category
    Get Random Listing                                     ${tv_cat_id}
    Insert Photos
    Input Electronic Accessories Attribute
    Input Title And Decription
    Select Location                                        ${State}                         ${City}                 ${Region}

Coming Back From The Post Listing Page
    Click Element                                          ${TOOLBAR_BACK}
    Wait Until Page Contains Element                       ${REGION_HEADER}                 timeout=5s

Input Electronic Accessories Attribute
    Select Tv Category
    Input Price In Listing Form                            ${price_value}
    Input Stuff Status                                     ${stuff_status}

Select Tv Category
    Select Category And SubCategory                         لوازم الکترونیکی               صوتی و تصویری                       تلویزیون

Go To Post Listing Page And Check Msg
    Click Element                                          ${New_Listing}
    Wait Until Page Contains Element                       ${PLAIN_BUTTON}                 timeout=5s
    Page Should Contain Element By ID And Text             ${MORE_INFO_DESC}               ${draft_adv_msg}
    Click Element                                          ${PLAIN_BUTTON}

Check Post Listing Page Information
    Check Tv Category Is Selected
    Check Price Value
    Check Stuff Status Value
    Check Advertising Title Value
    Check Description Field Value
    Check Location Value

Check Tv Category Is Selected
    Page Should Contain Element By ID and Text              ${COMPONENT_EDITT_EXT}           تلویزیون

Check Price Value
    ${price}                                                Get Text                         ${INPUT_EDIT_TXT}
    ${price_seperator}                                      Evaluate                         "${price}".replace("٬","")
    Should Be Equal                                         ${price_seperator}               ${price_value}

Check Stuff Status Value
    Page Should Contain Element By Description and Text     ${stuff_status}                  ${stuff_status}

Check Advertising Title Value
    Page Should Contain Element By ID and Text              ${INPUT_EDIT_TXT}                ${Listings_title}

Check Description Field Value
    ${locator}                                              Set Variable                     android=UiScrollable(UiSelector().scrollable(true).instance(0)).scrollIntoView(new UiSelector().description("توضیحات").childSelector(new UiSelector().resourceId("${INPUT_EDIT_TXT}")))
    ${desc_value}                                           Get Text                         ${locator}
    ${stripped1}                                            Strip String                     ${desc_value}
    ${stripped2}                                            Strip String                     ${Listings_description}
    Should Be Equal                                         ${stripped1}                     ${stripped2}

Check Location Value
    Check Region Field
    IF                                                     ${Region_Field}
    Check Location And Region Field Value
    ELSE
    Check Location Field Value
    END

Check Region Field
    ${Region_Field}                                        Run Keyword And Return Status     Page Should Contain Element By ID And Text            ${CHECK_OUT_RECEIVER_NAME_TITLE}    محله
    Set Test Variable                                      ${Region_Field}                   ${Region_Field}

Check Location And Region Field Value
    Page Should Contain Element By ID and Text             ${COMPONENT_EDITT_EXT}           ${State}, ${City}
    Page Should Contain Element By ID and Text             ${INPUT_EDIT_TXT}                ${Region}

Check Location Field Value
    ${Loc}                                                 Get Text                         ${COMPONENT_EDITT_EXT}
    Page Should Contain Element By ID and Text             ${COMPONENT_EDITT_EXT}           ${State}, ${City}, ${region}

Check Error Message In Listing Page
    Page Should Contain Element By ID And Text              ${COMPONENT_EDIT_TEXT_ERROR}     ${ten_letter_msg}
    Page Should Contain Element By ID And Text              ${COMPONENT_EDIT_TEXT_ERROR}     ${twenty_letter_msg}
    Page Should Contain Element By ID And Text              ${COMPONENT_TEXT_VIEW_ERROR}     ${select_location_msg}
