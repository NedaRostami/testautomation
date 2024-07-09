*** Settings ***
Library          FakerLibrary       locale=fa_IR

*** Variables ***

*** Keywords ***
Get ListingID from Listing Detail And Accept
  Click Text                              ${Title_Words}
  Wait Until Page Contains element        id=${APP_PACKAGE}:id/adapterAdDetailsDelete       timeout=10s
  Find Text By Swipe in loop              شناسه آگهی:
  ${AdverID}                              Get Text                                          id=${APP_PACKAGE}:id/adapterAdDetailsAdId
  # ${AdverID}                              Strip String                                      ${AdverID}
  # ${AdverID}                              Fetch From Right                                  ${AdverID}     شناسه آگهی:
  # ${AdverID}                              Strip String                                      ${AdverID}
  # Set Test Variable                       ${listingId}                                      ${AdverID}
  ${AdverID}                                Get Regexp Matches                                ${AdverID}        \\d{9}
  Set Test Variable                         ${listingId}                                      ${AdverID}[0]
  Trumpet adv                               accept                                            ${listingId}
  Click Back Button To Find Listings
  Check Listing Status In My Listing       ${APPROVED_MESSAGE}

Click Back Button To Find Listings
  FOR    ${INDEX}    IN RANGE    1    5
    Click Back Button
    ${Status}=    Run Keyword And Return Status    Wait Until Page Contains           ${Title_Words}        timeout=3s
    Exit For Loop If            ${Status}
  END

Check Listing Status In My Listing
    [Arguments]                                        ${Listing_State}
    FOR   ${index}   IN RANGE   0    5
       Wait Until Page Contains Element                id=${MY_LISTING_ITEM}
       Page Should Contain Text                        ${Title_Words}
       swipe Down    ${5}
       ${status}      Run Keyword And Return Status    Element Should Contain Text        ${OFFER_STATUS}              ${Listing_State}
       Exit For Loop If    ${status}
       Sleep     1s
    END
    Run Keyword If    not ${status}     Fail    Listing State can not be refreshed

Get ListingID With Paid Feature
     Sleep    3s
     Wait Until Page Contains Element        id=${APP_PACKAGE}:id/fragmentPaidFeaturesInfoTitle     timeout=15
     ${AdverID}                              Get Text                                          id=${APP_PACKAGE}:id/fragmentPaidFeaturesInfoTitle
     ${AdverID}                              Get Regexp Matches                                ${AdverID}        \\d{9}
     Set Test Variable                       ${listingId}                                      ${AdverID}[0]
     # Should Match Regexp	                   ${listingId}	                                     \\d{9}
     # Should Match Regexp	                   ${listingId}	                                     ^[0-9]*$
     # Should Match Regexp	                   ${listingId}	                                     ^[۰۱۲۳۴۵۶۷۸۹]+$
     Trumpet adv                             accept                                            ${listingId}
     Sleep                                   5s
     Click The Link                          فعلاً نه
     Wait Until Page Contains                آگهی‌های من                                         timeout=10s
     Find Text By Swipe in loop              ${Title_Words}


Get ListingID Without Paid Feature
     Sleep    3s
     Wait Until Page Contains Element        id=${APP_PACKAGE}:id/dialogOfferSubmitSuccessTvMessage    timeout=15
     ${text}              Get Text           id=${APP_PACKAGE}:id/dialogOfferSubmitSuccessTvMessage
     ${stripped} =        Strip String       ${text}
     ${tmp2AdID} =        Fetch From Right   ${stripped}     آگهی شما با کد
     ${tmpAdID} =         Fetch From Left    ${tmp2AdID}     پس از بررسی توسط تیم نظارت شیپور، تایید شده و نمایش آن در شیپور به شما اطلاع داده خواهد شد.
     ${AdverID} =         Strip String       ${tmpAdID}
     Set Test Variable    ${listingId}       ${AdverID}
     Trumpet adv          accept             ${listingId}
     Sleep     5s
     Click The Link       مشاهده آگهی

Open LeadS And View Slide
    ${LeadsAndView}                       Run Keyword And Return Status    Wait Until Page Contains Element    ${adapterLeadsAndViewsHeaderUp}   timeout=5s
    Run Keyword If                        ${LeadsAndView}                  click element                       ${adapterLeadsAndViewsHeaderUp}

Input Neighbourhood
    [Arguments]                   ${Texts}
    Input Edit Text               ${neighbourhood}     ${Texts}

Input price
    [Arguments]                   ${Label}      ${Price}
    Swipe Up                      ${1}
    ${Locator}                    Set Variable         android=UiScrollable(UiSelector().scrollable(true).instance(0)).scrollIntoView(new UiSelector().text("${Label}").instance(0))
    Scroll Next                   ${Locator}
    Set Test Variable             ${Selector}        android=UiSelector().text("${Label}").childSelector(new UiSelector().className("${EDIT_TEXT}"))
    Click Element                 ${Selector}
    Input Text                    ${Selector}        ${Price}

Description Faker
    ${Faker_Description}    FakerLibrary.Sentence	nb_words=6  variable_nb_words=False
    ${Words}             	  Fetch From left         ${Faker_Description}  .
    ${Words}              	Fetch From right        ${Words}  .
    ${Words}                Strip String            ${Words}
    ${Words}                Convert Digits    ${Words}   Fa2EN
    Set Test Variable       ${Title_Description}    ${Words}

Title Faker
    ${Faker_Words}       FakerLibrary.Sentence	nb_words=5  variable_nb_words=False
    ${Words}             Fetch From left        ${Faker_Words}  .
    ${Words}             Fetch From right       ${Words}  .
    ${Words}             Strip String           ${Words}
    ${Words}             Convert Digits    ${Words}   Fa2EN
    Set Test Variable    ${Title_Words}         ${Words}

Register By New Email B
    Email Generator B
    Mobile Generator A
    Input Edit Text     ${Mail_Number}       ${Random_User_Email_A}
    Click Login Register Button
    Input Edit Text     ${second_number}     ${Random_User_Mobile_A}
    Click The Link      ثبت‌نام
    Input SMS Code       ${Random_User_Mobile_A}
    Click The Link       تایید نهایی
    Close Welcome Screen

Register By New Email
    Email Generator A
    Mobile Generator A
    Input Edit Text     ${Mail_Number}       ${Random_User_Email_A}
    Press Keycode    66
    Click Login Register Button
    Input Edit Text     ${second_number}     ${Random_User_Mobile_A}
    Click The Link      ثبت‌نام
    Input SMS Code       ${Random_User_Mobile_A}
    Click Confirm SMS
    Close Welcome Screen

Login By Email
    [Arguments]    ${Mobile}   ${Email}
    Input Edit Text     ${Mail_Number}       ${Email}
    Click Login Register Button
    Input SMS Code      ${Mobile}
    Click Confirm SMS
    Close Welcome Screen

Login By Secret MOBILE
    [Arguments]    ${Mobile}
    ${Status}=   Run Keyword And Return Status    Wait Until Page Contains Element       ${Mail_Number}   timeout=5
    Run Keyword unless    ${Status}    Click Toolbar Items    ${MYACCOUNT}
    Run Keyword unless    ${Status}    Wait Until Page Contains Element       ${Mail_Number}   timeout=5
    Input Edit Text    ${Mail_Number}      ${Mobile}
    Run Keyword And Ignore Error    Hide Keyboard
    Click Login Register Button
    Wait Until Page Contains Element       ${Confirm_Digit}
    Tap              ${Confirm_Digit}
    Insert Code      1234
    Run Keyword And Ignore Error    Hide Keyboard
    Click Confirm SMS
    Close Welcome Screen

Close Welcome Screen
    Wait Until Page Contains     به شیپور خوش آمدید    timeout=5
    Page Should Contain Text     ورود به حساب کاربری با موفقیت انجام شد
    Click The Link               متوجه شدم

Check My Listing
    FOR   ${index}             IN RANGE   0  5
       ${status}               Run Keyword And Return Status    Page Should Contain Element     accessibility_id=main menu
       Exit For Loop If        ${status}
       Sleep     400ms
    END
    Run Keyword Unless         ${status}      Fail    main menu is not shown
    Click Toolbar Account

Find Text By Swipe UP in loop
    [Arguments]             ${Text}
    FOR    ${INDEX}    IN RANGE    1    10
       ${Status}           Run Keyword And Return Status   Page Should Contain Text     ${Text}
       Exit For Loop If    ${status}
       Run Keyword If      not ${Status}    swipe by percent     90   40  90   70   150
    END
    Run Keyword If         not ${Status}    Fail    can not find ${Text} in page

Get Locator Of Attribute
    [Arguments]    ${text}
    Set Test Variable    ${AttrLoc}       android=UiSelector().text("${text}").childSelector(new UiSelector().className("${EDIT_TEXT}"))
    [Return]             ${AttrLoc}

Scroll Spinner Up
    [Arguments]        ${text}
    ${Elem} =          Get Locator Of Spinner    ${text}
    Find Element By Swipe in loop      ${Elem}

Get Locator Of Spinner
    [Arguments]    ${text}
    Set Test Variable    ${SpinLoc}       android=UiSelector().className("android.widget.Spinner").childSelector(new UiSelector().text("${text}"))
    [Return]             ${SpinLoc}

Get toolbar icon Coordinates
    ${Locator}     Set Variable    android=UiSelector().resourceId("${TOOLBAR}").childSelector(new UiSelector().className("android.widget.ImageButton"))
    ${Location}   Get Element Location   ${Locator}
    ${top}      	Get From Dictionary	   ${Location}	 y
    ${top}        Convert To Integer     ${top}
    ${top}        set variable   ${top+20}
    ${left}     	Get From Dictionary	   ${Location}	 x
    ${left}       Convert To Integer     ${left}
    ${left}       set variable   ${left+20}
    Set Test Variable    ${x1}   ${left}
    Set Test Variable    ${y1}   ${top}

Get a Random Image
   ${Image_List}                select images              ${Category}         ${PIC_NO}      ${Listings_ListingID}
   ${Image}                     Set Variable                ${Image_List[0]}
   Set Test Variable            ${Image}                    ${image.base64}

Select Auto Location                #DeprecatedKeyword
    Click Spinner               موقعیت مکانی
    Scroll The List             مکان یابی خودکار
    wait until page contains    فلسطین     timeout=5

Email Generator A
    ${Random_String} =  Generate Random String  6  [LOWER]
    Set Suite Variable          ${Random_User_Email_A}    QAA-${Random_String}-test@qaqa.com

Check Listing Title In Serp
    FOR   ${index}   IN RANGE   0    10
       Wait Until Page Contains Element   id=${OfferInSerpID}
       swipe Down    ${2}
       Get Listing Title In Serp by loop
       ${status}      Run Keyword And Return Status    Should Contain      ${SerpTitles}          ${Title_Words}
       Exit For Loop If    ${status}
       Sleep     1s
    END
    Run Keyword If    not ${status}     Fail    Listing is not shown in serp

Get Listing Title In Serp by loop
    @{Titles}=    Create List
    @{elements}    Get Webelements     id=${OfferInSerpID}
    ${Length}      Get Length    ${elements}
    FOR   ${INDEX}    IN RANGE    1    ${Length+1}
       ${Title}     Get Text    ${elements}[${INDEX-1}]
       Append To List   ${Titles}   ${Title}
    END
    Set Test Variable       ${SerpTitles}    ${Titles}
