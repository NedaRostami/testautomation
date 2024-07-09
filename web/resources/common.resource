*** Settings ***
Documentation             A resource file with reusable keywords and variables.
...                       The system specific keywords created here form our own
...                       domain specific language. They utilize keywords provided
...                       by the imported SeleniumLibrary.
Resource                  ../../resources/all.resource
Library                   SeleniumLibrary  plugins=SeleniumSelectorsPlugin   timeout=20    run_on_failure=capture custom screenshots
Library                   String
Library                   SSHLibrary            encoding=cp1256
Library                   OperatingSystem
Library                   DateTime
Library                   XML
Library                   RequestsLibrary
Library                   Collections
Library                   Sheypoor              platform=web     env=${trumpet_prenv_id}    general_api_version=${general_api_version}   ServerType=${ServerType}
Library                   FakerLibrary          locale=fa_IR
Library                   Process


*** Variables ***
${LOGin}                          [data-bind="visible: item.loggedIn === true, click: submit.bind($data)"]
${NotLOGin}                       [data-bind="visible: item.loggedIn === false, click: gotoStep.bind($data, 2)"]
${HEADLESS}                       No
${RecordV}                        No
${IMGcount}                       ${0}
${PaymentButton}                  xpath://*[@id="bump-gateway"]/p/button
${PaymentButton_PF}               xpath://button[@class='payment pull-right']
${Second}                         ${False}
${image_holder}                    name=qqfile
# ${image_holder}                 css:[accept="image/*"]
${Billing_MyListing_Button}       css:a.button.go-back-to-listing
${Post_Moderation}                ${TRUE}
${CDN}                            cdn.mielse.com
${Ad_Registration_Button}         //form[@class="full-width"]/p[@class="button-bar"]/button
${in-progress}                    //ul[@aria-live="polite"]/li[contains(@class,"qq-in-progress")]
${upload-success}                 //ul[@aria-live="polite"]/li[contains(@class,"qq-upload-success")]
${Submit_Without_Img_Popup}       ${Open_Popup.format("popup-item-form-image-confirmation")}
${show_sp_popup}                  ${FALSE}
${sp_required}                    ${FALSE}

*** Keywords ***
Check Home Page
    Open Browser to the Home Page
    Home Page Should Be Open
    Set Test Payment Gateway                                   success

Open Browser to the Home Page
    Go to  ${SERVER}/


check 404
    FOR  ${i}    IN RANGE     5
      Go to  ${SERVER}/Error404
      Wait Until Page Is Loaded
      ${Loaded}                            Run Keyword And Return Status    Wait Until Page Contains      ${lost_message}    timeout=5s
      Exit For Loop If                     ${Loaded}
    END
    Run Keyword Unless                     ${Loaded}           Fail                can not load 404 page
    Wait Until Keyword Succeeds            5x    500ms         Delete All Cookies
    Wait Until Keyword Succeeds            5x    500ms         Add Cookie          geo    dont-care    domain=${EXACTDOMAIN}
    Check Backend Errors                   failure=${TRUE}


Dont See Errors
    Page Should Not Contain            خطای داخلی
    # ${timeout_error}                   Run Keyword And Return Status           Page Should Contain Element    //*[@id="popup-timeout" and @class="popup open"]
    # Run Keyword If                     ${timeout_error}                        Click Link                     بارگذاری دوباره صفحه
    [Return]                           ${false}


Go To Post Listing Page
  Click Link                                     ${Home_Post_Listing_Btn}
  Is Post Listing Loaded


# Fill Listing Form When Not logged In
#     [Arguments]                   ${Pictures Count}     ${CatID}   ${CatID2}   ${SubCatID}    ${State}=فارس    ${City}=شیراز    ${Region}=ارم  ${Model}=${None}    ${ModelNo}=${None}    ${Title_Description}=${False}   ${Title_Words}=${False}
#     Filling Form                  ${CatID}   ${CatID2}   ${SubCatID}    ${State}    ${City}   ${Region}   ${Model}    ${ModelNo}    ${Title_Description}   ${Title_Words}
#     Run Keyword If        	      '${Pictures Count}' != 'No-Image'  Attach Listing Image    ${Pictures Count}  ${CatID}
#     Submit post listings          ${FALSE}
#
#
# Fill Listing Form When logged In
#         [Arguments]                   ${Pictures Count}   ${CatID}   ${CatID2}   ${SubCatID}   ${TEL}    ${State}=فارس    ${City}=شیراز    ${Region}=ارم   ${Uncompleteed}=${FALSE}    ${Model}=${None}    ${ModelNo}=${None}   ${Title_Description}=${False}   ${Title_Words}=${False}   ${shop_with_securePurchase_with_delivery}=${False}
#         Filling Form                  ${CatID}   ${CatID2}   ${SubCatID}     ${State}    ${City}   ${Region}   ${Model}    ${ModelNo}    ${Title_Description}   ${Title_Words}
#         Run Keyword If	             '${Pictures Count}' != 'No-Image'  Attach Listing Image    ${Pictures Count}   ${CatID}
#         Run Keyword If                ${Uncompleteed}         Check Uncompleted listing Form
#         # Is Image Uploaded
#         Submit post listings          ${TRUE}                 shop_with_securePurchase_with_delivery=${shop_with_securePurchase_with_delivery}


Edit Listing
        [Arguments]                    ${ImageProcess}  ${Pictures Count}   ${CatID}  ${TEL}   ${Title_Description}   ${Title_Words}  ${Price}   &{kwargs}
        Run Keyword If                '${ImageProcess}' != 'Nochange'  Image Edit Proccessing    ${ImageProcess}  ${Pictures Count}  ${CatID}
        Edit Listing Form              ${CatID}  ${Title_Description}   ${Title_Words}   ${Price}   &{kwargs}
        # Is Image Uploaded
        Submit post listings           ${TRUE}


Image Edit Proccessing
        [Arguments]                    ${ImageProcess}  ${Pictures Count}  ${CatID}
        Run Keyword If	              '${ImageProcess}' == 'Del'  Delete Images  ${Pictures Count}
        Run Keyword If	              '${ImageProcess}' == 'Add' and '${Pictures Count}' != 'No-Image'  Attach Listing Image    ${Pictures Count}  ${CatID}


Edit Listing Form
        [Arguments]                     ${CatID}    ${Title_Description}        ${Title_Words}  ${Price}        &{kwargs}
        Run Keyword If                  ${ChangeAttr}                           Edit other Attr if necessary    ${CatID}   &{kwargs}
        Sleep    1s
        Run Keyword If                  ${Title_Words}                          Input Random Title
        Run Keyword If                  ${Title_Description}                    Input Random Description
        ${PriceBase}                    Run Keyword And Return Status           Page Should Contain Element    ${PL_Form_Price}
        Run Keyword If                  ${PriceBase} and '${Price}' == '0'      Input Text                     ${PL_Form_Price}    ${Price}


Login OR Register By Random OR New Mobile
    [Arguments]                           ${Position}
    Mobile Generator B
    Login OR Register By Mobile           ${Random_User_Mobile_B}         ${Position}


Login OR Register By Mobile
  [Arguments]                           ${Mobile_No}                                     ${Position}
  Run Keyword If                       '${Position}' == '${Auth_Session_Position}'       Check Get Location For Session
  Check The Login Page View             ${Position}
  Fill Register User By Mobile          ${Mobile_No}                                     ${Position}
  Run Keyword If                        '${Position}' != 'SaveSearch'                    Close NPS popup
  Dispach The Status By Login Position  ${Position}


Check Get Location For Session
  ${Current_Loc}                            Get Location
  IF   '${Current_Loc}' != '${SERVER}/session/login'
        Go To                              ${SERVER}/session
  END


Check The Login Page View
  [Arguments]                           ${Login_Position}
  # Wait Until PageLogin OR Register By Mobile Contains Element      ${Auth_Session_Login_Xpath}                                timeout=10s
  Wait Until Page Contains Element      ${Auth_Username_Xpath}                                     timeout=10s
  Run Keyword If                       '${Login_Position}' == '${Auth_Post_Listiong_Position}'     Page Should Contain          ${Auth_Title_Listing_Login_Page}
  ...   ELSE                            Page Should Contain                                        ${Auth_Title_Login_Session_Page}


Dispach The Status By Login Position
  [Arguments]                            ${Login_Position}
  IF        '${Login_Position}' == '${Auth_Session_Position}'
      Evaluate Status After Login For Session

  ELSE IF   '${Login_Position}' == '${Auth_Post_Listiong_Position}'
      Evaluate Status After Login For Post Listing

  ELSE IF   '${Login_Position}' == '${Auth_Save_Search_Position}'
      Evaluate Status After Login For Save Search

  ELSE IF  '${Login_Position}' == '${Auth_LD_Prop_Price_Position}'
      Evaluate Status After Login For Propose Price Of Listing Details

  ELSE IF  '${Login_Position}' == '${Auth_LD_Chat_Position}'
      Evaluate Status After Login For Chat Of Listing Details

  ELSE IF  '${Login_Position}' == '${Auth_LD_Message_Seller_Position}'
      Evaluate Status After Login For Message Seller Of Listing Details

  ELSE IF  '${Login_Position}' == '${Auth_LD_Safe_Shop_Position}'
      Evaluate Status After Login For Safe Shop Of Listing Details

  ELSE IF  '${Login_Position}' == '${Auth_My_Chat_Position}'
      Evaluate Status After Login For My Chat
  END


Evaluate Status After Login For Session
  Wait Until Element Contains          ${ML_Header}             ${ML_Page_Title}    timeout=10s


Evaluate Status After Login For Post Listing
  Wait Until Page Contains Element     ${PF_Selector}        timeout=10s
  # Run Keyword And Return Status      Page Should Contain             افزایش بازدید
  # ...  To do: Validate  افزایش بازدید in the automatic post listing test


Evaluate Status After Login For Save Search
  Wait Until Page Contains Element     ${Serp_F_Save_Search_Popup}       timeout=10s


Evaluate Status After Login For Propose Price Of Listing Details
  Wait Until Page Contains Element     ${LD_Propose_Price_Popup_Open}    timeout=10s
  Wait Until Page Contains             ${LD_Propose_Price_Text}          timeout=10s


Evaluate Status After Login For Chat Of Listing Details
  Wait Until Page Contains Element     ${LD_Chat_Window_Xpath}           timeout=10s
  Page Should Contain                  ${LD_Chat_Text}


Evaluate Status After Login For Message Seller Of Listing Details
  Wait Until Page Contains Element     ${LD_SP_Chat_Xpath}               timeout=10s
  Page Should Contain                  ${LD_SP_Text}


Evaluate Status After Login For Safe Shop Of Listing Details
  Wait Until Page Contains Element     ${LD_Biling_Page_Xpath}           timeout=10s


Evaluate Status After Login For My Chat
  Wait Until Page Contains Element     ${Chat_Section}            timeout=10s


Login OR Register In Listing By New Mobile
  Login OR Register By Random OR New Mobile    ${Auth_Post_Listiong_Position}


Check Uncompleted listing Form
    Go To Serp Page
    Go To Post Listing Page


Check Listing Limit is Reached
    ${Limited1}                               Run Keyword And Return Status    Wait Until Page Contains         ${Listing_limit_message1}     timeout=3    error=Limit Listing Problem
    ${Limited2}                               Run Keyword And Return Status    Page Should Contain              ${Listing_limit_message2}
    Set Test Variable                         ${Limited}                       ${Limited1} or ${Limited2}


Verify Post Listing Is done
    Check Listing Limit is Reached
    Run Keyword If                            not ${Limited}                   Verify Post Listing Is done Without Limit


Verify Post Listing Is done Without Limit
    # ${After_post_listing_message}         Set Variable If
    # ...  ${Toggle_paid-features} == ${FALSE}                                                     ${post_listing_message}
    # ...  ${Toggle_paid-features} == ${TRUE} and ${Toggle_paid-features-bumps} == ${TRUE}         ${post_listing_paid_message}
    # ...  ${Toggle_paid-features} == ${TRUE} and ${Toggle_paid-features-bumps} == ${FALSE}        ${post_listing_message}
    # ...  ${listing_actived_approved_paid_feature_title_web}

    ${autoapprove}                           Run Keyword And Return Status          Wait Until Page Contains              ${listing_actived_approved_paid_feature_title_web}        timeout=5s
    Run Keyword Unless                       ${autoapprove}                         Wait Until Page Contains              ${post_listing_paid_message}                              timeout=5s
    ${After_post_listing_message}            Set Variable If                        ${autoapprove}                        ${listing_actived_approved_paid_feature_title_web}         ${post_listing_paid_message}
    Set Suite Variable                       ${After_post_listing_message}


Check My Listing Without Limit
    Get ListingID
    Run Keyword If                           ${Post_Moderation}                     Post Moderation validation
    ...  ELSE                                Listing Must Be On Check State In My Listing


Post Moderation validation
     ${blacklisted}                          Is BlackListed          	${AdsId}
     Run Keyword if                          ${blacklisted}           Verify Advertise By ID
     Run Keyword if                          ${blacklisted}           Set Test Message    listing ${AdsId} was blacklisted and approved by tets so no post moderation is occured    append=True
     Listing Must Be On Verify State In My Listing


Get ListingID
     Run Keyword If                         ${Toggle_paid-features} and ${Toggle_paid-features-bumps}           Get ListingID With Paid Feature      ELSE      Get ListingID Without Paid Feature


Get ListingID With Paid Feature
    Wait Until Element Contains            //*[@class="section pending"]/strong               ${After_post_listing_message}    timeout=5s
    ${MessageContainAdv}                   Get Text                                           xpath=//*[@id="paid-features"]//section/strong
    Set Test Variable                      ${MessageContainAdv}
    ${status}                              Run Keyword And Return Status                      Should Contain                 ${MessageContainAdv}    شناسه آگهی
    Run Keyword If                        ${status}                                           Get Listing ID from Header Title
    ...  ELSE                             Get Listing ID from Paid ID attribute


Get Listing ID from Paid ID attribute
   ${AdverId}                      SeleniumLibrary.Get Element Attribute    id:paid     data-listing
   Set Test Variable               ${AdsId}                                 ${AdverId}


Get Listing ID from Header Title
    ${AdverId}                    Fetch From right   ${MessageContainAdv}	        شناسه آگهی:
    ${AdverId}                    Strip String       ${AdverId}
    Set Test Variable             ${AdsId}           ${AdverId}


Get ListingID Without Paid Feature
    ${MessageContainAdv}          Get Text           xpath=//*[@id="session-my-listings-page"]/body/main/div[1]/p
    ${msgA}                      	Fetch From left    ${MessageContainAdv}	  پس از بررسی توسط تیم نظارت شیپور، تایید شده و نمایش آن در شیپور به شما اطلاع داده خواهد شد.
    ${msgB}                     	Fetch From right   ${msgA}	 آگهی شما با کد
    ${AdverId}                    Strip String       ${msgB}
    Set Test Variable             ${AdsId}           ${AdverId}


Check My Listing
    Run Keyword If                ${Limited}         Check My Listing With Limit
    ...  ELSE                     Check My Listing Without Limit


Check My Listing With Limit
    Run Keyword If               	        ${Toggle_paid-features}              Check My Listing With Limit with PF
    ...  ELSE     Check My Listing With Limit without PF


Check My Listing With Limit with PF
    Wait Until Element Is Visible         css:section.card.listing-limit
    ${URL}                                Get Location
    ${seprator}                           Set Variable                        ${SERVER}/session/paid-features/
    ${URL}                                Remove String                       ${URL}                              ${seprator}
    @{URL}                                Split String                        ${URL}                              separator=/
    Set Test Variable                     ${AdsId}                            ${URL}[0]
    Pay Listing Limit in PF
    Click Element                        ${Billing_MyListing_Button}


Check My Listing With Limit without PF
    Wait Until Element Is Visible         css:[data-popup="popup-listing-limitation"]
    ${URL}                                Get Location
    ${seprator}                           Set Variable                        ${SERVER}/session/listing-limitation/
    ${URL}                                Remove String                       ${URL}                              ${seprator}
    @{URL}                                Split String                        ${URL}                              separator=/
    Set Test Variable                     ${AdsId}                            ${URL}[0]
    Pay Listing Limit
    Click Element                        ${Billing_MyListing_Button}
    Listing Must Be On Check State


Listing Must Be On Check State
    Listing Must Be On Check State In My Listing


Listing Must Be On Verify State In My Listing
    Run Keyword If    	                                      ${Toggle_paid-features-bumps}         Validate Page Is In PF view
    Run Keyword If                                            ${in_Bump_Pf_view}                    go to                            ${SERVER}/session/myListings
    Look For Validator Till found in Refresh Loop             5   2                                 Element Should Contain           ${ML_Listing_Status.format('${AdsId}')}   منتشر شده
    Close NPS popup
    Element Should Contain                                    ${ML_Listing_Title.format('${AdsId}')}           ${Title_Words}


Listing Must Be On Check State In My Listing
    Run Keyword If    	                                      ${Toggle_paid-features-bumps}         Validate Page Is In PF view
    Run Keyword If                                            ${in_Bump_Pf_view}                    go to                            ${SERVER}/session/myListings
    Look For Validator Till found in Refresh Loop             5   2                                 Element Should Contain           ${ML_Listing_Status.format('${AdsId}')}    در حال بررسی
    Element Should Contain                                    ${ML_Listing_Title.format('${AdsId}')}            ${Title_Words}


Validate Page Is In PF view
    Wait Until Page Contains               ${post_listing_pf_message_new}       timeout=2s
    Set Test Variable                      ${in_Bump_Pf_view}                   ${TRUE}


Pay Listing Limit in PF
    Click Element                         ${PaymentButton_PF}
    Wait Until Page Contains              پرداخت شما با موفقیت انجام شد
    Page Should Not Contain               خطا در سفارش
    Validate Invoice Form


Validate Invoice Form
    Validate Invoice Page
    Validate Success Payment Invoice


Validate Invoice Form With Coupon
    Validate Invoice Page


Validate Invoice Page
    Page Should Contain                        شرح خدمات
    Page Should Contain                        مبلغ کل با احتساب مالیات
    Page Should Contain                        مالیات و عوارض بر ارزش افزوده
    Page Should Contain                        تاریخ
    SeleniumLibrary.Element Text Should Be     ${Billing_MyListing_Button}        آگهی های من


Validate Success Payment Invoice
    Page Should Contain                        کد رهگیری
    Page Should Contain                        بانک
    Page Should Contain                        فروشنده
    Page Should Contain                        شماره اقتصادی
    Page Should Contain                        کدپستی
    Page Should Contain                        نشانی
    Page Should Contain                        تلفن
    Page Should Contain                        شرکت نت تجارت اهورا (شیپور)
    Page Should Contain                        ۴۱۱۳-۸۸۱۷-۱۵۸۴
    Page Should Contain                        ۱۵۱۸۶۱۳۱۱۸
    Page Should Contain                        تهران، تقاطع افریقا و همت، پلاک ۱۱
    Page Should Contain                        ۰۲۱-۵۴۵۸۷



Pay Listing Limit
    Click By Css Selector                 [data-popup="popup-listing-limitation"]
    Click Element                         ${PaymentButton}
    Wait Until Page Contains              پرداخت شما با موفقیت انجام شد
    Page Should Not Contain               خطا در سفارش
    Validate Invoice Form



Look For Validator Till found in Refresh Loop
      [Arguments]                             ${Repeter}      ${delays}   ${Keyword}      @{args}
      FOR  ${INDEX}   IN RANGE    1           ${Repeter}
        ${passed}                            	Run Keyword And Return Status    ${Keyword}    @{args}
        Exit For Loop If                      ${passed}
        Execute Javascript                    location.reload()
        Sleep                                 ${delays}s
      END
      Run Keyword If    not ${passed}     Failed Log Message     ${Repeter}      ${delays}     @{args}


Failed Log Message
      [Arguments]             ${Repeter}      ${delays}     @{args}
      ${str}       Set Variable
      FOR  ${item}   IN    @{args}
        ${str}   Set Variable    ${str} ${item}
      END
      Fail    ${str} not found after ${Repeter} refresh with ${delays}s


Set Test Payment Gateway
   [Arguments]    ${Status}
   Add Cookie     payment       ${Status}


Login Trumpet Admin Page
      Go to                       ${SERVER}/trumpet/login
      Input Text                  email       ${admin_user}
      Input Text                  password    trumpet
      Click Element               css:button.btn.btn-primary
      Wait Until Page Contains    داشبورد


Wait Until Keyword Returns True
    [Arguments]                      ${timeout}    ${retry_interval}    ${name}                       @{args}
    Wait Until Keyword Succeeds      ${timeout}    ${retry_interval}    Keyword Should Return True    ${name}    @{args}


Keyword Should Return True
    [Arguments]                      ${name}        @{args}
    ${ret_val}                       Run Keyword    ${name}    @{args}
    Should Be Equal                  ${ret_val}     ${True}


Wait Until Keyword Returns Passed
    [Arguments]                      ${retry}    ${timeout}    ${name}    @{args}
    FOR   ${INDEX}                   IN RANGE     0            ${retry}
      ${status}    	                 Run Keyword And Return Status    ${name}    @{args}
      Exit For Loop If               ${status}
      Sleep                          ${timeout}
      Reload Page
    END
    Run Keyword If                   not ${status}      fail    ${name} @{args} failed


Wait Until Keyword Returns No Null
    [Arguments]                      ${timeout}    ${retry_interval}    ${name}    @{args}
    ${ret_val}                       Wait Until Keyword Succeeds    ${timeout}   ${retry_interval}   Verify SMS Code Must be Numbers    ${name}    @{args}
    [return]                         ${ret_val}


Verify SMS Code Must be Numbers
    [Arguments]            ${name}        @{args}
    ${ret_val}             Run Keyword    ${name}      @{args}
    Should Match Regexp	   ${ret_val}	    ^\\d{4}$
    [return]   ${ret_val}


False Once
    [Arguments]    @{args}
    Log    ${args}
    ${called_already}=    Get Variable Value    ${FALSE_ONCE}    ${False}
    Set Global Variable    ${FALSE_ONCE}    ${True}
    [Return]    ${called_already}


Verify Advertise By ID
    Trumpet adv          accept            ${AdsId}


Reject Advertise By ID
    Trumpet adv          reject            ${AdsId}


Delete Advertise By ID
    Trumpet adv          delete            ${AdsId}


Trumpet adv
    [Arguments]   ${Kind}    ${listingId}
    Wait Until Keyword Returns True    3x    2s      Mock Listing Moderate    ${Kind}    ${listingId}


Check My Ads Has been Verified
    Go to                                            ${SERVER}/session/myListings/active
    Look For Validator Till found in Refresh Loop    10    1      Page Should Contain       ${Title_Words}
    Look For Validator Till found in Refresh Loop    10    1      Element Should Contain    ${ML_Listing_Status.format('${AdsId}')}    منتشر شده


Check My Ads Has been Rejected
    Go to                                             ${SERVER}/session/myListings/inactive
    Look For Validator Till found in Refresh Loop     10     0.5     Page Should Contain    ${Title_Words}
    Element Should Contain                            ${ML_Listing_Status.format('${AdsId}')}     رد شد


Check My Ads Has been Deleted By User
    Go to                                             ${SERVER}/session/myListings/inactive
    Look For Validator Till found in Refresh Loop     10     0.5     Page Should Contain    ${Title_Words}
    Element Should Contain                            ${ML_Listing_Status.format('${AdsId}')}       حذف شده


Check Duplicate Ads Has been Deleted By Admin
    Go to                                             ${SERVER}/session/myListings/active
    Wait Until Page Does Not Contain Element          ${ML_Listing_Status.format('${AdsId}')}        timeout=5s
    Go to                                             ${SERVER}/session/myListings/inactive
    Wait Until Page Does Not Contain Element          ${ML_Listing_Status.format('${AdsId}')}        timeout=5s


Wait Until Page Is Loaded
    sleep                                             500ms
    Wait For Condition                                return window.document.readyState === "complete"   timeout=15s

Wait Until Page Is Loaded in Moderation
    Wait For Condition     return window.document.readyState === "complete"
    FOR    ${INDEX}    IN RANGE    1   11
      ${status}      ${Loaded}   Run Keyword And Ignore Error   Execute Javascript    return window.jQuery.active == 0
      Exit For Loop If    ${Loaded}
      Sleep    500ms
    END


Wait Until Page Loading Is Finished
    Wait For Condition     return window.document.readyState === "complete"   timeout=15s


Do Enter And Wait Until Page Reloaded
    [Arguments]      ${element}
    Press Keys	      ${element}  	RETURN
    Wait Until Page Is Loaded


Email Generator A
    ${Random_String}            Generate Random String  6  [LOWER]
    Set Suite Variable          ${Random_User_Email_A}    QAA-${Random_String}-test@qaqa.com


Mobile Generator A
    ${Random_Number}            Generate Random String  7  [NUMBERS]
    Set Suite Variable          ${Random_User_Mobile_A}    0900${Random_Number}


Email Generator B
    ${Random_String}            Generate Random String  6  [LOWER]
    Set Suite Variable          ${Random_User_Email_B}    QBB-${Random_String}-test@qaqa.com


Mobile Generator B
    ${Random_Number}            Generate Random String  7  [NUMBERS]
    Set Suite Variable          ${Random_User_Mobile_B}    0900${Random_Number}


Attach Listing Image Old
    [Arguments]     ${PIC_NO}
    Random Photo    ${PIC_NO}
    Wait Until Page Contains Element     ${image_holder}     timeout=10s
    FOR    ${INDEX}    IN RANGE    1   ${PIC_NO+1}
      Choose File       ${image_holder}     ${CURDIR}${/}Images${/}${photo${INDEX}}
      Is Image Uploaded
    END
    Set Test Variable     ${IMGcount}      ${IMGcount+${PIC_NO}}
    # Wait Until Keyword Returns True    5x    3s    Execute Javascript       !bee('[data-bind*="visible"][data-bind*="uploaderMessageForceShow"]:visible').size()


Attach Listing Image
    [Arguments]                           ${PIC_NO}            ${Category}
    ${IMG List}                           select images        ${Category}         ${PIC_NO}      ${Listings_ListingID}
    ${IMG List}     Convert To List       ${IMG List}
    Wait Until Page Contains Element      ${image_holder}      timeout=10s
    FOR    ${IMG}    IN   @{IMG List}
      Choose File                         ${image_holder}      ${IMG.file_path}
      Is Image Uploaded
    END
    Set Test Variable                     ${IMGcount}          ${IMGcount+${PIC_NO}}
    #Wait Until Keyword Returns True    5x    3s    Execute Javascript       !bee('[data-bind*="visible"][data-bind*="uploaderMessageForceShow"]:visible').size()


Is Image Uploaded
    Wait Until Page Does Not Contain Element    ${in-progress}               timeout=30s
    FOR    ${INDEX}         IN RANGE    0   5
      ${Uploaded}           Execute Javascript    return window.bee('.fine-uploader .qq-upload-spinner-selector, .fine-uploader .qq-upload-retry-selector').is(':visible')
      Exit For Loop If      not ${Uploaded}
    END
    Run Keyword If          ${Uploaded}    Fail    image can not be uploaded


Delete Images
    [Arguments]              ${DelCount}
    Is Image Uploaded
    Run Keyword If           '${DelCount}' == 'ALL'                   Delete All images
    ...  ELSE                Delete Multi Images                      ${DelCount}
    Is Image Uploaded


Delete All images
    ${images_count}          SeleniumLibrary.Get Element Count        ${PL_Img_Selector}
    FOR    ${INDEX}          IN RANGE                                 ${images_count}
      Click Element          ${PL_Open_Img_Icon}
      Wait Until Page Contains Element                               ${PL_Icon_Trash}        timeout=3s
      Click Element          ${PL_Icon_Trash}
      Wait Until Page Does Not Contain Element                        ${in-progress}         timeout=3s
    END
    Set Test Variable        ${IMGcount}                               ${0}


Delete Multi Images
    [Arguments]              ${DelCount}     ${IMGcount}=10
    FOR    ${INDEX}          IN RANGE    1   ${DelCount+1}
      # Execute Javascript   bee('.fine-uploader .qq-upload-list li:nth-child(${INDEX})').find('.qq-upload-delete-selector, .qq-upload-cancel-selector').click()
      Click Element          ${PL_Img_Selector}
      Click Element          ${PL_Icon_Trash}     END
    Set Test Variable        ${IMGcount}      ${IMGcount-${DelCount}}


Is Image Uploaded in Moderation Page
    FOR    ${INDEX}    IN RANGE    1   10
      ${uploaded} =	Run Keyword And Return Status    Element Should Be Visible   css=.qq-upload-success
      Exit For Loop If    '${uploaded}' == 'True'
      Sleep     1s
    END


Is Confirm Button Worked?
  FOR    ${INDEX}       IN RANGE    0    5
     ${FormClass}       SeleniumLibrary.Get Element Attribute    id:reviewForm_1   class
     ${passed}       	  Run Keyword And Return Status            Should Contain    ${FormClass}   bg-success
     Exit For Loop If   ${passed}
     Click Button       تایید
     BuiltIn.Sleep      2s
  END
  [return]    ${passed}


Random Photo
    [Arguments]    ${PIC_NO}
    ${numbers}=    Evaluate    random.sample(range(701, 759), ${PIC_NO+1})    random
    FOR    ${INDEX}    IN RANGE    1   ${PIC_NO+1}
      ${file$INDEX}=     Get From List   ${numbers}  ${INDEX}
      Set Test Variable     ${photo${INDEX}}    qa${file$INDEX}.jpg
    END


Click And Validiate Button
    [Arguments]                        ${Button}
    Wait Until Page Contains Element   ${Button}                             timeout=7s
    Wait Until Keyword Succeeds        3x   2s                               Click Element                 ${Button}


Input Mobile Field
    [Arguments]                        ${UserNameME}
    Input Text                         ${Auth_Username_Xpath}                ${UserNameME}
    ${CLickStatus}                     Run Keyword And Return Status         Click And Validiate Button    ${username_submit_btn}
    Run Keyword Unless                 ${CLickStatus}                        Fail                          Could not click the submit username button.
    Wait Until Page Contains Element   ${code_submit_btn}                    timeout=7s

# Filling Form
#     [Arguments]                      ${CatID}      ${CatID2}   ${SubCatID}  ${State}  ${City}   ${Region}   ${Model}=${None}    ${ModelNo}=${None}    ${Title_Description}=${False}   ${Title_Words}=${False}
#     Get Random Listing               ${SubCatID}   ${Model}    ${ModelNo}
#     Set Suite Variable               ${CatID}
#     ${CatType}                       Get Cat Parent Name       ${CatID}
#     Set Suite Variable               ${CatType}
#     Input Category                   ${CatID}                  ${CatID2}
#     Input Sub Category               ${SubCatID}
#     Handle New Used Attribute
#     Fill other Attr if necessary     ${CatID}     ${Model}     ${ModelNo}
#     Sleep    1s
#     Input Listing Title              ${Title_Words}
#     Input Listing Description        ${Title_Description}
#     Handle Price
#     ${passed}                        Run Keyword And Return Status    Element Should Not Contain     ${PL_Popup_Loc_CSS}        ${State} > ${City}
#     Run Keyword If	                 ${passed}                        Select Neighborhood            ${State}  ${City}   ${Region}


# Handle New Used Attribute
#     ${status}                        Run Keyword And Return Status    Page Should Contain Element    ${PL_Status_Field_CSS}
#     Run Keyword If                   ${status}                        Set New Used Attribute
#
#
# Set New Used Attribute
#     Click By Css Selector                ${PL_Status_Field}             # وضعیت
#     Wait Until Page Contains Element     ${PL_Status_Field_Open}        timeout=5s
#     click element                        ${PL_Att_Field_CSS.format(453188)}           #در حد نو


# Get Suggested Price
#     ${Price}                         Get Text         ${PL_Suggested_Price}
#     ${Price}                         Remove String    ${Price}    ,
#     ${Price}                         Remove String    ${Price}    تومان
#     ${Price}                         Convert Digits   ${Price}   Fa2En
#     Set Test Variable                ${Price}         ${Price}


Get Random Listing
    [Arguments]                     ${SubCatID}=${subCat_id}      ${attribute_id}=${model}    ${option_id}=${model_id}
    ${Random_Listing}               Random Live Listing           category=${SubCatID}        attribute_id=${attribute_id}    option_id=${option_id}
    FOR   ${key}       IN           @{Random_Listing.keys()}
        ${randomKey}                Get From Dictionary           ${Random_Listing}           ${key}
        Set Suite Variable          ${Listings_${key}}            ${randomKey}
    END
    # ${Listings_title}    Replace String Using Regexp  ${Listings_title}	  /\s\s+/g    ${SPACE}
    # Set Suite Variable    ${Listings_title}           ${Listings_title}


# Fill other Attr if necessary
#     [Arguments]       ${CatID}      ${Model}      ${ModelNo}
#     Run Keyword If    '${CatID}' == '43626'   Fill Car Attributes        Add   ${Model}    ${ModelNo}
#     Run Keyword If    '${CatID}' == '43603'   Fill Real RealEstate Attributes
    # Run Keyword If    '${CatID2}' == '43627'   click element  xpath://*[@id="item-form"]/div/div[1]/form/p[4]/label[1]/span[1]


Edit other Attr if necessary
    [Arguments]       ${CatID}     &{kwargs}
    Run Keyword If    '${CatID}' == '43626'   Fill Car Attributes        Edit   &{kwargs}
    Run Keyword If    '${CatID}' == '43603'   Fill Real RealEstate Attributes
    # Run Keyword If    '${CatID2}' == '43627'   click element  xpath://*[@id="item-form"]/div/div[1]/form/p[4]/label[1]/span[1]


# Fill Car Attributes
#     [Arguments]                ${Kind}=Add    ${Model}=${None}    ${ModelNo}=${None}   ${Payment}=445097   ${ProductionYear}=1396   ${KM}=2500   ${Colour}=445243  ${GearBox}=445308   ${Body}=445327
#     ${speed}                   Set Selenium Speed                        200ms
#     Run Keyword If             '${Kind}' == 'Add'                               Add Model and ModelNo    ${Model}   ${ModelNo}
#     Click By Css Selector      ${PL_Item_Form.format('a69150')}                     #نقدی/اقساطی
#     click element              ${PL_Att_Field_CSS.format('${Payment}')}
#     Input Text                 ${PL_Product_Year_Field}      ${ProductionYear}                 #سال تولید
#     Input Text                 ${PL_Kilometer_Field}         ${KM}                             #کیلومتر
#     Click By Css Selector      ${PL_Item_Form.format('a69130')}                   # رنگ
#     click element              ${PL_Att_Field_CSS.format('${Colour}')}    #سفید
#     Click By Css Selector      ${PL_Item_Form.format('a69140')}                   #گیربکس
#     click element              ${PL_Att_Field_CSS.format('${GearBox}')}
#     # Run Keyword And Ignore Error    Click Element              xpath=(//span[@class="icon-indicator"])[3]
#     Click By Css Selector      ${PL_Item_Form.format('a69160')}                   # وضعیت بدنه
#     click element              ${PL_Att_Field_CSS.format('${Body}')}
#     # Click By Css Selector      ${PL_Item_Form.format('a69601')}            # پلاک ملی
#     # click element              ${PL_Att_Field_CSS.format(450672)}
#     Set Selenium Speed         ${speed}


# Add Model and ModelNo
#      [Arguments]                ${Model}     ${ModelNo}
#      Click By Css Selector      ${PL_Item_Form.format('${Model}')}               #پژو
#      click element              ${PL_Att_Field_CSS.format('${ModelNo}')}  # پارس ( سایر)
#
#
# Select Chasi
#      Click By Css Selector      ${PL_Item_Form.format('a68099')}                # شاسی
#      click element              ${PL_Att_Field_CSS.format(267063)}


Fill Real RealEstate Attributes
    Click By Css Selector           ${PL_Item_Form.format('a68096')}            #نوع ملک
    click element                   ${PL_Att_Field_CSS.format(440477)}          #آپارتمان
    Sleep                           1s

    Add New Real Estate Attributes
    Input Text                      ${PL_Area_Field}    100                     #متراژ
    # Click By Css Selector           ${PL_Item_Form.format(a68094)}
    # click element                   ${PL_Att_Field_CSS.format(440470)}
    Click By Css Selector           ${PL_Item_Form.format('a68133')}            #تعداد اتاق
    click element                   ${PL_Att_Field_CSS.format(439415)}
    Input Text                      ${PL_Mortgage_Field}                        234567891
    Input Text                      ${PL_Rent_Field}                            9876541
    Click By Text                   ${PL_Convert_Mortgage_Rent_Option}


Add New Real Estate Attributes
    Click By Css Selector           ${PL_Item_Form.format('a92367')}            #سال ساخت بنا
    click element                   ${PL_Att_Field_Class.format(455204)}  #  1396 سال
    Click By Text                   ${PL_Parking_Txt}
    Click By Text                   ${PL_Warehouse_Txt}
    Click By Text                   ${PL_Elevator_Txt}


Input Listing Title
    [Arguments]                     ${Title_Static}=${title_words}
    # Run Keyword If               '${Title_Static}' == '${False}'    Input Random Title   ELSE   Input Static Title    ${Title_Static}
    Run Keyword If                 '${Title_Static}' == '${False}'    Input Real Title   ELSE   Input Static Title    ${Title_Static}


Input Real Title
    ${Title}                     Set Variable                ${Listings_title}
    # ${Title}                    	Fetch From left             ${Title}  .
    ${Title}                     Replace String              ${Title}  ي  ی
    ${Title}                     Replace String              ${Title}  ى  ی
    ${Title}                     Replace String              ${Title}  ك  ک
    ${Title}                     Convert Digits              ${Title}  Fa2En
    ${Title}                     Strip String                ${Title}
    Set Test Variable            ${Title_Words}              ${Title}
    Input Text                   ${PL_Form_Title}            ${Title_Words}


Input Random Title
    ${Title}                      FakerLibrary.Sentence	nb_words=6  variable_nb_words=False
    ${Title}                     	Fetch From left             ${Title}  .
    ${Title}                      Replace String              ${Title}  ي  ی
    ${Title}                      Replace String              ${Title}   ى  ی
    ${Title}                      Replace String              ${Title}  ك  ک
    ${Title}                      Convert Digits              ${Title}  Fa2En
    ${Title}                      Strip String                ${Title}
    Set Test Variable             ${Title_Words}              ${Title}
    Input Text                    ${PL_Form_Title}            ${Title_Words}


Input Static Title
    [Arguments]                 ${Title_Static}
    ${Title}                   	Fetch From left             ${Title_Static}  .
    ${Title}                    Replace String              ${Title}  ي  ی
    ${Title}                    Replace String              ${Title}  ك  ک
    ${Title}                    Convert Digits              ${Title}  Fa2En
    ${Title}                    Strip String                ${Title}
    Set Test Variable           ${Title_Words}              ${Title}
    Input Text                  ${PL_Form_Title}            ${Title_Words}


Input Listing Description
    [Arguments]                 ${Description_Static}=${title_description}
    Run Keyword If              '${Description_Static}' == '${False}'    Input Real Description   ELSE   Input Static Description    ${Description_Static}


Input Real Description
    ${Description}               Set Variable             ${Listings_description}
    ${Description}               Strip String             ${Description}
    Set Test Variable            ${Title_Description}     ${Description}
    Input Text                   ${PL_Desc_Field}         ${Title_Description}


Input Random Description
    ${Faker_Description}        FakerLibrary.Paragraph	nb_sentences=6  variable_nb_sentences=ّFalse
    Set Test Variable           ${Title_Description}    ${Faker_Description}
    Input Text                  ${PL_Desc_Field}        ${Title_Description}


Input Static Description
    [Arguments]                 ${Description_Static}
    Set Test Variable           ${Title_Description}    ${Description_Static}
    Input Text                  ${PL_Desc_Field}        ${Description_Static}


# Input Category
#     [Arguments]        ${CatID}   ${CatID2}
#     Wait Until Page Contains Element              ${PL_Cats_Menu}                    timeout=5s
#     FOR  ${i}      IN RANGE    5
#       Click Element                               ${PL_Cats_Menu}
#       ${done}                                     Run Keyword And Return Status      Wait Until Page Contains Element      ${Open_Popup.format("${PL_Cats_Popup}")}         timeout=3s
#       Exit For Loop If                            ${done}
#     END
#     Click By Css Selector                         ${PL_Cat_Subcat_Selector}${CatID}
#     Run Keyword If                                '${CatID2}' != '${EMPTY}'          Input Second Category    ${CatID2}

#
# Input Second Category
#     [Arguments]                         ${SubCatID}
#     Wait Until Page Contains Element    ${PL_Second_Cat}               timeout=5s
#     Click By Css Selector               ${PL_Cat_Subcat_Selector}${SubCatID}


# Input Sub Category
#     [Arguments]                         ${SubCatID}
#     # Wait Until Page Contains Element    ${PL_Cat_Subcat_Selector}${SubCatID}                 timeout=5s
#     Click By Css Selector               ${PL_Cat_Subcat_Selector}${SubCatID}


# Input Tel                       # There is no phone field and this keyword is not used now.
#     [Arguments]                 ${TEL}
#     Execute Javascript          bee("#item-form-telephone").val("${TEL}").trigger("change");
#     #Input Text    id=item-form-telephone    ${TEL}

Input By bee
    [Arguments]                ${Input_Text_Name}    ${Sample_Texts}
    Execute Javascript         bee("#${Input_Text_Name}").val("${Sample_Texts}").trigger("change");
    #Wait Until Keyword Succeeds    5x    1s   Input Text    ${Input_Text_Name}    ${Sample_Texts}

Click By bee
    [Arguments]                ${Css_Selector}
    Execute Javascript         bee('${Css_Selector}').eq(0).click();

Click By Css Selector
    [Arguments]                 ${Css_Selector}
    Click Element               css:${Css_Selector}

Input By Css Selector
    [Arguments]                 ${Css_Selector}    ${Texts}
    Execute Javascript          bee('${Css_Selector}').val("${Texts}").trigger("change");
    Sleep  300ms

Clean Up Auth Elements Locator
    [Arguments]                             ${position}
    IF                                     '${position}' == '${Auth_Post_Listiong_Position}'
        Set Test Variable                   ${username_submit_btn}                            ${Auth_Next_Btn}
        Set Test Variable                   ${code_input}                                     ${Auth_PL_Code_Xpath}
        Set Test Variable                   ${code_submit_btn}                                ${Auth_Confirm_AND_Submit}

    ELSE
        Set Test Variable                   ${username_submit_btn}                            ${Auth_Login_OR_Register_Btn}
        Set Test Variable                   ${code_input}                                     ${Auth_Code_Xpath}
        Set Test Variable                   ${code_submit_btn}                                ${Auth_Login_Btn_Final_Confirm}
    END

Fill Register User By Mobile
    [Arguments]                             ${User_Mobile}                       ${Position}
    Clean Up Auth Elements Locator          ${Position}
    Wait Until Page Contains Element        ${Auth_Username_Xpath}
    Input Mobile Field                      ${User_Mobile}
    Input SMS Verify Code                   ${User_Mobile}
    Page Should Not Contain Element         ${Auth_Confirm_Code_Val}
    Page Should Not Contain Element         ${Auth_Complete_Field_Val}
    # Wait Until Element Contains             ${Auth_Verification_Container}      ${Auth_Complete_Field_Val_Msg}      timeout=2s


Close NPS popup
    ${status}   ${result}                   Run Keyword And Ignore Error           Wait Until Page Contains Element       xpath://*[@id="popup-nps-vote" and @class="popup droppable open"]            timeout=2s
    Run Keyword If                         '${status}' == 'PASS'                  Click Element                          xpath://*[@id="popup-nps-vote"]//span[@class='link close icon-close']

Rating In NPS Popup
  [Arguments]                               ${NPS_Popup}
  Validation NPS Popup                      ${Nps_Popup}
  Click Element                             xpath://input[@type='radio' and @index='9']//following::span[1]
  Click Button                              css:[data-test-id='nps-popup-submit']

Validation NPS Popup
    [Arguments]                            ${NPS_Popup}
    Page Should Contain                    نظرسنجی
    Element Should Contain                 ${NPS_Popup}                          چقدر احتمال دارد که شیپور را به دوستان یا همکاران خود توصیه کنید؟

Check Profile Email
    [Arguments]                            ${Profile_Email}
    Go To                                  ${SERVER}/session/profile
    Page Should Contain                    ${Profile_Email}


Get Code From Server
   [Arguments]                             ${MobileNo}
   ${VCode}                                Mock Login Get Code                   ${MobileNo}
   Set Suite Variable                      ${Code}    ${VCode}


Input SMS Verify Code
    [Arguments]                            ${MobileNo}
    Get Code From Server                   ${MobileNo}
    Input Text                             ${code_input}                         ${Code}
    Textfield Value Should Be              ${code_input}                         ${Code}
    Wait Until Keyword Succeeds            3x    2s                              Try Login To Sheypoor

Try Login To Sheypoor
    Run Keyword And Ignore Error                Click Element                    ${code_submit_btn}
    Wait Until Page Does Not Contain Element    ${code_submit_btn}               timeout=5s

Get The Date
    ${date}                                     Get Current Date	                result_format=datetime
    Set suite variable                          ${date}

Logout User
    Go to                                       ${SERVER}/session/logout

Logout Admin
    Go to                                       ${SERVER}/trumpet/logout
    Wait Until Page Contains                    ورود


Open Admin browser
    Set Log Level    TRACE
    Open test browser
    Maximize Browser Window
    Login Trumpet Admin Page

Create API Context
  [Arguments]                         ${DOMAIN_URL}=${EXACTDOMAIN}
  @{auth}                             Create List              trumpet  newsite
  Create Session                      ${DOMAIN_URL}            https://${DOMAIN_URL}     auth=@{auth}    verify=${FALSE}

Assert an image is visible
    [Documentation]
    ...  This keyword fails if the given image element is not visible.
    ...  Three checks are performed: that the element is on the page,
    ...  that selenium thinks the element is visible, and that the
    ...  src attribute of the image points to a resource that is
    ...  accessible.
    ${LastURL}                                Get Location
    &{Headers}                                Create Dictionary         sec-fetch-mode=no-cors   sec-fetch-site=same-site   sec-fetch-dest=image
    Get Image Attribute Except Place Holder   ${LastURL}
    Page should contain image                 ${SRC}
    Create API Context                        ${IMG_DOMAIN}
    ${resp}                                   GET On Session            ${IMG_DOMAIN}   ${img}     headers=${Headers}
    Should Be Equal As Strings	              ${resp.status_code}	      200


Get Image Attribute Except Place Holder
  [Arguments]            ${LastURL}
  ${Condition}           Run Keyword And Return Status    Should Contain        ${LastURL}            ${SERVER}/session/myListings
  ${ListingIMG}          Set Variable If                                        ${Condition}
  ...                    ${ML_Listing_Img.format('${AdsId}')}                   xpath://*[starts-with(@id,'listing-${AdsId}')]//*/img
  Set Test Variable      ${IMG_ELEMENT}                                         ${ListingIMG}
  FOR  ${INDEX}  IN RANGE   0   5
    ${STATUS}              Run Keyword And Return Status    Wait Until Page Contains Element
    ...                    ${IMG_ELEMENT}                   timeout=10s
    Exit For Loop If       ${STATUS}
    Reload Page
  END
  Run Keyword If         not ${STATUS}      Fail                                        Page Should Contain Element IMG_ELEMENT
  Wait Until Keyword Succeeds    4x   1s    Get Image Source
  Run Keyword Unless                        ${NoPlaceHolder} and ${NoEmpty}             Fail    Should Not Contain placeholders or empty
  ${SRC}                                    SeleniumLibrary.Get Element Attribute       ${IMG_ELEMENT}        src
  Set Test Variable                         ${SRC}
  ${cdn_checker}                            Run Keyword And Return Status               Should Contain        ${SRC}            cdn.mielse.com
  ${IMG_DOMAIN}                             Set Variable If                             ${cdn_checker}        cdn.mielse.com    ${EXACTDOMAIN}
  ${img}                                    Fetch From Right                            ${SRC}                ${IMG_DOMAIN}
  Set Test Variable                         ${IMG_DOMAIN}
  Set Test Variable                         ${img}

Get Image Source
  FOR  ${INDEX}  IN RANGE                  5
    # ${IMG_ELEMENT}                          Set Variable                             //*[starts-with(@id,'listing-${AdsId}')]//*/img
    Wait Until Page Contains Element       ${IMG_ELEMENT}                            timeout=5s
    Wait Until Keyword Succeeds            5x   2s                                   SeleniumLibrary.Get Element Attribute     ${IMG_ELEMENT}    src
    ${img src}                             SeleniumLibrary.Get Element Attribute     ${IMG_ELEMENT}                            src
    ${NoPlaceHolder}                       Run Keyword And Return Status             Should Not Contain                        ${img src}        placeholders
    ${NoEmpty}                             Run Keyword And Return Status             Should Not Contain                        ${img src}        empty
    Exit For Loop If                       ${NoPlaceHolder} and ${NoEmpty}
    Reload Page
    Sleep                                  3s
  END
  Set Test Variable                         ${NoPlaceHolder}
  Set Test Variable                         ${NoEmpty}
  # Set Test Variable                         ${IMG_ELEMENT}

Check Image Filter
    [Arguments]                   ${LastURL}
    Click Link                    جستجوهای پیشنهادی
    ${resultA}                    Get Text      //*[@id="pagination"]/ul/li/strong[3]
    go to                         ${LastURL}&wi=1&qawi
    BuiltIn.Sleep                 5s
    Click Link                    جستجوهای پیشنهادی
    ${resultB}                    Get Text      //*[@id="pagination"]/ul/li/strong[3]
    Should Not Be Equal           ${resultA}    ${resultB}

Submit post listings
    [Arguments]                   ${LoggedIn}      ${Edited}=${FALSE}
    FOR    ${INDEX}               IN RANGE    1    6
      ${SubmitStatus}             Run Keyword And Return Status    Handle Submit listing         ${LoggedIn}   ${Edited}
      Set Test Variable           ${SubmitStatus}
      Exit For Loop If            ${SubmitStatus}
    END
    Check Backend Errors          failure=${TRUE}
    run Keyword Unless            ${SubmitStatus}      Fail    Can not submit    PostListing

Handle Submit listing
    [Arguments]                    ${LoggedIn}              ${Edited}=${FALSE}
    Wait Until Keyword Succeeds    2x    3s                 Click Element              ${Ad_Registration_Button}
    Run Keyword If                 ${IMGcount} == ${0}      Handle Submit Listing Without Image
    Wait Until Page Is Loaded
    Validate Submit Listing        ${LoggedIn}              ${Edited}

Handle Submit Listing Without Image
    ${status}         Run Keyword And Return Status    Wait Until Page Contains Element
    ...               ${Submit_Without_Img_Popup}      timeout=5s
    Run Keyword If    ${status}                        Click Button                       ${PL_Without_Img}

Validate Submit Listing
    [Arguments]                         ${LoggedIn}                       ${Edited}=${FALSE}
    Page Should Not Contain             ${Auth_Complete_Field_Val_Msg}
    Page Should Not Contain Element     ${PL_Upload_Img}
    Run Keyword If                      ${LoggedIn}
    ...                                 Handle Secure Purchase Process
    # Page Should Not Contain         این فیلد اجباریست
    ${validator}                    Set Variable If
    ...                             ${Edited}                             ویرایش شد
    ...                             ${LoggedIn}                           ${post_listing_paid_message}
    ...                             ${Auth_Title_Listing_Login_Page}
    # ${Done}                         Run Keyword And Return Status        Page Should Contain                ${validator}
    ${Done}                         Run Keyword And Return Status          Wait Until Page Contains           ${validator}      timeout=5s
    Run Keyword unless              ${Done}                              Validate Other Cases

Validate Other Cases
    ${Done}                        Run Keyword And Return Status        Page Should Contain         ${listing_actived_approved_paid_feature_title_web}
    Check Listing Limit is Reached
    Run Keyword unless              ${Done}                              should be true               ${Limited}

Handle Secure Purchase Process
    Run Keyword If                         ${show_sp_popup}                  Handle Secure Purchase Popup
    IF                                     ${sp_required}
      Set Info To Active SecurePurchase For Listing
    END

Handle Secure Purchase Popup
    Check Secure Purchase PopUp Is Open
    IF                                     ${sp_required}
      Activate Secure Purchase For Listing In Secure Purchase Popup
    ELSE
      Close Secure Purchase Popup
    END

Check Secure Purchase PopUp Is Open
    Wait Until Page Contains Element      ${SP_Activation_Btn_Popup}                           timeout=10s
    Page Should Contain                   با تبدیل آگهی خود به "خرید امن" سریع‌تر بفروشید.
    Page Should Contain                   فعال شدن قابلیت پرداخت اینترنتی برای آگهی شما
    Page Should Contain                   حمل و نقل کالا توسط پیک شیپور
    Page Should Contain                   بازگشت کالا در صورت بروز هر گونه مشکل
    Page Should Contain                   نمایش آگهی در سراسر ایران

Activate Secure Purchase For Listing In Secure Purchase Popup
    Go To Enable Secure Purchase Page

Go To Enable Secure Purchase Page
    Click Element                         ${SP_Activation_Btn_Popup}
    Wait Until Page Contains              ${SP_Form}                                           timeout=10s

Close Secure Purchase Popup
    Click Button                         فعلا نه

Verify Advertise By ID in trumpet
    Run Keyword And Ignore Error         Login Trumpet Admin Page
    Go to                                ${SERVER}/trumpet/listing/moderation?AdsId=${AdsId}
    Wait Until Page Contains             شناسه آگهی: ${AdsId}    timeout=10s
    # Check Backend Errors                 failure=${TRUE}
    Click Button                         تایید
    ${confirmed}                         Is Confirm Button Worked?
    Run Keyword If                       '${confirmed}' == 'False'     Fail    msg=Can not confirm listing

Check My Listing Image Count
  [Arguments]                            ${Desired_IMG_Count}
  # Listing Must Be On Check State
  Assert an image is visible
  ${ImgNo}                               Convert Digits    ${Desired_IMG_Count}   En2Fa
  ${PIC_NOS}                             get Text          ${ML_Listing_Img_Count.format('${AdsId}')}
  Should Contain                         ${PIC_NOS}        ${ImgNo}

Change Serp sort
  [Arguments]                            ${Value}
  Select From List by value              xpath://*[@id="serp-intro"]//select    ${Value}
  Wait Until Keyword Succeeds            5x    1s     Validate list change       ${Value}
  Sleep                                  3s    reason=${None}

capture custom screenshots
  # Capture Page Screenshot                ${Browser_Name}_${TEST_NAME}_{index:03}.png
  Capture Page Screenshot                  EMBED


Is Post Listing Loaded
  FOR    ${INDEX}                         IN RANGE    1    6
    Wait Until Page Loading Is Finished
    ${DescStatus}                         Run Keyword And Return Status      Wait Until Page Contains Element     ${PL_Desc_Field}         timeout=10s
    ${ImgStatus}                          Run Keyword And Return Status      Page Should Contain Element          ${image_holder}
    Exit For Loop If                      ${DescStatus} and ${ImgStatus}
    Execute Javascript                    location.reload()
    Sleep                                 1s
  END

Validate list change
   [Arguments]      ${Value}
   ${Sort}          Get Selected List Value     xpath://*[@id="serp-intro"]//select
   Should Be Equal    ${Sort}  ${Value}
   Wait Until Page Is Loaded

Add zaleniumMessage Cookie
  [Arguments]           ${message}
  Run Keyword If   '${REMOTE_TEST}' == 'Grid'    Add Cookie      zaleniumMessage    ${message}

Click By Xpath
  [Arguments]              ${Class}       ${Text}
  Click Element            //span[@class='${Class}' and contains(text(), '${Text}')]

Click By Data Test ID
  [Arguments]              ${dti}       ${Text}
  Click Element            //*[@data-test-id='${dti}' and contains(text(),'${Text}')]

Click By Text
  [Arguments]              ${Text}
  Click Element            //*[contains(text(),'${Text}')]

# Check an image is optically visible
#     [Arguments]                                ${IMG_ELEMENT}
#     ${imageSRC}                                SeleniumLibrary.Get Element Attribute       ${IMG_ELEMENT}  src
#     Page Should Contain Image                  ${imageSRC}
#     Should Not Contain                         ${imageSRC}                                 placeholders
#     Element should be visible                  ${IMG_ELEMENT}
#     ${img}                                     Fetch From Right                            ${imageSRC}             ${SERVER}
#     Create API Context
#     ${resp}         GET On Session             ${EXACTDOMAIN}                              ${img}
#     Should Be Equal As Strings	               ${resp.status_code}	                       200
#
# Check an image is optically visible By Source
#     [Arguments]                                ${imageSRC}
#     Create API Context
#     ${resp}         GET On Session             ${EXACTDOMAIN}                               ${imageSRC}
#     Should Be Equal As Strings	               ${resp.status_code}	                        200


Search Some Keywords
    [Arguments]                           ${query}
    FOR    ${INDEX}                       IN RANGE    1   4
      Input Text                          name=q      ${query}
      Press Keys	                        name=q    	RETURN
      Wait Until Page Is Loaded
      ${status}                           Run Keyword And Return Status              Page Should Contain     نتایج جستجو برای ${query}
      Continue For Loop If                not ${status}
      ${count}                            SeleniumLibrary.Get Element Count          ${Serp_All_L_Title}
      ${status}                           Run Keyword And Return Status              Should Be True  ${count} > 0
      Exit For Loop If                    ${status}
    END
    Run Keyword Unless                    ${status}                                  Page Should Contain        متاسفانه نتیجه‌ای پیدا نشد

Search Listing
    [Arguments]                           ${title}
    FOR    ${INDEX}                       IN RANGE    1   4
      Input Text                          name=q    ${title}
      Press Keys	                        name=q  	RETURN
      Wait Until Page Is Loaded
      ${status}                           Run Keyword And Return Status                  Page Should Contain     نتایج جستجو برای ${title}
      Continue For Loop If                not ${status}
      ${element}                          Get WebElement                                 ${Serp_All_L_Title}
      ${result}                           Get Text    ${element}
      ${status}                           Run Keyword And Return Status                  Should Be Equal    ${result}   ${title}
      Exit For Loop If                    ${status}
      Sleep                               1s
    END
    Run Keyword Unless                    ${status}                                      Page Should Contain        متاسفانه نتیجه‌ای پیدا نشد

Set Cat Listing Limit
    [Arguments]                           ${Cat}                    ${Subcat}           ${Listing_Limit}=30     ${Limit_price}=10000
    Mock Listing Limit Set                ${Limit_price}            ${Listing_Limit}    ${Cat}                  ${Subcat}
    Set Test Variable                     ${LIMIT_LISTING}          ${TRUE}

# Set Listing Limit In Admin
#     Go To                                 ${SERVER}/trumpet/listing-limitation
#     Wait Until Page Contains Element      name=CategoryId                timeout=5
#     Select From List By Value             name=CategoryId                ${CatID}
#     Wait Until Keyword Succeeds           3x    1s                       Click Element                   id:limitation-reset
#     Select From List By Value             name=CategoryId                ${CatID}
#     Wait Until Page Contains Element      name=LimitationCount           timeout=5
#     Sleep      500ms
#     input text                            name=LimitationCount           ${Listing_Limit}
#     Clear Element Text                    name=LimitationPrice
#     input text                            name=LimitationPrice           ${Limit_price}
#     Press Keys	                          name=LimitationPrice  	       RETURN
#     Select From List By Value             name=RegionId                  ${State}
#     Select From List By Value             name=CityId                    ${City}
#     Select From List By Value             name=NeighborhoodId            ${Region}
#     Click By Css Selector                 [value="اعمال محدودیت"]


Listing Must Not Be On Check State
    Run Keyword If    	                 ${Toggle_paid-features-bumps}         Validate Page Is In PF view
    Run Keyword If                       ${in_Bump_Pf_view}                    go to             ${SERVER}/session/myListings
    FOR  ${INDEX}   IN RANGE    0   5
      ${passed}                          Run Keyword And Return Status         Page Should Contain Element     ${ML_Listing_Status.format('${AdsId}')}
      Exit For Loop If                   ${passed}
      Execute Javascript                 location.reload()
      Sleep   1s
    END
    Run Keyword If     ${passed}         Fail      duplicate or Banned listing is in my listing :${AdsId}
    # Element Should Contain    ${ML_Listing_Status.format('${AdsId}')}    در حال بررسی
    # Element Should not Contain               ${ML_Listing_Title.format('${AdsId}')}           ${Title_Words}

Refresh Varnish
    ${Value}                              Generate Random String            12  [LOWER]
    ${Key}                                Generate Random String            4  [LOWER]
    ${URL}                                Get Location
    ${hasParam}                           Run Keyword And Return Status     Should Contain    ${URL}    ?
    ${Connector}                          Set Variable If    ${hasParam}    &     ?
    go to                                 ${URL}${Connector}${Key}=${Value}
    Wait Until Page Is Loaded

Convert Number To Price
    [Arguments]                           ${Price}            ${seperator_char}=,
    ${separator_price}                    Evaluate            f'{${Price}:,}'
    ${separator_price}                    Convert Digits      ${separator_price}   En2Fa
    ${separator_price}                    Evaluate            "${separator_price}".replace(",","${seperator_char}")
    [Return]                              ${separator_price}

Go To Serp Page
    Click Link                            ${AllAdvs}
    Wait Until Page Contains              ${IranAllH1}

Go To Listing Details Page
    [Arguments]                           ${ad_id}=${AdsId}
    Go To                                 ${SERVER}/${ad_id}
    Wait Until Page Contains Element      ${LD_Seller_Details}                  timeout=15s

Go To My Profile Page
    Go To                                 ${SERVER}/session/my-profile
    Wait Until Page Contains Element      ${P_Section}                          timeout=15s

Change Profile Name
    [Arguments]                           ${Profile_Name}
    Go to                                 ${SERVER}/session/profile
    Wait Until Page Contains Element      ${P_E_Section}                        timeout=10s
    Input Text                            ${P_E_Input_Name}                     ${Profile_Name}
    Submit Profile Info Changes

Submit Profile Info Changes
    Click Button                          ${P_E_Submit_Btn}
    Wait Until Page Contains Element      ${P_E_Success_Msg}                    timeout=5s
    Element Should Contain                ${P_E_Success_Msg}                    ${Edit_Profile_Success_Msg}

########################################## Post Listing #####################################################################
Post A New Random Listing
    [Arguments]                           ${phone_number}=${EMPTY}
    IF                                   '${phone_number}' == '${EMPTY}'
        Mobile Generator A
        ${phone_number}                   Set Variable                          ${Random_User_Mobile_A}
    END
    ${AdsId}   ${random_listing}          Post A Random Listing In Background   ${phone_number}
    Set Test Variable                     ${AdsId}
    Set Test Variable                     ${random_listing}
    Verify Advertise By ID
    
############################################################################

Post A New Listing
    [Arguments]           ${pictures_count}               ${cat_id}                 ${subCat_id}                     ${brand_id}=${EMPTY}
    ...                   ${state}=17                     ${city}=647               ${region}=4019                   ${model}=${EMPTY}
    ...                   ${model_id}=${EMPTY}            ${model_type}=${EMPTY}    ${title_description}=${FALSE}    ${title_words}=${FALSE}
    ...                   ${hide_seller_phone}=${FALSE}   ${logged_in}=${TRUE}      ${tel}=${EMPTY}
    ...                   ${submit}=${TRUE}
    ############################  Set All Arguments As Test Variables  ###############################
    Comment               Set All Arguments As Test Variables
    Set Test Variable     ${pictures_count}
    Set Test Variable     ${cat_id}
    Set Test Variable     ${subCat_id}
    Set Test Variable     ${brand_id}
    Set Test Variable     ${state}
    Set Test Variable     ${city}
    Set Test Variable     ${region}
    Set Test Variable     ${model}
    Set Test Variable     ${model_id}
    Set Test Variable     ${model_type}
    Set Test Variable     ${title_description}
    Set Test Variable     ${title_words}
    Set Test Variable     ${hide_seller_phone}
    Set Test Variable     ${logged_in}
    Set Test Variable     ${tel}
    ############################################################################
    Filling Post Listing Form
    Run Keyword If        ${logged_in}    Validate Seller Phone Number
    Run Keyword If        ${submit}       Submit Post Listings    ${logged_in}

Filling Post Listing Form
    Get Random Listing
    Set Cat And SubCat
    Run Keyword Unless   '${brand_id}' == '${EMPTY}'      Select The Brand
    ${is_general}         Check That It Is In The General Category              ${cat_id}
    IF                    ${is_general}
      Fill General Category Fields
    ELSE
      Fill Non General Category Fields
    END
    Input Listing Title
    Input Listing Description
    Handle Price
    Set Listing Location
    Run Keyword Unless	  '${pictures_count}' == 'No-Image'    Attach Listing Image            ${pictures_count}          ${cat_id}

Set Cat And SubCat
    Open Cat PopUp
    Select The Cat
    Select The SubCat

Open Cat PopUp
    Click Element                       ${PL_Cats_Menu}
    Wait Until Page Contains Element    ${Open_Popup.format('${PL_Cats_Popup}')}          timeout=5s

Select The Cat
    Click Element                       css:${PL_Cat_Subcat_Selector}${cat_id}
    Wait Until Page Contains Element    ${PL_Second_Cat}                                  timeout=5s

Select The SubCat
    Click Element                       css:${PL_Cat_Subcat_Selector}${subCat_id}
    Wait Until Page Is Loaded

Select The Brand
    Wait Until Page Contains Element    class:mode-brand                                  timeout=5s
    Click Element                       css:${PL_Cat_Subcat_Selector}${brand_id}
    Wait Until Page Is Loaded

Fill General Category Fields
    Set New Used Attribute
    IF                                 '${cat_id}' == '43612'               #لوازم شخصی
      Fill Personal Goods Attrs
    END

Set New Used Attribute
    Open New Used PopUp
    Select Like New Status


Open New Used PopUp
    Wait Until Page Contains Element     ${PL_Status_Field}                     timeout=5s
    Click Element                        ${PL_Status_Field}                     # وضعیت
    Wait Until Page Contains Element     ${PL_Status_Field_Open}                timeout=5s

Select Like New Status
    Click Element                        ${PL_Att_Field_CSS.format(453188)}     #در حد نو
    Wait Until Page Is Loaded

Fill Personal Goods Attrs
    Run Keyword If                     '${subCat_id}' == '43613'            Set Goods Gender
    Run Keyword If                      ${hide_seller_phone}                Hide Seller Phone Number

Set Goods Gender
    Open Goods Gender PopUp
    Select Goods Gender

Open Goods Gender PopUp
    Open Post Listing Attribute PopUp    a68127

Select Goods Gender
    Click Element              ${PL_Att_Field_CSS.format('440457')}             #زنانه
    Wait Until Page Is Loaded

Hide Seller Phone Number
    Click Element              ${PL_Hide_Phone_Number}

Fill Non General Category Fields
    IF                                 '${subCat_id}' == '43627'            #خودرو
      Fill Car Attrs
    ELSE IF                            '${subCat_id}' == '43606'            #رهن و اجاره خانه و آپارتمان
      Fill Real RealEstate Attributes
    ELSE IF                            '${cat_id}' == '43618'               #استخدام
      Fill Hiring Attributes
    END

Fill Car Attrs
    Run Keyword Unless                 '${model}' == '${EMPTY}'           Set Car Model
    Run Keyword Unless                 '${model_type}' == '${EMPTY}'      Set Car Model Type
    Set Car Payment Type
    Input Car Production Year
    Input Car Travelled KMs
    Set Colour Of Car
    Set Car GearBox
    Set Fuel Type
    Set Car Body Condition

Set Car Model
    Open Car Model PopUp
    Select Car Model

Open Car Model PopUp
    Open Post Listing Attribute PopUp    ${model}

Select Car Model
    Click Element              ${PL_Att_Field_CSS.format('${model_id}')}
    Wait Until Page Is Loaded

Set Car Model Type
    Open Car Model Type PopUp
    Select Car Model Type

Open Car Model Type PopUp
    Open Post Listing Attribute PopUp    a88888

Select Car Model Type
    Click Element              ${PL_Att_Field_CSS.format('${model_type}')}
    Wait Until Page Is Loaded

Set Car Payment Type
    Open Payment Type PopUp
    Select Payment Type

Open Payment Type PopUp
    Open Post Listing Attribute PopUp    a69150

Select Payment Type
    Click Element              ${PL_Att_Field_CSS.format('445097')}             #نقدی
    Wait Until Page Is Loaded

Set Colour Of Car
    Open Colour Of Car PopUp
    Select Colour

Open Colour Of Car PopUp
    Open Post Listing Attribute PopUp    a69130

Select Colour
    Click Element              ${PL_Att_Field_CSS.format('445243')}             #سفید
    Wait Until Page Is Loaded

Set Car GearBox
    Open Car GearBox PopUp
    Select Car GearBox

Open Car GearBox PopUp
    Open Post Listing Attribute PopUp    a69140

Select Car GearBox
    Click Element              ${PL_Att_Field_CSS.format('445308')}             #دنده‌ای
    Wait Until Page Is Loaded

Set Fuel Type
    Open Fuel Type PopUp
    Select Fuel Type

Open Fuel Type PopUp
    Open Post Listing Attribute PopUp    a69602

Select Fuel Type
    Click Element              ${PL_Att_Field_CSS.format('450675')}             #بنزین
    Wait Until Page Is Loaded

Set Car Body Condition
    Open Car Body Condition PopUp
    Select Car Body Condition

Open Car Body Condition PopUp
    Open Post Listing Attribute PopUp    a69160

Select Car Body Condition
    Click Element              ${PL_Att_Field_CSS.format('445327')}             #یک لکه رنگ
    Wait Until Page Is Loaded

Input Car Production Year
    Input Text                 ${PL_Product_Year_Field}      1399

Input Car Travelled KMs
    Input Text                 ${PL_Kilometer_Field}         2500

Fill Hiring Attributes
    Set Education Level
    Set Contract Type
    Set Salary
    Set Gender

Set Education Level
    Open Education Level PopUp
    Select Education Level

Open Education Level PopUp
    Open Post Listing Attribute PopUp    a68221

Select Education Level
    Click Element              ${PL_Att_Field_CSS.format('442219')}             #کارشناسی
    Wait Until Page Is Loaded

Set Contract Type
    Open Contract Type PopUp
    Select Contract Type

Open Contract Type PopUp
    Open Post Listing Attribute PopUp    a68222

Select Contract Type
    Click Element              ${PL_Att_Field_CSS.format('442212')}             #تمام وقت
    Wait Until Page Is Loaded

Set Salary
    Open Salary PopUp
    Select Salary

Open Salary PopUp
    Open Post Listing Attribute PopUp    a69300

Select Salary
    Click Element              ${PL_Att_Field_CSS.format('450597')}             #توافقی
    Wait Until Page Is Loaded

Set Gender
    Open Gender PopUp
    Select Gender

Open Gender PopUp
    Open Post Listing Attribute PopUp    a69197

Select Gender
    Click Element              ${PL_Att_Field_CSS.format('445381')}             #مرد
    Wait Until Page Is Loaded

Open Post Listing Attribute PopUp
    [Arguments]                         ${attr}
    Wait Until Page Contains Element    css:${PL_Item_Form.format('${attr}')}            timeout=5s
    Click Element                       css:${PL_Item_Form.format('${attr}')}
    Wait Until Page Contains Element    ${Open_Popup.format('item-form-${attr}')}        timeout=5s

Handle Price
    ${PriceBase}                     Run Keyword And Return Status    Page Should Contain Element    ${PL_Form_Price}
    Run Keyword If                   ${PriceBase}                     Input Price

Input Price
    # ${HaveSuggestedPrice}            Run Keyword And Return Status    Page Should Contain            ${PL_Propos_Price_Txt}
    # Run Keyword If                   ${HaveSuggestedPrice}            Get Suggested Price
    # ...  ELSE                        Set Price Value
    Set Price Value
    Input Text                       ${PL_Form_Price}                ${Price}

Set Price Value
    ${LivePrice}                     Run Keyword And Return Status    Variable Should Exist          ${Listings_price}
    ${Price}                         Set Variable If                  ${LivePrice}                   ${Listings_price}      50000000
    Set Test Variable                ${Price}                         ${Price}

Validate Seller Phone Number
    Element Attribute Value Should Be   ${PL_Form_Telephone}          value              ${tel}

Set Listing Location
    ${loc_field_text}          SeleniumLibrary.Get Element Attribute    ${PL_Loc_Menu}    text
    IF                         '${loc_field_text}' == 'انتخاب کنید'
      Open Location Popup
      Select The State
      Select The City
      Set The Region
    ELSE
      Validate Selected Loc      ${loc_field_text}
    END

Validate Selected Loc
    [Arguments]                  ${loc}
    ${loc}                       Split String                ${loc}                     ${SPACE}>${SPACE}
    ${loc_length}                Get Length                  ${loc}
    IF                          '${loc_length}' == '${3}'
      ${loc_id}                  Get Location Object         location=${loc}[0]         city=${loc}[1]          district=${loc}[2]     id=${TRUE}
      Should Be Equal           '${loc_id}'                 '${region}'
    ELSE
      ${loc_id}                  Get Location Object         location=${loc}[0]         city=${loc}[1]          id=${TRUE}
      Should Be Equal           '${loc_id}'                 '${city}'
      Element Attribute Value Should Be                      ${PL_Region_Field}         value                   ${region}
    END

Open Location Popup
    Click Element                       ${PL_Loc_Menu}
    Wait Until Page Contains Element    ${Open_Popup.format("${PL_Loc_Popup}")}          timeout=5s

Select The State
    Click Element                       ${PL_Loc_State.format("${state}")}
    Wait Until Page Contains Element    ${PL_City_Popup}                                 timeout=5s

Select The City
    Click Element                       ${PL_Loc_City.format("${city}")}

Set The Region
  ${region_popup}                Run Keyword And Return Status     Page Should Contain Element     ${PL_Region_Popup}
  IF                             ${region_popup}
    Select The Region
  ELSE
    Input Region
  END

Select The Region
    Click Element                ${PL_Loc_Region.format("${region}")}

Input Region
    Wait Until Page Contains Element           ${PL_Region_Field}               timeout=3s
    Input Text                                 ${PL_Region_Field}               ${region}
