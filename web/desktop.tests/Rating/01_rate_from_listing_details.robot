*** Settings ***
Documentation                                     post a new listing by random seller, then login with a another random phone number
...                                               and rate and comment to the seller,
...                                               then login with the seller's phone number and reply to the comment,
...                                               then validate the submitted rate and comment and reply.
Resource                                          ../../resources/setup.resource
Test Setup                                        Open Test Browser
Test Teardown                                     Clean Up Tests

*** Variables ***
${rater_nickname}                                 کریستیانو
${seller_nickname}                                لئو
${rating_comment}                                 تست ثبت نظر برای فروشنده
${rating_reply}                                   تست ثبت ریپلای به نظر مشتری
${main_rate_star}                                 ${3}
${response_speed_rate_star}                       ${2}
${how_to_deal_rate_star}                          ${4}
${accuracy_of_info_rate_star}                     ${1}

*** Test Cases ***
Rate To Seller From Listing Details
    [Tags]          notest                        listing     listing details   rate     review    reply    profile
    Setup Init
    Post A New Random Listing
    Login To Sheypoor As A Rater
    Set Rater Nickname
    Go To Listing Details Page
    Open Rating Popup On Listing Details
    Rate And Comment To The Seller
    Approve Comment Via Admin
    Logout Rater User
    Login To Sheypoor By Seller Phone Number
    Set Seller Nickname
    Go To My Profile Page
    Check Customers Comments Tab
    Reply To Rater Comment
    Approve Reply Via Admin
    Logout Seller User
    Go To Seller Profile Page
    Check Customers Comments Tab
    Validate The Submitted Reply And Review

*** Keywords ***
Setup Init
    Confirm That Rating In Listing Details Is Enabled
    Set Index Of Rating Stars
    Convert Rating Stars To FA

Confirm That Rating In Listing Details Is Enabled
    Run Keyword Unless                            ${Toggle_user-insert-rating}                               Enable User Insert Rating
    Run Keyword Unless                            ${Toggle_user-insert-listing-rating}                       Enable User Insert Listing Rating

Enable User Insert Rating
    Mock Toggle Set                               web      user-insert-rating                                ${1}

Enable User Insert Listing Rating
    Mock Toggle Set                               web      user-insert-listing-rating                        ${1}

Set Index Of Rating Stars
    Set Test Variable                             ${main_rate_star_index}                                    ${main_rate_star-1}
    Set Test Variable                             ${response_speed_rate_star_index}                          ${response_speed_rate_star-1}
    Set Test Variable                             ${how_to_deal_rate_star_index}                             ${how_to_deal_rate_star+4}
    Set Test Variable                             ${accuracy_of_info_rate_star_index}                        ${accuracy_of_info_rate_star+9}

Login To Sheypoor As A Rater
    Login OR Register By Random OR New Mobile     ${Auth_Session_Position}

Set Rater Nickname
    Change Profile Name                           ${rater_nickname}

Set Seller Nickname
    Change Profile Name                           ${seller_nickname}

Open Rating Popup On Listing Details
    Click Element                                 ${LD_Rate}
    Wait Until Page Contains Element              ${Open_Popup.format("${LD_Rate_Popup}")}                   timeout=10s

Rate And Comment To The Seller
    Select Main Rate To Seller
    Select Detailed Rates To Seller
    Input Rating Comment
    Submit Rate

Select Main Rate To Seller
    ${main_stars}                                 Get WebElements                                            ${LD_Main_Rate_Stars}
    Click Element                                 ${main_stars}[${main_rate_star_index}]
    Validate Selected Stars                       ${main_stars}                                              ${main_rate_star_index}

Select Detailed Rates To Seller
    ${Detailed_stars}                             Get WebElements                                            ${LD_Detailed_Rates_Stars}
    Click Element                                 ${Detailed_stars}[${response_speed_rate_star_index}]
    Validate Selected Stars                       ${Detailed_stars}                                          ${response_speed_rate_star_index}
    Click Element                                 ${Detailed_stars}[${how_to_deal_rate_star_index}]
    Validate Selected Stars                       ${Detailed_stars}                                          ${how_to_deal_rate_star_index}
    Click Element                                 ${Detailed_stars}[${accuracy_of_info_rate_star_index}]
    Validate Selected Stars                       ${Detailed_stars}                                          ${accuracy_of_info_rate_star_index}

Validate Selected Stars
    [Arguments]                                   ${star_elements}                                           ${selected_index}           ${attr_value}=selected
    ${start_range}                                Set Variable If                                            ${selected_index} < ${5}    ${0}
    ...                                           ${selected_index} < ${10}                                  ${5}                        ${10}
    FOR   ${i}   IN RANGE                         ${start_range}                                             ${start_range+5}
      ${element_class}                            SeleniumLibrary.Get Element Attribute                      ${star_elements}[${i}]      class
      IF                                          ${i} <= ${selected_index}
        Should Contain                            ${element_class}                                           ${attr_value}
      ELSE
        Should Not Contain                        ${element_class}                                           ${attr_value}
      END
    END

Input Rating Comment
    Input Text                                    ${LD_Rate_Comment_Input}                                   ${rating_comment}

Submit Rate
    Click Button                                  ${LD_Rate_Submit_Btn}
    Wait Until Page Contains                      ${message_of_successfully_rating}                          timeout=5s

Approve Comment Via Admin
    Approve User Comments                         phone=${Random_User_Mobile_B}                              seller_type=0

Approve Reply Via Admin
    Approve User Comments                         phone=${Random_User_Mobile_B}                              seller_type=0

Logout Rater User
    Logout User

Logout Seller User
    Logout User

Login To Sheypoor By Seller Phone Number
    Login OR Register By Mobile                   ${Random_User_Mobile_A}               ${Auth_Session_Position}

Check Customers Comments Tab
    Element Should Contain                        ${P_Tabs}                             نظرات مشتریان
    Click Link                                    نظرات مشتریان
    Wait Until Page Contains Element              ${P_CC_Article}                       timeout=10s

Reply To Rater Comment
    Open Reply Popup
    Validate Reply Popup Details
    Submit Reply To Rater

Open Reply Popup
    Click Element                                 ${P_Reply_Menu}
    Wait Until Page Contains Element              ${P_Reply_Popup}                      timeout=5s

Validate Reply Popup Details
    Validate Rater Nickname On Reply Popup
    Validate Rating Main Stars On Reply Popup
    Validate Rating Comment On Reply Popup

Validate Rater Nickname On Reply Popup
    Element Should Contain                        ${P_RP_Rater_Details}                 ${rater_nickname}

Validate Rating Main Stars On Reply Popup
    ${main_stars}                                 Get WebElements                       ${P_RP_Rater_Stars}
    Validate Selected Stars                       ${main_stars}                         ${main_rate_star_index}              fill-star

Validate Rating Comment On Reply Popup
    Element Should Contain                        ${P_RP_Rater_Comment}                 ${rating_comment}

Submit Reply To Rater
    Input Text                                    ${P_RP_Reply_Input}                   ${rating_reply}
    Click Button                                  ثبت پاسخ
    Wait Until Page Contains                      ${message_of_under_review_reply}      timeout=5s

Go To Seller Profile Page
    Go To Listing Details Page
    Refresh Varnish
    Check Seller Nickname

Check Seller Nickname
    SeleniumLibrary.Element Text Should Be        ${LD_Seller_Nickname}                 ${seller_nickname}
    Click Element                                 ${LD_Seller_Nickname}
    Wait Until Page Contains Element              ${P_Section}                          timeout=15s

Validate The Submitted Reply And Review
    Validate Rater Nickname
    Validate Rating Main Stars
    Validate Rating Comment
    Validate Rating Details
    Validate Seller Nickname
    Validate Seller Reply

Validate Rater Nickname
    Element Should Contain                        ${P_CC_Article_Details}               ${rater_nickname}

Validate Rating Main Stars
    ${main_stars}                                 Get WebElements                       ${P_CC_Article_Stars}
    Validate Selected Stars                       ${main_stars}                         ${main_rate_star_index}              fill-star

Validate Rating Comment
    Element Should Contain                        ${P_CC_Article_Comment}               ${rating_comment}

Validate Rating Details
    ${rating_details_value}                       Get WebElements                       ${P_CC_Article_Rating_Details_Value}
    Element Should Contain                        ${rating_details_value}[0]            ${response_speed_rate_star_FA}/۵
    Element Should Contain                        ${rating_details_value}[1]            ${how_to_deal_rate_star_FA}/۵
    Element Should Contain                        ${rating_details_value}[2]            ${accuracy_of_info_rate_star_FA}/۵

Convert Rating Stars To FA
    ${response_speed_rate_star}                   Convert To String                     ${response_speed_rate_star}
    ${how_to_deal_rate_star}                      Convert To String                     ${how_to_deal_rate_star}
    ${accuracy_of_info_rate_star}                 Convert To String                     ${accuracy_of_info_rate_star}
    ${response_speed_rate_star_FA}                Convert Digits                        ${response_speed_rate_star}          En2Fa
    ${how_to_deal_rate_star_FA}                   Convert Digits                        ${how_to_deal_rate_star}             En2Fa
    ${accuracy_of_info_rate_star_FA}              Convert Digits                        ${accuracy_of_info_rate_star}        En2Fa
    Set Test Variable                             ${response_speed_rate_star_FA}
    Set Test Variable                             ${how_to_deal_rate_star_FA}
    Set Test Variable                             ${accuracy_of_info_rate_star_FA}

Validate Seller Nickname
    Element Should Contain                        ${P_Seller_Nickname}                  ${seller_nickname}
    Element Should Contain                        ${P_Reply_Details}                    ${seller_nickname}

Validate Seller Reply
    Element Should Contain                        ${P_Reply_Text}                       ${rating_reply}
