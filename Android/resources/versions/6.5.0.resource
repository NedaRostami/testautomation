*** Settings ***
Resource                                            6.4.2.resource

*** Variables ***


*** Keywords ***
########################################      Secure Purchase          ###############################################

Validate Secure Purchase Detail In Listing Details Page
    Wait Until Page Contains Element       ${PURCHASE_BUTTON}
    Element Should Contain Text            ${PURCHASE_BUTTON}      ${PURCHASE_BUTTON_TEXT}
    # Validate Secure Purchase Banner In Listing Details Page
    Page Should Not Contain Element        ${SECURE_PURCHASE_ICONS_OLD}

# Validate Secure Purchase Banner In Listing Details Page
#     Page Should Contain Element            ${TOP_BANNER_ICON}
#     Element Should Contain Text            ${TOP_BANNER_TITLE}          ${TOP_BANNER_TITLE_TXT}
#     Element Should Contain Text            ${TOP_BANNER_DESC}           ${TOP_BANNER_DESC_TXT}
