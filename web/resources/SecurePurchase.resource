*** Settings ***
Documentation                                   Base resource file for SecurePurchase tests
Resource                                        setup.resource

*** Variables ***
${shop_seller}                                  ${TRUE}
${Provider_Posting_Cost}                        0
${Post_Provider_Name}                           توافق با فروشنده
${send_time}                                    ${TRUE}
${Post_By_Seller}                               ${FALSE}
${Posting_Cost_City}                            0
${Posting_Cost_Country}                         0

*** Keywords ***
Set Web Toggles For Shop SecurePurchase Testing
    Set Toggles For Shop SecurePurchase Testing     web                 ${1}

Set Web Toggles For User SecurePurchase Testing
    Set Toggles For User SecurePurchase Testing     web                 ${1}

Enable Secure Purchasing Capability In Secure Purchase Popup
    ${SP_Title_Txt}                             Get Text                     ${PF_SP_Popup_Title}
    SeleniumLibrary.Element Text Should Be      ${PF_SP_Popup_Title}         ${PF_SP_Popup_Title_Txt}
    Click Element                               ${PF_SP_Activation_Btn}
    Wait Until Page Contains Element            ${SP_Activation_Form}        timeout=5s

Set Info To Active SecurePurchase For Listing
    Wait Until Page Contains Element    ${SP_Shipping_Weight_Popup}                            timeout=10s
    Input Weight and Dimensions
    ${Existence_Price_Field}            Run Keyword And Return Status                          Page Should Contain Element       ${SP_Price_Input}
    Run Keyword If                     '${Price}' == '${0}' and ${Existence_Price_Field}       Set New Price
    ${Existence_Nickname_Field}         Run Keyword And Return Status                          Page Should Contain Element       ${SP_Nickname_Input}
    Run Keyword If                      ${Existence_Nickname_Field}                            Set User Nickname
    Click Element                       ${SP_Activation_Btn}
    Wait Until Page Contains Element    ${SP_Paid_Features_Page}

Input Weight and Dimensions
    Input Weight
    Input Dimensions

Input Weight
    Click Element           ${SP_Shipping_Weight_Popup}
    Click Element           ${SP_Shipping_Weight_Value}

Input Dimensions
    Click Element           ${SP_Shipping_Dimensions_Popup}
    Click Element           ${SP_Shipping_Dimensions_Value}

Set New Price
    Set Test Variable       ${Price}                       1000000
    Input Text              ${SP_Price_Input}              ${Price}

Set User Nickname
    ${FakeName}             FakerLibrary.Name
    Set Test Variable       ${UserNickname}                ${FakeName}
    Input Text              ${SP_Nickname_Input}           ${UserNickname}

Get ListingID And Accept Listing
    Verify Post Listing Is done
    Get ListingID
    Verify Advertise By ID

###################################################   Validate Ad - Home Page ###########################################################################
Validate Ad Details With SecurePurchase On Home Page And Click On It
    Wait Until Ad To Appear On Home Page
    Element Should Contain                      ${Home_SP_Banner}                         ${Home_SP_Banner_Txt}
    ${Ad_In_SecurePurchase_Banner}              Set Variable                              ${Home_Ad_In_SP_Banner.format("${AdsId}")}
    ${Ad_Icon_In_SecurePurchase_Banner}         Set Variable                              ${Ad_In_SecurePurchase_Banner}//*[contains(@class,"icon-secure-purchase")]
    ${Ad_Price_In_SecurePurchase_Banner}        Set Variable                              ${Ad_In_SecurePurchase_Banner}//*[contains(@class,"item-price")]
    Page Should Contain Element                 ${Ad_In_SecurePurchase_Banner}
    Page Should Contain Element                 ${Ad_Icon_In_SecurePurchase_Banner}
    ${Converted_Price}                          Convert Number To Price                   ${Price}
    Set Test Variable                           ${Converted_Price}
    Element Should Contain                      ${Ad_Price_In_SecurePurchase_Banner}      ${Converted_Price}
    Click Element                               ${Ad_In_SecurePurchase_Banner}

Wait Until Ad To Appear On Home Page
    FOR  ${Index}   IN RANGE   3
        Refresh Varnish
        Wait Until Page Contains Element        ${Home_SP_Banner}                 timeout=10s
        ${pass}                                 Run Keyword And Return Status     Element Should Contain
        ...                                     ${Home_SP_Banner}                 ${title_words}
        Exit For Loop If                        ${pass}
    END
    Run Keyword Unless                          ${pass}         Fail                      The ad was not found.

###################################################   Validate Ad - Serp Page ###########################################################################
Validate Ad Details With SecurePurchase On Serp Page And Click On It
    Filter Listing By SubCategory In Serp Page
    Find Ad On Serp Page
    Validate Ad Details On Serp Page
    Click Element                               ${Serp_L_Article.format("${AdsId}")}

Filter Listing By SubCategory In Serp Page
    Open All Category Popup
    Click Link                                  ${Ad_SubCategory}
    Wait Until Page Contains Element            ${Tag_Filter.format('${Ad_SubCategory}')}           timeout=10s

Open All Category Popup
    Wait Until Keyword Succeeds    2x    2s     Click Element                                       ${Home_All_Category}
    Wait Until Page Contains Element            ${Open_Popup.format('categories-expandable')}       timeout=2s

Find Ad On Serp Page
    Filter Listing To Only Show Listing With SecurePurchase
    Wait Until Ad To Appear On Serp Page

Filter Listing To Only Show Listing With SecurePurchase
    Click Element                               ${Serp_F_SP_Checkbox}
    Wait Until Page Contains Element            ${Tag_Filter.format('فقط خرید امن')}               timeout=10s

Wait Until Ad To Appear On Serp Page
    FOR  ${Index}   IN RANGE   3
        Reload Page
        ${pass}                                 Run Keyword And Return Status         Wait Until Page Contains
        ...                                     ${title_words}                        timeout=5s
        Exit For Loop If                        ${pass}
    END
    Run Keyword Unless                          ${pass}         Fail                  The ad was not found.

Validate Ad Details On Serp Page
    Page Should Contain Element                 ${Serp_L_Article.format("${AdsId}")}
    ${Ad_SecurePurchase_Icon_In_Serp_Page}      Set Variable                              ${Serp_Ad_SP_Icon.format("${AdsId}")}
    ${Ad_Price_In_Serp_Page}                    Set Variable                              ${Serp_Ad_SP_Price.format("${AdsId}")}
    Page Should Contain Element                 ${Ad_SecurePurchase_Icon_In_Serp_Page}
    ${Converted_Price}                          Convert Number To Price                   ${Price}
    Set Test Variable                           ${Converted_Price}
    Element Should Contain                      ${Ad_Price_In_Serp_Page}                  ${Converted_Price}

###################################################   Login  ###########################################################################
Generate Phone Number For The Seller User And Login With It
    ${Seller_User_Phone}                    Login With The User Phone    ${Auth_Session_Position}
    Set Test Variable                       ${Seller_User_Phone}

Login With The Phone Number Of The Seller User
    Login OR Register By Mobile            ${Seller_User_Phone}             ${Auth_Session_Position}

Login With The Shop Owner Phone
    Login OR Register By Mobile           ${Shop_owner_phone}                ${Auth_Session_Position}

Login With The Phone Number Of The Buyer User
    Login As Customer                    ${Auth_Session_Position}       ${Customer_Phone_Number}

Login As Customer
    [Arguments]                         ${Log_Position}                     ${Customer_Phone_Number}
    ${Customer_Phone_Number}            Login With The User Phone           ${Log_Position}                  ${Customer_Phone_Number}
    Set Task Variable                   ${Customer_Phone_Number}

Login With The User Phone
    [Arguments]                         ${Log_Position}                  ${Phone_Number}=${EMPTY}
    IF   '${Phone_Number}' == '${EMPTY}'
      Mobile Generator A
      ${Phone_Number}                   Set Variable                     ${Random_User_Mobile_A}
    END
    Login OR Register By Mobile         ${Phone_Number}                  ${Log_Position}
    Return From Keyword               ${Phone_Number}

################################################### Logout ###########################################################################
Logout Seller User
      Logout User

Logout Buyer User
      Logout User
###################################################   Listing Details ###########################################################################
Validate Ad Details On Listing Details Page
    ${seller_name}  	                                Set Variable If	                               ${shop_seller}
    ...                                               ${Shop_title}                                  ${UserNickname}
    ${seller_name}                                    Replace Arabic Fonts                           ${seller_name}
    Set Test Variable                                 ${seller_name}
    ${Seller_Number}  	                              Set Variable If	                               ${shop_seller}
    ...                                               ${Shop_owner_phone}                            ${Seller_User_Phone}
    Set Test Variable                                 ${Seller_Number}
    Validate Item Seller Details
    Validate Breadcrumbs Of Listing
    Page Should Contain Element                       ${LD_Listing_Details}
    Element Should Contain                            ${LD_Listing_Details}                          ${title_words}
    Validate Images Count In Listing Details
    Validate Price In Listing Details
    Validate Listing Location In Listing Details
    Validate Condition Of Listing in Listing Details
    Validate Listing Phone Number Of Seller In Listing Details                                       ${Seller_Number}
    Run Keyword If         ${Post_By_Seller}          Validate Posting Cost By Seller

Validate Item Seller Details
    Wait Until Page Contains Element               ${LD_Seller_Details}            timeout=10s
    Element Should Contain                         ${LD_Seller_Details}            ${seller_name}
    Page Should Contain Element                    ${LD_Chat_Btn_Loggedin}
    Page Should Contain Element                    ${LD_Securepurchase_Btn}
    Run Keyword If                                 ${shop_seller}                  Check Logo Shop And Price Offer Button In Listing Details Page

Check Logo Shop And Price Offer Button In Listing Details Page
    Page Should Contain Element                    ${LD_Shop_Logo}
    Run Keyword If                                '${Shop_price_offer}' == '${1}'
    ...   Page Should Contain Element              ${LD_Price_Offer_Btn}

Validate Breadcrumbs Of Listing
    Element Should Contain     ${LD_Breadcrumbs}      ${Ad_Category}
    Element Should Contain     ${LD_Breadcrumbs}      ${Ad_SubCategory}
    Element Should Contain     ${LD_Breadcrumbs}      ${Ad_province}
    Element Should Contain     ${LD_Breadcrumbs}      ${Ad_City}
    Element Should Contain     ${LD_Breadcrumbs}      ${Ad_Region}

Validate Images Count In Listing Details
    Run Keyword If       '${Number_Of_Photos}' == '${0}'    Page Should Not Contain      ${LD_Img_Container}
    ...    ELSE IF       '${Number_Of_Photos}' == '${1}'    Validate Listing Details With One Image
    ...    ELSE IF       '${Number_Of_Photos}' >= '${2}'    Validate Listing Details With More Than One Image

Validate Listing Details With One Image
    Page Should Contain Element    ${LD_Img_Container}
    ${Image_Count}                 SeleniumLibrary.Get Element Count    ${LD_Img_Container}//img
    Should Be Equal                '${Image_Count}'                     '${1}'

Validate Listing Details With More Than One Image
    Page Should Contain Element    ${LD_Img_Container}
    ${Number_Of_Photos}            Convert To String       ${Number_Of_Photos}
    ${Expected_Total}              Convert Digits          ${Number_Of_Photos}    En2Fa
    ${Pagination_Total}            Get Text                ${LD_Total_Img}
    Should Be Equal               '${Expected_Total}'     '${Pagination_Total}'

Validate Price In Listing Details
    Run Keyword If                '${Price}' == '${EMPTY}'        Fail      The price of this product was not found.
    ${Converted_En_Price}          Evaluate                               f'{${Price}:,}'
    Element Should Contain         ${LD_Price}               ${Converted_En_Price}

Validate Listing Location In Listing Details
    ${loc}  	                  Set Variable If	                         '${Ad_Region}' == '${EMPTY}'
    ...                         ${Ad_City}	                          ${Ad_City}، ${Ad_Region}
    Element Should Contain      ${LD_Location}               ${loc}

Validate Condition Of Listing in Listing Details
    ${Existence_Goods_Ststus}   Run Keyword And Return Status          Element Should Contain
    ...                         ${LD_Goods_Status}                     ${LD_Goods_Status_Txt_1}
    Run Keyword If              ${Existence_Goods_Ststus}              Element Should Contain
    ...                         ${LD_Goods_Status}                     ${LD_Goods_Status_Txt_2}       #based on common.resource

Validate Listing Phone Number Of Seller In Listing Details
    [Arguments]                    ${Seller_Number}
    Run Keyword If                '${Seller_Number}' == '${EMPTY}'        Fail                   There is no argument of seller number for validating Listing Details
    ${HiddenMobile}                Catenate                               SEPARATOR=XXX          ${Seller_Number[:4]}   ${Seller_Number[7:]}
    Element Should Contain         ${LD_Description}                      ${HiddenMobile}

Determine The Type Of Posting
    IF                                          '${Post_Provider_Name}' == 'تیپاکس' or '${Post_Provider_Name}' == 'ماهکس' or '${Post_Provider_Name}' == 'الوپست'
      ${Post_With_Alo_Sh_La}                       Set Variable                   ${FALSE}
    ELSE
      ${Post_With_Alo_Sh_La}             Evaluate
      ...                                         ('${origin_city}' == '${Ad_City}') and ('${Destination_Name}' == '${Customer_City}') and '${Has_Delivery_Time}' == 'True'
      Run Keyword Unless   ${Post_With_Alo_Sh_La}
      ...                  Fail              The provider posting cost with ${Post_Provider_Name} not evaluate correctly.
    END
    Set Test Variable                           ${Post_With_Alo_Sh_La}

Validate Posting Cost By Seller
    Element Should Contain          ${LD_Delivery_Pricing}        ${Ad_City}
    ${Converted_En_City_Price}      Evaluate                   f'{${Posting_Cost_City}:,}'
    Element Should Contain          ${LD_Delivery_Pricing}        ${Converted_En_City_Price}
    Element Should Contain          ${LD_Delivery_Pricing}        ${LD_Delivery_Pricing_Txt}
    ${Converted_En_Country_Price}   Evaluate                   f'{${Posting_Cost_Country}:,}'
    Element Should Contain          ${LD_Delivery_Pricing}        ${Converted_En_Country_Price}

Press Secure Purchase Button In Listing Details Page
    Click Element                   ${LD_Securepurchase_Btn}

################################################### SecurePurchase - With Delivery ############################################################################
SecurePurchase With Delivery
    [Arguments]                     ${Logged_In}=${FALSE}
    Determine The Type Of Posting
    Press Secure Purchase Button In Listing Details Page
    Validate Checkout Page With Delivery
    Run Keyword Unless                      ${Logged_In}    Login As Customer                          ${Auth_LD_Safe_Shop_Position}     ${EMPTY}

################################################### Check out - With Delivery ############################################################################
Validate Checkout Page With Delivery
    Validate Checkout Structure For SecurePurchase With Delivery
    Run Keyword If                        ${shop_seller}          Set Number Of Goods
    Validate Step One In Checkout Page
    Press Next Step Button In Step One And Validate Step Two
    Input Customer Name In Step Two Of Checkout Page
    Input Address Of Buyer In Step Two Of Checkout Page
    Input Delivery Time In Step Two Of Checkout Page
    Press Next Step Button In Step Two And Validate
    Validate Step Three Of Checkout Page
    Click Payment Button

################################################### Structure - Check out ############################################################################
Validate Checkout Structure For SecurePurchase With Delivery
    Wait Until Page Contains Element            ${SP_Securepurchase_Checkout_Page}         timeout=5s
    Page Should Contain Element                 ${SP_Checkout_General_Step_1}
    Element Should Contain                      ${SP_Checkout_General_Step_1}             ۱
    Element Should Contain                      ${SP_Checkout_General_Step_1}             ${SP_Checkout_Goods_Number_Txt}
    Page Should Contain Element                 ${SP_Checkout_General_Step_2}
    Element Should Contain                      ${SP_Checkout_General_Step_2}             ۲
    Element Should Contain                      ${SP_Checkout_General_Step_2}             ${SP_Checkout_Address_Time_Txt}
    Page Should Contain Element                 ${SP_Checkout_General_Step_3}
    Element Should Contain                      ${SP_Checkout_General_Step_3}             ۳
    Element Should Contain                      ${SP_Checkout_General_Step_3}             ${SP_Checkout_Pay_Txt}

################################################### Step One - Check out ############################################################################
Validate Step One In Checkout Page
    Validate Listing Details In Step One Of Checkout
    Validate Banner In Step One Of Checkout

Validate Listing Details In Step One Of Checkout
    Wait Until Page Contains Element          ${SP_Checkout_Listing_Content}
    Element Should Contain                    ${SP_Checkout_Listing_Content}      ${title_words}
    Element Should Contain                    ${SP_Checkout_Listing_Content}      ${Converted_Price} تومان
    Page Should Contain Element               ${SP_Checkout_Shop_Icon}
    Element Should Contain                    ${SP_Checkout_Shop_Info}            ${seller_name}
    Run Keyword If                            ${shop_seller}                      Validate Number Of Goods For B To C Case
    ...   ELSE                                Validate Number Of Goods For C To C Case

Validate Banner In Step One Of Checkout
    Element Should Contain                    ${SP_Checkout_Verify_Box}           ${SP_Checkout_Refund_Guarantee_Txt}
    Element Should Contain                    ${SP_Checkout_Verify_Box}           ${SP_Checkout_Mismatch_Goods_Refund_Txt}

Set Number Of Goods
    FOR     ${Index}   IN RANGE               ${Number_Goods-1}
          Click Element                       ${SP_Checkout_Listing_Content_Plus_Icon}
    END

Validate Number Of Goods For C To C Case
    Page Should Not Contain Element           ${SP_Checkout_Listing_Content_Plus_Icon}
    Page Should Not Contain Element           ${SP_Checkout_Listing_Content_Minus_Btn}
    Element Should Contain                    ${SP_Checkout_Count_Goods}             ۱

Validate Number Of Goods For B To C Case
    Page Should Contain Element               ${SP_Checkout_Listing_Content_Plus_Icon}
    Page Should Contain Element               ${SP_Checkout_Listing_Content_Minus_Btn}

Press Next Step Button In Step One And Validate Step Two
    Click Button                     ${SP_Checkout_Next_Step_Btn}
    Wait Until Page Contains         ${SP_Checkout_Fill_Goods_Info_Step1}        timeout=5s
    Close Permission Popup

Close Permission Popup
    ${Permission_Popup}              Run Keyword And Return Status
    ...                              Page Should Contain Element       ${SP_Permission_Popup_Open}
    IF   ${Permission_Popup}
      Run Keyword And Ignore Error     Click Element                     ${SP_Permission_Ask_Close_Icon}
      Run Keyword And Ignore Error     Click Element                     ${SP_Permission_Deny_Close_Icon}
    END

################################################### Step Two - Check out #########################################################################
Input Customer Name In Step Two Of Checkout Page
    ${Customer_Name}          FakerLibrary.Name
    ${Customer_Name}          Replace Arabic Fonts              ${Customer_Name}
    Set Test Variable         ${Customer_Name}
    Input Text                ${SP_Checkout_Receiver_Name}      ${Customer_Name}

Input Address Of Buyer In Step Two Of Checkout Page
    Input Address  ${Customer_ProvinceId}       ${Customer_CityId}                            ${Customer_City}
    ...            ${Customer_District}         ${Customer_Address}                           ${Customer_Plaque}
    ...            ${Customer_Unit_Num}         ${SP_Checkout_Securepurchase_Address}         ${Open_Popup.format('popup-secure-purchase-address')}


Input Address
    [Arguments]    ${Delivery_ProvinceId}       ${Delivery_CityId}              ${Delivery_City}
    ...            ${Delivery_District}         ${Delivery_Address}             ${Delivery_Plaque}
    ...            ${Delivery_Unit_Num}         ${Addres_Field}                 ${Popup_Address}
    ...            ${seller}=${FALSE}
    Open Select Address Popup                   ${Addres_Field}                 ${Popup_Address}
    Open Select Province Popup
    Select Delivery Province                    ${Delivery_ProvinceId}
    Select Delivery City                        ${Delivery_CityId}              ${Popup_Address}
    Select Delivery District                    ${Delivery_District}
    Click Element                               ${SP_Submit_Address_Buttun}
    Validate Location On Map By Lat-Long        ${Delivery_City}                ${Delivery_District}      ${seller}
    Input Delivery Address Details              ${Delivery_Address}             ${Delivery_Plaque}       ${Delivery_Unit_Num}
    Click Element                               ${SP_Submit_Address_Buttun}
    Validate Checkout Address                   ${Delivery_Address}             ${Popup_Address}          ${seller}

Open Select Address Popup
    [Arguments]                                 ${Addres_Field}                 ${Popup_Address}
    Click Element                               ${Addres_Field}
    Wait Until Page Contains Element            ${Popup_Address}                 timeout=3s

Open Select Province Popup
    Click Element                               ${SP_Address_Province_City}
    Wait Until Page Contains Element            ${Open_Popup.format('popup-locations')}

Select Delivery Province
    [Arguments]                                 ${Delivery_ProvinceId}
    ${Province}                                 Set Variable            ${SP_Checkout_Select_Province.format("${Delivery_ProvinceId}")}
    Click Element                               ${Province}
    Wait Until Page Contains Element            ${SP_Mode_City}            timeout=3s

Select Delivery City
    [Arguments]                                 ${Delivery_CityId}              ${Popup_Address}
    ${City}                                     Set Variable                    ${SP_Checkout_Select_City.format("${${Delivery_CityId}}")}
    Click Element                               ${City}
    Wait Until Page Contains Element            ${Popup_Address}                timeout=2s

Select Delivery District
    [Arguments]                                 ${Delivery_District}
    Input Text                                  ${SP_Search_Root_Hint}                    ${Delivery_District}
    Wait Until Page Contains Element            ${SP_Suggested_Districts_Items}           timeout=10s
    ${Customer_District_Suggests}               Set Variable                           ${SP_Checkout_Delivery_District.format("${Delivery_District}")}
    ${Suggested_Districts_Count}                SeleniumLibrary.Get Element Count      ${Customer_District_Suggests}
    Run Keyword If                             '${Suggested_Districts_Count}' == '${0}'
    ...       Fail                              Customer District Not Found.
    ${Suggested_Districts}                      Get WebElements                        ${Customer_District_Suggests}
    Click Element                               ${Suggested_Districts}[${0}]
    Wait Until Page Does Not Contain Element    ${SP_Updating_Map_Loading}                timeout=3s
    Page Should Not Contain Element             ${SP_Suggested_Districts_Items}

Validate Location On Map By Lat-Long
    [Arguments]                                 ${Delivery_City}                  ${Delivery_District}         ${seller}=${FALSE}
    Wait Until Page Contains Element            ${SP_Map_Pin}                     timeout=10s
    Wait Until Keyword Succeeds    2x    2s     Get Src From Map Pin
    IF                                          ${seller}
      @{Lat_Long}                                 Get Lat And Long On Web           ${Map_Src}   spl_lat_long=,
    ELSE
      @{Lat_Long}                                 Get Lat And Long On Web           ${Map_Src}
    END
    ${City_Based_Lat_Long}                      ${District_Based_Lat_Long}
    ...                                         Get Location From Lat And Long    @{Lat_Long}
    # Should Be Equal                             ${City_Based_Lat_Long}            ${Delivery_City}
    # ...                                         Initial Location of pin in Map is not in ${Delivery_City}.
    # Should Be Equal                             ${District_Based_Lat_Long}        ${Delivery_District}
    # ...                                         Initial Location of pin in Map is not in ${Delivery_District}.

Get Src From Map Pin
    ${Map_Src}              SeleniumLibrary.Get Element Attribute      ${SP_Map_Pin}      src
    Should Not Be Equal    '${Map_Src}'                                'None'
    Set Test Variable       ${Map_Src}

Input Delivery Address Details
    [Arguments]             ${Delivery_Address}                 ${Delivery_Plaque}       ${Delivery_Unit_Num}
    Input Text              ${SP_Delivery_Address_Text}         ${Delivery_Address}
    Input Text              ${SP_Delivery_Address_Plaque}       ${Delivery_Plaque}
    Input Text              ${SP_Delivery_Address_Unit_Num}     ${Delivery_Unit_Num}

Validate Checkout Address
    [Arguments]                                 ${Delivery_Address}                    ${Popup_Address}            ${seller}
    Wait Until Page Does Not Contain Element    ${Popup_Address}                        timeout=1s
    ${address}                                  Set Variable If                         ${seller}
    ...                                         ${SP_Complete_Form_Address}             ${SP_Checkout_Securepurchase_Address}
    Element Should Contain                      ${address}             ${Delivery_Address}

Input Delivery Time In Step Two Of Checkout Page
    IF                                          ${Post_With_Alo_Sh_La}
      Select Delivery Time
    ELSE
      Set And Validate Send By Post
    END

Select Delivery Time
    Click Element                               ${SP_Checkout_Delivery_Time}
    Wait Until Page Contains Element            ${Open_Popup.format('popup-secure-purchase-delivery-time')}   timeout=3s
    ${Count}                                    SeleniumLibrary.Get Element Count        ${SP_Checkout_Delivery_Times}
    Run Keyword If                             '${Count}' == '${0}'                      Fail    No items found for delivery time.
    ${Random}                                   Evaluate                                 random.randint(0, ${Count-1})
    ${Delivery_Time_Text}                       Get WebElements                          ${SP_Checkout_Delivery_Times}
    Click Element                               ${Delivery_Time_Text}[${Random}]
    ${Delivery_Time}                            Get Text                                 ${SP_Checkout_Delivery_Time}
    Set Test Variable                           ${Delivery_Time}

Set And Validate Send By Post
    ${Delivery_Time}                            Get Text                                ${SP_Checkout_Delivery_Time}
    Should Contain                              ${Delivery_Time}                        ${SP_Checkout_Delivery_Post}
    Set Test Variable                           ${Delivery_Time}
    Check Select Send By Post

Check Select Send By Post
    Click Element                               ${SP_Checkout_Delivery_Time}
    Wait Until Page Contains Element            ${SP_Checkout_Delivery_Times_Popup}     timeout=2s
    Element Should Contain                      ${SP_Checkout_Delivery_Times_Popup}     ${SP_Checkout_Delivery_Post}
    Click Element                               ${SP_Checkout_Send_Post}

Press Next Step Button In Step Two And Validate
    Click Button                                ${SP_Checkout_Next_Step_Btn}
    Page Should Not Contain                     ${SP_Checkout_Fill_Goods_Info_Step2}
    Wait Until Page Contains Element            ${SP_Last_Step}                              timeout=5s

###################################################  Step Three - Check out ############################################################################
Validate Step Three Of Checkout Page
    Validate Listing Details In Step Three Of Checkout
    Validate Customer Info For Step Three
    Validate Coupon Section
    Validate Price On The Payment Button                ${Converted_Total_Price_Wpc}

Validate Listing Details In Step Three Of Checkout
    Element Should Contain                     ${SP_Checkout_User_Details}                  ${SP_Checkout_Purchase_Summary_Txt}
    Element Should Contain                     ${SP_Checkout_User_Details}                  ${SP_Checkout_Purchase_Summary_Txt}
    Element Should Contain                     ${SP_Checkout_User_Details}                  ${title_words}
    Element Should Contain                     ${SP_Checkout_User_Details}                  ${SP_Checkout_Seller_Name_Txt}
    Element Should Contain                     ${SP_Checkout_User_Details}                  ${seller_name}
    Element Should Contain                     ${SP_Checkout_Pay_Details}                   ${SP_Checkout_Order_Number_Txt}
    ${Number_Goods}                            Convert To String                            ${Number_Goods}
    ${Converted_Number_Goods}                  Convert Digits                               ${Number_Goods}   En2Fa
    Element Should Contain                     ${SP_Checkout_Pay_Details}                   ${Converted_Number_Goods} عدد
    Element Should Contain                     ${SP_Checkout_Pay_Details}                   ${SP_Checkout_Goods_Amount_Txt}
    Element Should Contain                     ${SP_Checkout_Pay_Details}                   ${Converted_Price} تومان
    Element Should Contain                     ${SP_Checkout_Pay_Details}                   ${SP_Checkout_Delivery_Price_Txt}
    IF                                         ${shop_seller}
      Determine Posting Cost By Seller
    ELSE
      ${Posting_Cost}                            Set Variable                                 ${Provider_Posting_Cost}
    END
    ${Converted_Posting_Cost}                  Convert Number To Price                      ${Posting_Cost}
    Element Should Contain                     ${SP_Checkout_Pay_Details}                   ${Converted_Posting_Cost} تومان
    Element Should Contain                     ${SP_Checkout_Pay_Details}                   ${SP_Checkout_Total_Price_Txt}
    ${Total_Price_Wpc}                         Evaluate                                     (${Number_Goods} * ${Price} + ${Posting_Cost})
    ${Converted_Total_Price_Wpc}               Convert Number To Price                      ${Total_Price_Wpc}                           #قیمت کل پرداخت با هزینه پست
    Element Should Contain                     ${SP_Checkout_Pay_Details}                   ${Converted_Total_Price_Wpc} تومان
    Set Test Variable                          ${Converted_Total_Price_Wpc}
    ${Total_Price_Npc}                         Evaluate                                     (${Number_Goods} * ${Price})
    ${Converted_Total_Price_Npc}               Convert Number To Price                      ${Total_Price_Npc}                            #قیمت کل پرداخت بدون هزینه پست
    Set Test Variable                          ${Converted_Total_Price_Npc}
    Element Should Contain                     ${SP_Checkout_Pay_Details}                   ${SP_Checkout_Rules_Agreement_Txt}

Determine Posting Cost By Seller
    IF                                         '${Shop_shipping_type}' == '1'
      ${Posting_Cost}                             Determine Posting Cost
    ELSE
      ${Posting_Cost}                             Set Variable                     ${Provider_Posting_Cost}
    END
    Set Test Variable                           ${Posting_Cost}

Determine Posting Cost
    ${Posting_Cost}       Set Variable If     '${Customer_CityId}' == '${Ad_City_Id}'
    ...                                        ${Posting_Cost_City}                        ${Posting_Cost_Country}
    Return From Keyword   ${Posting_Cost}

Validate Customer Info For Step Three
    Element Should Contain                     ${SP_Checkout_User_Details}                   ${SP_Checkout_Recipient_Name_Txt}
    Element Should Contain                     ${SP_Checkout_User_Details}                   ${Customer_Name}
    Element Should Contain                     ${SP_Checkout_User_Details}                   ${SP_Checkout_Recipient_Address_Txt}
    Element Should Contain                     ${SP_Checkout_User_Details}                   ${Customer_Address}
    Element Should Contain                     ${SP_Checkout_User_Details}                   ${SP_Checkout_Delivery_Time_Txt}
    Element Should Contain                     ${SP_Checkout_User_Details}                   ${Delivery_Time}

###################################################  Check out - Without Delivery ############################################################################
Validate Checkout Page Witout Delivery
    Wait Until Page Contains Element    ${SP_Securepurchase_Checkout_Page}             timeout=5s
    Run Keyword If                      ${shop_seller}                              Set Number Of Goods
    ${Converted_Price}                  Convert Number To Price                     ${Price}
    Set Test Variable                   ${Converted_Price}
    Validate Goods Specifications
    Validate SecurePurchase Messages
    Validate Purchase Details
    Validate Coupon Section
    Validate Price On The Payment Button   ${Converted_Total_Price_Nd}

Validate Goods Specifications
    Element Should Contain    ${SP_Checkout_Listing_Content}    ${title_words}
    Element Should Contain    ${SP_Checkout_Listing_Content}    ${Converted_Price} تومان
    Element Should Contain    ${SP_Checkout_Listing_Content}    ${seller_name}

Validate SecurePurchase Messages
    Element Should Contain    ${SP_Securepurchase_Checkout_Page}      ${SP_Checkout_Refund_Guarantee_Txt}
    Element Should Contain    ${SP_Securepurchase_Checkout_Page}      ${SP_Checkout_Return_Back_Txt}
    Element Should Contain    ${SP_Securepurchase_Checkout_Page}      ${SP_Checkout_Post_By_Seller_Txt}
    Element Should Contain    ${SP_Securepurchase_Checkout_Page}      ${SP_Checkout_Coordination_With_Seller}
    Element Should Contain    ${SP_Securepurchase_Checkout_Page}      ${SP_Checkout_Rules_Agreement_Txt}

Validate Purchase Details
    ${Number_Goods}             Convert To String                     ${Number_Goods}
    ${Converted_Number_Goods}   Convert Digits                        ${Number_Goods}   En2Fa
    Element Should Contain      ${SP_Chceckout_Purchase_Details}       ${Converted_Number_Goods} عدد
    Element Should Contain      ${SP_Chceckout_Purchase_Details}       ${Converted_Price} تومان
    Element Should Contain      ${SP_Chceckout_Purchase_Details}       ${SP_Checkout_Price_Offer_Txt}
    ${Total_Price}              Evaluate                           (${Number_Goods} * ${Price})
    ${Converted_Total_Price_Nd}    Convert Number To Price            ${Total_Price}
    Set Test Variable           ${Converted_Total_Price_Nd}
    Element Should Contain      ${SP_Chceckout_Purchase_Details}       ${Converted_Total_Price_Nd} تومان

###################################################  Check out - Common  ############################################################################
Validate Coupon Section
    Element Should Contain         ${SP_Coupon_Section}               ${SP_Checkout_Have_Coupon_Txt}
    Page Should Contain Element    ${SP_Coupon_Section_Input}
    Page Should Contain Element    ${SP_Coupon_Section_Button}

Validate Price On The Payment Button
    [Arguments]                    ${Total_Price}
    Element Should Contain         ${SP_Payment_Button}              پرداخت ${Total_Price} تومان

Click Payment Button
    Click Button                   ${SP_Payment_Button}

###################################################  Payment  ############################################################################
Validate Successful Payment Page And Track Post
    Page Should Not Contain                    ${SP_Payment_Error_Message}
    Wait Until Page Contains Element           ${SP_Success_Payment}               timeout=10s
    Element Should Contain                     ${SP_Success_Payment}               ${SP_Payment_Successful_Message}
    Element Should Contain                     ${SP_Success_Payment}               ${SP_Payment_Money_Blocking_Message}
    Element Should Contain                     ${SP_Success_Payment}               ${SP_Payment_Ready_For_Post_Message}
    Click Link                                 ${SP_Payment_Post_Tracking}

###################################################  Chat  ############################################################################
Send The Price Offer To The Seller As Customer
    [Arguments]                         ${Logged_In}=${FALSE}                               ${Price_Offer}=${Customer_Price_Offer}
    Click Element                       ${LD_Price_Offer_Btn}
    Run Keyword Unless                  ${Logged_In}               Login As Customer         ${Auth_LD_Prop_Price_Position}     ${EMPTY}
    Wait Until Page Contains Element    ${Open_Popup.format('popup-price-suggestion')}
    Input Text                          ${Chat_SP_Customer_Price_Offer_Input}                ${Price_Offer}
    Click Element                       ${Chat_SP_Send_Message}
    Wait Until Page Contains Element    ${Ld_Send_Messages_Input}                            timeout=15s
    Input Text                          ${Ld_Send_Messages_Input}                            ${Chat_SP_Sent_Price_Offer}
    Click Button                        ${LD_Send_Messages_Btn}
    Wait Until Page Contains Element    ${LD_Messages_Sent}                                   timeout=5s

Go To Chat Page And Validate Ad
    [Arguments]                         ${Status}
    Go to Chat Page
    Validate The Ad And Click On It     ${Status}

Go to Chat Page
    Click Element                       ${Chat_SP_My_Chat}
    Wait Until Page Contains Element    ${Chat_Section}                         timeout=10s

Validate The Ad And Click On It
    [Arguments]                         ${Status}
    Wait Until Page Contains Element    ${Chat_List_Item.format('${AdsId}')}    timeout=5s
    ...                                 error=The ad was not found.
    Element Should Contain              ${Chat_Item_Title.format('${AdsId}')}   ${title_words}
    Wait Until Element Contains         ${Chat_Item_Status.format('${AdsId}')}  ${Status}
    ...                                 timeout=2s                              error=The status of the ad is not correct.
    Click Element                       ${Chat_List_Item.format('${AdsId}')}
    Wait Until Element Contains         ${Chat_Wall_Title}                      ${title_words}        timeout=5s

Validate Seller Chat Page When Received Price Offer From Customer
    [Arguments]                         ${Received_Price_Offer}=${Customer_Price_Offer}
    Wait Until Keyword Succeeds         2x    2s          Validate Received Price Offer From Customer
    ...                                 ${Received_Price_Offer}

Validate Received Price Offer From Customer
    [Arguments]                         ${Received_Price_Offer}
    Page Should Not Contain Element     ${Chat_Sp_Action_Box_Loading}
    Element Should Contain              ${Chat_SP_Received_Msg}                 ${Chat_SP_Sent_Price_Offer}
    ${Converted_Received_Price_Offer}   Convert Number To Price                 ${Received_Price_Offer}
    Element Should Contain              ${Chat_Wall}                            این کاربر مبلغ ${Converted_Received_Price_Offer} تومان را برای خرید این کالا پیشنهاد داده است.
    Page Should Contain Element         ${Chat_Accept_Price}
    Page Should Contain Element         ${Chat_Offer_New_Price}

Send The Price Offer To The Customer
    Click Element                       ${Chat_Offer_New_Price}
    Wait Until Page Contains Element    ${Chat_SP_Price_Offer_Input}
    Input Text                          ${Chat_SP_Price_Offer_Input}            ${Seller_Price_Offer}
    Click Button                        ${Chat_SP_Price_Offer_Submit}
    Wait Until Keyword Succeeds         2x    2s                                Validate Price Offer Sent To Customer

Validate Price Offer Sent To Customer
    Page Should Not Contain Element     ${Chat_Sp_Action_Box_Loading}
    ${Converted_Seller_Price_Offer}     Convert Number To Price                 ${Seller_Price_Offer}
    Set Test Variable                   ${Converted_Seller_Price_Offer}
    Element Should Contain              ${Chat_Wall_Container}                  مبلغ معامله به ${Converted_Seller_Price_Offer} تومان تغییر کرد
    Element Should Contain              ${Chat_Sp_Action_Box}                   مبلغ قابل پرداخت هم‌اکنون ${Converted_Seller_Price_Offer} تومان است، در صورت تمایل می‌توانید این مبلغ را برای معامله با این کاربر ویرایش کنید.
    Page Should Contain Element         ${Chat_Edit_Price}

Validate Customer Chat Page When Received Price Offer From Seller
    [Arguments]                         ${Received_Price_Offer}=${Seller_Price_Offer}
    Wait Until Keyword Succeeds         2x    2s                                Validate Received Price Offer From Seller
    ...                                 ${Received_Price_Offer}

Validate Received Price Offer From Seller
    [Arguments]                         ${Received_Price_Offer}
    Page Should Not Contain Element     ${Chat_Sp_Action_Box_Loading}
    Element Should Contain              ${Chat_SP_Msg_Sent}                     ${Chat_SP_Sent_Price_Offer}
    Element Should Contain              ${Chat_Wall_Container}                  مبلغ معامله به ${Converted_Seller_Price_Offer} تومان تغییر کرد
    Element Should Contain              ${Chat_Sp_Action_Box}                   ${title_words}
    Element Should Contain              ${Chat_Sp_Action_Box}                   ${Converted_Seller_Price_Offer} تومان
    Page Should Contain Element         ${Chat_Sp_Btn}

Validate Chat Page Of Buyer After Successful Payment
    Validate Chat Page Of Seller And Buyer After Successful Payment             seller=${FALSE}

Validate Chat Page Of Seller After Successful Payment
    Validate Chat Page Of Seller And Buyer After Successful Payment             seller=${TRUE}

Validate Chat Page Of Seller And Buyer After Successful Payment
    [Arguments]                           ${seller}=${TRUE}
    Go To Chat Page And Validate Ad       ${Chat_SP_Paid_Status}
    Element Should Contain                ${Chat_Sp_Msg_Box}                    ${Chat_Sp_Msg_1}
    Element Should Contain                ${Chat_Sp_Msg_Box}                    ${Chat_Sp_Msg_2}
    Element Should Contain                ${Chat_Sp_Msg_Box}                    ${Chat_Sp_Msg_3}
    Page Should Contain Element           ${Chat_Sp_Icon}
    Wait Until Keyword Succeeds           2x    2s                              Validate Chat Page Of Seller And Buyer       ${seller}
    Page Should Contain Element           ${Chat_Messages_Input}
    Page Should Contain Element           ${Chat_Attach_Icon}

Validate Chat Page Of Seller And Buyer
    [Arguments]                           ${seller}
    Element Should Contain                ${Chat_Wall_Container}                ${Chat_SP_Paid_By_Buyer}
    Page Should Not Contain Element       ${Chat_Sp_Action_Box_Loading}
    Run Keyword If                        ${seller}                             Validate Chat Page Of Seller
    ...       ELSE                        Validate Chat Page Of Buyer

Validate Chat Page Of Seller
    IF                                    ${send_time}
      Run Keyword If                        ${Post_With_Alo_Sh_La}                Validate Successful Paymant With Send Time Interval For Seller
      ...       ELSE                        Validate Successful Paymant With Send By Post For Seller
    ELSE
      Validate Successful Paymant With Send By Post For Seller
    END

Validate Successful Paymant With Send Time Interval For Seller
    ${Payment_Msg}                        Set Variable                          مبلغ ${Converted_Total_Price_Npc} تومان توسط خریدار با موفقیت پرداخت شد
    Element Should Contain                ${Chat_Sp_Action_Box}                 ${Payment_Msg}
    ${Converted_Delivery_Time_Message}    Convert Delivery Time Message         seller=${TRUE}
    Element Should Contain                ${Chat_Delivery_Time_Seller}          ${Converted_Delivery_Time_Message}
    Element Should Contain                ${Chat_SP_Conf_cont}                  ${Chat_SP_Conf_cont_Msg}
    Element Should Contain                ${Chat_SP_Other_Time}                 ${Chat_SP_Other_Time_Msg}

Validate Successful Paymant With Send By Post For Seller
    ${Payment_Msg}                        Set Variable                          مبلغ ${Converted_Total_Price_Npc} تومان توسط این خریدار برای ۱ عدد از این کالا پرداخت شد.
    Element Should Contain                ${Chat_Delivery_Time_Seller}          ${Payment_Msg}
    Element Should Contain                ${Chat_Delivery_Time_Buyer}           ${Chat_SP_Send_Goods_Msg}
    Element Should Contain                ${Chat_SP_Enter_Info}                 ${Chat_SP_Enter_Info_Msg}

Convert Delivery Time Message
    [Arguments]                                  ${seller}
    ${List}               Split String           ${Delivery_Time}       separator=${SPACE}
    IF                   '${List}[0]' == 'سه'
      Remove From List      ${List}                0
    END
    ${Day}                Set Variable           ${List}[1]
    ${Dey_Length}         Get Length             ${Day}
    ${Day}                Set Variable If       '${Dey_Length}' == '${1}'          ۰${Day}
    ...                   ${Day}
    ${Month}              Set Variable If       '${List}[2]' == 'فروردین'                ۰۱
    ...                  '${List}[2]' == 'اردیبهشت'     ۰۲
    ...                  '${List}[2]' == 'خرداد'     ۰۳
    ...                  '${List}[2]' == 'تیر'     ۰۴
    ...                  '${List}[2]' == 'مرداد'     ۰۵
    ...                  '${List}[2]' == 'شهریور'     ۰۶
    ...                  '${List}[2]' == 'مهر'     ۰۷
    ...                  '${List}[2]' == 'آبان'     ۰۸
    ...                  '${List}[2]' == 'آذر'     ۰۹
    ...                  '${List}[2]' == 'دی'     ۱۰
    ...                  '${List}[2]' == 'بهمن'     ۱۱
    ...                  '${List}[2]' == 'اسفند'     ۱۲
    ...                   ${0}
    Run Keyword If       '${Month}' == '${0}'    Fail              Could not convert the Delivery Time.
    ${Max_Hours}         Fetch From Left         ${List}[7]        :
    ${Min_Hours}         Fetch From Left         ${List}[5]        :
    Run Keyword If       ${seller}
    ...                  Return From Keyword        پیک شیپور در روز ۱۴۰۰/${Month}/${Day} بین ساعات ${Min_Hours} تا ${Max_Hours} کالا را از شما تحویل می‌گیرد.
    ...       ELSE       Return From Keyword        بازه زمان ارسال: ۱۴۰۰/${Month}/${Day} بین ساعات ${Min_Hours} تا ${Max_Hours}

Validate Chat Page Of Buyer
    IF                                    ${send_time}
      Set Test Variable                     ${Delivary}                               ${TRUE}
      Run Keyword If                        ${Post_With_Alo_Sh_La}                    Validate Successful Paymant With Send Time Interval For Buyer
      ...       ELSE                        Validate Successful Paymant With Send By Post For Buyer
    ELSE
      Set Test Variable                     ${Delivary}                               ${FALSE}
      Validate Successful Paymant With Send By Post For Buyer
    END

Validate Successful Paymant With Send Time Interval For Buyer
    ${Payment_Msg}                        Set Variable                              مبلغ ${Converted_Total_Price_Wpc} تومان توسط خریدار با موفقیت پرداخت شد
    Element Should Contain                ${Chat_Sp_Action_Box}                     ${Payment_Msg}
    ${Converted_Delivery_Time_Message}    Convert Delivery Time Message             seller=${FALSE}
    Element Should Contain                ${Chat_Delivery_Time_Buyer}           ${Converted_Delivery_Time_Message}

Validate Successful Paymant With Send By Post For Buyer
    ${Payment_Msg}                        Set Variable If                       ${Delivary}
    ...                                   مبلغ ${Converted_Total_Price_Wpc} تومان پرداخت شد.                   مبلغ ${Converted_Total_Price_Nd} تومان پرداخت شد.
    Element Should Contain                ${Chat_Delivery_Time_Buyer}           ${Chat_SP_Send_Post_Msg}
    Page Should Contain Element           ${Chat_Contact_Support.format('sp10')}
    Page Should Contain Element           ${Chat_Contact_Seller}

Send Goods By The Seller
    Click On Enter The Necessary Information And Send The Goods
    Input The Necessary Information
    Click On The Submit Information Button

Click On Enter The Necessary Information And Send The Goods
    Click Link                                 ${Chat_SP_Enter_Info}
    Wait Until Page Contains Element           ${SP_Complete_Form}                    timeout=10s
    Element Should Contain                     ${SP_Complete_Form}                    ${SP_Complete_Form_Msg}

Input The Necessary Information
    Input Text                                 ${SP_Complete_Form_Name}               ${seller_name}
    Input A Value As Sheba
    Set The Address For Sending The Goods By The Seller

Input A Value As Sheba
    Run Keyword If                             ${shop_seller}                           Elemet Should Contain           ${SP_Complete_Form_Shaba}       ${Shop_sheba}
    ...       ELSE                             Input Text                               ${SP_Complete_Form_Shaba}       ${SP_Complete_Form_Sheba_Val}

Set The Address For Sending The Goods By The Seller
    Input Address                              ${Seller_ProvinceId}                     ${Seller_CityId}                ${Seller_City}
    ...                                        ${Seller_District}                       ${Seller_Address}               ${Seller_Plaque}
    ...                                        ${Seller_Unit_Num}                       ${SP_Complete_Form_Address}     ${Open_Popup.format('popup-map')}
    ...                                        seller=${TRUE}
Click On The Submit Information Button
    Click Button                               ${SP_Complete_Form_Submit_Btn}
    Wait Until Page Contains Element           ${Chat_Section}                          timeout=10s

Validate Chat Page Of Seller After Send Goods
    ${Status}                                 Set Variable                              ${Chat_SP_Send_Status}
    Validate The Ad And Click On It           ${Status}
    Validate Message Of Seller Chat Page After Send Goods

Validate Message Of Seller Chat Page After Send Goods
    Wait Until Keyword Succeeds    2x    2s   Element Should Contain                      ${Chat_Sp_Action_Box}            ${Chat_SP_Send_By_Seller_Msg}
    Element Should Contain                    ${Chat_Sp_Action_Box}                       ${Chat_SP_Transfer_Cost_Msg}
    Element Should Contain                    ${Chat_Contact_Support.format('sp20')}      ${Chat_Contact_Support_Msg}

Validate Chat Page Of Buyer After Send Goods
    ${Status}                                 Set Variable                                ${Chat_SP_Send_Status}
    Go To Chat Page And Validate Ad            ${Status}
    Validate Message Of Buyer Chat Page After Send Goods

Validate Message Of Buyer Chat Page After Send Goods
    Wait Until Keyword Succeeds    2x    2s   Element Should Contain                      ${Chat_Wall_Container}            ${Chat_SP_Send_Stuff_Seller_Msg}
    Wait Until Keyword Succeeds    2x    2s   Element Should Contain                      ${Chat_SP_Wall.format('20')}      ${Chat_SP_Requested_Stuff_Msg}
    Element Should Contain                    ${Chat_SP_Wall.format('20')}                ${Chat_SP_Receive_Stuff_Msg}
    Element Should Contain                    ${Chat_SP_Transfer_Funds}                   ${Chat_SP_Transfer_Funds_Msg}
    Element Should Contain                    ${Chat_Contact_Support.format('sp20')}      ${Chat_Contact_Support_Msg}

Confirmation And Transfer Of Funds By Buyer
    Click On Confirmation And Transfer Of Funds Button
    Validation Secure Purchase Accept Buy Popup
    Click On Confirmation And Transfer Of Funds Button In Popup
    Points To Buy In The Secure Purchase Process By The Buyer In NPS Popup
    Validate Chat Page Of Buyer After Handle NPS Popup

Click On Confirmation And Transfer Of Funds Button
    Click Button                       ${Chat_SP_Transfer_Funds}

Validation Secure Purchase Accept Buy Popup
    Wait Until Page Contains Element  ${Chat_SP_Accept_Buy_Popup}                         timeout=2s
    Element Should Contain            ${Chat_SP_Commodity_Health}                         ${Chat_SP_Commodity_Health_Msg}
    Element Should Contain            ${Chat_SP_Accept_Buy_Submit}                        ${Chat_SP_Transfer_Funds_Msg}

Click On Confirmation And Transfer Of Funds Button In Popup
    Click Button                      ${Chat_SP_Accept_Buy_Submit}
    Wait Until Page Contains Element  ${Chat_SP_Wall_Nps_Popup}                           timeout=5s

Points To Buy In The Secure Purchase Process By The Buyer In NPS Popup
    Rating In NPS Popup               ${Chat_SP_Wall_Nps_Popup}

Validate Chat Page Of Buyer After Handle NPS Popup
    Element Should Contain            ${Chat_SP_Wall.format('31')}                         ${Chat_SP_Shop_Exp_Point_Msg}
    Element Should Contain            ${Chat_SP_Wall.format('31')}                         ${Chat_SP_Seller_Rate_Msg}
    Element Should Contain            ${Chat_SP_Rate_To_Seller.format('30')}               ${Chat_SP_Rate_To_Seller_Msg}

Validate The Non Purchase Of The Purchased Ad On The Ad Details Page
    Open The Details Page Of The Purchased Ad
    Validate Item Seller Details Section In Purchased Ad

Open The Details Page Of The Purchased Ad
    Filter Listing By SubCategory In Serp Page
    Find Ad On Serp Page
    Click Element                               ${Serp_L_Article.format("${AdsId}")}

Validate Item Seller Details Section In Purchased Ad
    Validate The Lack Of A Secure Purchase Button
    Validate The Seller Phone Number Button
    Validate Chat With Seller Button

Validate The Lack Of A Secure Purchase Button
    ${status}                                   Run Keyword And Return Status        Page Should Not Contain Element            ${LD_Securepurchase_Btn}
    IF         not ${status}
      FOR  ${Index}   IN RANGE   2
          Click Element                           ${LD_Securepurchase_Btn}
          ${status}                               Run Keyword And Return Status        Wait Until Page Does Not Contain Element
          ...                                     ${LD_Securepurchase_Btn}             timeout=2s
          Exit For Loop If                        ${status}
      END
    END

Validate The Seller Phone Number Button
    ${HiddenMobile}                           Catenate                          SEPARATOR=XXX                                  ${Seller_User_Phone[:4]}            ${Seller_User_Phone[7:]}
    Element Should Contain                    ${LD_Seller_Call_Button}          تماس با ${HiddenMobile}

Validate Chat With Seller Button
    Element Should Contain                    ${LD_Chat_Btn_Not_Loggedin}           چت با ${seller_name}
#################################################################### Admin Panel #########################################################################################################################
Validate Success Payment Via Admin
    [Arguments]                               ${Customer_PhoneNumber}=${Customer_Phone_Number}
    ${Payment_Status}                         Get Status Of Payment                                      ${Customer_PhoneNumber}             ${Title_Words}
    Should Be Equal                           '${Payment_Status}'                                        'پرداخت شده'
    ...                                       msg=Payment operation not completed successfully!
