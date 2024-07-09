***Settings***
Documentation                              In this scenario, sending and recieving masseges is tested.
Resource                                   ../../resources/package.resource
Test Setup                                 Open test browser
Test Teardown                              Clean Up Tests

***Variables***
${Message}                                 سلام
${Responds}                                خوبی؟

***Test Cases***
Send And Recieve Masseges
  [Tags]                                   Chat                                 Sheypoor
  Login to Aloonak User A
  Create A Listing
  Check If Chat Is Empty
  Login To Sheypoor User B
  Send ${Message} To user A
  User A ${Responds} To Chat
  Check If User A Has Responded To Chat

***Keywords***
Login to Aloonak User A
  Create Shop In Sheypoor
  Login To ProTools                        ${Shop_owner_phone}

Create A Listing
  Create New Listing                       Land Main Attribute For Rent    1    44099    house   District=n1203
  Get Listing Human Readable Id

Check If Chat Is Empty
  Wait Until Keyword Succeeds              3x    3s     Click Element           ${My_Chats}
  Wait Until Page Contains                 ${Chat_View}                         timeout=10s

Login To Sheypoor User B
  Open test browser
  Import Resource                          ${CURDIR}../../../../../web/resources/common.resource
  Set Library Search Order                 common                               package
  Mobile Generator B
  Login OR Register By Mobile              ${Random_User_Mobile_B}              ${Auth_Session_Position}

Send ${Message} To user A
  Go To                                    ${SERVER}/${human_readable_id}
  Click Element                            ${Chat_Btn}
  Wait Until Element Is Visible            ${LD_Chat_Nickname}                  timeout=10s
  Input Text                               ${Msg_Txt_Box_2}                     ${Message}
  Click Element                            ${Send_Msg_2}
  Wait Until Page Contains                 ${Message}                           timeout=10s



User A ${Responds} To Chat
  Switch Browser                           1
  Wait Until Keyword Succeeds              3x    3s     Click Element           ${My_Chats}
  Wait Until Page Contains                 ${Message}                           timeout=10s
  Click By Text                            ${Message}
  Input Text                               ${Msg_Txt_Box_1}                     ${Responds}
   Click Element                           ${Send_Msg_1}
  Wait Until Page Contains                 ${Responds}                          timeout=10s

Check If User A Has Responded To Chat
  Switch Browser                           2
  Wait Until Page Contains                 ${Responds}                          timeout=10s
