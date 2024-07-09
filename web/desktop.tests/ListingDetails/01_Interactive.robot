*** Settings ***
Documentation                                    Check Listing detail Utilities
Test Setup                                       Open test browser
Test Teardown                                    Clean Up Tests
Resource                                         ../../resources/setup.resource

*** variables ***
${State}                                         اصفهان
${City}                                          اصفهان
${Region}                                        لادان

*** Test Cases ***
Check Listing Options
    [Tags]                                       Options   listing details   serp   header
    # Add New Listing Min LoggedIn By Mobile
    # Go To       ${SERVER}/ایران/ورزش-فرهنگ-فراغت/انواع-ساز-آلات-موسیقی
    # Wait Until Page Contains     آگهی های انواع ساز و آلات موسیقی در ${AllIran}     timeout=10s
    Click Link                                   ${AllAdvs}
    Wait Until Page Contains                     ${IranAllH1}
    Check Serp Favourites
    Check Mobile Number Visibility In Contact
    Check Contact Visibility in Description
    Share Pop UP
    Favorite
    Open Listing detail
    Report Listing
    #todo :keyword
    #Contact Support

*** Keywords ***
Add New Listing Min LoggedIn By Mobile
  Login OR Register By Random OR New Mobile      ${Auth_Session_Position}
  Go To Post Listing Page
  Post A New Listing                             ${1}  43619  43625  tel=${Random_User_Mobile_B}
  #Click By Css Selector  [data-bind="click: submit"]
  Verify Post Listing Is done
  Check My Listing
  Login Trumpet Admin Page
  Verify Advertise By ID in trumpet
  Check My Ads Has been Verified

Check Serp Favourites
  ${SerpTitle}                                   Get Text                                      ${Serp_All_L_Title}
  click element                                  css:span.icon-star-empty.initialized
  Wait Until Page Contains Element               css:span.icon-star-empty.initialized.saved    timeout=3s
  click element                                  ${Serp_All_L_Title}
  Wait Until Page Contains Element               ${LD_Item_Detail_Header}                      timeout=10s
  ${TitleDetail}                                 Get Text                                      ${LD_Item_Detail_Header}
  Should Contain                                 ${TitleDetail}                                ${SerpTitle}
  Set Test Variable                              ${SerpTitle}

Check Mobile Number Visibility In Contact
  Assign ID to Element                           ${LD_Item_Seller.format('1')}                 MobileA
  ${NumberFiltered}                              Get Text                                      MobileA
  Element Should Contain                         MobileA                                       XXX
  Wait Until Keyword Succeeds   3x  1s           Reclick Mobile No                             MobileA

Check Contact Visibility in Description
  Run Keyword And Ignore Error                   click link                                    ${LD_Contact_Show_More}
  Element Should Contain                         ${LD_Underlined}                               XXX
  Click Element                                  ${LD_Underlined}
  Wait Until Page Does Not Contain               ${LD_Show_Complete}
  Element Should Not Contain                     ${LD_Item_Seller_Details}     XXX

Reclick Mobile No
  [Arguments]    ${MobileHidden}
  ${passed}                                      Run Keyword And Return Status                 Element Should Not Contain        ${MobileHidden}  XXX
  Run Keyword Unless                             ${passed}                                     Click Element                     ${MobileHidden}
  Element Should Not Contain                     ${MobileHidden}                               XXX

Share Pop UP
  #TODO:    3186  telegram  Run Keyword And Ignore Error                   click element                                 ${LD_Post_Listing_Report}
  Run Keyword And Ignore Error                   click element                                 ${LD_Post_Listing_Report}
  Sleep                                          3s
  Click By Css Selector                          ${LD_Share_Listing}
  Wait Until Page Contains                       ${LD_Share_Listing_PU}
  click element                                  ${LD_Share_Listing_PU_Close}



Report Listing
  Email Generator A
  Mobile Generator A
  Click By Css Selector                          ${LD_Listing_Report_PU}
  Wait Until Page Contains                       ${LD_Reason_To_Report_PU}
  @{Report_Listing_Item}                         Get WebElements                               ${LD_Complain_Type_PU}
  Click Element                                  ${Report_Listing_Item}[1]
  Input Text                                     ${LD_Report_Email_PU}                         ${Random_User_Email_A}
  Input Text                                     ${LD_Report_Mobile_PU}                        ${Random_User_Mobile_A}
  input text                                     message                                       ${LD_Input_Txt_Report_PU}
  Wait Until Keyword Succeeds                    3x    1s                                      Click Send Report Button
  click element                                  ${LD_Report_PU_Close}
  Login Trumpet Admin Page
  Go To                                          ${SERVER}/trumpet/reported-listing/search
  Wait Until Page Contains                       نوع گزارش                                    timeout=5s
  Input Text                                     id=ce                                         ${Random_User_Email_A}
  Wait Until Keyword Succeeds                    3x    1s                                      Click Search Button


Click Send Report Button
  Click Button                                   ارسال
  wait until page contains                       آگهی مورد نظر با موفقیت گزارش گردید         timeout=5s

Click Search Button
  Click Button                                   جستجو
  Wait Until Page Contains                       ${Random_User_Email_A}                        timeout=5s

Favorite
  Page Should Contain Element                  css=.saved
  go to                                        ${SERVER}/session/favourites
  wait until page contains                     ${SerpTitle}
  click element                                css=.saved
  Wait Until Keyword Returns Passed            3   1          Page Should Contain             آگهی‌های مورد علاقه خود را توسط دکمه

Open Listing detail
  Go To                                        ${SERver}/ایران
  Wait Until Page Contains                     آگهی‌های عکس‌‌دار                                timeout=3s
  @{serp_item}                                 Get WebElements                                class=serp-item
  Click Element                                ${serp_item}[1]
  Wait Until Page Contains                     ${LD_Lising_Report}                            timeout=2s


Contact Support
  #پشتیبانی
  click by xpath                               link                                          ${Header_Support}
  click by xpath                               link                                          ${Header_Contact_Support}
