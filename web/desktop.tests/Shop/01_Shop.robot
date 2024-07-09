*** Settings ***
Documentation                      Shop functionality and Shop package
Test Setup                         Open Admin browser
Test Teardown                      Clean Up Tests
Resource                           ../../resources/setup.resource

*** Variables ***
${Working_Hours}                   شنبه تا چهارشنبه از 9 الی 18 و پنجشنبه از 9 الی 14
${Shop_Count}                      1
${Listing_Count}                   6
${c1}                              1
${c2}                              1
${c3}                              1
${c4}                              1
@{Listing_Ids}
@{SpecialAds}
${duration}                        30
${shopLimit}                       4
${bump_refresh}                    3
${refresh_top}                     3
${refresh_top_2x}                  1
${listing_limitation}              10
${instant_tag}                     5
${SpecialCount}                    3
${PaymentLink}                     //*[@id="shop-package-results-generic"]/tbody/tr/td[10]/a   #لینک پرداخت
${State}                            اردبیل
${City}                             اردبیل
${Region}                           لادان

*** Test Cases ***
Check Shop UI
    [Tags]                          shop
    Create shops
    Search And Validate Shop
    Go To New Shop Page And Validate Shop Details
    # Pass Execution                 Special ads has problem
    # Validate Shop Special Ads
    # Validate Shop limit
    # Validate Shop Details


*** Keywords ***
Create shops
    FOR  ${INDEX}   IN RANGE  0   ${Shop_Count}
       Create New shop
       Check Payment Link
       Enable Shop Package
       Fill Shop With Listing
       Set Special Ads
    END

Check Payment Link
    Click Link                               ساخت لینک پرداخت
    Wait Until Page Contains Element         Price                            timeout=5s
    Input Text                               Price                            10000
    Input Text                               NumberOfDays                     30
    Select From List By Label                id=GatewayAccount                حساب املاک
    Click Button                             css=.btn.btn-success
    ${status}                                Run Keyword And Return Status    Wait Until Page Contains            بانک تست                     timeout=5s
    Run Keyword If                           not ${status}                    Page Should Contain                 بانک سامان
    Page Should Contain                      عملیات با موفقیت انجام شد
    ${PaymentLink}                           get text                          //div[@class="alert alert-success"]/a
    Should Contain                           ${PaymentLink}                   ${SERVER}/session/payments/invoice/


Validate Shop Special Ads
    @{ShopAds}                               get WebElements                              //*[starts-with(@id,'listing')]
    FOR  ${i}  ${element}  IN ENUMERATE      @{ShopAds}
       ${ShopAdsID}                          SeleniumLibrary.Get Element Attribute         ${element}                              id
       ${ShopAdsID}                          Remove String                                 ${ShopAdsID}                            listing-
       Run Keyword If                        ${i} <= ${2}                                  Should Be Equal                         ${ShopAdsID}                  @{Listing_Ids}[${2-${i}}]
       Exit For Loop If                      ${i} > ${2}
    END

Validate Shop limit
    @{ShopAds}                                 get WebElements                              //*[starts-with(@id,'listing')]
    ${RemaingCount}                            Evaluate    ${shopLimit} - ${3}
    FOR    ${i}        IN RANGE              ${RemaingCount}
       ${ShopAdsID}                           SeleniumLibrary.Get Element Attribute        ${ShopAds}[${i-${i}*2-1}]               id
       ${ShopAdsID}                           Remove String                                ${ShopAdsID}                            listing-
       Should Be Equal                        ${ShopAdsID}                                 ${Listing_Ids}[${i-${i}*2-1}]
    END

Set Special Ads
    Go to                                      ${SERVER}/trumpet/shop/profile/edit/${SHOP_ID}
    Wait Until Page Contains                   شماره کاربر صاحب فروشگاه                   timeout=10s
    # click button                             اضافه کردن آیتم ویژه صفحه اصلی
    # Input text                               name:SpecialItemsInHomeMultiple[]            ${Listing_Ids}[${-1}]
    FOR    ${i}    IN RANGE       0           ${SpecialCount}
      click button                            اضافه کردن آیتم ویژه
      Wait Until Page Contains Element        name:SpecialItemsMultiple[]                  timeout=5
      @{SpecialAds}                           get WebElements                              name:SpecialItemsMultiple[]
      #   Input text                             ${SpecialAds}[${i}]                          ${Listing_Ids}[${i-${i}*2-1}]
      Input text                              ${SpecialAds}[${i}]                          ${Listing_Ids}[${i}]
    END
    Execute Javascript                           window.scrollTo(0,5000);
    Submit Shop
    Go To                                      ${SERVER}/trumpet/shop/profile/reindex/${SHOP_ID}
    Wait Until Page Is Loaded in Moderation
    Wait Until Page Contains                   عملیات با موفقیت انجام شد               timeout=5s

Input Consultants
    [Arguments]                                ${Count}
    FOR   ${INDEX}   IN RANGE                 0            ${Count}
      click button                            ثبت مشاور
    #   Click By Css Selector                 [data-target="#consultant-phone-holder"]
      Get Random Mobile                       Consultant_Mobile_${INDEX}
      Wait Until Page Contains Element        name:ConsultantPhones[]                timeout=5
      @{ConsultantPhones}                     get WebElements                        name:ConsultantPhones[]
      @{ConsultantNames}                      get WebElements                        name:ConsultantNames[]
      Input Text                              ${ConsultantPhones}[${INDEX}]          ${Consultant_Mobile_${INDEX}}
      Input Random By Kind                    Name                                   Consultant_Name${INDEX}               ${ConsultantNames}[${INDEX}]
    END

Enable Shop Package
  Go to      ${SERVER}/trumpet/shop/profile/package/${SHOP_ID}
  Wait Until Page Contains                     مدیریت بسته / فروشگاه: ${Shop_Title}     timeout=5s
  # Click Element                                //*[contains(text(),'Package C')]
  Click By Text                                Package C
  input text                                   id:price                                     10000
  input text                                   id:duration                                  ${duration}
  input text                                   id:shopPackageListingLimit                   ${shopLimit}
  input text                                   id:bump_refresh                              ${bump_refresh}
  input text                                   id:refresh_top                               ${refresh_top}
  input text                                   name:paid_features[3]                        ${refresh_top_2x}
  input text                                   id:listing_limitation                        ${listing_limitation}
  input text                                   name:paid_features[5]                        ${instant_tag}
  click element                                name:out_of_iran
  click element                                name:website_link
  click element                                //input[@value='افزودن']
  Wait Until Page Contains                     عملیات با موفقیت انجام شد                    timeout=5s
  Wait Until Page Contains                     نام بسته: Package C                          timeout=5s
  Wait Until Page Contains                     ایجاد توکن                                   timeout=5s
  Execute Javascript                           window.scrollTo(0,5000);
  SeleniumLibrary.Element Text Should Be       //*[@id="shop-package-results-generic"]/tbody/tr[1]/td[3]    30
  SeleniumLibrary.Element Text Should Be       //*[@id="shop-package-results-generic"]/tbody/tr[1]/td[4]    4
  Click Payment Link And Validate
  # Activate Package

Activate Package
    click element                                //*[@class="btn btn-success fr-remove btn-block package-activate"]
    Wait Until Page Contains Element             xpath://div[@class='alert alert-danger']//h4
    Wait Until Element Contains                  xpath://div[@class='alert alert-danger']//h4                                             با فعال سازی این بسته سایر بسته ها غیر فعال خواهند شد، آیا از فعال سازی اطمینان دارید؟           timeout=10s
    click button                                 بله
    Wait Until Page Contains                     عملیات با موفقیت انجام شد                                                                timeout=5s
    Wait Until Page Contains Element             //*[@class="btn btn-danger fr-remove btn-block package-inactivate"]                      timeout=5s
    Wait Until Page Contains                     غیر فعال کردن                                                                            timeout=5s
    Execute Javascript                           window.scrollTo(0,5000);

Click Payment Link And Validate
  FOR   ${i}    IN RANGE     3
    Run Keyword And Ignore Error               click element                                           ${PaymentLink}
    Wait Until Page Contains Element           //*[@class="modal in"]//input[@value="تایید"]           timeout=3s
    Select From List By Label                  id=GatewayAccount                                       حساب املاک
    Click Button                               xpath://*[@class="modal in"]//input[@value="تایید"]
    ${status}                                  Run Keyword And Return Status                           Page Should Contain                 بانک تست
    Exit For Loop If                           ${status}
    ${status}                                  Run Keyword And Return Status                           Wait Until Page Contains            بانک سامان                      timeout=5s
    Exit For Loop If                           ${status}
  END
  ${PaymentLink}                               get text                                                //div[@class="alert alert-success"]/a
  Click Link                                   ${PaymentLink}
  ${handle}                                    Switch Window	                                         NEW
  Wait Until Page Contains                     قیمت کل                                                 timeout=10s
  click button                                 پرداخت
  Wait Until Page Contains                     پرداخت با موفقیت انجام شد                               timeout=10s
  Switch Window	                               ${handle}
  reload page
  Wait Until Page Is Loaded in Moderation
  Wait Until Page Does Not Contain Element     //div[@class="alert alert-success"]/a
  Execute Javascript                           window.scrollTo(0,5000);
  SeleniumLibrary.Element Text Should Be       //*[@id="shop-package-results-generic"]//span[@class="btn-success"]                      پرداخت شده
  Execute Javascript                           window.scrollTo(0,5000);
  ${expire}                                    get text                                                //*[@id="shop-package-results-generic"]/tbody/tr[1]/td[6]
  Should Not Be Empty                          ${expire}
  ${activation}                                get text                                                //*[@id="shop-package-results-generic"]/tbody/tr[1]/td[7]
  Should Not Be Empty                          ${activation}

Fill Shop With Listing
    [Tags]                                     shop
    Add New Listing By Owner And 3 Consultant  ${c1}   ${c2}   ${c3}   ${c4}

Search And Validate Shop
    # Check Home Page
    # Click Link                                 همه فروشگاه‌ها
    Go To Shops Page
    Search And Validate Shop Tag And Title

Go To Shops Page
    ${Random_String}                           Generate Random String                 12  [LOWER]
    ${Random_Key}                              Generate Random String                 4  [LOWER]
    go to                                      ${SERVER}/shops?${Random_String}
    Wait Until Page Is Loaded

Search And Validate Shop Tag And Title
    input Text                                 name:q                                 ${Shop_Title}
    Press Keys                                 name:q                                 RETURN
    Wait Until Page Is Loaded
    Page Should Contain                        ${Shop_TagLine}
    Page Should Contain                        ${Shop_Title}
    # Wait Until Keyword Succeeds    3x  1s     Vlaidate Shop Counters
    Check Backend Errors                       failure=${TRUE}

Vlaidate Shop Counters
    ${Random_String}                           Generate Random String                 12  [LOWER]
    ${Random_Key}                              Generate Random String                 4   [LOWER]
    ${URL}                                     Get Location
    go to                                      ${URL}&${Random_Key}\=${Random_String}
    Wait Until Page Is Loaded
    Execute Javascript                         window.location.reload(true);
    Wait Until Page Is Loaded
    ${shopLimit}                               Convert Digits               ${shopLimit}    En2Fa
    SeleniumLibrary.Element Text Should Be     //span[@class="adds"]/strong            ${shopLimit}
    SeleniumLibrary.Element Text Should Be     //span[@class="adds"]/span              آگهی


Go To New Shop Page And Validate Shop Details
    Go To New Shop And Validate Primary Phone And Title Of Shop
    Validate Working Hours Of Shop
    Validate Count Of Advertisment In Shop Page

Go To New Shop And Validate Primary Phone And Title Of Shop
    FOR  ${index}   IN RANGE   1   5
      Go To New Shop Page
      ${status}                                  Run Keyword And Return Status      Validate Shop Primary Phone
      Continue For Loop If                       not ${status}
      Run Keyword If                             not ${status}                      Fail                    ${Shop_Primary_Phone} is not in shop details section.
      ${status}                                  Run Keyword And Return Status      Validate Shop Title
      Continue For Loop If                       not ${status}
      Exit For Loop If                           ${status}
    END
    Run Keyword If                               not ${status}                       Fail                     ${Title_Words} is not in shop serp

Go To New Shop Page
    ${key}                                     Generate Random String            length=5               chars=[LETTERS]
    ${value}                                   Generate Random String            length=20              chars=[LETTERS][NUMBERS]
    go to                                      ${SERVER}/${Shop_Slug}?${key}=${value}

Validate Shop Primary Phone
    ${status}                                     Run Keyword And Return Status        Element Should Contain    ${SD_Section}    XXX
    Run Keyword If                                not ${status}                        Fail                      Shop primary phone does not include XXX.
    Click Element                                 ${SD_Phone}
    Wait Until Keyword Succeeds    2x    2s       Element Should Contain               ${SD_Section}             ${Shop_Primary_Phone}

Validate Shop Title
     Page Should Contain     ${Title_Words}

Validate Working Hours Of Shop
     Page Should Contain                          ${Working_Hours}

Validate Count Of Advertisment In Shop Page
     Page Should Contain Element                  xpath://article                     limit=${shopLimit}

Check Consultants
    @{Labels}                                  Get List Items        name:ui
    ${SelectLabels}                            Create List
    ${Inserted}                                Create List
    FOR    ${Label}  IN   @{Labels}
      ${Label}                               Strip String       ${Label}
      append to list                         ${SelectLabels}    ${Label}
    END
    ${Consultants}                             Create List    همه مشاورها  ${Consultant_Name0}  ${Consultant_Name1}  ${Consultant_Name2}
    FOR    ${Consultant}  IN  @{Consultants}
      ${Consultant}                          Strip String       ${Consultant}
      append to list                         ${Inserted}        ${Consultant}
    END
    Lists Should Be Equal                      ${SelectLabels}    ${Inserted}

Validate Shop Details
    Check My Listing Image Count                  2
    Check Consultants
    Click Link                                 درباره
    Page Should Contain                        ${Shop_Description}
    Click Link                                 اطلاعات تماس
    Page Should Contain                        ${Shop_Address}
    Page Should Contain                        ${Shop_Primary_Phone}
    Page Should Contain                        ${Shop_Phone1}
    Page Should Contain                        ${Shop_Phone2}
    Page Should Contain                        ${Shop_Email}
    Page Should Contain                        ${Shop_Website}
    # Click Link                               http://${Shop_Website}
    # Select Window                            title=${Shop_Website}
    # Select Window                            url=http://${Shop_Website}


Add New Listing Min LoggedIn By Mobile
  [Arguments]          ${Count}                ${Mobile}
  Login OR Register By Mobile                  ${Mobile}       ${Auth_Session_Position}
  Add Some New Listings                        ${Count}        ${Mobile}
  Logout User

Add Some New Listings
    [Arguments]        ${Count}                 ${Mobile}
    FOR    ${INDEX}    IN RANGE    0            ${Count}
       Go To Post Listing Page
       Post A New Listing                       ${2}  43603  43606    tel=${Mobile}
       # Post A New Listing                       ${2}  43626  43627   43973  model=a68142    model_id=440655    tel=${Mobile}
       Verify Post Listing Is done
       Check My Listing
      #  Verify Advertise By ID     آملاک
       Remember Listing Id
    END

Add New Listing By Owner And 3 Consultant
  [Arguments]                                 ${c1}   ${c2}   ${c3}   ${c4}
  Set Listing Limit For Cat per locations     parentid=${43603}  catid=${43606}  regid=${17}  cityid=${647}  nghid=${4051}  limitcount=${30}  limitprice=${11000}
  Add New Listing Min LoggedIn By Mobile      ${c1}    ${Shop_Owner_Mobile}
  Add New Listing Min LoggedIn By Mobile      ${c2}    ${Consultant_Mobile_0}
  Add New Listing Min LoggedIn By Mobile      ${c3}    ${Consultant_Mobile_1}
  Add New Listing Min LoggedIn By Mobile      ${c4}    ${Consultant_Mobile_2}

Create New shop
  Open New Shop in Moderation
  Fill New Shop Form
  Submit Shop
  Find Shop ID

Find Shop ID
  input Text                             id:title                                 ${Shop_Title}
  Press Keys                             id:title                                 RETURN
  Sleep  1s
  wait until page loading is finished
  Wait Until Element Contains           //*[@id="shop-profile-results-generic"]/tbody/tr/td[2]                     ${Shop_Title}               timeout=10s
  ${SHOP_ID}                            get text                                  //*[@id="shop-profile-results-generic"]/tbody/tr/td[1]
  Set Test Variable                     ${SHOP_ID}                                ${SHOP_ID}


Submit Shop
  Click Button                      css=.btn.btn-success
  Wait Until Page Contains          عملیات با موفقیت انجام شد       timeout=10s
  Wait Until Page Contains          ${Shop_Title}                     timeout=10s


Open New Shop in Moderation
  Go To                             ${SERVER}/trumpet/shop/profile/new
  Wait Until Page Contains          شماره کاربر صاحب فروشگاه           timeout=10s
  Check Backend Errors              failure=${TRUE}


Fill New Shop Form
  Input Shop Title
  Input Shop Uniqe Address
  Input Owner Phone
  Input Consultants               3
  Input Shop Address
  Input Shop Email
  Input Shop Website
  Input Shop Phones               2
  Select Region and Neighborhood
  Select Category
  Insert Photos
  Input Working Hours
  Input Shop Description
  Input Shop Tag Line
  Input Lat and Long

Input Shop Title
     Input Items                    4                                     Shop_Title                             id:Title

Input Shop Uniqe Address
     ${Random_String}               Generate Random String                7  [LOWER]
     Set Test Variable              ${Shop_Slug}                          ${Random_String}
     Input Text                     id:Slug                               ${Shop_Slug}

Input Owner Phone
    Get Random Mobile               Shop_Owner_Mobile
    Input Text                      id:OwnerPhone                         ${Shop_Owner_Mobile}

Input Shop Address
     # Input Items                    45                                     Shop_Address                             id:Address
     Input Random By Kind           Address                                Shop_Address                             id:Address

Input Shop Email
    Input Random By Kind            Email                                  Shop_Email                             id:Email

Input Shop Website
   ${Random_String}                 Generate Random String                 20  [LOWER]
   Set Test Variable                ${Shop_Website}                        ${Random_String}.qaqa
   Input Text                       id:Website                             ${Shop_Website}


Input Shop Phones
    [Arguments]                     ${Count}
    ${Count}                        Convert To Integer                    ${Count}
    Get Random Mobile               Shop_Primary_Phone
    Input Text                      id:PrimaryPhone                       ${Shop_Primary_Phone}
    ${Shop_Primary_Phone}           Convert Digits              ${Shop_Primary_Phone}                  En2Fa
    Set Test Variable               ${Shop_Primary_Phone}                 ${Shop_Primary_Phone}
    Run Keyword If                  ${Count} >= 1                         Input Shop Extra Phones                ${Count}

Input Shop Extra Phones
    [Arguments]                     ${Count}
    FOR   ${INDEX}   IN RANGE      1                                     ${Count+1}
      click button                 ثبت شماره تماس های دیگر
      Get Random Mobile            Shop_Phone${INDEX}
      @{ShopPhones}                get WebElements                        css:[placeholder="شماره تماس"]
      Input Text                   ${ShopPhones}[${INDEX-1}]              ${Shop_Phone${INDEX}}
      ${Shop_PhoneFa}              Convert Digits               ${Shop_Phone${INDEX}}                En2Fa
      Set Test Variable            ${Shop_Phone${INDEX}}                  ${Shop_PhoneFa}
    END


Select Region and Neighborhood
    Select From List By Label       id=CityId                              تهران - تهران
    Select From List By Label       id=NeighbourhoodId                     تهران - دولت

Select Category
    Select From List By Label       id=CategoryId                          املاک
    # Select From List By Label       id=CategoryId                          وسایل نقلیه

Insert Photos
    @{number}                       Evaluate                               random.sample(range(601, 617), 1)    random
    Choose File                     id=ImageFile                           ${CURDIR}${/}Images${/}logo${/}${number}[0].jpg
    @{number}                       Evaluate                               random.sample(range(701, 707), 1)    random
    Choose File                     id=CoverImageFile                      ${CURDIR}${/}Images${/}banner${/}${number}[0].jpg

Input Working Hours
    Input Text                      name=WorkingTime                       ${Working_Hours}

Input Shop Description
     Input Items                    55                                     Shop_Description                        id:Description

Input Shop Tag Line
    Input Items                     15                                     Shop_TagLine                             id:TagLine

Input Lat and Long
    Input Text                      id:Latitude                            35.705
    Input Text                      id:Longitude                           51.403

Select Shop Status
    Select From List By Label       id=Status                              فعال

Input Random By Kind
    [Arguments]                     ${Kind}                                ${Test_Variable}                        ${locator}
    Random By Kind                  ${Kind}                                ${Test_Variable}
    Input Text                      ${locator}                             ${${Test_Variable}}

Random By Kind
    [Arguments]                     ${Kind}                                ${Test_Variable}
    ${Random}                       Run Keyword                            FakerLibrary.${Kind}
    ${Random}                       Replace String                         ${Random}  ي  ی
    ${Random}                       Replace String                         ${Random}  ك  ک
    ${Random}                       Convert Digits                         ${Random}  Fa2EN
    Set Test Variable               ${${Test_Variable}}                    ${Random}

Input Items
    [Arguments]                     ${Count}                               ${Test_Variable}                        ${locator}
    Get Random Inputs               ${Count}                               ${Test_Variable}
    Input Text                      ${locator}                             ${${Test_Variable}}

Get Random Inputs
    [Arguments]                     ${Count}                               ${Test_Variable}
    ${Random}                       FakerLibrary.Sentence	                 nb_words=${Count}                        variable_nb_words=False
    ${Random}  	                    Fetch From left                        ${Random}  .
    ${Random}                       Replace String                         ${Random}  ي  ی
    ${Random}                       Replace String                         ${Random}  ك  ک
    ${Random}                       Convert Digits                         ${Random}  Fa2EN
    Set Test Variable               ${${Test_Variable}}                    ${Random}

Get Random Mobile
    [Arguments]                     ${Random_Mobile}
    ${Random_Number}                Generate Random String                 7  [NUMBERS]
    Set Test Variable               ${${Random_Mobile}}                    0900${Random_Number}

Remember Listing Id
    Append To List                  ${Listing_Ids}                       ${AdsId}
    Set Suite Variable              ${Listing_Ids}                       ${Listing_Ids}
