*** Settings ***
Variables           ../variables/ProVars.py
Variables           ../variables/Variables.py
Resource            ../../resources/resource.resource
Library             SeleniumLibrary          timeout=10s      run_on_failure=capture custom screenshots
Library             DateTime
Library             Sheypoor             platform=web            env=${trumpet_prenv_id}         general_api_version=${general_api_version}    ServerType=${ServerType}

*** Variables ***
# ${Rejection_Reason}                      گروه بندی اشتباه
# ${Deletion_Reason}                       محتوا یا شرح نامناسب
${NPM_not_done}                            ${TRUE}
${Province_Id}                             8                                    #تهران
@{Cities_Id}                               293         301         295          #آبسرد, تهران, باغستان
@{Districts_Id}                            n5316       n3571                    #پیروزی, پرستار
${Submit_Location_Button}                  choose-selectedItems

*** Keywords ***
Open test browser
    Set Log Level            TRACE
    Setup Initial Env
    Set Desired Capabilities
    IF    '${NameOfBrowser}' == 'firefox'
        Open browser             about:about       browser=${Browser_Name}  remote_url=${remote_url}   desired_capabilities=${desired_caps}
    ELSE
        Set Chrome Options
        Open browser             about:${EMPTY}    browser=${Browser_Name}  remote_url=${remote_url}   desired_capabilities=${desired_caps}    options=${options}
    END
    Maximize Browser Window
    Go To      ${SERVER}/pro
    Wait Until Page Contains            با ثبت نام در شیپور از مزایای کسب و کار اینترنتی بهره‌مند شوید      timeout=10s



Setup Initial Env
    Set Test Variable        ${testFileNameTemplate}                ProTools_{testName}_{browser}_${Round}
    ${videoPattern} 	       Replace String Using Regexp            ProTools_${TEST NAME}_${SUT_NAME}_${NameOfBrowser}_${Round}	 ${SPACE}	 _
    ${videoPattern} 	       Remove String                          ${videoPattern}	        (	   )
    Set Test Variable        ${testVideoNAme}                       ${videoPattern}
    ${isheadless}            Set Variable If                        '${HEADLESS}' == 'Yes'    headless    ${EMPTY}
    Set Suite Variable       ${isheadless}
    ${RecordVideoChecker}    Set Variable If                        '${RecordV}' == 'Yes'     ${TRUE}    ${FALSE}
    Set Suite Variable       ${RECORDVIDEO}                         ${RecordVideoChecker}
    Set Suite Variable       ${Browser_Name}                        ${isheadless}${NameOfBrowser}
    ${remote_url}            Set Variable If                       '${REMOTE_TEST}' == 'Grid'          ${PROOTOOLS_URL}      ${FALSE}
    Set Suite Variable       ${remote_url}


Set Desired Capabilities
    &{desired_caps}   Create Dictionary    name=${TEST NAME}_${SUITE NAME}     build=${build}                 idleTimeout=90
    ...   recordVideo=${RECORDVIDEO}       cssSelectorsEnabled=${true}         javascriptEnabled=${true}
    ...   screenResolution=1920x1080       tz=Asia/Tehran                      testFileNameTemplate=${testVideoNAme}
    Set Suite Variable                     ${desired_caps}


Set Chrome Options
    ${prefs}                 Create Dictionary                                  profile.password_manager_enabled=${FALSE}
    ...                      credentials_enable_service=${FALSE}
    ${options}               Catenate      SEPARATOR=
    ...                      add_experimental_option("prefs", ${prefs});
    ...                      add_experimental_option("excludeSwitches", ['enable-automation']);
    ...                      add_argument("test-type");
    ...                      add_argument("--disable-infobars");
    ...                      add_argument("--start-maximized");
    ...                      add_argument("--no-first-run");
    ...                      add_argument("--disable-notifications");
    ...                      add_argument("--disable-translate");
    ...                      add_argument("--disable-physical-keyboard-autocorrect");
    ...                      add_argument("--disable-virtual-keyboard-overscroll");
    ...                      add_argument("--disable-new-virtual-keyboard-behavior");
    ...                      add_argument("--no-sandbox");
    ...                      add_argument("--disable-setuid-sandbox");
    ...                      add_argument("--no-default-browser-check");
    ...                      add_argument("--enable-features\=NetworkServiceInProcess");
    ...                      add_argument("--dns-prefetch-disable");
    ...                      add_argument("--disable-dev-shm-usage");
    ...                      add_argument("--disable-cache");
    ...                      add_argument("--disable-application-cache");
    ...                      add_argument("--disable-offline-load-stale-cache");
    ...                      add_argument("--disk-cache-size\=0");
    ...                      add_argument("--log-level\=3");
    ...                      add_argument("--aggressive-cache-discard");
    ...                      add_argument("--window-size\=1920,1080")
    Set Suite Variable       ${options}



Open Chrome With Options
  [Documentation]  Starts a Chrome browser with specified setting.
  ${prefs}         Create Dictionary            profile.default_content_setting_values.notifications=1
  ${co}          Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys,selenium.webdriver
  Run Keyword If    '${isheadless}' == 'headless'      Call Method    ${co}    add_argument    --headless
  Call Method    ${co}    add_argument    test-type
  Call Method    ${co}    add_argument    --disable-infobars
  Call Method    ${co}    add_argument    --start-maximized
  Call Method    ${co}    add_argument    --no-first-run
  Call Method    ${co}    add_argument    --disable-notifications
  Call Method    ${co}    add_argument    --disable-translate
  Call Method    ${co}    add_argument    --disable-physical-keyboard-autocorrect
  Call Method    ${co}    add_argument    --disable-virtual-keyboard-overscroll
  Call Method    ${co}    add_argument    --disable-new-virtual-keyboard-behavior
  Call Method    ${co}    add_argument    --no-sandbox
  Call Method    ${co}    add_argument    --disable-setuid-sandbox
  Call Method    ${co}    add_argument    --no-default-browser-check
  Call Method    ${co}    add_argument    --enable-features\=NetworkServiceInProcess
  Call Method    ${co}    add_argument    --dns-prefetch-disable
  Call Method    ${co}    add_argument    --disable-dev-shm-usage
  Call Method    ${co}    add_argument    --disable-cache
  Call Method    ${co}    add_argument    --disable-application-cache
  Call Method    ${co}    add_argument    --disable-offline-load-stale-cache
  Call Method    ${co}    add_argument    --disk-cache-size\=0
  Call Method    ${co}    add_argument    --log-level\=3
  Call Method    ${co}    add_argument    --aggressive-cache-discard
  Call Method    ${co}    add_argument    --window-size\=1920,1080
  Call Method    ${co}    add_experimental_option    prefs   ${prefs}
  ${caps}                 Call Method   ${co}   to_capabilities
  Set To Dictionary       ${caps}   name=${TEST NAME}_${SUT_NAME}   build=${build}
  ...  idleTimeout=90  recordVideo=${RecordV}     cssSelectorsEnabled=${true}   recordVideo=${RECORDVIDEO}
  ...  javascriptEnabled=${true}   screenResolution=1920x1080    tz=Asia/Tehran  testFileNameTemplate=${testFileNameTemplate}
  Run Keyword If  '${REMOTE_TEST}' == 'Local'   Create Webdriver  Chrome  desired_capabilities=${caps}
  Run Keyword If   '${REMOTE_TEST}' == 'Grid'   Create Webdriver  Remote  command_executor=${PROOTOOLS_URL}    desired_capabilities=${caps}
  Go to       about:

Login To ProTools
    [Arguments]                         ${Phone}=${Shop_owner_phone}                    ${Category}=alounak
    Validate Click By Name is Done      ${Category}                                     شما موافقت‌نامه کاربری آن را پذیرفته‌اید.
    Validate Click By Name is Done      intro-action                                    شماره شما به عنوان شناسه کاربری
    Input Text                          name:cellphone                                  ${Phone}

    Validate Click By Name is Done      submit                                          لطفا کد چهار رقمی ارسال شده به شماره
    Wait Until Keyword Succeeds         3x  2s    Input SMS Verify Code                 ${Phone}
    ${pin-submit-action}                Set Variable                                    //*[@name='submit']/span[text()='تایید']
    Validate Click By Xpath is Done     ${pin-submit-action}                            مدیریت آگهی‌ها
    Validate Click By Name is Done      edit-profile-action                             اطلاعات شخصی
    ${profile_Name}                     FakerLibrary.Name
    Input By Name                       name                                            ${profile_Name}
    ${Phone}                            Convert Digits                                  ${Phone}       En2Fa
    Textfield Value Should Be           name:phonenum                                   ${Phone}
    ${elements}                         Get WebElements                                 name:choose-image-action
    Click Element                       ${elements}[1]
    Choose File                         name:pick-image                                ${CURDIR}/qa2.png
    Click By Name                       accept-crop
    Wait Until Page Contains            عکس شما با موفقیت ثبت شد، پس از بررسی توسط ادمین نمایش داده می‌شود       timeout=10s
    Set The Work Location Range
    Click By Name                       ${SUBMIT_FILE}
    Wait Until Keyword Succeeds         3x  2s    Check Does Not Exist Profile Info Errors
    Wait Until Page Contains            سطح‌بندی                                         timeout=15s
    Run Keyword And Ignore Error        Close Secure Popup

Check Does Not Exist Profile Info Errors
    Page Should Not Contain             نام خود را وارد کنید
    Page Should Not Contain             لطفا حداقل ۳ حرف وارد کنید
    Page Should Not Contain             محدوده‌ی کاری خود را وارد کنید

Set The Work Location Range
    Open Location Popup
    Select The Province
    Select The Cities

Open Location Popup
    Click By Name                       locations-trigger
    Wait Until Page Contains Element    name:locations-0                        timeout=10s


Select The Province
    Click By Name                       ${Province_Id}
    Wait Until Page Contains Element    name:locations-1                        timeout=10s

Select The Cities
    FOR       ${City}       IN          @{Cities_Id}
        ${City_Checkbox}                    Set Variable                        xpath://*[@name='${City}']//*[@type='checkbox']
        Click By Name                       ${City}
        ${Existance_Checkbox}               Run Keyword And Return Status       Page Should Contain Element
        ...                                 ${City_Checkbox}
        Run Keyword If                      ${Existance_Checkbox}
        ...                                 Checkbox Should Be Selected         ${City_Checkbox}
        ...     ELSE                        Select The Districts
    END
    Submit The Work Location Range

Select The Districts
    Wait Until Page Contains Element            name:locations-2
    FOR     ${District}           IN            @{Districts_Id}
        ${District_Checkbox}                      Set Variable                  xpath://*[@name='${District}']//*[@type='checkbox']
        Click By Name                             ${District}
        Checkbox Should Be Selected               ${District_Checkbox}
    END
    ${Go_Back}                                  Set Variable                    xpath://*[@name="locations-2"]//*[@name="go-back"]
    Click Element                               ${Go_Back}
    Wait Until Page Does Not Contain Element    name:locations-2                timeout=2s

Submit The Work Location Range
    Click By Name                                    ${Submit_Location_Button}
    Wait Until Page Does Not Contain Element         name:locations-0

Close Secure Popup
    Wait Until Page Contains                    تبریک! شما به سطح              timeout=5s
    Wait Until Keyword Succeeds                 3x  2s    Click Button          name:close-action

Validate Click By Xpath is Done
    [Arguments]                         ${xpath}                 ${Passage}
    FOR       ${INDEX}    IN RANGE    0    3
      Run Keyword And Ignore Error      Click Element             ${xpath}
      ${Status}              Run Keyword And Return Status    Wait Until Page Contains     ${Passage}       timeout=10s
      Exit For Loop If       ${Status}
    END
    Run Keyword Unless        ${Status}      Fail    ${xpath} is not clicked or ${Passage} is not in page


Validate Click By Name is Done
    [Arguments]                         ${Name}                 ${Passage}
    FOR       ${INDEX}    IN RANGE    0    3
      Run Keyword And Ignore Error      Click By Name          ${Name}
      ${Status}              Run Keyword And Return Status    Wait Until Page Contains     ${Passage}       timeout=10s
      Exit For Loop If       ${Status}
    END
    Run Keyword Unless        ${Status}      Fail    ${Name} is not clicked or ${Passage} is not in page

Log Out Protools
    Click By Name                        ${LOGOUT}
    Wait Until Page Contains Element     ${REGISTER_BUTTON}                      timeout=10s
    Go to                                ${SERVER}/pro
    Wait Until Page Contains             با ثبت نام در شیپور از مزایای کسب و کار اینترنتی بهره‌مند شوید      timeout=10s

Create Shop And Login To Sheypoor
    Create Shop In Sheypoor
    Login To ProTools                   ${Shop_owner_phone}


Input Random Mobile
   ${Random_Number}            Generate Random String  7  [NUMBERS]
   Set Suite Variable          ${Random_User_Mobile}    0900${Random_Number}
   Input Text                  name:cellphone           ${Random_User_Mobile}


Input Mobile
   [Arguments]     ${User_Mobile}
   Wait Until Keyword Succeeds     3x  1s   Input Text    mobile    ${User_Mobile}

Input SMS Verify Code
   [Arguments]                               ${MobileNo}
   Get and validate Verification Code        ${MobileNo}
   FOR       ${INDEX}    IN RANGE    0    3
     ${Status}              Run Keyword And Return Status    Insert Code    ${Verification_Code}
     Exit For Loop If       ${Status}
   END

Insert Code
    [Arguments]                               ${characters}
    ${stripped}                               Strip String                  ${Verification_Code}
    ${characters}                             Split String To Characters    ${stripped}
    ${Entered_Code}                           Get Webelements               class:pincode-input-text
    ${Ch1} 	                                  Get From List	                ${characters}	0
    ${Ch2} 	                                  Get From List	                ${characters}	1
    ${Ch3} 	                                  Get From List	                ${characters}	2
    ${Ch4} 	                                  Get From List	                ${characters}	3
    Input Text                                ${Entered_Code}[0]            ${Ch1}
    Sleep    1s
    Input Text                                ${Entered_Code}[1]            ${Ch2}
    Sleep    1s
    Input Text                                ${Entered_Code}[2]            ${Ch3}
    Sleep    1s
    Input Text                                ${Entered_Code}[3]            ${Ch4}
    Sleep    1s

Title And Description Maker
    Get Random Live Listing
    Set Test Variable               ${Real_Description}      ${Random_Live_Listing['description']}
    Set Test Variable               ${Real_Title}            ${Random_Live_Listing['title']}

Click By Name
    [Arguments]                         ${option}
    ${element}                          Set Variable If
    ...                                 '${option}' == 'form-submit-action'     xpath://button[@type='submit' and @name='${option}']
    ...                                 name:${option}
    Wait Until Page Contains Element    ${element}                                                timeout=5s
    Click Element                       ${element}

Click By Text
    [Arguments]              ${Text}
    Click Element            //*[contains(text(),'${Text}')]

Click By Css Selector
    [Arguments]    ${Css_Selector}
    Wait Until Page Contains Element     css:${Css_Selector}                                          timeout=10s
    Wait Until Keyword Succeeds    3x    3s     Click Element    css:${Css_Selector}
    Sleep  300ms

Input By Name
    [Arguments]                         ${option}            ${text}
    Wait Until Page Contains Element    name:${option}                                                 timeout=10s
    Input Text         name:${option}       ${text}

Choose Location
    [Arguments]                         ${Province}           ${City}             ${District}
    Click By Name                       location-trigger
    Click By Name                       ${Province}
    Click By Name                       ${City}
    Click By Name                       ${District}

Choose Single Select Attributes
    [Arguments]                         ${Attribute}          ${name}
    Execute Javascript                  document.getElementsByName('${Attribute}')[0].parentElement.children[0].click()
    Sleep                               1s
    Click By Name                       ${name}

Choose Multi Select Attributes
    [Arguments]                         ${Attribute}          @{args}
    Click By Name                       ${Attribute}
    Sleep                               1s
    FOR           ${I}       IN        @{args}
       Click By Name                   ${I}
    END
    Click By Name                       select-add-action

Input Price
    [Arguments]                         ${Mortgage}=${EMPTY}      ${Rent}=${EMPTY}      ${Price}=${EMPTY}       ${Mortgage_Price}=${EMPTY}      ${Rent_Price}=${EMPTY}
    # ${Sale_Price}                       Run Keyword And Return Status    Element Should Be Visible    name:price
    ${Sale_Price}                       Run Keyword And Return Status    Page Should Contain Element    name:price
    ${Random_Price}                     FakerLibrary.Random Number      8    10
    Set Suite Variable                  ${Price}                        ${Random_Price}
    Run Keyword If                      ${Sale_Price}                   Input By Name      price        ${Price}
    ...  ELSE                           Input Rent Price                ${Mortgage}      ${Rent}        ${Mortgage_Price}       ${Rent_Price}

Input Rent Price
    [Arguments]                         ${Mortgage}      ${Rent}        ${Mortgage_Price}       ${Rent_Price}
    Input By Name                       ${Mortgage}                     ${Mortgage_Price}
    Input By Name                       ${Rent}                         ${Rent_Price}

Clear Textfield
    [Arguments]                         ${name}
    ${field text}                       Set Variable                     NO EMPTY STRING
    FOR    ${index}    IN RANGE         3
       Press Keys                       name:${name}                      CTRL+a+DELETE
       Wait For Condition               return window.document.readyState === "complete"       timeout=5s
       Wait Until Page Does Not Contain Element                           name:is-loading      timeout=5s
       Page Should Not Contain Element  name:clear-search
       Wait Until Page Contains Element                                   name:${name}         timeout=5s
       ${Status}   ${field text}        Run Keyword And Ignore Error      Get Value            name:${name}
       ${is_empty}                      Run Keyword And Return Status     Should Be Empty      ${field text}
       Exit For Loop If                 ${is_empty}
    END
    Run Keyword unless                  ${is_empty}                      Fail     can not clear element name:${name}

Get Listing Human Readable Id
    [Arguments]                         ${Listings_Item}=0       ${Category}=real-estate
    FOR    ${INDEX}    IN RANGE    0    4
      Go To             ${SERVER}/pro/${Category}/files
      ${status}         Run Keyword And Return Status   Reload Page To Find Element         file-item-${Listings_Item}
      Exit For Loop If    ${status}
    END
    Sleep    2s
    ${url}                              Get Element Attribute             name:file-item-${Listings_Item}     href
    ${human_readable_id}                Get Regexp Matches     ${url}     [\\/](\\d{8,10})     1
    Set Suite Variable                  ${human_readable_id}              ${human_readable_id}[0]
    [Return]                            ${human_readable_id}

Reload Page To Find Element
    [Arguments]                         ${name}
    FOR    ${INDEX}    IN RANGE    0    3
      Reload Page
      ${status}        Run Keyword And Return Status    Wait Until Page Contains Element   name:${name}    timeout=5s
      Exit For Loop If    ${status}
    END
    Run Keyword Unless                 ${status}                          Fail    Can not find ${name}

Reload Page To Find Text
    [Arguments]                         ${text}
    FOR    ${INDEX}                     IN RANGE    0    3
      Reload Page
      ${status}                         Run Keyword And Return Status     Wait Until Page Contains      ${text}   timeout=5s
      Exit For Loop If                  ${status}
    END
    Run Keyword Unless                 ${status}                          Fail    Can not find element

Set Test Payment Gateway
     [Arguments]                        ${Status}
     Add Cookie                         payment       ${Status}

Login Trumpet Admin Page
     ${User_Is_Loggedin}                Run Keyword And Return Status             Wait Until Page Contains Element    id:email     timeout=10s
     Run Keyword If	                    ${User_Is_Loggedin}                       Input Login Form

Input Login Form
    Input Text                          password    trumpet
    Input Text                          email       ${admin_user}
    Click Element                       css:button.btn.btn-primary
    Wait Until Page Contains            داشبورد

Upload Images
     [Arguments]                                                     ${Category}                             ${Image_Number}                    ${Listings_ListingID}=${NULL}
     Wait Until Page Contains                                        انتخاب عکس‌های آگهی                      timeout=10s
     ${Image_List}                                                   Select Images                           ${Category}                       ${Image_Number}    ${Listings_ListingID}
     ${Image_List}                                                   Convert To List                         ${Image_List}
     FOR            ${image}      IN                                 @{Image_List}
        Execute JavaScript                                           window.document.getElementsByName('${CHOOSE_IMAGE}')[0].value='${EMPTY}'
        Choose File                                                  name:${CHOOSE_IMAGE}                    ${image.file_path}
        Sleep                                                        2s
        Image Upload Loading
        ${status}                                                    Run Keyword And Return Status
        ...  Wait Until Page Does Not Contain Element                name:retry-upload-action                timeout=10s
        Run Keyword If    not ${status}                              Retry Reload Image                      ${Image_Number}
     END
     ${URL}                                                          Get Location
     ${Uploaded_Images_Count}                                        SeleniumLibrary.Get Element Count       name:form-delete-action
     ${isEdit}                                                       Run Keyword And Return Status           Should Contain                    ${URL}                      edit
     ${isPublished}                                                  Run Keyword And Return Status           Should not Contain                ${URL}                      published
     ${Uploaded_Images_Count}                                        Set Variable If    ${isEdit} and ${isPublished}         ${Uploaded_Images_Count - 1}      ${Uploaded_Images_Count}
     ${Image_Number}                                                 Convert To Integer                      ${Image_Number}
     Should Be Equal	                                               ${Uploaded_Images_Count}                ${Image_Number}

Retry Reload Image
    [Arguments]                                                      ${Image_Number}
    Wait Until Keyword Succeeds        3x      3s                    Reload Image                            ${Image_Number}

Reload Image
    [Arguments]                                                      ${Image_Number}
    ${Reload}                                                        Get Web Elements                        name:retry-upload-action
    FOR    ${INDEX}                  IN RANGE    0    ${Image_Number}
      Click Element                  ${Reload[${INDEX}]}
      ${status}                      Run Keyword And Return Status                 Wait Until Page Does Not Contain        name:retry-upload-action          timeout=5s
      Exit For Loop If              ${status}
      Run Keyword If                  not ${status}    Fail    Image can not be reloaded
    END

Image Upload Loading
    Wait Until Page Does Not Contain Element         name:image-upload-loading
    ...                          timeout=10s         error=Image can not be loaded

Choose Category
    [Arguments]                                                      ${category}                    ${SubCategory}=${EMPTY}
    Click By Name                                                    category-trigger
    Click By Name                                                    ${category}
    ${status}        Run Keyword And Return Status                   Wait Until Page Does Not Contain Element         name:go-back              timeout=5s
    Run Keyword If    '${status}' == 'False'                         Click By Name                                    ${SubCategory}
    Wait Until Page Does Not Contain Element                         name:go-back                                     timeout=5s

Input Note Book Info
    Create Phone Book Member
    Click By Name                                                    دفترچه شخصی
    ${name}            Run Keyword And Return Status                 Input By Name                                    a69533                ${Faker_Name}
    Run Keyword If    '${name}' == 'False'                           Input By Name                                    a75000                ${Faker_Name}
    ${phone}           Run Keyword And Return Status                 Input By Name                                    a69534                ${Faker_Phone_Number}
    Run Keyword If    '${phone}' == 'False'                          Input By Name                                    a75001                ${Faker_Phone_Number}
    ${Faker_Description}                                             FakerLibrary.Address
    Set Suite Variable                                               ${Faker_Description}
    ${desc}            Run Keyword And Return Status                 Input By Name                                    a69535                ${Faker_Description}
    Run Keyword If    '${desc}' == 'False'                           Input By Name                                    a75002                ${Faker_Description}
    Click By Name                                                    apply-action

Validate Advertise is Verified
    [Arguments]                                                      ${Category}=real-estate
    Get Listing Human Readable Id                                    0          ${Category}
    Verify Advertise By ID
    Go to                                                            ${SERVER}/pro/${Category}/listings
    Wait Until Page Does Not Contain Element                         name:is-loading                      timeout=15s
    Reload Page To Find Text                                         پذیرفته شد
    [Return]                                                         ${human_readable_id}

Verify Advertise By ID in trumpet
    Go to                                ${SERVER}/trumpet/listing/moderation?AdsId=${human_readable_id}
    Login Trumpet Admin Page
    Wait Until Page Contains             شناسه آگهی: ${human_readable_id}    timeout=10s
    Click Button                         تایید
    ${confirmed} =                       Is Confirm Button Worked?
    Run Keyword If    '${confirmed}' == 'False'     Fail    msg=Can not confirm listing

Is Confirm Button Worked?
    FOR    ${INDEX}    IN RANGE    1    50
       ${FormClass}=    SeleniumLibrary.Get Element Attribute    id:reviewForm_1  class
       ${passed} =	Run Keyword And Return Status   Should Contain  ${FormClass}  bg-success
       Exit For Loop If  ${passed}
       Click Button                         تایید
       BuiltIn.Sleep     200ms
    END
    [return]    ${passed}

Wait Until Page Is Loaded in Moderation
    Wait For Condition     return window.document.readyState === "complete"
    FOR    ${INDEX}    IN RANGE    1   11
       ${Loaded}    Execute Javascript    return window.jQuery.active == 0
       Exit For Loop If    ${Loaded}
       Sleep    500ms
    END

Reject Advertise By ID in trumpet
    Go to                                ${SERVER}/trumpet/listing/moderation?AdsId=${human_readable_id}
    Login Trumpet Admin Page
    Wait Until Page Contains             شناسه آگهی: ${human_readable_id}                      timeout=10s
    ${Rejection_Reason}                  Random Rejection Deletion Reasons                     ${human_readable_id}   rejection
    Select From List By Label            //select[contains(@data-bind,'rejectionReasons')]     ${Rejection_Reason}
    Click Button                         رد

Validate Advertise is Rejected
    Get Listing Human Readable Id
    Reject Advertise By ID in trumpet
    Go to                                                            ${SERVER}/pro/real-estate/files
    Reload Page To Find Text                                         رد شد
    [Return]                                                         ${human_readable_id}

Delete Advertise By ID in trumpet
    Go to                                ${SERVER}/trumpet/listing/moderation?AdsId=${human_readable_id}
    Login Trumpet Admin Page
    Wait Until Page Contains             شناسه آگهی: ${human_readable_id}                           timeout=10s
    ${Deletion_Reason}                   Random Rejection Deletion Reasons                          ${human_readable_id}   deletion
    Select From List By Label            //select[contains(@data-bind,'deletionReasons')]          ${Deletion_Reason}
    Click Button                         حذف

Validate Advertise is Deleted From Admin
    Get Listing Human Readable Id
    Delete Advertise By ID in trumpet
    Go to                                                            ${SERVER}/pro/real-estate/files
    Reload Page To Find Text                                         در اینجا فایل خود را ثبت و مدیریت کنید.

Delete Listing From Listing Management
    Click By Name                                                    ${DELETE}
    Wait Until Page Contains                                        از حذف این همکار اطمینان دارید؟
    Click By Name                                                    ${CONFIRM_ACCEPT}
    Wait Until Page Does Not Contain                                از حذف این همکار اطمینان دارید؟
    Wait Until Page Contains                                         لغو انتشار با موفقیت انجام شده است

Land Main Attribute For Rent
    Choose Single Select Attributes                                  ${LAND_PROPERTY_TYPE_MENU}      ${LAND_PROPERTY_TYPE}
    Input By Name                                                    ${AREA}     2000
    Input Price

Create New File
    [Arguments]                                                      ${Main_Attr_KeyWord}   ${Images_Count}=No-Image     ${Category_ID}=43604        ${Category_Name}=${EMPTY}   ${More_Detail_Attr_KeyWord}=${EMPTY}   ${Province}=${TEHRAN_PROVINCE}    ${City}=${TEHRAN}     ${District}=${ASEMAN_DISTRICT}       ${Random_ListingID}=${EMPTY}
    ${Random_ListingID}                                              Get Random Listing Attribute                         listingID                  ${Category_ID}
    Click By Name                                                    ${CREATE_NEW_FILE}
    Run Keyword If	                                                 '${Images_Count}' != 'No-Image'
    ...                                                              Upload Images                       ${Category_Name}    ${Images_Count}    ${Random_ListingID}
    Choose Category                                                  ${Category_ID}                      44118
    Choose Location                                                  ${Province}                         ${City}    ${District}
    Run Keyword                                                      ${Main_Attr_KeyWord}
    Run Keyword If	  '${More_Detail_Attr_KeyWord}' != '${EMPTY}'    ${More_Detail_Attr_KeyWord}
    Input Note Book Info
    Execute JavaScript                                               window.scrollTo(0,0)
    FOR    ${INDEX}    IN RANGE    3
      Run Keyword And Ignore Error                                   Click By Name                   ${SUBMIT_FILE}
      ${submitted}        Run Keyword And Return Status              Wait Until Page Contains         فایل شما با موفقیت ثبت شد            timeout=15s
      Exit For Loop If    ${submitted}
    END
    Run Keyword Unless   ${submitted}                                Fail    can not submit File

Create New Listing
    [Arguments]                                                      ${Main_Attr_KeyWord}    ${Images_Count}=No-Image     ${Category_ID}=43604    ${Category_Name}=${EMPTY}   ${More_Detail_Attr_KeyWord}=${EMPTY}   ${Province}=${TEHRAN_PROVINCE}    ${City}=${TEHRAN}     ${District}=${ASEMAN_DISTRICT}    ${phone_number}=${Shop_owner_phone}
    ${Listings_Title}                                                Get Random Listing Attribute                         title                   ${Category_ID}
    Set Suite Variable                                               ${Listings_Title}
    Create New File                                                  ${Main_Attr_KeyWord}    ${Images_Count}     ${Category_ID}    ${Category_Name}   ${More_Detail_Attr_KeyWord}   ${Province}    ${City}     ${District}
    Register Advertise                                               ${ADVERTISE_CREATED_FILE}
    Wait Until Page Does Not Contain                                 فایل شما با موفقیت ثبت شد
    Sleep    2s
    Clear Textfield                                                  name
    Input Text                                                       name                              ${Listings_Title}
    Input Text                                                       ${LISTING_DESCRIPTION}            ${Faker_Description}
    Handle Phone Number Field                                        ${phone_number}
    # Clear Textfield                                                  telephone
    # Input By Name                                                    telephone                         ${Faker_Phone_Number}
    Register Advertise                                               ${ADD_ACTION}
    Click By Name                                                    ${VIEW_LISTINGS_LIST}

Handle Phone Number Field
    [Arguments]                                                      ${expected_phone_number}
    ${phone_number}                                                  Get Value                                    name:telephone
    ${phone_number}                                                  Convert Digits                               ${phone_number}       Fa2En
    Should Be Equal                                                  ${expected_phone_number}                     ${phone_number}

Register Advertise
    [Arguments]                                                      ${Option}
    FOR    ${INDEX}    IN RANGE    5
      Click By Name                                                  ${Option}
      ${status}           Run Keyword And Return Status              Wait Until Page Does Not Contain Element     name:${Option}            timeout=5s
      Exit For Loop If    ${status}
    END

Create Some Listings
    [Arguments]                                                      ${Number}                            ${telephone}=${Shop_owner_phone}
    @{human_readable_ids}                                            Create List
    FOR    ${INDEX}    IN RANGE    0                                 ${Number}
      Create New Listing                                             Land Main Attribute For Rent    1    44099    house     phone_number=${telephone}
      ${human_readable_id}                                           Validate Advertise is Verified
      Append To List                                                 ${human_readable_ids}                   ${human_readable_id}
    END
    [Return]                                                         ${human_readable_id}

Create Some Files
    [Arguments]                                                      ${Number}
    @{human_readable_ids}                                            Create List
    FOR    ${INDEX}    IN RANGE    0                                 ${Number}
    Create New File                                                  Land Main Attribute For Rent    1    44099    house
    ${human_readable_id}                                             Validate File Is Registered
    Append To List                                                   ${human_readable_ids}                   ${human_readable_id}
    END
    [Return]                                                         ${human_readable_id}

Add New Colleague
    [Arguments]                                                      ${Role}                   ${Other_Role}
    Click By Name                                                    ${TEAM_MANAGEMENT_ITEM}
    Wait Until Page Contains                                         افزودن همکار جدید
    Click By Name                                                    ${ADD_NEW_MEMBER}
    Wait Until Page Contains                                         شماره همراه همکار
    Input Random Mobile
    Execute Javascript                                               ${role_drop_down}
    Click By Name                                                    ${Role}
    Wait Until Page Does Not Contain Element                         name:${Other_Role}
    Click By Name                                                    ${ADD_ACTION}
    Wait Until Page Contains Element                                 name:member-${Random_User_Mobile}

Delete Colleagues
    [Arguments]                                                      ${Random_User_Mobile}=${Random_User_Mobile}
    Click By Name                                                    member-${Random_User_Mobile}
    Click By Name                                                    menu-حذف
    Wait Until Page Contains                                         از حذف این همکار اطمینان دارید؟
    Click By Name                                                    ${CONFIRM_ACCEPT}
    Wait Until Page Contains                                         همکار با موفقیت حذف شد                       timeout=10s
    Wait Until Page Does Not Contain                                 همکار با موفقیت حذف شد                       timeout=10s
    Page Should Not Contain Element                                  name:member-${Random_User_Mobile}

Post Listing As a Diffrent Shop Member
    [Arguments]                                                      ${Agent_Num}       ${Listings_Num}     ${Agent_Phones}
    Log Out Protools
    Login To ProTools                                                ${Agent_Phones}[${Agent_Num}]
    ${human_readable_id}                                             Create Some Listings                   ${Listings_Num}       ${Agent_Phones}[${Agent_Num}]
    [Return]                                                         ${human_readable_id}

Create Phone Book Member
    ${Faker_Name}                                                    FakerLibrary.Name
    Set Suite Variable                                               ${Faker_Name}
    ${Faker_Phone_Number}                                            Generate Random String                           7             [NUMBERS]
    Set Suite Variable                                               ${Faker_Phone_Number}                            0218${Faker_Phone_Number}
    [Return]                                                         ${Faker_Name}

Validate File Is Registered
    [Arguments]                                                      ${Category}=real-estate
    Wait Until Page Contains                                         فایل شما با موفقیت ثبت شد
    Click By Name                                                    ${VIEW_FILES_LIST}
    Wait Until Page Does Not Contain                                 فایل شما با موفقیت ثبت شد
    Reload Page To Find Element                                      file-item-0
    Get Listing Human Readable Id                                    0          ${Category}

Delete Listing
    Click By Name                       delete-action
    Wait Until Page Contains            از انصراف اطمینان دارید؟                timeout=10s
    Click By Name                       ${CONFIRM_ACCEPT}
    Wait Until Page Does Not Contain    از انصراف اطمینان دارید؟                timeout=10s
    Wait Until Page Contains            لغو انتشار با موفقیت انجام شد           timeout=10s
    Wait Until Page Does Not Contain    لغو انتشار با موفقیت انجام شد           timeout=10s
    Reload Page To Find Text            در اینجا آگهی خود را ثبت و مدیریت کنید.

Click To Show Page
    [Arguments]                         ${Category}          ${Page}           ${Option}
    FOR    ${INDEX}    IN RANGE    0    3
      ${status}                   Run Keyword And Return Status                Click By Name                        ${Option}
      Exit For Loop If            ${status}
      Go to                       ${SERVER}/pro/${Category}/${Page}
    END
    Handle NPM

Handle NPM
    ${HasNpm}                      Run Keyword And Return Status               Wait Until Page Contains    چقدر احتمال دارد استفاده از آلونک را به دوستان یا همکاران خود توصیه کنید    timeout=3s
    Run Keyword If                 ${HasNpm} and ${NPM_not_done}               Click Element               //input[@type="radio" and @value=7]
    Run Keyword If                 ${HasNpm} and ${NPM_not_done}               Click Element               //button/span[text()="تایید "]
    Run Keyword If                 ${HasNpm} and ${NPM_not_done}               Set Test Variable           ${NPM_not_done}                             ${FALSE}


Clean Up Tests
    Run Keyword If Test Failed     On failure Setups
    Run Keyword If Test Passed     On Pass Setups
    Close All Browsers
    Final Grid Proccessing

On failure Setups
    Set Test Message               ${Browser_Name} 	append=yes
    Run keyword if                 '${REMOTE_TEST}' == 'Grid'       Add Cookie      zaleniumTestPassed    false
    # capture custom screenshots

On Pass Setups
    Set Test Message                ${Browser_Name} 	append=yes
    Run keyword if                  '${REMOTE_TEST}' == 'Grid'       Add Cookie       zaleniumTestPassed    true
    # capture custom screenshots

Final Grid Proccessing
    IF                             ${RECORDVIDEO}
      Set Test Variable            ${Values}                     [${PROOTOOLS_LOGS}/${build}/${testVideoNAme}.mp4 | ${testVideoNAme}.mp4]
      Set Suite Metadata           name=Watch Videos             value=${Values}  append=yes  top=False
      Set Test Message             ${Values}                     append=yes
    END


Expire Listing
    Create New Listing                                               Land Main Attribute For Rent    1    44099    house    District=n5364
    ${human_readable_id}                                             Validate Advertise is Verified
    Mock Listing Expire                                              2day       ${human_readable_id}
    Expired Listing Is Displayed In Inactive Tab

Expired Listing Is Displayed In Inactive Tab
    FOR    ${INDEX}    IN RANGE    0    10
      Click To Show Page                                               real-estate          listings        ${LISTINGS_LIST}
      Click By Name                                                    ${INACTIVE_TAB}
      ${Status}                                                        Run Keyword And Return Status        Wait Until Page Contains         منقضی شد
      Exit For Loop If                                                 ${Status}
    END

Input Car Main Attribute For Sale
    Choose Single Select Attributes     ${car_model_menu}                  ${car_model}
    Choose Single Select Attributes     ${selling_type_menu}               ${selling_type}
    Input By Name                       ${year}                            2020
    Input By Name                       ${km}                              10000
    Choose Single Select Attributes     ${color_menu}                      ${color}
    Choose Single Select Attributes     ${gearbox_menu}                    ${gearbox}
    Choose Single Select Attributes     ${fuel_type_menu}                  ${fuel_type}
    Choose Single Select Attributes     ${status_menu}                     ${status}
    Input Price

Input Car More Detail Attributes
    Click By Name                       افزودن جزئیات بیشتر
    Choose Single Select Attributes     ${internal_color_menu}             ${internal_color}
    Choose Single Select Attributes     ${car_tag_menu}                    ${car_tag}
    Wait Until Page Does Not Contain Element        name:450673            timeout=5s
    Click By Name                       ${ADD_ACTION}

capture custom screenshots
  Capture Page Screenshot                EMBED
