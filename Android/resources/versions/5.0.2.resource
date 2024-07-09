*** Settings ***

*** Variables ***

*** Keywords ***
Filter Location
  Scroll The List              موقعیت مکانی
  Scroll The List              استان تهران
  Scroll The List              تهران
  Scroll The List              محله
  Scroll The List              آجودانیه
  Click The Link               انتخاب 1 محله
  Sleep                        2s

Filter Location From Header
  Click Element                               ${REGION_HEADER}
  Scroll The List                             استان تهران
  Scroll The List                             تهران
  Validate Selected City                      تهران
  swipe by percent                            10    15   70    15   1000
  Click Text                                  محله
  Scroll The List                             آجودانیه
  Scroll The List                             آذری
  Scroll The List                             اختیاریه
  Click The Link                              انتخاب 3 محله

Validate Selected City
  [Arguments]                                 ${city_name}
  # page changes, therefore the "Element Text Should Be" keyboard is not used
  ${filtered_city_tab}                        Set Variable                                 android=UiSelector().resourceId("${SERP_TAB_LAYOUT_TEXT}").text("آگهی های ${city_name}")
  Wait Until Page Contains Element            ${filtered_city_tab}                         timeout=10s
  Element Text Should Be                      ${REGION_HEADER}                             ${city_name}

Get AdID And Accept Listing
    [Arguments]                  ${Ad_Status}='new'

    Run Keyword If         ${Toggle_paid-features} == ${FALSE} or ${Toggle_paid-features-bumps} == ${FALSE}          Fail              Paid feature or/and bumps toggles are turned off.
    ...   ELSE IF          ${Toggle_paid-features} == ${TRUE} and ${Toggle_paid-features-bumps} == ${TRUE} and ${Toggle_post-moderation} == ${TRUE} and ${Ad_Status} == 'new'      Set Test Variable     ${PostListingMessage}         ${listing_actived_approved_paid_feature_title}
    ...   ELSE IF          ${Toggle_paid-features} == ${TRUE} and ${Toggle_paid-features-bumps} == ${TRUE} and ${Toggle_post-moderation} == ${FALSE}       Set Test Variable     ${PostListingMessage}         ${post_listing_paid_message_without_approved}
    ...   ELSE IF          ${Ad_Status} == 'edit'             Set Test Variable          ${PostListingMessage}           ${post_listing_paid_message_without_approved}

    Refresh Page To Get fragment Paid Features Info Title
    ${ToltalSubmitMessage}                  Get Text                                               id=${APP_PACKAGE}:id/fragmentPaidFeaturesInfoTitle
    ${AdverID}                              Get Regexp Matches                                     ${ToltalSubmitMessage}        \\d{9}
    Set Test Variable                       ${listingId}                                           ${AdverID}[0]
    ${SubmitMessage}                        Get Regexp Matches                                     ${ToltalSubmitMessage}        ^.*?(?=\n)
    ${SubmitMessage}                        Set Variable                                           ${SubmitMessage}[0]
    ${listing_is_blacklist}                 Post Moderation validation
    #TODO  hotfix
    Set Test Variable                       ${PostListingMessage}                                   ${SubmitMessage}
    Run Keyword If                          ${listing_is_blacklist}                                 Should Be Equal As Strings              ${SubmitMessage}            ${post_listing_paid_message_without_approved}
    ...   ELSE                              Should Be Equal As Strings                              ${SubmitMessage}                        ${PostListingMessage}

Check Listing Status in My Listings Page By Click NOTNOW Button
    Click The Link                          فعلاً نه
    Wait Until Page Contains                آگهی‌های من                                             timeout=10s
    Find Text By Swipe in loop              ${Title_Words}
    Check Text In Element By Swipe In Loop  ${OFFER_STATUS}                                        ${APPROVED_MESSAGE}

Refresh Page To Get fragment Paid Features Info Title
    Handle Secure Purchase
    FOR  ${INDEX}                           IN RANGE    0   5
      ${InPaidPage}                         Run Keyword And Return Status    Wait Until Page Contains Element     id=${APP_PACKAGE}:id/fragmentPaidFeaturesInfoTitle   timeout=5s
      Exit For Loop If                      ${InPaidPage}
      Swipe Down                            ${2}
    END
    Run Keyword If                          not ${InPaidPage}         Fail    Can Not Validate In Paid Feature Page

Click Toolbar Account
   FOR  ${INDEX}     IN RANGE    0   5
        ${main_menu_in_view}     Run Keyword And Return Status    Page Should Contain Element    ${MAIN_MENU}
        Run Keyword If           not ${main_menu_in_view}         Click Back Button
        Run Keyword If           not ${main_menu_in_view}         Sleep     1s
        Continue For Loop If     not ${main_menu_in_view}
        click element            ${MAIN_MENU}
        ${mylisting_opened}      Run Keyword And Return Status    Wait Until Page Contains         ${MYACCOUNT}        timeout=10
        Exit For Loop If         ${mylisting_opened}
   END
   Run Keyword If                not ${mylisting_opened}          Fail    can not open drawer menu

Check Sheypoor Rules Page
    Click Toolbar Account
    Click Toolbar Items               ${MYACCOUNT}
    Login By Mobile
    click element                     ${PROFILE_SETTING}
    Find Text By swipe                قوانین و دستورالعمل‌ها
    click the link                    قوانین و دستورالعمل‌ها
    Wait Until Page Contains          توافق نامه کاربری    timeout=10

Validate First Initial Serp
  [Arguments]                             ${Region}=تهران
  Handle Location PopUp
  Wait Until Page Contains Element        ${REGION_HEADER}                    timeout=10s
  ${def}                                  Run Keyword And Return Status       Element Should Contain Text           ${REGION_HEADER}     ${Region}
  Run Keyword If                          not ${def}                          Element Should Contain Text           ${REGION_HEADER}     همه ایران
  FOR  ${INDEX}                           IN RANGE    0   3
    ${RootIsLoaded}                       Run Keyword And Return Status       Wait Until Page Contains Element      ${CAT_ROOT}          timeout=10s
    Exit For Loop If                      ${RootIsLoaded}
    Swipe Down                            ${2}
  END
  Run Keyword unless                      ${RootIsLoaded}                      Fail    app root content is not loaded
  Validate Home Activity

Handle Location PopUp
  ${status}         Run Keyword And Return Status    Wait Until Page Contains element     ${Location_Popup}      timeout=55s
  Run Keyword If      ${status}                      Click Back Button

Validate Home Activity
  Page Should Contain Element           ${CAT_ROOT}
  Page Should Contain Text              ${SERP_VALIDATOR}
  Page Should Not Contain Element       ${FILTER_HEADER}
  Page Should Not Contain Element       ${CATEGORY_HEADER}

Check Return Activity
    Check App is Ready                  ${HOME_ACTIVITY}

Fix Category bug
  [Arguments]                           ${Region}
  Click Toolbar Account
  Click Toolbar Items                   ${SERP_LINK}
  Wait Until Page Contains Element      ${New_Listing}       timeout=30
  Element Should Contain Text           ${REGION_HEADER}     همه ایران

Wait Until Element Contain Text Succeeds
  [Arguments]                  ${Locator}    ${text}
  Wait Until Keyword Succeeds    10    1    Element Should Contain Text    ${Locator}     ${text}
  swipe DOWN                   ${10}
  Wait Until Keyword Succeeds    10    1      Page Should Contain Text     ثبت رایگان آگهی

Filter Category
    [Arguments]                         ${Cat}                             ${SubCat}
    Check Cat List Is Visible           ${Cat}
    Filter Cat                          ${Cat}
    Filter SubCat                       ${SubCat}

Check Cat List Is Visible
    [Arguments]                          ${Category}
    FOR    ${i}    IN RANGE    1    6
    ${status}                            Run Keyword And Return Status     Page Should Contain Text           ${Category}
    Run Keyword Unless                   ${status}                         Swipe Down                         ${2}
    Exit For Loop If                     ${status}
    END

Filter Cat
    [Arguments]           ${Cat}
    FOR  ${i}   IN RANGE   3
      Run Keyword And Ignore Error                   Click The Link             ${Cat}
      ${status}     Run Keyword And Return Status    Wait Until Page Contains       همه دسته‌های ${Cat}     timeout=15s
      Exit For Loop If    ${status}
    END
    Run Keyword Unless    ${status}                 Fail    can not Filter Cat ${Cat}

Filter SubCat
    [Arguments]           ${SubCat}
    FOR  ${i}   IN RANGE   3
      Run Keyword And Ignore Error                   Scroll The List       ${SubCat}
      ${status}                                      Run Keyword And Return Status    Wait Until Page Contains Element   id=${OfferInSerpID}    timeout=15s
      Exit For Loop If                               ${status}
    END
    Run Keyword Unless                               ${status}                 Fail    can not Filter SubCat ${SubCat}

#Apply And Serp Should Contains
#  [Arguments]                             ${Validator}
#  Wait Until Page Contains                جستجو       timeout=10

Click Filter
  # click the link    فیلترها
  Wait Until Page Contains Element        ${SERP_FILTER_BUTTON}              timeout=30s
  click element                           ${SERP_FILTER_BUTTON}

Confirm Save Search Alert
  Wait Until Page Contains                آیا این جستجو ذخیره شود؟                 timeout=10s
  click element                           ${dialogButton}

Do Save Search
    Confirm Save Search Alert
    Sleep       1s
    Login By New Mobile
    Wait Until Page Contains Element      ${SAVE_SEARCH_ICON}  timeout=10s

Validate Real Estate Attributes
    Find Text By Swipe in loop            پارکینگ
    Find Text By Swipe in loop            انباری
    Find Text By Swipe in loop            آسانسور

Check Listing Title In My Listing Page
    Click The Link                        ${Title_Words}
    Wait Until Page Contains Element      ${myAdDetailTitle}   10s
    Wait Until Page Contains              وضعیت     timeout=15s
    ${Title}          Get Text            ${OfferID}
    Should Contain    ${Title}            ${Title_Words}

Check Leads and View
    Page Should Contain Text              تعداد تماس کل
    Page Should Contain Text              تعداد بازدید کل
    Find Text By Swipe in loop            آگهی شما در صفحه
    Find Text By Swipe in loop            افزایش بازدید
    Find Text By Swipe in loop            بازدید در ۲۴ ساعت اخیر

Succes Payment From Android App
  Click Element                             ${APPLY_BUTTON}
  Wait Until Page Contains                  WebView Browser Tester                      timeout=20s
  Click Text                                WebView Browser Tester
  Wait Until Page Contains                  پرداخت شما با موفقیت انجام شد               timeout=30s
  Wait Until Page Contains                  ${Price}               timeout=5s
  Get Source
  ${ReturnApp}                              Run Keyword And Return Status    Click Element                      ${ReturnAppDesc}
  Run Keyword If                            not ${ReturnApp}                 Click Element                      ${ReturnAppText}

##############################################  serp filter ############################################################
Open First Listing
    ${status_btn}                                   Run Keyword And Return Status        Page Should Contain Text       ثبت رایگان آگهی
    Run Keyword If                                  ${status_btn}                        Swipe Up                        ${2}
    Set Test Variable                               ${status_btn_submit}                 ${status_btn}
    Wait Until Page Contains Element                id=${OfferInSerpID}                  timeout=15s
    @{elements}                                     Get Webelements                      id=${OfferInSerpID}
    ${Title}                                        Get Text                             ${elements}[0]
    Should Not Be Empty                             ${Title}
    Set Test Variable                               ${FirstTitle}                        ${Title}
    Click First Title And Validate It On The Listing Details Page                        ${elements}[0]
    # Wait Until Keyword Succeeds                   5x       2s                    Page Should Contain Element    ${ListingFav}
