*** Settings ***
Resource                                                      ../../resources/setup.resource
Test Setup                                                    Open test browser
Test Teardown                                                 Clean Up Tests



*** variables ***
${Setting_Drop_Menu}                                          xpath://a[@class='dropdown-toggle' and contains(text(),'اقلام درآمدی')]
${Category_Selector}                                          id:CategoryId
${Price_Field}                                                id:Price
${Submit_Button_AllIran}                                      class:btn.btn-success.pull-left
${Select_City}                                                اصفهان
${Select_Category}                                            لوازم خانگی
${Search_List_Select_Region}                                  xpath://*[@id="search-filters"]//select[@name='region']
${Search_List_Select_Cat}                                     xpath://*[@id="search-filters"]//select[@name='category']
${Search_Button}                                              css:input.btn.btn-block.btn-primary
${Validator_Acc_AllIR}                                        css:.modal.in
${Validator_SuccessMsg_Close}                                 class:modal-open

${state_id}                                                   4                 #اصفهان
${city_id}                                                    127
${city_name}                                                  اصفهان
${region_id}                                                  3793
${region_name}                                                لادان
${Choose_AllIran}                                             xpath://div[contains(@class, 'title')]//following-sibling::strong[text()="نمایش آگهی در همه‌ی ایران"]
${Choose_All}                                                 xpath://div[contains(@class, 'title')]//following-sibling::strong[text()="نمایش آگهی سراسری"]
${Validator_Pay_Page}                                         id:billing-message-box
${Return_To_MyListing}                                        css:a.go-back-to-listing
${Validate_Region}                                            xpath://span[contains(@class, 'small-text')]
${State_Results_xPath}                                        xpath://*[@id="all-iran-price-results"]/tbody/tr/td[2]
${Cat_Results_xPath}                                          xpath://*[@id="all-iran-price-results"]/tbody/tr/td[3]
${Price_Results_xPath}                                        xpath://*[@id="all-iran-price-results"]/tbody/tr/td[4]
${State_Cat_Results_xPath}                                    xpath://*[@id="all-state-price-results"]/tbody/tr/td[3]
${State_Price_Results_xPath}                                  xpath://*[@id="all-state-price-results"]/tbody/tr/td[4]
${State_State_Results_xPath}                                  xpath://*[@id="all-state-price-results"]/tbody/tr/td[2]
${prcessing_selector}                                         id:all-iran-price-results_processing
${PackageNameAll}                                             نمایش آگهی سراسری
${PackageNameIran}                                            نمایش آگهی در همه‌ی ایران



*** Test Cases ***
All Iran Admin
  [Tags]                                                     AllIran   paid_features
  Login Trumpet Admin Page
  Set All Iran Config
  Set All State Config

  Login OR Register By Random OR New Mobile                 ${Auth_Session_Position}
  Go To Post Listing Page
  Post A New Listing                                        ${1}   43608  43609    state=${state_id}   city=${city_id}   region=${region_id}     tel=${Random_User_Mobile_B}
  Get Listing ID from Paid ID attribute
  Verify Post Listing Is done

  Buy All Iran
  Verify Advertise By ID in trumpet
  Check My Ads Has been Verified
  Validate Listing Location In My Listings
  Validate Listing Location In Listing Details
  Validate Listing Location Is Empty In Serp
  Check The Listing Location On My Listing Page

*** Keywords ***
Set All Iran Config
  Go To Setting menu
  Enter To All Iran Feature
  Add Price For All Iran
  Choose City                                                 ${Select_City}
  Choose Category                                             ${Select_Category}
  Input Price And Submit                                      12000
  Validate All Iran Added                                     ${Select_City}                            ${Select_Category}

Set All State Config
  Go To Setting menu
  Enter To All State Feature
  Add Price For All Iran
  Choose City                                                 ${Select_City}
  Choose Category                                             ${Select_Category}
  Input Price And Submit                                      12000
  Validate All State Added                                    ${Select_City}                            ${Select_Category}

Go To Setting menu
   FOR  ${i}  IN RANGE    3
    click element                                             ${Setting_Drop_Menu}
    ${Drop-Menu}                                              Run Keyword And Return Status             Element Attribute Value Should Be      ${Setting_Drop_Menu}    aria-expanded    true
    Exit For Loop If                                          ${Drop-Menu}
  END
  Run Keyword unless                                          ${Drop-Menu}                              Fail                                   can not open setting menu dropdown


Enter To All Iran Feature
  Click Link                                                  قیمت گذاری پکیچ همه ایران


Enter To All State Feature
  Click Link                                                  قیمت گذاری پکیچ همه استان


Add Price For All Iran
  FOR  ${i}     IN RANGE     3
    Click Button                                              قیمت گذاری جدید
    ${All_Iran_Price_Modal_Status}                            Run Keyword And Return Status             Wait Until Page Contains Element       ${Validator_Acc_AllIR}    timeout=5s
    Exit For Loop If                                          ${All_Iran_Price_Modal_Status}
  END
  Run Keyword unless                                          ${All_Iran_Price_Modal_Status}            Fail                                   can not open all iran price modal


Choose City
  [Arguments]                                                 ${City}
  Select From List By Label                                   ${PF_Region_Id}                          ${City}

Choose Category
  [Arguments]                                                 ${Category}
  Select From List By Label                                   ${Category_Selector}                      ${Category}

Input Price And Submit
  [Arguments]                                                 ${Price}
  Input Text                                                  ${Price_Field}                            ${Price}
  Click Button                                                ${Submit_Button_AllIran}
  SeleniumLibrary.Wait Until Page Does Not Contain Element    ${Validator_Acc_AllIR}                    timeout=5s
  SeleniumLibrary.Wait Until Page Does Not Contain Element    ${Validator_SuccessMsg_Close}             timeout=5s

Validate All Iran Added
  [Arguments]                                                 ${City}                                   ${Category}
  Select From List By Label                                   ${Search_List_Select_Region}              ${City}
  Select From List By Label                                   ${Search_List_Select_Cat}                 ${Category}
  Click Element                                               ${Search_Button}
  Wait Until Element Is Not Visible                           ${prcessing_selector}                     timeout=10s
  ${State-result}                                             Get Text                                  ${State_Results_xPath}
  ${cat-result}                                               Get Text                                  ${Cat_Results_xPath}
  ${price-result}                                             Get Text                                  ${Price_Results_xPath}
  Should Be Equal                                             ${City}                                   ${State-result}
  Should Be Equal                                             ${Category}                               ${cat-result}
  Should Be Equal                                             ۱۲,۰۰۰                                    ${price-result}

Validate All State Added
  [Arguments]                                                 ${City}                                   ${Category}
  Select From List By Label                                   ${Search_List_Select_Region}              ${City}
  Select From List By Label                                   ${Search_List_Select_Cat}                 ${Category}
  Click Element                                               ${Search_Button}
  Wait Until Element Is Not Visible                           ${prcessing_selector}                     timeout=10s
  ${State-result}                                             Get Text                                  ${State_State_Results_xPath}
  ${cat-result}                                               Get Text                                  ${State_Cat_Results_xPath}
  ${price-result}                                             Get Text                                  ${State_Price_Results_xPath}
  Should Be Equal                                             ${City}                                   ${State-result}
  Should Be Equal                                             ${Category}                               ${cat-result}
  Should Be Equal                                             ۱۲,۰۰۰                                    ${price-result}


Buy All Iran
  Click Element                                               ${Choose_All}
  Wait Until Page Contains Element                            ${PF_AllIran_Selector}                    timeout=10s
  click element                                               ${PF_AllIran_Selector}
  Wait Until Page Does Not Contain Element                    ${PF_AllIran_Selector}                    timeout=10s
  Wait Until Page Contains Element                            ${PaymentButton_PF}
  ${Payment_Price}                                            get text                                  ${PaymentButton_PF}
  Should Contain                                              ${Payment_Price}                          ۱۳,۰۸۰
  Click Element                                               ${PaymentButton_PF}
  Wait Until Page Contains Element                            ${Validator_Pay_Page}
  ${Pay_Page_message}                                         get text                                  ${Validator_Pay_Page}
  Should Contain                                              ${Pay_Page_message}                       ${PF_Successful_Payment}
  Element Should Contain                                      ${PF_Purchase_Summary}                    ${PackageNameIran}
  Click Element                                               ${Return_To_MyListing}
  Wait Until Page Contains                                    ${PF_Active_Listing}

Validate Listing Location In My Listings
  ${AllIran_ML_Page}                                          Run Keyword And Return Status             Element Should Contain
  ...                                                         ${ML_Listing.format('${AdsId}')}          ${city_name}، ${region_name}
  Set Test Variable                                           ${AllIran_ML_Page}

Validate Listing Location In Listing Details
  Go To                                                       ${SERVER}/${AdsId}
  Element Should Contain                                      ${Validate_Region}                        ${city_name}، ${region_name}


Validate Listing Location Is Empty In Serp
  Go To                                                       ${SERVER}/ایران/لوازم-خانگی
  Wait Until Page Contains Element                            id:tags
  Wait Until Page Contains                                    آگهی های لوازم خانگی در ایران
  Refresh Varnish To Get Element                              xpath://*[@id="listing-${AdsId}"]//p[2]
  ${Text}                                                     Get Text                                  xpath://*[@id="listing-${AdsId}"]//p[2]
  Should Be Empty                                             ${Text}

Refresh Varnish To Get Element
  [Arguments]                                                 ${elem}
  FOR  ${i}                                                   IN RANGE                                  5
    ${Value}                                                  Generate Random String                    12  [LOWER]
    ${Key}                                                    Generate Random String                    4  [LOWER]
    ${URL}                                                    Get Location
    go to                                                     ${URL}?${Key}=${Value}
    Wait Until Page Is Loaded
    ${Element_Is_In_Page}                                     Run Keyword And Return Status             Wait Until Page Contains Element     ${elem}    timeout=3s
    Exit For Loop If                                          ${Element_Is_In_Page}
  END
  Run Keyword unless                                          ${Element_Is_In_Page}                     Fail    Element ${elem} Is Not In Page


Check The Listing Location On My Listing Page
  Run Keyword Unless       ${AllIran_ML_Page}                 Fail                                      The listing location on my Listings page does not exist correctly.
