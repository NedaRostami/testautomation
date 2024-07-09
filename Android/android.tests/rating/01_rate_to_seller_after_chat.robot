*** Settings ***
Documentation                                               In this scenario, Rate is given to seller of a listing without secure purchase.
Resource                                                    ..${/}..${/}resources${/}common.resource
Suite Setup                                                 Set Suite Environment
Test Setup                                                  start app
Test Teardown                                               Close test application
Test Timeout                                                10 minutes

*** Test Cases ***
Rate To Seller Of A Listing Without SecurePurchase
    [Tags]                                                  rate                                 chat
    Confirm That Rating Toggle Is Enabled
    Open First Listing
    Find A Listing Without SecurePurchase By Swipe Next
    Try To Start Chat When Not Loggedin
    Login By Mobile
    Send A Message To Seller
    Back To Listing Details Page
    Click On Chat Button
    Rating Popup Should Appear On Chat Page
    Go To Rating Page
    Rate And Comment To The Seller

*** Keywords ***
Find A Listing Without SecurePurchase By Swipe Next
    FOR    ${i}    IN RANGE    24
        Check Listing Details Page Is Loaded
        ${with_sp}                                          Run Keyword And Return Status        Page Should Contain Element        id=${PURCHASE_BUTTON}
        Exit For Loop If                                    not ${with_sp}
        Swipe Next
    END
    Run Keyword If                                          ${with_sp}                           Fail                               Listing without securePurchase not found.
    ${Listing_Title}                                        Get Text                             id=${LISTING_DETAILS_TITLE}
    Set Test Variable                                       ${Listing_Title}

Swipe Next
    Swipe By Percent                                        80   80   30   80   500

Try To Start Chat When Not Loggedin
    Click On Chat Button

Click On Chat Button
    Click Element                                           id=${LISTING_DETAILS_CHAT_BTN}

Send A Message To Seller
    Validate That Is On The Chat Page
    Check That Connected To Server
    Send A Hello Message

Validate That Is On The Chat Page
    Wait Until Page Contains Element                        ${PAGE_TITLE_TEXT.format("${Listing_Title}")}                           timeout=10s

Check That Connected To Server
    Wait Until Page Does Not Contain Element                ${PAGE_SUB_TITLE_TEXT.format("${communicating_with_server}")}           timeout=15s

Send A Hello Message
    Input Text                                              ${CHAT_TEXT_EDIT}                                                       سلام
    Click Element                                           ${CHAT_SEND_BTN}

Back To Listing Details Page
    Click Back Button
    Wait Until Page Contains Element                        id=${LISTING_DETAILS_TITLE}

Rating Popup Should Appear On Chat Page
    Wait Until Page Contains Element                        ${CHAT_RATING_POPUP}                                                    timeout=10s

Go To Rating Page
    Click Element                                           ${CHAT_RATE_TO_SELLER_BTN}
    Validate That Is On The Rating Page
