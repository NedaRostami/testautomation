*** Settings ***
Resource         setup.resource

*** Variables ***
${group_refresh_BumpSelectButton}                 0
${group_top3_BumpSelectButton}                    1
${Pictures Count}                                 ${1}
# ${BumpPopUP}                                      xpath=//*[@id="popup-bump-group_refresh" and contains(@class, 'open')]
*** Keywords ***
Test Setup Init
    Open test browser
    Set limits
    Login OR Register By Random OR New Mobile   ${Auth_Session_Position}

Set limits
    # Set Cat Listing Limit                       وسایل نقلیه    خودرو     50     10000
    # Set Cat Listing Limit                        وسایل نقلیه    خودرو     50     10000
    Login Trumpet Admin Page
    Set Listing Limit For Cat per locations      parentid=${43633}  catid=${43637}  regid=${11}  cityid=${444}  nghid=${3844}  limitcount=${30}  limitprice=${11000}
    Get Bump Prices

Get Bump Prices
   ${bump_group_refresh}                       Get Bump Price By Category And Region                    5:1                11    43633
   ${bump_group_refresh}                       Set Bump Price Value                                     ${bump_group_refresh}
   Set Test Variable                           ${bump_group_refresh}
   ${bump_group_top3}                          Get Bump Price By Category And Region                    6:5                11    43633
   ${bump_group_top3}                          Set Bump Price Value                                     ${bump_group_top3}
   Set Test Variable                           ${bump_group_top3}                                       ${bump_group_top3}

   # Get Bump Price By Type And Region            5:1        11      43633    bump_group_refresh
   # Get Bump Price By Type And Region            6:5        11      43633    bump_group_top3

Get Bump Price By Type And Region
   [Arguments]                                 ${bump_type}   ${region}   ${category}  ${BumpName}
   Set Test Variable                           ${BumpName}
   GO To                                       ${SERVER}/trumpet/bump-price/search?bump_type=${bump_type}&region=${region}&category=${category}
   Wait Until Page Is Loaded in Moderation
   ${hasPrice}                                 Run Keyword And Return Status      Wait Until Page Contains Element            ${PF_Bump_Price_Selector}    timeout=5s
   Run Keyword If    ${hasPrice}               Get Bump Price Value              ${BumpName}
   ...  ELSE                                   Get Bump Price Value for Cat In All Iran   ${bump_type}   ${category}  ${BumpName}



Set Bump Price Value
  [Arguments]                                 ${Value}
  ${Value}                                    remove string            ${Value}       ,
  ${Value}                                    Convert Digits           ${Value}       Fa2En
  ${Value}                                    Evaluate                 ${Value} * 1.09
  ${Value}                                    Convert To Integer       ${Value}
  ${Value}                                    Format String            {:,}           ${Value}
  ${Value}                                    Convert Digits           ${Value}       En2Fa
  [Return]                                    ${Value} تومان


Get Bump Price Value
   [Arguments]                                 ${BumpName}
   ${Value}                                    get text                 ${PF_Bump_Price_Selector}
   ${Value}                                    remove string            ${Value}       ,
   ${Value}                                    Convert Digits           ${Value}       Fa2En
   ${Value}                                    Evaluate                 ${Value} * 1.09
   ${Value}                                    Convert To Integer       ${Value}
   ${Value}                                    Format String            {:,}           ${Value}
   ${Value}                                    Convert Digits           ${Value}       En2Fa
   Set Test Variable                           ${${BumpName}}           ${Value} تومان

Select Bump Button and Apply Discount
   [Arguments]      ${BumpButton}   ${BumpPrice}    ${Random_Code}                ${DiscountAmount}
   ${BumpPrice}                                     Remove String                ${BumpPrice}     تومان
   ${BumpPrice}                                     Strip String                 ${BumpPrice}
   Open Bumps popup                                 ${BumpButton}
   Wait Until Page Contains Element                 ${PF_Total_Price}
   Element Should Contain                           ${PF_Total_Price}            ${BumpPrice}
   Input Text                                       ${PF_Enter_Off_Code}              ${Random_Code}
   Click Element                                    ${PF_Apply_Discount}
   ${noVAt}                                         remove string               ${BumpPrice}       تومان
   ${noVAt}                                         remove string               ${noVAt}           ,
   ${noVAt}                                         Convert Digits              ${noVAt}           Fa2En
   ${noVAt}                                         Evaluate                    round(${noVAt} / 1.09, 0)
   ${noVAt}                                         Convert To Integer          ${noVAt}
   ${noVAt}                                         Format String               {:,}              ${noVAt}
   ${noVAt}                                         Convert Digits              ${noVAt}          En2Fa
   Set Test Variable                                ${noVAt}
   Wait Until Page Contains                         کد تخفیف به مبلغ ${noVAt} تومان اعمال شد.          timeout=5s
   SeleniumLibrary.Element Text Should Be           ${PF_Payment_Btn}               ${PF_Free_Btn}
   click element                                    ${PF_Payment_Btn}

Get Bump Price Value for Cat In All Iran
   [Arguments]                                      ${bump_type}   ${category}  ${BumpName}
   GO To                                            ${SERVER}/trumpet/bump-price/search?bump_type=${bump_type}&region=&category=${category}
   Wait Until Page Is Loaded in Moderation
   ${hasPrice}                                      Run Keyword And Return Status      Wait Until Page Contains Element            ${PF_Bump_Price_Selector}    timeout=5s
   Run Keyword If    ${hasPrice}                    Get Bump Price Value     ${BumpName}
   ...  ELSE                                        Get Bump Price Value for All Cat In All Iran      ${bump_type}   ${category}  ${BumpName}


Get Bump Price Value for All Cat In All Iran
  [Arguments]                                 ${bump_type}   ${category}  ${BumpName}
  GO To                                       ${SERVER}/trumpet/bump-price/search?bump_type=${bump_type}&region=&category=
  Wait Until Page Is Loaded in Moderation
  ${Value}                                    get text                 ${Admin_Grouping}
  Set Test Variable                           ${${BumpName}}           ${Value} تومان


Post a listing
    [tags]                                           Listing
    go to                                            ${SERVER}
    Home Page Should Be Open
    Go To Post Listing Page
    Post A New Listing                               ${Pictures Count}   ${CatID}   ${SubCatID}   ${BrandID}   state=${State_Id}  city=${City_Id}  region=${Region_Id}   tel=${Random_User_Mobile_B}             #ساعت
    Verify Post Listing Is done
    Check My Listing
    Check My Listing Image Count                     1
    Verify Advertise By ID
    Check My Ads Has been Verified

Bump Listing
    [Arguments]         ${BumpButton}                ${BumpPrice}
    Click Element                                    ${BumpButton}
    Wait Until Page Contains                         ${PF_Update_pack_Cost}       timeout=5s
    SeleniumLibrary.Element Text Should Be           ${PF_L_Title}                ${Title_Words}
    SeleniumLibrary.Element Text Should Be           ${PF_Bump_Pack}              ${BumpPrice}
    Click Element                                    ${PaymentButton}


Bump Listing in Paid Feature
    [Arguments]         ${BumpButton}                ${BumpPrice}
    ${BumpPrice}                                     Remove String                ${BumpPrice}     تومان
    ${BumpPrice}                                     Strip String                 ${BumpPrice}
    Open Bumps popup                                 ${BumpButton}
    Page Should Contain Element                      ${PF_Total_Price}
    Element Should Contain                           ${PF_Total_Price}            ${BumpPrice}
    Click Element                                    ${PF_Payment_Btn_2}

Check Wrong Discount Code
    [Arguments]                                      ${BumpSelectButton}
    Open Bumps popup                                 ${BumpSelectButton}
    Input Text                                       ${PF_Enter_Off_Code}     ${PF_Wrong_Code}
    Click Element                                    ${PF_Apply_Discount}
    Wait Until Page Contains                         ${PF_Wrong_Off_Code_}
    Clear Element Text                               ${PF_Enter_Off_Code}                     #clear wrong code
    Click Element                                    ${BumpSelectButton}

Open Bumps popup
    [Arguments]                                      ${BumpSelectButton}
    ${BumpPopUP}                                     Set Variable                       ${PF_Bump_PU.format("${BumpeType}")}
    # ${BumpPopUP}                                     Set Variable                       xpath=//*[contains(@class,'${BumpeType}') and contains(@class, 'selected')]
    FOR   ${i}                                       IN RANGE    3
      Click Element                                  ${BumpSelectButton}
      ${Status}                                      Run Keyword And Return Status      Wait Until Page Contains element     ${Open_Popup.format("${BumpPopUP}")}       timeout=10s
      Exit For Loop If                               ${Status}
    END
    Run Keyword Unless                               ${Status}                      Fail   can not open bump popup
    Click Element                                    ${PF_Close_PU}

Check Disabled Bumps
    [Arguments]                                      ${SelectButton}               ${ValidatorText}
    Go To                                            ${SERVER}/session/bump/${AdsId}
    Wait Until Page Contains                         ${ValidatorText}              timeout=5s
    Refresh Varnish
    Wait Until Page Contains                         ${ValidatorText}              timeout=10s
    Wait Until Keyword Succeeds    10x    3s         Disabled Bump                 ${SelectButton}          ${ValidatorText}

Disabled Bump
    [Arguments]                                      ${ValidatorText}    ${SubCatID}
    Go To                                            ${SERVER}/session/paid-features/${AdsId}/${SubCatID}
    Wait Until Page Contains                         ${ValidatorText}                      timeout=5s
    Refresh Varnish
    ${BumpSelectButtons}                             Get WebElements                      ${Admin_Bump_Select_Btn}
    ${Disabled_Vitrin}                               Execute Javascript                   return window.bee('div.card.bump').eq(1).hasClass('disable')
    Run Keyword If                                   not ${Disabled_Vitrin}             Fail                         bump is not disabled     Bump

Create Discount Code
    [Arguments]                                       ${bump_type}
    Go To                                             ${SERVER}/trumpet/coupon/search
    Wait Until Page Contains                          ${Admin_Coupon_Type}      timeout=10s
    # click element                                     //*[@id="bump-coupon-search"]/button
    click button                                      ${Admin_New_Off_Code_Btn}
    Wait Until Page Contains Element                  ${Admin_Coupon_Modal}                                  timeout=3s     error=new coupon form is not visible
    Input Discount Code
    Input Text                                        ${Admin_Discount_Percent}                   100
    Select Start And End Date
    # click element                                     ${Admin_Coupon_Type_css}
    Select From List By Value                         ${Admin_Coupon_Type_css}          ${bump_type}
    # Click Element                                     ${bump_type}
    Input Text                                        ${Admin_Coupon_Total_Uses}            10000
    Input Text                                        ${Admin_Coupon_Per_User_Uses}         10000
    Execute Javascript                                jQuery('#coupon-modal [type="submit"]').click()   #تایید
    Wait Until Page Contains                          ${Admin_Submit_Active_Coupon}               timeout=3s    error=None
    Execute Javascript                                jQuery('[class="yes btn btn-primary"]').click()  #بله
    Wait Until Page Is Loaded in Moderation
    FOR  ${INDEX}                                     IN RANGE   1   6
       ${Cupon}                                       get text                         ${Admin_Coupon_Result.format("${INDEX}")}
       ${status}                                      Run Keyword And Return Status    Should Be Equal    ${Cupon}    ${Random_Code}
       Exit For Loop If                               ${status}
    END
    Run Keyword Unless                                ${status}       Fail    Can not crate Discount Bump


Select Start And End Date
   Set Discount Start And End date
   click Element                     ${Admin_Coupon_Start_Date}
   Wait Until Page Contains element  ${Admin_Calendar_Menu.format("${SDED}[0]")}
   click element                     ${Admin_Calendar_Menu.format("${SDED}[0]")}
   click element                     ${Admin_Coupon_End_Date}
   @{elements}                       get Webelements    ${Admin_Calendar_Menu.format("${SDED}[1]")}
   ${Status}                         Run Keyword And Return Status    Page Should Contain Element    ${elements}[1]
   Run Keyword If    ${Status}       click element   ${elements}[1]    ELSE    Select Next Month

Select Next Month
  @{nexts}                           get Webelements                  ${Admin_Calendar_Next_Month_Btn}
  click element                      ${nexts}[1]
  ${NextMonth}                       Convert To Integer                             ${SDED}[1]
  ${NextMonth}                       Set Variable                                   ${NextMonth+3600000}
  ${Status}                          Run Keyword And Return Status    Page Should Contain Element     ${Admin_Calendar_Menu.format("${NextMonth}")}
  ${NextDay}                         Set Variable If    ${Status}     ${Admin_Calendar_Menu.format("${NextMonth}")}   ${Admin_Calendar_Menu.format("${NextMonth-7200000}")}
  @{ENDDATE}                         get Webelements                  ${NextDay}
  Wait Until Keyword Succeeds        3x  3s                           click element                      ${ENDDATE}[1]

Set Discount Start And End date
  ${date}  	           Get Current Date	   result_format=datetime                    exclude_millis=True
  ${DayStr}            Convert To String   ${date.day}
  ${DLength}           Get Length          ${DayStr}
  ${Day}               Set Variable If     ${DLength} == ${1}                        0${date.day}      ${date.day}
  ${MonthStr}          Convert To String   ${date.month}
  ${MLength}           Get Length          ${MonthStr}
  ${Month}             Set Variable If     ${MLength} == ${1}                        0${date.month}    ${date.month}
  ${Date}  	           Convert Date	       ${date.year}${Month}${Day} 00:00:00.0
  ${Start}             Convert Date	       ${Date}                                   epoch             exclude_millis=yes
  ${StartStr}          Convert To String   ${Start}
  ${END}               Set Variable        ${Start+86400}
  ${END}               Convert To String   ${END}
  ${StartDate}         Replace String      ${StartStr}                               .0               000
  ${EndDate}           Replace String      ${END}                                    .0               000
  Set Test Variable    @{SDED}             ${StartDate}       ${EndDate}

Input Discount Code
   ${Random_Code}      Generate Random String      24
   Set Test Variable   ${Random_Code}
   Input Text          ${Admin_New_Code_Value}     ${Random_Code}


Verify Packages Rules
   Click By Css Selector                                     ${PF_PU_Bump_Terms}
   Wait Until Page Contains                                  ${PF_Currency_Notice}   timeout=10s
   Click element                                             ${PF_Verify_Pack}

Verify Bump is in Top 3 in Serp
   ${ostan}                                                  Replace String Using Regexp  ${state_name}	 ${SPACE}	 -
   go to                                                     ${SERVER}/${ostan}
   Wait Until Page Contains                                  ${Home_All_Category_Txt}
   Click Element                                             ${Serp_F_Category_Menu}
   Wait Until Page Contains Element                          ${Open_Popup.format("${Serp_F_Category_Popup}")}         timeout=5s
   Click link                                                ${Serp_F_Subcat_Link.format("${CatName}")}
   wait until page Contains                                  ${CatName} در ${state_name}                              timeout=5s
   Refresh Varnish
   Run Keyword If    '${BumpeType}' != 'group_refresh'       Page Should Contain         ${Home_Vitrin_Txt}
   Run Keyword If    '${BumpeType}' != 'group_refresh'       Verify Listing in Vitrin
   ...       ELSE     Verify Listing in Top list

Verify Listing in Top list
    ${serp_listings}                       Get WebElements                                   ${Serp_All_L_Article}
    Element Attribute Value Should Be      ${serp_listings}[0]                               id                               listing-${AdsId}
    Element Should Contain                 ${Serp_L_Title.format("${AdsId}")}                ${Title_Words}

Verify Listing in Vitrin
    Verify Number of Listing in Vitrin
    ${existence_in_vitrin}                 Run Keyword And Return Status                     Page Should Contain Element       ${Serp_Vitrin_L_Article.format("${AdsId}")}
    IF                                     ${existence_in_vitrin}
        Element Should Contain             ${Serp_Vitrin_L_Title.format("${AdsId}")}         ${Title_Words}
    ELSE
        Verify Listing in All Vitrin Page
    END

Verify Listing in All Vitrin Page
    Go To All Vitrin Page
    Page Should Contain Element            ${Serp_Vitrin_L_Article.format("${AdsId}")}       message=Listing is NOT in Vitrin Top 3 in Serp
    Element Should Contain                 ${Serp_Vitrin_L_Title.format("${AdsId}")}         ${Title_Words}

Go To All Vitrin Page
    Click Link                             ${Serp_All_Vitrin_Link}
    Wait Until Page Contains Element       ${Serp_All_Vitrin_Page}                           timeout=10s

Verify Number of Listing in Vitrin
    ${VitrinCount}                         SeleniumLibrary.Get Element Count                 ${Serp_Vitrin_All_L}
    Should Be True                         ${1} <= ${VitrinCount} <= ${4}
    Set Test Variable                      ${VitrinCount}

Bump List
   [Arguments]                             ${list}
   ${cnt}                                  Get length    ${list}
   should be equal as numbers              ${cnt}  3

Check Gallery view
   Click By Css Selector                  [data-set-cookie="sv=g"]
   Assign ID to Element                   css=.gallery                               ${Serp_L_Photo_Galery}
   Page Should Contain Element            ${Serp_L_Photo_Galery}
   ${TitleSerp}                           Get Text                                   ${Home_Listing_Title}
   ${elem}                              	Get WebElement                             ${Home_Category_Content}
   Element Should Not Contain             css:.serp-item.gallery:nth-child(1)        ${Title_Words}
   click element                          ${elem}
   click element                          ${Serp_L_Photo_Galery}
   ${TitleDetail}                         Get Text                                   ${LD_Item_Detail_Header}
   Should Be Equal                        ${TitleSerp}                               ${TitleDetail}
   Set Test Variable                      ${SerpTitle}                               ${TitleSerp}

Validate Sort Type
   [Arguments]                            ${Value}
   ${Sort}                                Get Selected List Value              ${Serp_Sort_L}
   Should Be Equal                        ${Sort}  ${Value}
   Wait Until Page Is Loaded
