*** Settings ***
Resource                                      startup.resource


*** Variables ***
${CheckNewUsed}                               OK
${Show_SP_Popup}                              ${FALSE}
${SP_Required}                                ${FALSE}

*** Keywords ***
#####################################        validation          ##########################################
Check Black List
    Click Element                             ${MY_LISTING_ITEM}
    Wait Until Page Contains                  ${WAITING}
    Find Text By Swipe in loop                شناسه آگهی:
    ${AdverID}                                Get Text                                id=${APP_PACKAGE}:id/adapterAdDetailsAdId
    ${AdverID}                                Get Regexp Matches                      ${AdverID}        \\d{9}
    Set Test Variable                         ${listingId}                            ${AdverID}[0]
    ${listing_is_blacklist}                   Post Moderation validation
    Run Keyword Unless                        ${listing_is_blacklist}                 Fail                   Post Moderation is not run on listing with ID ${listingId}
    Click Element                             ${TOOLBAR_BACK}
    Wait Until Page Contains                  ${Title_Words}
    Check Text In Element By Swipe In Loop    ${OFFER_STATUS}                         ${APPROVED_MESSAGE}


#####################################        Data          ##########################################
Get Random Listing
    [Arguments]                              ${SubCatID}                ${attribute_id}=${None}        ${option_id}=${None}
    ${Random_Listing}                        Random Live Listing        category=${SubCatID}           attribute_id=${attribute_id}    option_id=${option_id}    image=${False}
    FOR   ${key}    IN   @{Random_Listing.keys()}
        ${randomKey}                         Get From Dictionary        ${Random_Listing}              ${key}
        Set Suite Variable                   ${Listings_${key}}         ${randomKey}
    END

Input Title And Decription
    Get Real Description
    Get Real Title
    Input Title                              ${Title_Words}
    Input Description                        ${Title_Description}
    Swipe By Percent                         50     70     50    30  1000

#TODO: There are different methods for generating random number in whole project, shuch as @keyword(name='Random Phone Number')
Mobile Generator A
    ${Random_Number}            Generate Random String      7           [NUMBERS]
    Set Suite Variable          ${Random_User_Mobile_A}    0900${Random_Number}

Filter Car In Tehran
    Filter Category             وسایل نقلیه      خودرو
    Click Filter
    Filter Car Brand
    Click Spinner               نوع شاسی
    Scroll The List             سدان (سواری)
    click Spinner               نقدی/اقساطی
    Scroll The List             نقدی
    click Spinner               نو / کارکرده
    Scroll The List             کارکرده
    Click Spinner               حداقل سال تولید
    Scroll The List             ۱۳۷۸ (۱۹۹۹)
    Click Spinner               حداکثر سال تولید
    Scroll The List             ۱۳۹۶ (۲۰۱۷)
    Click Spinner               حداقل کیلومتر
    Scroll The List             ۱۰۰۰۰
    Click Spinner               حداکثر کیلومتر
    Scroll The List             ۱۰۰۰۰۰
    Click Spinner               رنگ
    Scroll The List             سفید
    Click Spinner               گیربکس
    Scroll The List             دنده‌ای
    Click Spinner               وضعیت بدنه
    Scroll The List             دو لکه رنگ
    Click The Switch            کارشناسی شده    0
    Input Attribute             قیمت از (تومان)        10000000
    Input Attribute             قیمت تا (تومان)     80000000
    Filter Location
    swipe by percent            95   60   95   30   1000
    Wait Until Page Contains Element    ${FILTER_BUTTON}
    Click Element               ${FILTER_BUTTON}

Filter Car Brand
    click element               android=UiScrollable(UiSelector().scrollable(true).instance(0)).scrollIntoView(new UiSelector().description("برند و مدل"))
    ${Status}                   Run Keyword And Return Status    Wait Until Page Contains        ${CAR_FILTER_LIST}      timeout=10s
    Run Keyword If              ${Status}     Do New Filter Car Brand            ELSE      Do Old Filter Car Brand
    Set Test Variable           ${MultiBrand}     ${Status}
    Sleep                       2s

Do New Filter Car Brand
   Click Element               android=UiScrollable(UiSelector().scrollable(true).instance(0)).scrollIntoView(new UiSelector().description("باز کردن پراید"))
   Scroll The List             صبا (صندوقدار)
   Click Element               id=${APP_PACKAGE}:id/searchButton

Do Old Filter Car Brand
    Scroll The List             پراید
    Scroll The List             صبا (صندوقدار)
    Click Element               ${APPLY_BUTTON}


####################################        Select Items  &   find location of items          ########################################
Scroll Next
    [Arguments]                         ${Elem}
    Find Element By Swipe in loop       ${Elem}
    Scroll To Top                       ${Elem}             260                   #appium_extended.py

Scroll The List
    [Arguments]                         ${option}
    ${Locator}                          Set Variable      android=UiScrollable(UiSelector().scrollable(true).instance(0)).scrollIntoView(new UiSelector().description("${option}"))
    Wait Until Keyword Succeeds         3x     500ms      Click Element     ${Locator}
    Sleep     100ms

Back To Home Page
    [Arguments]                        ${Number_of_back}
    FOR   ${INDEX}    IN RANGE    0    ${Number_of_back}
        Click Back Button
        Sleep               2s
    END
    Wait Until Page Contains Element   ${CAT_ROOT}                         timeout=10s

Click Back Button
    Press Keycode                      4

Click Home Button
    Press Keycode                      3

Click Toolbar Items
    [Arguments]                      ${Label}
    Wait Until Page Contains         ${MYACCOUNT}        timeout=10
    swipe by percent                 90   80   90   30   1000
    FOR    ${INDEX}                  IN RANGE    1    5
       ${status}                     Run Keyword And Return Status    Page Should Contain Text   تماس با پشتیبانی
       Exit For Loop If              ${status}
       swipe by percent              90   80   90   30   1000
    END
    ${elements}                      Get Webelements     id=${APP_PACKAGE}:id/titleText
    ${toolbar}                       Get Length          ${elements}
    FOR    ${INDEX}    IN RANGE     1       ${toolbar+1}
       ${Title}                     Get Text            ${elements}[${INDEX-1}]
       Run Keyword If               '${Title}' == '${Label}'    click Element   ${elements}[${INDEX-1}]
       Exit For Loop If             '${Title}' == '${Label}'
    END
    Run Keyword If                  '${Title}' != '${Label}'      Fail    ${Label} not found in toolbar

Click The Switch
    [Arguments]                     ${option}      ${instance}
    Wait Until Keyword Succeeds     3x    500ms     Click Element     android=UiScrollable(UiSelector().scrollable(true).instance(0)).scrollIntoView(new UiSelector().text("${option}").instance(${instance}))
    Sleep                           100ms

Click The Checkbox
    [Arguments]             ${instance}
    Wait Until Keyword Succeeds    3x    500ms     Click Element     android=UiScrollable(UiSelector().scrollable(true).instance(0)).scrollIntoView(new UiSelector().className("android.widget.CheckBox").instance(${instance}))
    Sleep     100ms

Click Spinner
    [Arguments]                            ${Content_Description}
    ${Locator}                             Set Variable                        android=UiScrollable(UiSelector().scrollable(true).instance(0)).scrollIntoView(new UiSelector().description("${Content_Description}").childSelector(new UiSelector().resourceId("com.sheypoor.mobile.debug:id/componentSpinnerRoot")))
    # swipe by percent                     90   60   90   40   500
    # Scroll Next                            ${Locator}
    Wait Until Page Contains Element       ${Locator}     timeout=10s
    Scroll To Top                          ${Locator}     260
    Run Keyword And Ignore Error           Click Element                ${Locator}
    Sleep                                  500ms

Click Category Spinner
    Click Element                          android=UiScrollable(UiSelector().scrollable(true).instance(0)).scrollIntoView(new UiSelector().description("دسته بندی"))

Click The Link
    [Arguments]    ${option}
    Wait Until Page Contains Element     android = UiSelector().text("${option}")           timeout=5s
    Click Element                        android = UiSelector().text("${option}")

Click The List
    [Arguments]                          ${option}
    Click Element                        android = UiSelector().text("${option}")

Find Element By Swipe in loop
    [Arguments]                          ${Locator}
    FOR    ${INDEX}                      IN RANGE    1    10
       ${Status}                         Run Keyword And Return Status   Page Should Contain Element    ${Locator}
       Exit For Loop If                  ${status}
       Run Keyword If                    not ${Status}    swipe by percent     90   60   90   40   500
    END
    [Return]                             ${Status}

Find Element By Swipe Up
    [Arguments]                          ${Locator}
    FOR    ${INDEX}                      IN RANGE    1    10
       ${Status}                         Run Keyword And Return Status   Page Should Contain Element    ${Locator}
       Exit For Loop If                  ${status}
       Run Keyword If                    not ${Status}    swipe by percent     90   40   90   60   350
    END
    [Return]                             ${Status}

Find Text By Swipe in loop
    [Arguments]                             ${Text}
    FOR    ${INDEX}                         IN RANGE    1    10
       ${Status}                            Run Keyword And Return Status   Page Should Contain Text     ${Text}
       Exit For Loop If                     ${status}
       Run Keyword If                       not ${Status}    swipe by percent     90   80  90   60   150
    END
    Run Keyword If                          not ${Status}    Fail    can not find ${Text} in page

Check Home Page List Is Loaded
    [Documentation]                        check in home page is diffrenet from serp page because of shop vitrin
    Find Element By Swipe in loop          ${OfferInSerpID}

Find Text By swipe
   [Arguments]           ${option}
   Find Element By Swipe in loop           android=UiSelector().text("${option}")

Check Text In Element By Swipe In Loop
    [Arguments]                            ${Locator}          ${Text}
    FOR    ${INDEX}                        IN RANGE    1    10
       ${Status}                           Run Keyword And Return Status    Element Should Contain Text        ${Locator}        ${Text}
       Exit For Loop If                    ${Status}
       Swipe Down                          ${2}
    END
    Run Keyword If                         not ${Status}    Fail    can not find ${Text} in page

Check Text By Swipe In Loop
    [Arguments]                            ${Text}
    FOR    ${INDEX}                        IN RANGE    1    10
       ${Status}                           Run Keyword And Return Status    Page Should Contain Text         ${Text}
       Exit For Loop If                    ${Status}
       Swipe Down                          ${2}
    END
    Run Keyword If                         not ${Status}    Fail    can not find ${Text} in page

Page Should Contain Element By ID
    [Arguments]                            ${Id}
    ${local_var}                           Set Variable        UiSelector().resourceId("${Id}")
    ${status}                              Run Keyword And Return Status     Page Should Contain Element         android=${local_var}
    Run Keyword Unless                     ${status}           Page Should Contain Element By ScrollView         ${local_var}

Page Should Contain Element By ID And Text
    [Arguments]                            ${Id}               ${Text}
    ${local_var}                           Set Variable        UiSelector().resourceId("${Id}").text("${Text}")
    ${status}                              Run Keyword And Return Status     Page Should Contain Element         android=${local_var}
    Run Keyword Unless                     ${status}           Page Should Contain Element By ScrollView         ${local_var}

Page Should Contain Element By Class And Text
    [Arguments]                            ${Class}                    ${Text}
    ${local_var}                           Set Variable        UiSelector().className("${Class}").text("${Text}")
    ${status}                              Run Keyword And Return Status     Page Should Contain Element         android=${local_var}
    Run Keyword Unless                     ${status}           Page Should Contain Element By ScrollView         ${local_var}

Page Should Contain Element By Description
    [Arguments]                            ${Description}
    ${local_var}                           Set Variable        UiSelector().description("${Description}")
    ${status}                              Run Keyword And Return Status     Page Should Contain Element         android=${local_var}
    Run Keyword Unless                     ${status}           Page Should Contain Element By ScrollView         ${local_var}

Page Should Contain Element By Description And Text
    [Arguments]                            ${Description}      ${Text}
    ${local_var}                           Set Variable        UiSelector().description("${Description}").text("${Text}")
    ${status}                              Run Keyword And Return Status     Page Should Contain Element         android=${local_var}
    Run Keyword Unless                     ${status}           Page Should Contain Element By ScrollView         ${local_var}

Page Should Contain Element By ScrollView
    [Arguments]                             ${locator}
    Page Should Contain Element             android=UiScrollable(UiSelector().scrollable(true).instance(0)).scrollIntoView(new ${locator})

Page Should Not Contain Element By ID And Text
    [Arguments]                             ${Id}               ${Text}
    ${local_var}                            Set Variable        UiSelector().resourceId("${Id}").text("${Text}")
    Page Should Not Contain Element By ScrollView               ${local_var}

Page Should Not Contain Element By ScrollView
    [Arguments]                             ${locator}
    Page Should Not Contain Element         android=UiScrollable(UiSelector().scrollable(true).instance(0)).scrollIntoView(new ${locator})

Element Should Contain Text By ID And Text
    [Arguments]                            ${Id}               ${Text}
    ${local_var}                           Set Variable        UiSelector().resourceId("${Id}")
    ${status}                              Run Keyword And Return Status     Element Should Contain Text                android=${local_var}      ${Text}
    Run Keyword Unless                     ${status}           Element Should Contain Text By ScrollView                ${local_var}              ${Text}

Element Should Contain Text By ScrollView
    [Arguments]                           ${locator}          ${Text}
    Element Should Contain Text           android=UiScrollable(UiSelector().scrollable(true).instance(0)).scrollIntoView(new ${locator})      ${Text}

Page Should Contain CheckBox By Text And Status
    [Arguments]                           ${Text}          ${Status}
    Page Should Contain Element           xpath=//android.widget.TextView[@text='${Text}']/following-sibling::android.widget.ImageView[@content-desc='${Status}']

Click Element By ID And Text
    [Arguments]                           ${Id}               ${Text}
    ${local_var}                          Set Variable        UiSelector().resourceId("${Id}").text("${Text}")
    ${status}                             Run Keyword And Return Status     Click Element         android=${local_var}
    Run Keyword Unless                    ${status}           Click Element By ScrollView         ${local_var}

Click Element By ScrollView
    [Arguments]                         ${locator}
    Click Element                       android=UiScrollable(UiSelector().scrollable(true).instance(0)).scrollIntoView(new ${locator})

#Find Text By Swipe UP in loop              #DeprecatedKeyword
#Get Locator Of Attribute                   #DeprecatedKeyword
#Select Auto Location                       #DeprecatedKeyword
#Get toolbar icon Coordinates               #DeprecatedKeyword
#Scroll Spinner Up                          #DeprecatedKeyword
#Get Locator Of Spinner                     #DeprecatedKeyword

####################################         Data Entry             ########################################
Input Attribute
    [Arguments]                         ${Content_Description}           ${Texts}
    Wait Until Page Contains Element    android=UiScrollable(UiSelector().scrollable(true).instance(0)).scrollIntoView(UiSelector().description("${Content_Description}"))                       timeout=10s
    ${locator}                          Set Variable      UiSelector().description("${Content_Description}").childSelector(new UiSelector().resourceId("${APP_PACKAGE}:id/componentEditTextInput"))
    ${status}                           Run Keyword And Return Status           Page Should Contain Element         android=${locator}
    Run Keyword If                      ${status}         Input Text                              android=${locator}                  ${Texts}
    ...  ELSE                           Input Text        android=UiScrollable(UiSelector().scrollable(true).instance(0)).scrollIntoView(${locator})      ${Texts}
    Sleep                               500ms

Input Edit Text
    [Arguments]          ${Locator}              ${Texts}
    ${local_var}         Set Variable            UiSelector().resourceId("${Locator}").childSelector(new UiSelector().className("${EDIT_TEXT}"))
    ${status}            Run Keyword And Return Status           Page Should Contain Element         android=${local_var}
    Run Keyword If       ${status}              Input Text              android=${local_var}                 ${Texts}
    ...  ELSE            Input Text             android=UiScrollable(UiSelector().scrollable(true).instance(0)).scrollIntoView(${local_var})      ${Texts}
    Sleep                500ms

Input SMS Code
    [Arguments]  ${MobileNo}
    FOR  ${INDEX}              IN RANGE  0   3
       ${status}               Run Keyword And Return Status   Wait Until Page Contains Element    ${Confirm_Digit}     timeout=10
       Exit For Loop If        ${status}
       Run Keyword If          not ${status}                   Click Login Register Button
    END
    Run Keyword If             not ${status}                   Fail       Can't click register Btn
    Tap                        ${Confirm_Digit}
    ${Code}                    Wait Until Keyword Succeeds     3x    1s    Verify Code From Server  ${MobileNo}
    Insert Code                ${Code}

Verify Code From Server
    [Arguments]               ${MobileNo}
    ${Code}                   Mock Login Get Code           ${MobileNo}
    ${stripped}               Strip String                  ${Code}
    ${characters}             Split String To Characters    ${stripped}
    [Return]                  ${characters}

Insert Code
    [Arguments]               ${Number}
    ${Length}                 get Length      ${Number}
    FOR   ${index}            IN RANGE   0    ${Length}
        ${Char}  	            Get From List	  ${Number}	  ${index}
        ${key}                Evaluate        ${Char} + 7
        Press Keycode         ${key}
    END

Input Price In Listing Form
    [Arguments]                         ${Price_Value}
    Input Attribute                     قیمت (تومان)    ${Price_Value}

Input Stuff Status
    [Arguments]                         ${Stuff_Status_Value}
    Click Spinner                       وضعیت کالا
    Click The List                      ${Stuff_Status_Value}

Input Title
    [Arguments]                 ${Texts}
    wait until page contains element                 android=UiScrollable(UiSelector().scrollable(true).instance(0)).scrollIntoView(new UiSelector().resourceId("${OFFER_NAME}"))   timeout=10s
    Input Edit Text                                  ${OFFER_NAME}         ${Texts}

Input Description
    [Arguments]                 ${Texts}
    wait until page contains element                 android=UiScrollable(UiSelector().scrollable(true).instance(0)).scrollIntoView(new UiSelector().resourceId("${OFFER_DESC}"))             timeout=10s
    Input Edit Text                                 ${OFFER_DESC}          ${Texts}

Click Confirm SMS
    FOR    ${Index}                IN RANGE   1    3
      ${Sent}                      Run Keyword And Return Status    Wait Until Page Does Not Contain    ارسال مجدد کد     timeout=10
      Exit For Loop If             ${Sent}
      ${final_confirm}             Run Keyword And Return Status    Page Should Contain Text            تایید نهایی
      Run Keyword If               ${final_confirm}                 Run Keyword And Ignore Error        Click The Link    تایید نهایی
    END

Input Attribute By Id
    [Arguments]                   ${Resource_Id}           ${Texts}
    ${Locator}                    Set Variable       android=UiScrollable(UiSelector().scrollable(true).instance(0)).scrollIntoView(new UiSelector().resourceId("${Resource_Id}"))
    Swipe Up Element To Top       ${Locator}
    Input Text                    ${Locator}               ${Texts}
    Sleep                         500ms

###################################        Login  &  Log Out             #######################################

Click Login Register Button
   Click Element                                    ${APP_PACKAGE}:id/loginButton

Login By Mobile
    [Arguments]                                     ${Mobile}=${EMPTY}
    IF                                             '${Mobile}'=='${EMPTY}'
        Mobile Generator A
        Set Test Variable                           ${Mobile}                       ${Random_User_Mobile_A}
    END
    Wait Until Page Contains Element                ${Mail_Number}
    Input Text                                      ${Mail_Number}                  ${Mobile}
    Run Keyword And Ignore Error                    Hide Keyboard
    Click Login Register Button
    Input SMS Code                                  ${Mobile}
    Click Confirm SMS

Login to Sheypoor
    [Arguments]                                     ${Mobile}=${EMPTY}
    Go To The Login Page And Log In                 ${Mobile}
    Check My listing is loaded for New user         ${Mobile}

Login to Sheypoor For User With Listing
    [Arguments]                                     ${Mobile}
    Go To The Login Page And Log In                 ${Mobile}
    Check My listing is loaded for Existing user    ${Mobile}

Go To The Login Page And Log In
    [Arguments]                                     ${Mobile}
    Click Toolbar Account
    Wait Until Page Contains                        کاربر شیپور                     timeout=10
    Click The Link                                  کاربر شیپور
    Login By Mobile                                 ${Mobile}

Go To Paid Feature Page From My Listing
    Page Should Contain Element By ID               ${MY_AD_BUMP_BUTTON_TITLE}
    Click Element                                   ${MY_AD_BUMP_BUTTON_TITLE}
    Wait Until Page Contains Element                ${BUMP_ITEM_TITLE}
    Page Should Contain Text                        ${PAID_FEATURE_BUMP_ADVERTISMENT_MSG}

Check My listing is loaded for Existing user
    [Arguments]                                 ${userMobile}
    Wait Until Page Contains                    ${Listings_title}
    Page Should Contain Element                 id=${PROFILE_SETTING}
    Page Should Contain Element                 id=${APP_PACKAGE}:id/myAdsEdit
    Element Should Contain Text                 id=${APP_PACKAGE}:id/myAdsPhone      ${userMobile}
    Page Should Contain Element                 id=${NEW_LISTING}
    Page Should Contain Text                    ویرایش
    Page Should Contain Text                    فعال
    Page Should Contain Text                    غیر فعال
    Page Should Contain Text                    آگهی‌های من
    Page Should Contain Text                    تایید شده
    Page Should Contain Text                    آمار بازدید
    Page Should Contain Text                    حذف
    Page Should Contain Text                    ویرایش
    Page Should Contain Text                    وضعیت بازدید:
    Page Should Contain Text                    افزایش بازدید
    Page Should Contain Text                    تعداد بازدید در ۲۴ ساعت اخیر:

Check My listing is loaded for New user
    [Arguments]                                 ${userMobile}
    Wait Until Page Contains                    شما تا کنون آگهی ثبت نکرده اید
    Page Should Contain Text                    همین الان اولین آگهی خود را ثبت نمایید
    Page Should Contain Element                 id=${PROFILE_SETTING}
    Page Should Contain Element                 id=${APP_PACKAGE}:id/myAdsEdit
    Element Should Contain Text                 id=${APP_PACKAGE}:id/myAdsPhone      ${userMobile}
    Page Should Contain Element                 id=${NEW_LISTING}
    Page Should Contain Text                    ویرایش
    Page Should Contain Text                    فعال
    Page Should Contain Text                    غیر فعال

Log Out From Sheypoor
    Click Toolbar Account
    Click Toolbar Items                         ${LOG_OUT}
    Wait Until Page Contains Element            ${ALERT_TITLE}
    Page Should Contain Text                    ${LOG_OUT_CONFIRM_MESSAGE}
    Click The Link                              بله
    Wait Until Page Contains Element            ${MAIN_MENU}
    Click Element                               ${MAIN_MENU}
    Wait Until Page Contains Element            ${USER_NAME}
    Element Should Contain Text                 ${USER_NAME}               کاربر شیپور
    Page Should Not Contain Element             ${USER_EDIT_PROFILE}
    Page Should Not Contain Element             ${USER_MOBILE}
    Back To Home Page           1

###################################        function about listing (Approve , Delete, ... )           #######################################

Post Moderation validation
     ${blacklisted}                        Is BlackListed          	${listingId}
     # Run Keyword if                        ${blacklisted}           Trumpet adv         accept         ${listingId}
     Trumpet adv                           accept         ${listingId}
     Run Keyword if                        ${blacklisted}           Set Test Message    listing ${listingId} was blacklisted and approved by tests so no post moderation is occured    append=True
     [Return]                              ${blacklisted}

Post A New Listing Without Payment
    [Arguments]      ${SubCategory_ID}=43601        ${Num_Of_Photo}=${0}        ${Category}= لوازم خانگی       ${SubCategory}=مبلمان و لوازم چوبی
    ...              ${State}=تهران               ${City}=تهران               ${Region}=${EMPTY}             ${User_Mobile}=${EMPTY}         ${Price}=${EMPTY}
    ...              ${NewUsed}=نو                ${Chip_Diccount_Price}=${0}       ${Kind}=${EMPTY}            ${Sub_SubCategory}=${EMPTY}
    ...              ${Instant_Tag_Price}=${0}    ${BarCode}=${EMPTY}

    Post A New Listing
    ...              ${SubCategory_ID}               ${Num_Of_Photo}             ${Category}                    ${SubCategory}
    ...              ${State}                     ${City}                     ${Region}                      ${User_Mobile}        ${Price}
    ...              ${NewUsed}                   ${Chip_Diccount_Price}      ${Kind}                        ${Sub_SubCategory}
    ...              ${Instant_Tag_Price}         ${BarCode}
    Check Listing Status in My Listings Page By Click NOTNOW Button

Post A New Listing
    [Arguments]      ${SubCategory_ID}=43601      ${Num_Of_Photo}=${0}          ${Category}= لوازم خانگی     ${SubCategory}=مبلمان و لوازم چوبی
    ...              ${State}=تهران               ${City}=تهران                 ${Region}=${EMPTY}           ${User_Mobile}=${EMPTY}      ${Price}=${EMPTY}
    ...              ${NewUsed}=نو                ${Chip_Diccount_Price}=${0}   ${Kind}=${EMPTY}             ${Sub_SubCategory}=${EMPTY}
    ...              ${Instant_Tag_Price}=${0}    ${BarCode}=${EMPTY}
    Go To Post Listing Page
    Get Random Listing                          ${SubCategory_ID}
    ${has_Image}                                Handle Inserting Photo          ${Num_Of_Photo}
    Select Category And SubCategory             ${Category}                     ${SubCategory}               ${Sub_SubCategory}
    Handle Kind                                 ${Kind}
    Handle Price                                ${Price}
    Handle New Used Attribute                   ${NewUsed}
    Handle BarCode                              ${BarCode}
    Input Title And Decription
    Handle Chip Discount Attribute              ${Chip_Diccount_Price}
    Handle Instant Tag                          ${Instant_Tag_Price}
    Select Location                             ${State}                ${City}                ${Region}
    Submit Post Listing                         ${has_Image}            ${FALSE}
    Login By Mobile                             ${User_Mobile}
    Get AdID And Accept Listing
    Sleep                                       2s

Post A new Listing By Random Mobile By Api And Accept
    Mobile Generator A
    Post Listing In Background Via Python         ${Category}                 ${SubCategory}              ${Price}
    ...   ${State}              ${City}           ${Region}                   ${Random_User_Mobile_A}
    ...   ${Number_Of_Photos}   ${NewUsed}        ${FALSE}                    ${Kind}
    Trumpet adv                 accept            ${listingId}

Handle Inserting Photo
    [Arguments]                                 ${Num_Of_Photo}
    ${has_Image}                                Set Variable If         ${Num_Of_Photo} > 0       ${TRUE}          ${FALSE}
    Run Keyword If                              ${has_Image}            Insert Photos             ${Num_Of_Photo}
    [Return]                                    ${has_Image}

Select Category And SubCategory
    [Arguments]                         ${Category}     ${SubCategory}           ${Sub_SubCategory}=${EMPTY}
    Click Category Spinner
    Scroll The List                     ${Category}
    Scroll The List                     ${SubCategory}
    Run Keyword If                     '${Sub_SubCategory}' != '${EMPTY}'            Scroll The List      ${Sub_SubCategory}

Handle Price
    [Arguments]                        ${Price}
    ${Has_Price_Field}                 Run Keyword And Return Status       Page Should Contain Element By Description     قیمت (تومان)
    ${Listings_price}                  Set Variable If                     '${Listings_price}' == '0'                     5000000                ${Listings_price}
    Run Keyword If                     '${Price}' == '${EMPTY}' and ${Listings_price} and ${Has_Price_Field}              Input Attribute        قیمت (تومان)          ${Listings_price}
    ...    ELSE IF                     '${Price}' != '${EMPTY}'            Input Attribute        قیمت (تومان)            ${Price}
    Set Test Variable                  ${Listings_price}

Handle New Used Attribute
    [Arguments]                        ${New_Used_Att}
    ${status}                          Run Keyword And Return Status       Page Should Contain Element By Description    وضعیت کالا
    Run Keyword If                     ${status}                           Set New Used Attribute         ${New_Used_Att}

Set New Used Attribute
    [Arguments]                        ${New_Used_Att}
    Click Spinner                      وضعیت کالا
    Scroll The List                    ${New_Used_Att}

Handle BarCode
    [Arguments]                        ${BarCode}
    Run Keyword If                     '${BarCode}' != '${EMPTY}'          Fill BarCode TextBox             ${BarCode}

Fill BarCode TextBox
    [Arguments]                        ${BarCode}
    ${status}                          Run Keyword And Return Status       Page Should Contain Element By Description     شناسه کالا
    Run Keyword If                     ${status}                           Input Attribute        شناسه کالا           ${BarCode}
    ...      ELSE                      Fail                                There is no textbox with name شناسه کالا

Handle Kind
    [Arguments]                        ${Kind}
    Run Keyword If                    '${Kind}'!='${EMPTY}'                Set Kind Attribute         ${Kind}

Set Kind Attribute
    [Arguments]                        ${Kind}
    ${status}                          Run Keyword And Return Status       Page Should Contain Element    android=UiScrollable(UiSelector().scrollable(true).instance(0)).scrollIntoView(UiSelector().text("زنانه / مردانه"))
    Run Keyword If                     ${status}                           Select Kind Attribute        ${Kind}
    ...       ELSE                     Fail                                The kind spinner is not found in post listing page.

Select Kind Attribute
    [Arguments]                        ${Kind}
    Click Spinner                      زنانه / مردانه
    Scroll The List                    ${Kind}

Handle Chip Discount Attribute
    [Arguments]                        ${Chip_Diccount_Price}
    Run Keyword If                    '${Chip_Diccount_Price}'!='${0}'         Select Chip Discount Switch             ${Chip_Diccount_Price}

Select Chip Discount Switch
    [Arguments]                        ${Chip_Diccount_Price}
#    TODO: after debugging, we should check price in post listing page
#    ${status}                          Run Keyword And Return Status       Page Should Contain Element By ID And Text       ${APP_PACKAGE}:id/componentSwitchTitle        نشان${SPACE}تخفیفی${SPACE}(${Chip_Diccount_Price}${SPACE}تومان)
    ${status}                          Run Keyword And Return Status       Page Should Contain Element By ID        ${APP_PACKAGE}:id/componentSwitchTitle
#    Run Keyword If                     ${status}                           Validate Type Of Tag                نشان${SPACE}تخفیفی
    Run Keyword If                     ${status}                           Click The Switch       OFF   0
    ...       ELSE                     Fail                                The chip discount is not define in admin

Handle Instant Tag
    [Arguments]                        ${Instant_Tag_Price}
    Run Keyword If                    '${Instant_Tag_Price}'!='${0}'         Select Instant Tag Switch             ${Instant_Tag_Price}

Select Instant Tag Switch
    [Arguments]                        ${Instant_Tag_Price}
#    TODO: after debugging, we should check price in post listing page
#    ${status}                          Run Keyword And Return Status       Page Should Contain Element By ID And Text    ${APP_PACKAGE}:id/componentSwitchTitle         نشان${SPACE}فوری${SPACE}(${Instant_Tag_Price}${SPACE}تومان)
    ${status}                          Run Keyword And Return Status       Page Should Contain Element By ID        ${APP_PACKAGE}:id/componentSwitchTitle
#    Run Keyword If                     ${status}                           Validate Type Of Tag                نشان${SPACE}فوری
    Run Keyword If                     ${status}                           Click The Switch       OFF   0
    ...       ELSE                     Fail                                The instant tag is not in post listing page

Validate Type Of Tag
    [Arguments]                         ${Tag_Type_Text}
    ${text_instant_tag}                 Get Element Attribute           android=UiSelector().resourceId("${APP_PACKAGE}:id/componentSwitchTitle")       text
    Should Contain                      ${text_instant_tag}             ${Tag_Type_Text}

Select Location Region
    [Arguments]                         ${State}         ${City}          ${Region}
    Click Element                       android=UiScrollable(UiSelector().scrollable(true).instance(0)).scrollIntoView(new UiSelector().resourceId("${LOCATION_SPINNER_DEFAULT}"))
    Scroll The List                     استان${SPACE}${State}
    Scroll The List                     ${City}
    Run Keyword Unless                 '${Region}' == '${EMPTY}'        Scroll The List       ${Region}
    # Swipe By Percent                    50     70     50    30  1000

Select Location
    [Arguments]                            ${State}   ${City}   ${Region}
    ${Locator}                             Set Variable                        android=UiScrollable(UiSelector().scrollable(true).instance(0)).scrollIntoView(new UiSelector().description("موقعیت مکانی").childSelector(new UiSelector().resourceId("com.sheypoor.mobile.debug:id/componentEditText")))
    Wait Until Page Contains Element       ${Locator}     timeout=10s
    Scroll To Top                          ${Locator}     260
    Run Keyword And Ignore Error           Click Element                ${Locator}
    # Click Element                        ${LOCATION_SPINNER_LOCATOR}
    Scroll The List                        استان${SPACE}${State}
    Scroll The List                        ${City}
    Input Region                           ${Region}                    ${City}
    # Swipe By Percent                     50     70     50    30  1000

Input Region
    [Arguments]                                           ${Region}                           ${City}
    ${Status}                                             Run Keyword And Return Status       Page Should Contain Text        محله‌های شهر ${City}
    ${ValidRegion}                                        Run Keyword And Return Status       Should Not Be Empty             ${Region}
    ${Reg_Field_Var}                                      Set Variable                        ${FALSE}
    Set Test Variable                                     ${Reg_Field_Var}
    Run Keyword If                                        ${Status} and ${ValidRegion}        Input Region In Popup           ${Region}
    ...  ELSE                                             Run Keyword Unless                  ${Status}                       Input Value For Region Feild    ${Region}   ${ValidRegion}

Input Region In Popup
    [Arguments]                                           ${Region}
    Scroll The List                                       ${Region}

Input Value For Region Feild
    [Arguments]                                           ${Region}                           ${ValidRegion}
    Page Should Contain Element By ID And Text            ${CHECK_OUT_RECEIVER_NAME_TITLE}    محله
    Run Keyword If                                        ${ValidRegion}                      Input Attribute                 محله                       ${Region}
    ${Reg_Value_Status}                                   Run Keyword And Return Status       Check Value Of Region           ${Region}
    Run Keyword If                                        ${Reg_Value_Status}                 Set Test Variable               ${Reg_Field_Var}           ${True}

Check Value Of Region
    [Arguments]                                           ${Region}
    Page Should Contain Element By Description And Text   محله                                ${Region}

Click Post Listing Button
    Click Element By ID And Text                  ${Post_Ad_Button}            ثبت آگهی

Submit Post Listing
    [Arguments]                             ${HasImage}                        ${loggedin}=${TRUE}
    Page Should Contain Element By ID And Text                             ${APP_PACKAGE}:id/fragmentPostAdButton             ثبت آگهی
    FOR  ${i}  IN RANGE  3
      Run Keyword And Ignore Error          Click Element By ID And Text       ${APP_PACKAGE}:id/fragmentPostAdButton             ثبت آگهی
      Run Keyword Unless                    ${HasImage}                        Handle NoImage PopUP
      ${Done}                               Run Keyword And Return Status      Wait Until Page Does Not Contain Element       android=UiSelector().resourceId("${PAGE_TITLE}").text("ثبت آگهی رایگان")         timeout=10s
      Exit For Loop If                      ${Done}
    END
    Run Keyword Unless                      ${Done}         Fail               Can not submit listing
    Run Keyword If                          ${loggedin}
    ...                                     Handle Secure Purchase
    Set Test Variable                       ${loggedin}

Handle Secure Purchase
    Run Keyword If                         ${Show_SP_Popup}                  Handle Secure Purchase Popup

Handle Secure Purchase Popup
    Check Secure Purchase PopUp Is Open
    IF                                     ${SP_Required}
    Activate Secure Purchase For Listing
    ELSE
    Close Secure Purchase Popup
    END

Close Secure Purchase Popup
    Click Element                         id=${SECURE_PURCHASE_CLOSE_BTN}

Activate Secure Purchase For Listing
    Go To Secure Purchase Page
    Input Secure Purchase Activation Data

Go To Secure Purchase Page
    Click Element                         id=${SECURE_PURCHASE_ACTIVAITE_BTN}
    Wait Until Page Contains              ${SECURE_PURCHASE_FORM}             timeout=10s

Check Secure Purchase PopUp Is Open
    Wait Until Page Contains Element      id=${SECURE_PURCHASE_ACTIVAITE_BTN}                         timeout=10s
    Page Should Contain Text              با تبدیل آگهی خود به "خرید امن" سریع‌تر بفروشید.
    Page Should Contain Text              فعال شدن قابلیت پرداخت اینترنتی برای آگهی شما
    Page Should Contain Text              حمل و نقل کالا توسط پیک شیپور
    Page Should Contain Text              بازگشت کالا در صورت بروز هر گونه مشکل
    Page Should Contain Text              نمایش آگهی در سراسر ایران

Input Secure Purchase Activation Data
    Click Spinner                         وزن
    Scroll The List                       ۱ تا ۵ کیلو
    Click Spinner                         ابعاد
    Scroll The List                       متوسط (حمل با سواری تا ۹۰*۵۰*۵۰)
    ${hasprice}                           Run Keyword And Return Status
    ...                                   Page Should Contain Element                               ${SP_Price_Input}
    Run Keyword If                        ${hasprice}
    ...                                   Input Text                                                ${SP_Price_Input}
    ...                                   55555555
    ${hasName}                            Run Keyword And Return Status
    ...                                   Page Should Contain Element                               ${SP_Nickname_Input}
    Run Keyword If                        ${hasName}
    ...                                   Input Text                                                ${SP_Nickname_Input}
    ...                                   پروفایل تستی
    Click Element                         id=com.sheypoor.mobile.debug:id/formSubmitButton

Handle NoImage PopUP
    Run Keyword And Ignore Error          Wait Until Page Contains            ثبت آگهی بدون عکس     timeout=3s
    Run Keyword And Ignore Error          Click The Link                      ثبت آگهی بدون عکس

Trumpet adv
    [Arguments]                         ${Kind}    ${listingId}
    Wait Until Keyword Returns True    3x    2s     Mock Listing Moderate    ${Kind}     ${listingId}
#    ${result}                Mock Listing Moderate    ${Kind}    ${listingId}
#    Log to console           ${listingId} ${Kind} == ${result}

Wait Until Keyword Returns True
    [Arguments]                                     ${timeout}    ${retry_interval}    ${name}    @{args}
    Wait Until Keyword Succeeds                     ${timeout}    ${retry_interval}    Keyword Should Return True    ${name}    @{args}

Keyword Should Return True
    [Arguments]                                      ${name}    @{args}
    ${ret_val}                                       Run Keyword    ${name}    @{args}
    Should Be Equal                                  ${ret_val}    ${True}

Check Aproved Listing
   Wait Until Page Contains Element                  ${OFFER_STATUS}      timeout=5
   Wait Until Page Contains                          ${APPROVED_MESSAGE}

Delete Listing
    Click Toolbar Account
    Click Toolbar Items                             ${MYACCOUNT}
    Check Aproved Listing
    Wait Until Page Contains Element                ${OFFER_DELETE}
    Click The Link                                  ${DELETE_LISTING_BTN_TXT}
    Select Reason To Delete Listing
    Click Element                                   ${DELETE_LISTING_BTN}
    Wait Until Page Does Not Contain Element        ${ADAPTER_MY_ADV}
#    TODO: next 2 lines are irrational but product team think noncritical
    Check Text By Swipe In Loop                     ${NO_LISTING_MSG_1}
    Check Text By Swipe In Loop                     ${NO_LISTING_MSG_2}
    Click Element                                   accessibility_id=غیر فعال
    Check Text In Element By Swipe In Loop          ${OFFER_STATUS}                     ${DELETED_ADV_MESSAGE}
#    TODO:  uncomment below lines after fix bug in INACTIVE page
#    Page Should Not Contain Text              شما تا کنون آگهی ثبت نکرده اید
#    Page Should Not Contain Text              همین الان اولین آگهی خود را ثبت نمایید

Select Reason To Delete Listing
    [Arguments]                          ${reason}=مشتری پیدا نشد
    Click The Link                       ${reason}         # the reason for deleting
    Sleep     500ms

Click First Title And Validate It On The Listing Details Page
    [Arguments]                                   ${ad_title}
    Run Keyword Unless                            ${status_btn_submit}             Swipe Down                                       ${2}
    Click Element                                 ${ad_title}
    ${ld_status}                                  Run Keyword And Return Status    Validate That Is On The Listing Details Page    ${FirstTitle}
    Run Keyword Unless                            ${ld_status}                     Fail                                            Listing details page of advertisment first is not visible.

Validate That Is On The Listing Details Page
    [Arguments]                                   ${ad_title}
    Check Listing Details Page Is Loaded
    Element Should Contain Text                   id=${LISTING_DETAILS_TITLE}      ${ad_title}

Check Listing Details Page Is Loaded
    Wait Until Page Contains Element              ${AD_DETAILS_PAGE}               timeout=10s
    Wait Until Page Does Not Contain Element      ${AD_DETAILS_LOADING}            timeout=10s

Go To Post Listing Page
    Wait Until Page Contains Element              ${New_Listing}                   timeout=10s
    Click Element                                 ${New_Listing}
    Wait Until Page Contains Element              ${offer_name}                    timeout=15s
    ...    error=can not load post listing

Close LeadS And View Slide
    ${LeadsAndView}                     Run Keyword And Return Status    Wait Until Page Contains Element    ${LeadsAndViewsHeaderDown}   timeout=5s
    Run Keyword If                      ${LeadsAndView}                  click element                       ${LeadsAndViewsHeaderDown}

Is Next Listing Loaded
    [Arguments]                         ${INDEX}
    FOR    ${i}    IN RANGE    1    8
       Swipe Element Horizontally       ${OfferID}
       Sleep     500ms
       ${ListingTitle}                  Get Text    ${OfferID}
       Set Test Variable                ${Nav${INDEX}}    ${ListingTitle}
       ${status}                        Run Keyword And Return Status    Should Not Be Equal  ${Nav${INDEX-1}}  ${Nav${INDEX}}
       Exit For Loop If                 ${status}
    END
    Run Keyword Unless                 ${status}           Fail    Listing details failed on swipe ${INDEX}

Clear Listing Form
    Click Element                                 ${CLEAR_FORM}
    ${Locator}                                    Set Variable      android=UiScrollable(UiSelector().scrollable(true).instance(0)).scrollIntoView(new UiSelector().description("دسته بندی"))
    ${Cat_Value}                                  Get Text          ${Locator}
    Should Be Empty                               ${Cat_Value}

########################################      Serp Page         #######################################################
Check Listing Title In Serp
    [Arguments]                                  ${Listing_ID}    ${Listing_Title}    ${Category}      ${SubCategory}
    ...                                          ${State}         ${City}             ${Region}
    Add Filter To Serp                           ${Listing_Title}        ${Category}      ${SubCategory}        ${State}         ${City}          ${Region}
    Advance Search Listing Title In Serp         ${Listing_Title}
    Element Should Contain Text                  android=UiScrollable(UiSelector().scrollable(true).instance(0)).scrollIntoView(new UiSelector().description("listing_${Listing_ID}").childSelector(new UiSelector().resourceId("${OfferInSerpID}")))     ${Listing_Title}
    ${loc}    	                                 Set Variable If	          '${Region}' == '${EMPTY}'	     ${City}	     ${City}،${SPACE}${Region}
    Element Should Contain Text                  android=UiScrollable(UiSelector().scrollable(true).instance(0)).scrollIntoView(new UiSelector().description("listing_${Listing_ID}").childSelector(new UiSelector().resourceId("${SERP_LISTING_LOCATION}")))    ${loc}

Add Filter To Serp
    [Arguments]                              ${Listing_Title}       ${Category}      ${SubCategory}       ${State}         ${City}          ${Region}=${EMPTY}
    Wait Until Page Contains Element         id=${OfferInSerpID}
    ${Filter_Btn_Id}                         Select Filter Button Based On Name Of BTN
    Swipe Down                               ${2}
    Sleep                                    2s
    Click The Link                           جستجو
    Input Text                               ${SEARCH_BAR}          ${Listing_Title}
    Sleep              2s
#    Press Keycode                            84              # Search Key on keyboard
    Click Element                            ${Filter_Btn_Id}          # we need to call this keyword just for close pop up search result
    Sleep              1s
    Wait Until Page Does Not Contain Element          ${FILTER_SORTS_TITLE}   timeout=2s
    Sleep              1s                   # Just for show the search result
    ${Filter_Btn_Id}                         Select Filter Button Based On Name Of BTN
    Click Element                            ${Filter_Btn_Id}
    Wait Until Page Contains Element         ${FILTER_SORTS_TITLE}   timeout=10s
    Select Category And SubCategory          ${Category}             ${SubCategory}
    Select Location In Filter                ${State}                ${City}          ${Region}
    Click Element                            ${FITLER_BTN}
    Wait Until Page Contains Element         ${REGION_HEADER}
    Element Should Contain Text              ${REGION_HEADER}        ${City}


Select Filter Button Based On Name Of BTN
#    TODO:   Add filter button id based on other category type
    ${Has_serpFilter}                       Run Keyword And Return Status               Page Should Contain Element     ${SERP_FILTER_BUTTON}         #serpFilter
    ${Has_FragmentSerpFilter}               Run Keyword And Return Status               Page Should Contain Element     ${FILTER_HEADER}         #fragmentSerpFilterRoot
    Run Keyword If                          ${Has_serpFilter}              Set Test Variable          ${Filter_Id}      ${SERP_FILTER_BUTTON}         #serpFilter
    ...    ELSE IF                          ${Has_FragmentSerpFilter}      Set Test Variable          ${Filter_Id}      ${FILTER_HEADER}         #fragmentSerpFilterRoot
    ...    ELSE                             Fail                          filter button id is changed
    [Return]                                ${Filter_Id}

Select Location In Filter
    [Arguments]                             ${State}         ${City}          ${Region}=${EMPTY}
    Click Element                           android=UiScrollable(UiSelector().scrollable(true).instance(0)).scrollIntoView(new UiSelector().resourceId("${FITLER_LOCATION_SPINNER}"))
    Scroll The List                         استان${SPACE}${State}
    Scroll The List                         ${City}
    Run Keyword Unless                     '${Region}' == '${EMPTY}'        Select Location Of Region In Filter       ${Region}

Select Location Of Region In Filter
    [Arguments]                                ${Region}
    Scroll The List                            محله
    Wait Until Page Contains Element           android=UiSelector().resourceId("${FITLER_LOCATION_REGION_SELECT_BTN}").text("انتخاب همه محله‌ها")
    Scroll The List                            ${Region}
    Page Should Contain Element                android=UiSelector().resourceId("${FITLER_LOCATION_REGION_SELECT_BTN}").text("انتخاب 1 محله")
    Click Element                              ${FITLER_LOCATION_REGION_SELECT_BTN}
    # Wait Until Page Contains Element        android=UiSelector().resourceId("${FITLER_LOCATION_REGION}").childSelector(new UiSelector().resourceId("${FITLER_LOCATION_REGION_TEXT}").text("${Region}"))
    Wait Until Page Does Not Contain Element    id=${APP_PACKAGE}:id/districtSelectList     timeout=10s
    # Element Should Contain Text             ${FITLER_LOCATION_REGION}        ${Region}

Advance Search Listing Title In Serp
    [Arguments]                        ${Listing_Title}
    Wait Until Page Contains Element   id=${OfferInSerpID}
    FOR   ${index1}   IN RANGE         10
        ${Status_Current_Serp}         Search In Current Page Of Serp        ${Listing_Title}
        Exit For Loop If               ${Status_Current_Serp}
        swipe by percent               90   85   90   10   1500
    END
    Run Keyword Unless    ${Status_Current_Serp}    Fail    Can not find listing by search Until 30th listing in Serp

Search In Current Page Of Serp
    [Arguments]                     ${Listing_Title}
    @{elements}                     Get Webelements                  id=${OfferInSerpID}
    ${Length}                       Get Length                       ${elements}
    FOR  ${INDEX}  IN RANGE  ${Length}
        ${Title}                    Get Text                         ${elements}[${INDEX}]
        ${Status}                   Run Keyword And Return Status    Should Be True  '${Listing_Title}' == '${Title}'
        Return From Keyword If      ${Status}                        ${Status}
    END
    [Return]                        ${Status}

Click Listing In Serp
    [Arguments]             ${Listing_ID}           ${Listing_title}
    Click Element           android=UiSelector().description("listing_${Listing_ID}").childSelector(new UiSelector().resourceId("${OfferInSerpID}").text("${Listing_title}"))

#Check Listing Title In Serp                    #DeprecatedKeyword
#Get Listing Title In Serp by loop              #DeprecatedKeyword

########################################      Insert Photo          #######################################################
Insert Photos
    [Arguments]                               ${Number_of_Photos}=${1}
    Run Keyword If                            ${Number_of_Photos} > ${8}        Fail                The number of images which are requested is more than 8.
    Set Test Variable                         ${Number_of_Photos}
    Insert Photos To Device
    Select Photos From Gallery

Insert Photos To Device
    [Documentation]                           Insert photos from listing and if needed from directory to device.
    ${Len_Listings_images}                    Get Length                                      ${Listings_images}
    FOR     ${INDEX}    IN RANGE              ${Number_of_Photos}
        IF                                    ${INDEX+1} <= ${Len_Listings_images}
            Push File To Device From URL      /mnt/sdcard/Pictures/test${INDEX+1}.jpg         source_url=${Listings_images[${INDEX}]}
        ELSE
            Push File To Device               /mnt/sdcard/Pictures/test${INDEX+1}.jpg         source_path=${CURDIR}${/}Images/image${INDEX+1}.jpg
        END
        adb shell                             am broadcast -a android.intent.action.MEDIA_SCANNER_SCAN_FILE -d file:///mnt/sdcard/Pictures/test${INDEX+1}.jpg        # Is there this photo in Android Gallery?
    END

Select Photos From Gallery
    Select From Gallery
    Wait Until Page Contains Element          ${IMAGE_CHECKBOX}
    ${Photos}                                 Get Webelements                                ${IMAGE_CHECKBOX}
    ${Existing}                               Get Length                                     ${Photos}
    Run Keyword If                           '${Existing}' < '${Number_of_Photos}'
    ...                                       Fail                                           The number of photos in gallery is less than number of photos inserted to device.
    FOR    ${INDEX}  IN RANGE                 ${Number_of_Photos}
        Click Element                         ${Photos}[${INDEX}]
        Wait Until Page Contains              انتخاب ${INDEX+1} از 8 عکس
    END
    Click Confirm Images In Gallery
    Wait Until Page Does Not Contain          ${NO_IMAGE_FOR_LISTING_MSG}                    timeout=10s
    Wait Until Page Does Not Contain Element  ${LOADED_LISTING_IMAGE_PROGRESS}               timeout=30s
    Page Should Contain Element               ${LOADED_LISTING_IMAGE}
    Page Should Contain Text                  تصویر اصلی

Click Confirm Images In Gallery
    Wait Until Keyword Succeeds               5x   1s      Click Element                     ${PHONE_GALLEY_ADD_IMAGE_BTN}

Remove Inserted Photo From Device
    Return From Keyword If                    ${Number_of_Photos} == ${0}                    There is no image to delete from device
    FOR     ${INDEX}    IN RANGE              ${Number_of_Photos}
        Remove Photo From Device              test${INDEX+1}.jpg
    END
    Log                                       Photos are deleted from gallery.

Remove Photo From Device
    [Arguments]                             ${Photo_name}=test1.jpg
    adb shell                               rm -f /mnt/sdcard/Pictures/${Photo_name}
    adb shell                               am broadcast -a android.intent.action.MEDIA_SCANNER_SCAN_FILE -d file:///mnt/sdcard/Pictures/${Photo_name}
    adb shell                               ls /mnt/sdcard/Pictures/

Close test application For Insert Photos
    Run Keyword And Ignore Error            Remove Inserted Photo From Device
    Run Keyword And Ignore Error            Finish Teardown Tasks

Select From Gallery
    Click Element                           id=${Photos_Upload}
    Click The Link                          انتخاب از گالری
    ${Status}                               Run Keyword And Return Status          Wait Until Page Contains Element          ${IMG_HOLDER}             timeout=10      # there is at least one picture in Gallery
    Run Keyword If                          not ${Status}                          Handle Gallery Menu        ## ?????

Handle Gallery Menu
    #TODO:  This Function is never called unless no photo is uploaded to the gallery. But it will never be passed, because there is no download link
    ${Status}                               Run Keyword And Return Status             Wait Until Page Contains Element     ${OPEN_OS_FILES}           timeout=5
    Run Keyword If                          ${Status}                                 Click Element                        ${OPEN_OS_FILES}
    Click The Link                          Pictures
    Wait Until Page Contains Element        ${IMG_HOLDER}                        timeout=15s

########################################      Payment          #######################################################

#Get ListingID from Listing Detail And Accept                   #DeprecatedKeyword
#Click Back Button To Find Listings                             #DeprecatedKeyword
#Check Listing Status In My Listing                             #DeprecatedKeyword

########################################      Search & Filter          ###############################################

Filter Category For General Category
    [Arguments]                          ${Category}                ${SubCategory}
    Filter Category                      ${Category}                ${SubCategory}
#    Wait Until Page Contains Element            ${CATEGORY_TOP_FILTER}         timeout=5s
#    Element Should Contain Text                 ${CATEGORY_TOP_FILTER}       ${SubCategory}

Filter Category For Not General Category
    [Arguments]                          ${Category}                ${SubCategory}
    Filter Category                      ${Category}                ${SubCategory}
    Wait Until Page Contains Element     ${CATEGORY_HEADER}         timeout=5s
    Element Should Contain Text          ${CATEGORY_HEADER}         ${SubCategory}

Filter Category For Car OR Home Category
    [Arguments]                          ${Category}                ${SubCategory}
    Filter Category                      ${Category}                ${SubCategory}
    Page Should Not Contain Element      ${CATEGORY_HEADER}
    Page Should Not Contain Element      ${CATEGORY_TOP_FILTER}

########################################        Setup Test              ################################################
Check Min Accepted Version Is
    [Arguments]                          ${Min_Version_App}
    Pass Execution If                    '${file_version}' < '${Min_Version_App}'        This scenario does not implemented for ${file_version} app version

Convert Number To Price
    [Arguments]                          ${Price}            ${seperator_char}=٬
    ${separator_price}                   Evaluate            f'{${Price}:,}'
    ${separator_price}                   Convert Digits      ${separator_price}   En2Fa
    ${separator_price}                   Evaluate            "${separator_price}".replace(",","${seperator_char}")
    [Return]                             ${separator_price}

########################################        Rating              ################################################
Confirm That Rating Toggle Is Enabled
    Run Keyword Unless                  ${Toggle_user-insert-rating}                    Enable User Insert Rating

Enable User Insert Rating
    Mock Toggle Set                     android      user-insert-rating                 ${1}

Validate That Is On The Rating Page
    Wait Until Page Contains Element    ${PAGE_TITLE_TEXT.format("امتیازدهی")}         timeout=10s

Rate And Comment To The Seller
    Select Main Rate To Seller
    Select Detailed Rates To Seller
    Input Rating Comment
    Submit Rate

Select Main Rate To Seller
    Click Element                       ${MAIN_RATING_STARS}

Select Detailed Rates To Seller
    Wait Until Page Contains Element    ${DETAILED_RATING_STARS}                timeout=5s
    ${detailed_rates}                   Get Webelements                         ${DETAILED_RATING_STARS}
    FOR   ${i}   IN RANGE   3
        Click Element                   ${detailed_rates}[${i}]
    END

Input Rating Comment
    Input Text                          ${RATING_COMMENT_INPUT}                 تست امتیازدهی به فروشنده

Submit Rate
    Click Element                      ${SUBMIT_RATE_BTN}
    Wait Until Page Contains           ${message_of_successfully_rating}        timeout=5s

########################################        NPS              ################################################
Close NPS Popup
    Wait Until Page Contains Element    id=${NPS_POPUP}                         timeout=10s
    Click Back Button

########################################     Contact Support     ################################################
Go To Contact Support Page
    Click Toolbar Account
    Click Toolbar Items                   ${CONTACT_SUPPORT}
    Wait Until Page Contains              کمک نیاز دارید؟                           timeout=20s
    Click The Link                        ارسال پیام
    Wait Until Page Contains Element      ${PAGE_TITLE_TEXT.format("ارسال پیام")}   timeout=20s

##############################################  serp filter ############################################################
Filter By Cat And Search By Listing Title
    [Arguments]                                      ${category}=${cat}                 ${subCategory}=${subCat}            ${ad_title}=${Listings_title}
    Filter Category For Not General Category         ${category}                        ${subCategory}
    Search By Listing Title                          ${ad_title}

Go To Desired Listing Details Page
    [Arguments]                                      ${ad_id}=${listingId}              ${ad_title}=${Listings_title}
    ${created_listing}                               Set Variable                       accessibility_id=listing_${ad_id}
    Wait Until Page Contains Element                 ${created_listing}                 timeout=10s
    Click Element                                    ${created_listing}
    Validate That Is On The Listing Details Page     ${ad_title}

Search By Listing Title
    [Arguments]                                      ${ad_title}
    Open Search Page On Serp
    Input The Listing Title And Search               ${ad_title}
    Validate Listing Title Search                    ${ad_title}

Open Search Page On Serp
    Click Element                                    ${SEARCH_ROOT_HINT}
    Wait Until Page Contains Element                 ${SEARCH_BAR}

Input The Listing Title And Search
    [Arguments]                                      ${search_words}
    Input Text                                       ${SEARCH_BAR}                      ${search_words}
    Click Element                                    ${APPLY_BUTTON}

Validate Listing Title Search
    [Arguments]                                      ${search_words}
    ${search_root_value}                             Set Variable                       android=UiSelector().resourceId("${SEARCH_ROOT_HINT}").text("${search_words}")
    Wait Until Page Contains Element                 ${search_root_value}               timeout=5s

Back To Sheypoor App
    [Arguments]                                      ${Number_of_back}=5
    FOR       ${i}        IN RANGE                   ${Number_of_back}
      Click Back Button
      ${app_activity}                                Get Activity
      ${pass}                                        Run Keyword And Return Status      Should Contain
      ...                                            ${app_activity}                    com.sheypoor
      Exit For Loop If                               ${pass}
    END
    Run Keyword Unless                               ${pass}                            Fail                    Could not back to sheypoor app.
