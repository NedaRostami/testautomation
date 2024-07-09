*** Settings ***
Documentation                                   Chat between two users, from listing details and My chat page,
...                                             Blocking one user by another.
Resource                                        ../../resources/setup.resource
Test Setup                                      Open Test Browser
Test Teardown                                   Run Keywords
...                                             Clean Up Tests
...                                             Delete Created Block Reason

*** Variables ***
${user1_name}                                   آل پاچینو
${user2_name}                                   رابرت دونیرو
${user2_msg1}                                   سلام آل حالت چطوره ؟؟؟؟
${user2_msg2}                                   چه خبرا!!!
${user2_msg3}                                   بهتره منو بلاک کنی!
${user2_msg4}                                   بلاک شدم؟
${user1_msg1}                                   قربانت رابی
${user1_msg2}                                   بدک نیست شکر :)
${block_reason_label}                           بلاک برای تست
${block_reason_description}                     توضیح دلایل بلاک تستی
@{mc_received_msgs}
${mc_sent_msgs_count}                           ${0}
${ld_sent_msgs_count}                           ${0}

*** Test Cases ***
Chat By 2 Users
    [Tags]                                      chat      block      listing      listing details
    Confirm That Chat Toggle Is Enabled
    Create New Test Block Reason
    Post A New Random Listing
    Login As User 1
    Change User 1 Profile Name
    Set User 1 Profile Photo
    Validate Empty Chat Page
    Open New Window For User 2
    Go To Listing Details Page Of User 1
    Try To Chat When Not Logged In
    Login As User 2
    Change User 2 Profile Name
    Go To Listing Page And Start Chat
    Switch To User 1 Browser
    Start Chat With User 2
    Switch To User 2 Browser
    Validate Received Messages In Listing Details
    Send A Message To Be Blocked
    Switch To User 1 Browser
    Validate Received 3th Message In My Chats
    Block User 2
    Switch To User 2 Browser
    Validate Block By Sending Message

*** Keywords ***
Confirm That Chat Toggle Is Enabled
    Run Keyword Unless                         ${Toggle_newChat}                  Enable Web Chat Toggle

Enable Web Chat Toggle
    Mock Toggle Set                            web      newChat                   ${1}

Create New Test Block Reason
    ${block_reason_id}                         Create New Block Reason            ${block_reason_label}
    Set Test Variable                          ${block_reason_id}

Login As User 1
    Login OR Register By Mobile                ${Random_User_Mobile_A}            ${Auth_Session_Position}

Validate Empty Chat Page
    Go To My Chats
    Wait Until Page Contains Element           ${Chat_Wall_Empty}                 timeout=30s
    Element Should Contain                     ${Chat_Wall_Empty}                 ${Chat_Empty_Msg1}
    Element Should Contain                     ${Chat_Wall_Empty}                 ${Chat_Empty_Msg2}

Open New Window For User 2
    Set Test Variable                          ${Second}                          ${TRUE}
    Open test browser

Go To Listing Details Page Of User 1
    Go To                                      ${SERVER}/${AdsId}
    Refresh Varnish
    Wait Until Page Contains Element           ${LD_Chat_Btn_Not_Loggedin}        timeout=10s
    Validate Profile Info On Listing Details

Try To Chat When Not Logged In
    Click Element                              ${LD_Chat_Btn_Not_Loggedin}

Login As User 2
    Mobile Generator B
    Login OR Register By Mobile                ${Random_User_Mobile_B}            ${Auth_LD_Chat_Position}

Go To Listing Page And Start Chat
    Go To Listing Details Page Of User 1
    Open Chat Popup In Listing Details Page
    Send Chat ${user2_msg1} In Listing Details Page
    Send Chat ${user2_msg2} In Listing Details Page

Open Chat Popup In Listing Details Page
    # Execute Javascript                         document.querySelector("#item-seller-details > a").click()
    Click Element                              ${LD_Chat_Btn_Loggedin}
    Wait Until Element Is Visible              ${LD_Chat_Nickname}                timeout=10s
    Element Should Contain                     ${LD_Chat_Nickname}                ${user1_name}

Start Chat With User 2
    Wait Until Chat Item Appear On The Page
    Open Chat Item Window
    Send Messages To User 2

Send Messages To User 2
    Send Chat ${user1_msg1} In My Chats Page
    Send Chat ${user1_msg2} In My Chats Page

Wait Until Chat Item Appear On The Page
    FOR   ${i}    IN RANGE  4
        ${existence_chat}                       Run Keyword And Return Status                 Wait Until Page Contains
        ...                                     ${Chat_Select_From_List_Msg}                  timeout=10s
        Exit For Loop If                        ${existence_chat}
        reload page
        Wait Until Page Is Loaded
    END
    Run Keyword Unless                          ${existence_chat}           Fail              No chats found on page.
    Wait Until Element Contains                 ${Chat_Item_Title.format('${AdsId}')}         ${random_listing}[title]    timeout=10s
    Element Should Contain                      ${Chat_Item_Nickname.format('${AdsId}')}      ${user2_name}

Open Chat Item Window
    Click Element                               ${Chat_List_Item.format('${AdsId}')}
    Wait Until Element Contains                 ${Chat_Wall_Title}                            ${random_listing}[title]    timeout=10s
    Element Should Contain                      ${Chat_Wall_Nickname}                         ${user2_name}
    Validate Received Messages In My Chats      ${user2_msg1}                                 ${user2_msg2}

Validate Received Messages In My Chats
    [Arguments]                                 @{msgs}
    reload page
    Wait Until Page Is Loaded
    Append To List                              ${mc_received_msgs}                           @{msgs}
    Set Test Variable                           ${mc_received_msgs}
    ${messages_count}                           Get Length                                    ${mc_received_msgs}
    Wait Until Page Contains Element            ${Chat_Received_Msg}                          timeout=10s
    ...                                         limit=${messages_count}                       error=Does not display ${messages_count} received messages.
    ${Received_Messages}                        Get WebElements                               ${Chat_Received_Msg}
    FOR   ${index}   ${message}                 IN ENUMERATE                                  @{mc_received_msgs}
        Element Should Contain                  ${Received_Messages}[${index}]                ${message}
    END

Validate Received Messages In Listing Details
    Wait Until Page Contains Element            ${LD_Received_Messages}                       timeout=10s
    ...                                         limit=${2}                                    error=Does not display two received messages.
    ${Received_Messages}                        Get WebElements                               ${LD_Received_Messages}
    Element Should Contain                      ${Received_Messages}[0]                       ${user1_msg1}
    Element Should Contain                      ${Received_Messages}[1]                       ${user1_msg2}

Go To My Chats
    Go to                                       ${SERVER}/session/myChats
    FOR  ${INDEX}                               IN RANGE   3
        Wait Until Page Does Not Contain        در حال برقراری ارتباط                         timeout=10s
        ${status}                               Run Keyword And Return Status                 Page Should Contain    ارتباط قطع شد
        Exit For Loop If                        not ${status}
        Click Link                              بارگذاری دوباره صفحه
        Wait Until Page Is Loaded
    END
    Run Keyword If                              ${status}            Fail                     Can not connect Chat Server

Send Chat ${Message} In Listing Details Page
    Input Text                                  ${Ld_Send_Messages_Input}                     ${Message}
    Click Element                               ${LD_Send_Messages_Btn}
    Validate Sent Messages In Listing Details   ${Message}

Validate Sent Messages In Listing Details
    [Arguments]                                 ${msg}
    Set Test Variable                           ${ld_sent_msgs_count}                         ${ld_sent_msgs_count+1}
    Wait Until Page Contains Element            ${LD_Messages_Sent}                           timeout=2s
    ...                                         limit=${ld_sent_msgs_count}                   error=Does not display ${ld_sent_msgs_count} sent messages.
    ${sent_msgs}                                Get WebElements                               ${LD_Messages_Sent}
    Element Should Contain                      ${sent_msgs}[${ld_sent_msgs_count-1}]         ${msg}

Send Chat ${Message} In My Chats Page
    Input Text                                  ${Chat_Messages_Input}                        ${Message}
    Click Element                               ${Chat_Send_Messages_Btn}
    Validate Sent Messages In My Chats          ${Message}

Validate Sent Messages In My Chats
    [Arguments]                                 ${msg}
    Set Test Variable                           ${mc_sent_msgs_count}                         ${mc_sent_msgs_count+1}
    Wait Until Page Contains Element            ${Chat_Msg_Sent}                              timeout=2s
    ...                                         limit=${mc_sent_msgs_count}                   error=Does not display ${mc_sent_msgs_count} sent messages.
    ${sent_msgs}                                Get WebElements                               ${Chat_Msg_Sent}
    Element Should Contain                      ${sent_msgs}[${mc_sent_msgs_count-1}]         ${msg}

Send A Message To Be Blocked
    Send Chat ${user2_msg3} In Listing Details Page

Block User 2
    Open Block Reasons Popup
    Select Reason And Description Of Block
    Validate That User Is Blocked On Chat

Open Block Reasons Popup
    Click Element                               ${Chat_Wall_Option_Menu}
    Wait Until Page Contains Element            ${Chat_Wall_Option_Block}                                               timeout=3s
    Click Element                               ${Chat_Wall_Option_Block}
    Wait Until Page Contains Element            ${Chat_Block_Reasons_Popup}                                             timeout=3s

Select Reason And Description Of Block
    Click Element                               ${Chat_Block_Reasons_Label.format("${block_reason_label}")}
    Input Text                                  ${Chat_Block_Description}                                               ${block_reason_description}
    Click Button                                ${Chat_Block_Submit}

Validate That User Is Blocked On Chat
    Wait Until Page Contains Element            ${Chat_Wall_Block}                                                      timeout=5s
    Element Should Contain                      ${Chat_Wall_Block}                                                      ${Chat_Wall_Block_Msg}

Validate Block By Sending Message
    Run Keyword And Expect Error                Does not display ${4} sent messages.
    ...                                         Send Chat ${user2_msg4} In Listing Details Page
    Page Should Not Contain Element             ${LD_Messages_Sent} >> xpath://*[text()="${user2_msg4}"]

Set User 1 Profile Photo
    Upload Profile Photo
    Submit Profile Info Changes
    Validate The Photo Waiting For Approval
    Approve Profile Photo Via Admin

Upload Profile Photo
    ${img_path}                                 Normalize Path                                ${CURDIR}/../../../lib/Sheypoor/libraries/Images/static/users/Al_Pacino.jpg
    Choose File                                 ${P_E_Input_Img}                              ${img_path}
    Wait Until Page Contains Element            ${P_E_Img_Hide_Spinner}                       timeout=10s
    Page Should Contain Element                 ${P_E_Img_Trash_Icon}

Validate The Photo Waiting For Approval
    Validate Waiting Photo On Edit Profile
    Validate Waiting Photo On My Profile

Validate Waiting Photo On Edit Profile
    Page Should Contain Element                 ${P_E_Img_Pend_Approve}
    Validate Image Pending Notif

Validate Waiting Photo On My Profile
    Go To My Profile Page
    Page Should Contain Element                 ${P_Img_Pend_Approve}
    Validate Image Pending Notif

Validate Image Pending Notif
    Page Should Contain Element                 ${P_Img_Pend_Approve_Notif}
    Element Should Contain                      ${P_Img_Pend_Approve_Notif}                   ${Profile_Img_Pend_Approve_Msg}

Approve Profile Photo Via Admin
    Approve User Profile Photo                  name=${user1_name}                            phone=${Random_User_Mobile_A}
    ...                                         seller_type=normal
    Validate Approved Profile Photo

Validate Approved Profile Photo
    Refresh Varnish
    Wait Until Page Contains Element            ${P_Section}                                  timeout=10s
    Element Attribute Value Should Be           ${P_Img}                                      class                                 ${EMPTY}

Validate Profile Info On Listing Details
    Validate Seller Nickname On Listing Details
    Validate Profile Photo On Listing Details

Validate Seller Nickname On Listing Details
    SeleniumLibrary.Element Text Should Be      ${LD_Seller_Nickname}                         ${user1_name}

Validate Profile Photo On Listing Details
    ${profile_photo_src}                        SeleniumLibrary.Get Element Attribute         ${LD_Shop_Logo}                       src
    Should Contain                              ${profile_photo_src}                          _profile

Delete Created Block Reason
    ${block_reason_was_created}                 Run Keyword And Return Status                 Variable Should Exist                 ${block_reason_id}
    Run Keyword If                              ${block_reason_was_created}                   Delete Block Reason                   ${block_reason_id}

Change User ${th} Profile Name
    Change Profile Name                         ${user${th}_name}

Switch To User ${th} Browser
    Switch Browser                              ${th}

Validate Received 3th Message In My Chats
    Validate Received Messages In My Chats      ${user2_msg3}
