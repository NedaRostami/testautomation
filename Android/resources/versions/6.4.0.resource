*** Settings ***
Resource                                            6.3.2.resource

*** Variables ***


*** Keywords ***
Send A Message To Support
    [Arguments]                                     ${logged_in}=${TRUE}
    IF                                              ${Toggle_crm-ticket}
      Input The Support Message Title And Desc
      Submit Message To CRM Support                 ${logged_in}
    ELSE
      Fill Support Message Required Fields          ${logged_in}
      Submit Message To Support
    END

Submit Message To CRM Support
    [Arguments]                                     ${logged_in}
    Click Support Message Send Button
    Run Keyword Unless                              ${logged_in}                                           Login By Mobile
    Validate Msg Sent To Support With CRM Ticket

Validate Msg Sent To Support With CRM Ticket
    Wait Until Page Contains                        ${msg_of_successfully_send_support_msg_with_crm_ticket}
    ...                                             timeout=20s
    Click The Link                                  متوجه شدم

Succes Payment From Android App
    Click Element                                   ${APPLY_BUTTON}
    Handle And Validate Payment Page
    Wait Until Page Contains                        ${Price}                                                timeout=5s
    Swipe Up                                        ${3}
    Click Element                                   ${ReturnAppText}

Success Payment For Some Features
    [Arguments]                                     ${Tag_Type}=${EMPTY}                                    ${Tag_Price}=${0}
    ...                                             ${Tax_Price}=${0}                                       ${Bump_Type}=${EMPTY}
    ...                                             ${Bump_Price}=${0}                                      ${All_Iran_Packge_Price}=${0}
    ...                                             ${All_State_Packge_Price}=${0}
    Handle And Validate Payment Page
    Validate Items In Payment Receipt               ${Tag_Type}                                             ${Tag_Price}
    ...                                             ${Tax_Price}                                            ${Bump_Type}
    ...                                             ${Bump_Price}                                           ${All_Iran_Packge_Price}
    ...                                             ${All_State_Packge_Price}
    Swipe Up                                        ${3}
    Click Element                                   ${ReturnAppText}

Open First Listing
    Wait Until Page Contains Element                id=${OfferInSerpID}                  timeout=15s
    @{Listings_title}                               Get Webelements                      id=${OfferInSerpID}
    ${Title}                                        Get Text                             ${Listings_title}[0]
    Should Not Be Empty                             ${Title}
    Set Test Variable                               ${FirstTitle}                        ${Title}
    Click Element                                   ${Listings_title}[0]
    Validate That Is On The Listing Details Page    ${FirstTitle}
