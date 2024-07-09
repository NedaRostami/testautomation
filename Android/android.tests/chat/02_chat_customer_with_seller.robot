*** Settings ***
Documentation                                                 Two users chat with each other and send photos, location and text in the chat.
...                                                           Finally, one user blocks the other user.
Resource                                                      ../../resources/common.resource
Suite Setup                                                   Set Suite Environment
Test Setup                                                    Create New Test Block Reason On Admin Panel
Test Teardown                                                 Finish Teardown Android Chat Task
Test Timeout                                                  10 minutes

*** Variables ***
${customer_msg}                                               لطفا عکس و لوکیشن بفرست.
${seller_msg}                                                 ارسال شد.
${seller_block_msg}                                           بلاک شدم؟
${block_reason_label}                                         بلاک برای تست اندروید
${block_reason_description}                                   توضیح دلایل بلاک تستی

*** Test Cases ***
Chat Two Users
    [Tags]                                                    chat     call     block
    Customer Find A Listing And Send Message
    Seller Read And Answer The Chat Message
    Customer Read The Message And Block The Seller
    Seller Try To Send New Message
    Customer Validate The Seller Is Blocked

*** Keywords ***
Customer Find A Listing And Send Message
    Open Sheypoor Application As Customer
    Open First Listing
    Get Listing Info From Listing Details Page
    Send Message To Seller

Seller Read And Answer The Chat Message
    Open Sheypoor Application As Seller
    Make Customer Busy
    Go To My Chat Page
    Filter My Listings Chats
    Validate Recieved Message On My Chats Page
    Validate Recieved Message On Chat Room
    Make Customer Busy
    Send Messages To Customer

Customer Read The Message And Block The Seller
    Switch To Customer Application
    Validate Recieved Messages From Seller
    Block The Seller

Seller Try To Send New Message
    Switch To Seller Application
    Validate If Blocked By Sending Another Message

Customer Validate The Seller Is Blocked
    Switch To Customer Application
    Validate That Seller Blocked On My Chats Page

Open Sheypoor Application As Customer
    start app                                                 ALIAS=Customer

Open Sheypoor Application As Seller
    IF                                                       '${REMOTE_TEST}' == 'Local'
        Set Test Variable                                     ${deviceName}                             emulator-5556
        Set Test Variable                                     ${android_version}                        9
    END
    start app                                                 ALIAS=Seller

Switch To ${session} Application
    Switch Application                                        ${session}

Login As Seller
    Login By Mobile                                           ${seller_phone_number}

Login As Customer
    Login By Mobile

Get Listing Info From Listing Details Page
    Find Listing With The Call And Chat Button
    Get Listig Title
    Call Seller Number To Made It Visible
    Get Seler Phone Number

Find Listing With The Call And Chat Button
    FOR    ${i}    IN RANGE    20
        Check Listing Details Page Is Loaded
        ${pass}                                               Run Keyword And Return Status             Check That The Listing Has Call And Chat Conditions
        Exit For Loop If                                      ${pass}
        Swipe Next
    END
    Run Keyword Unless                                        ${pass}           Fail                    Listing that contains seller phone number and chat button is not found.

Check That The Listing Has Call And Chat Conditions
    Page Should Contain Element                               ${LISTING_DETAILS_CALL_BTN}
    Find Element By Swipe in loop                             ${LISTING_DETAILS_SHOP_NUMBER}
    Element Should Contain Text                               ${LISTING_DETAILS_SHOP_NUMBER}            0900XXX
    Page Should Contain Element                               ${LISTING_DETAILS_CHAT_BTN}

Swipe Next
    Swipe By Percent                                          80   80   30   80   500

Get Listig Title
    Get Listig Title Locator
    ${Listing_Title}                                          Get Text                                  ${title_locator}
    Set Test Variable                                         ${Listing_Title}

Get Listig Title Locator
    ${page_not_scrolled}                                      Run Keyword And Return Status
    ...                                                       Page Should Contain Element               ${LISTING_DETAILS_TITLE}
    ${title_locator}                                          Set Variable If                           ${page_not_scrolled}
    ...                                                       ${LISTING_DETAILS_TITLE}                  ${PAGE_TITLE}
    Set Test Variable                                         ${title_locator}

Call Seller Number To Made It Visible
    Click Element                                             ${LISTING_DETAILS_CALL_BTN}
    Wait Until Exit From Sheypoor App
    Back To Sheypoor App
    Close NPS Popup

Wait Until Exit From Sheypoor App
    Wait Until Keyword Succeeds                               5x    2s                                  Not In the Sheypoor App

Not In the Sheypoor App
    ${app_activity}                                           Get Activity
    Should Not Contain                                        ${app_activity}                           com.sheypoor

Get Seler Phone Number
    ${phone_number}                                           Get Text                                  ${LISTING_DETAILS_SHOP_NUMBER}
    ${phone_number}                                           Fetch From Right                          ${phone_number}                   :${SPACE}
    Set Test Variable                                         ${seller_phone_number}                    ${phone_number}

Click Chat Button
    Click Element                                             ${LISTING_DETAILS_CHAT_BTN}

Send Message To Seller
    Click Chat Button
    Login As Customer
    Validate That Is On The Chat Room Page
    Check That Connected To Server
    Wait Until Page Is Loaded
    Send Chat Message                                         ${customer_msg}

Validate That Is On The Chat Room Page
    Wait Until Page Contains Element                          ${PAGE_TITLE_TEXT.format("${Listing_Title}")}                           timeout=10s

Check That Connected To Server
    Wait Until Page Does Not Contain Element                  ${PAGE_SUB_TITLE_TEXT.format("${communicating_with_server}")}           timeout=20s

Wait Until Page Is Loaded
    Wait Until Page Does Not Contain Element                  ${HORIZONTAL_LOADING_PROGRESS}                                          timeout=10s

Send Chat Message
    [Arguments]                                               ${msg}
    Input Text                                                ${CHAT_TEXT_EDIT}                      ${msg}
    Click Element                                             ${CHAT_SEND_BTN}
    Page Should Contain Element By ID And Text                ${CHAT_ROOM_MSG}                       ${msg}

Go To My Chat Page
    Click Element                                             ${TOOLBAR_CHAT_ICON}
    Login As Seller

Filter My Listings Chats
    Filter My Chats Page                                      آگهی‌های من

Filter Listings Of Others Chats
    Filter My Chats Page                                      آگهی‌های دیگران

Filter My Chats Page
    [Arguments]                                               ${option}
    Validate That Is On The My Chats Page
    Click Element                                             ${MY_CHAT_FILTER}
    Click The Link                                            ${option}

Validate That Is On The My Chats Page
    Wait Until Page Contains Element                          ${MY_CHAT_FILTER}                      timeout=10s

Validate Recieved Message On My Chats Page
    Wait Until Page Contains Element                          ${CHAT_ITEMS}                          timeout=5s
    Element Text Should Be                                    ${CHAT_ITEM_MSG}                       ${customer_msg}
    ${hidden_mobile}                                          Catenate
    ...                                                       SEPARATOR=XXXX                         ${Mobile[:4]}   ${Mobile[7:]}
    Element Text Should Be                                    ${CHAT_ITEM_NICKNAME}                  ${hidden_mobile}

Send Messages To Customer
    Attach Image
    Attach Location
    Send Chat Message                                         ${seller_msg}

Go To Desired Chat Room
    Click Element                                             ${CHAT_ITEM_MSG}
    Validate That Is On The Chat Room Page
    Check That Connected To Server
    Wait Until Page Is Loaded

Validate Recieved Message On Chat Room
    Go To Desired Chat Room
    Page Should Contain Element By ID And Text                ${CHAT_ROOM_MSG}                         ${customer_msg}

Open Attachment Bottom Popup
    Click Element                                             ${CHAT_SEND_BTN}
    Wait Until Page Contains Element                          ${CHAT_ATTACHMENT_BOTTOM_POPUP}          timeout=5s

Attach Location
    Open Attachment Bottom Popup
    Open Map
    Send Current Location
    Validate That Location sent

Send Current Location
    Wait Until Page Does Not Contain                          ${searching_for_your_location}            timeout=5s
    Click Button                                              تایید

Open Map
    Click Button                                               ارسال آدرس
    Wait Until Page Contains Element                          ${CHAT_ROOM_MAP}                          timeout=10s

Validate That Location sent
    Wait Until Page Is Loaded
    Page Should Contain Both Image And Location

Page Should Contain Both Image And Location
    ${file_sent}                                              Get Webelements                           ${CHAT_ROOM_IMG}
    Length Should Be                                          ${file_sent}                              2

Attach Image
    Insert Chat Photos To Device
    Open Attachment Bottom Popup
    Select Image From Bottom Popup
    Validate That Image sent

Insert Chat Photos To Device
    ${img_path}                                               Normalize Path                            ${CURDIR}/../../../lib/Sheypoor/libraries/Images/static/sports/1.jpg
    Push File To Device                                       /mnt/sdcard/Pictures/chat_photo.jpg       source_path=${img_path}
    ADB Shell                                                 am broadcast -a android.intent.action.MEDIA_SCANNER_SCAN_FILE -d file:///mnt/sdcard/Pictures/chat_photo.jpg

Select Image From Bottom Popup
    Click Element                                             ${CHAT_ROOM_IMG_CHECKBOX}
    Click Element                                             ${CHAT_SEND_BTN}

Validate That Image sent
    Wait Until Page Contains Element                          ${CHAT_ROOM_IMG}                           timeout=5s
    Wait Until Page Does Not Contain Element                  ${CHAT_ROOM_IMG_PROGRESS}                  timeout=20s

Validate Recieved Messages From Seller
    Page Should Contain Both Image And Location
    Page Should Contain Element By ID And Text                ${CHAT_ROOM_MSG}                           ${seller_msg}

Block The Seller
    Open Block Page
    Select Block Reason
    Submit Block
    Validate If Seller Is Blocked On Chat Room

Create New Test Block Reason On Admin Panel
    ${block_reason_id}                                        Create New Block Reason                    ${block_reason_label}
    Set Test Variable                                         ${block_reason_id}

Open Block Page
    Click Element                                             ${CHAT_ROOM_TOOLBAR_MORE}
    Click The Link                                            بلاک کردن
    Wait Until Page Contains                                  ${block_reason_label}

Select Block Reason
    Click The Link                                            ${block_reason_label}
    Input Text                                                ${INPUT_EDIT_TXT}                          ${block_reason_description}

Submit Block
    Click Button                                               بلاک کن

Validate If Seller Is Blocked On Chat Room
    Wait Until Page Contains Element                          ${CHAT_ROOM_BLOCKED}                       timeout=10s
    Page Should Contain Text                                  ${blocked_user_msg1}
    Page Should Contain Text                                  ${blocked_user_msg2}
    Page Should Contain Element                               ${CHAT_ROOM_UNBLOCKE_BTN}

Validate If Blocked By Sending Another Message
    Send Message "Am I Blocked?"
    Close Attachment Bottom Popup
    Back To My Chats Page From Chat Room
    Go To Desired Chat Room
    Page Should Not Contain Message "Am I Blocked?"

Send Message "Am I Blocked?"
    Send Chat Message                                         ${seller_block_msg}

Page Should Not Contain Message "Am I Blocked?"
    Page Should Not Contain Element By ID And Text            ${CHAT_ROOM_MSG}                           ${seller_block_msg}

Back To My Chats Page From Chat Room
    Click Back Button
    Validate That Is On The My Chats Page

Close Attachment Bottom Popup
    Click Back Button

Validate That Seller Blocked On My Chats Page
    Back To Home Page                                         2
    Go To My Chat Page Via Hamburger Menu
    Filter Listings Of Others Chats
    Validate That Desired Chat Status Is Blocked

Go To My Chat Page Via Hamburger Menu
    Click Toolbar Account
    Click Toolbar Items                                       ${MY_CHATS}

Validate That Desired Chat Status Is Blocked
    Wait Until Page Contains Element                          ${CHAT_ITEMS}                              timeout=5s
    Page Should Contain Element By ID And Text                ${CHAT_ITEM_STATUS}                        بلاک شده

Finish Teardown Android Chat Task
    Run Keyword And Ignore Error                              Close Applications On Both Session
    Delete Created Block Reason
    Set File Vesion Metadata

Close Applications On Both Session
    Finish Teardown Tasks For Seller
    Finish Teardown Tasks For Customer
    Set App file Metadata
    Close All Applications

Finish Teardown Tasks For Seller
    ${switch_app}                                             Run Keyword And Return Status             Switch To Seller Application
    IF                                                        ${switch_app}
        Remove Inserted Photo From Seller Device
        Finish Seller Teardown Tasks
    END

Remove Inserted Photo From Seller Device
    Remove Photo From Device                                  chat_photo.jpg

Finish Teardown Tasks For Customer
    ${switch_app}                                             Run Keyword And Return Status              Switch To Customer Application
    Run Keyword If                                            ${switch_app}                              Finish Customer Teardown Tasks

Finish ${session} Teardown Tasks
    Run Keyword If	                                         '${REMOTE_TEST}' == 'Grid'                  Find Docker Name                 ${session}
    Run Keyword If Test Failed                                On failure Setups
    Run Keyword If Test Passed                                On Pass Setups
    Run Keyword If                                           '${REMOTE_TEST}' == 'Grid'                  Close Connection

Delete Created Block Reason
    ${block_reason_was_created}                               Run Keyword And Return Status              Variable Should Exist            ${block_reason_id}
    Run Keyword If                                            ${block_reason_was_created}                Delete Block Reason              ${block_reason_id}

Make Customer Busy
    [Documentation]                                           This keyword is used so that the customer session does not terminated due to timeout.
    Switch To Customer Application
    Open Attachment Bottom Popup
    Close Attachment Bottom Popup
    Switch To Seller Application

Set File Vesion Metadata
    Set Suite Metadata                                        name=File Version                     value=${file_version}

Save Video Recording Name
    IF                                                       '${ALIAS}' == 'Customer'
        Set Customer Video Metadata
    ELSE
        Set Seller Video Metadata
    END

Set ${session} Video Metadata
    ${Values}                                                 Set Variable If    ${Round} == ${1}
    ...                                                       [${APP_LOGS}/${PR}/${build}/${videoPattern}_1.mp4 | ${session} 1]
    ...                                                       [${APP_LOGS}/${PR}/${build}/${videoPattern}_1.mp4 | ${session} 1] | [${APP_LOGS}/${PR}/${build}/${videoPattern}_2.mp4 | ${session} 2]
    Set Suite Metadata                                        name=Watch ${session} Videos          value=${Values}       append=True     top=False
    Set Test Message                                          ${Values}                             append=True

Find Docker Name
    [Arguments]                                               ${session}
    SSH Login to HUB
    Get Docker Name
    Set Suite Metadata                                        name=${session} Docker Name           value=${DOCKERNAME}   append=True      top=False
