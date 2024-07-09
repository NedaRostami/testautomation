*** Settings ***
Documentation                           Check All Cats and sub cats link
Test Setup                              Open test browser
Test Teardown                           Clean Up Tests
Resource                                ../../resources/setup.resource

*** Variables ***
${ThirdBC}                               xpath=//*[@id="breadcrumbs"]/ul/li[4]
${SecondBC}                              xpath=//*[@id="breadcrumbs"]/ul/li[3]
${TAG1}                                  xpath=//*[@id="tags"]/span[1]
@{EXCEPTIONS}                            صوتی و تصویری   رهن و اجاره خانه و آپارتمان    خرید و فروش خانه و آپارتمان   رهن و اجاره اداری و تجاری   خرید و فروش اداری و تجاری    مبلمان و دکوراسیون    لوازم برقی و آشپزخانه   لباس ، کیف و کفش   زیورآلات و ساعت   بهداشتی و آرایشی   لباس و لوازم کودک و نوزاد
${JOB_PRE}                               استخدام
${OTHER_PRE}                             آگهی های
${NORESULT}                              متاسفانه نتیجه‌ای پیدا نشد
${short_Rent}                            اجاره روزانه ویلا سوئیت اقامتگاه
${real_estate_Rent}                      اجاره خانه و آپارتمان
${real_estate_trade}                     خرید خانه و آپارتمان
${buisness_Rent}                         اجاره اداری و تجاری
${buisness_Rent_Header}                  رهن و اجاره اداری و تجاری
${buisness_trade}                        خرید اداری و تجاری
${buisness_trade_Header}                 خرید و فروش اداری و تجاری


*** Test Cases ***
Check All Categories
  [Tags]                                api  cats  nosecond  notest   serp
  click link                            ${AllAdvs}
  Wait Until Page Contains              ${IranAllH1}
  ${CATS} =   Get Categories
  log         ${CATS}
  # loop over  dictionaries under list
  FOR    ${key}                          IN    @{CATS.keys()}
    @{Subcats}                           Get From Dictionary    ${CATS}    ${key}
    Set Test Variable                    ${cat}    ${key}
    Check Cat                            ${cat}
    Check SubCats                        @{Subcats}
    click link                           ${AllAdvs}
  END

*** Keywords ***
Check SubCats
  [Arguments]     @{Subcats}
  Set Jobs
  FOR    ${Subcat}    IN    @{Subcats}
    ${SubCatLink}                              make link clickable   ${Subcat}
    Set Test Variable                          ${SubCatLink}          ${SubCatLink}
    GO TO                                      ${SERVER}/ایران/${CATLINK}/${SubCatLink}
    Validate Subcat                            ${Subcat}
    Assign ID to Element                       ${ThirdBC}     SubcatElementID
    SeleniumLibrary.Element Text Should Be     SubcatElementID      ${Subcat}
    Assign ID to Element                       ${SecondBC}/a  CatElementID
    SeleniumLibrary.Element Text Should Be     CatElementID      ${cat}
    Assign ID to Element                       ${TAG1}        TagA
    SeleniumLibrary.Element Text Should Be     TagA     ${Subcat}
    Go Back
    Check Cat Result                           ${cat}
  END

Set Jobs OLD
  ${SerpPrefix}                  Set Variable If    '${cat}' == 'استخدام'      ${EMPTY}                      ${OTHER_PRE}${SPACE}
  Set Test Variable              ${SerpPrefix}       ${SerpPrefix}

Set Jobs
  ${SerpPrefix}                  Set Variable If    '${cat}' == 'استخدام'      ${JOB_PRE}${SPACE}             ${OTHER_PRE}${SPACE}
  Set Test Variable              ${SerpPrefix}       ${SerpPrefix}

Validate Subcat
  [Arguments]                    ${Subcat}
  ${Subcat}                      Set Variable If
  ...  '${Subcat}' == 'رهن و اجاره اداری، تجاری و صنعتی'     ${buisness_Rent_Header}
  ...  '${Subcat}' == 'خرید و فروش اداری، تجاری و صنعتی'     ${buisness_trade_Header}
  ...  ${Subcat}
  ${Status}                      Run Keyword And Return Status                  Wait Until Page Contains       ${SerpPrefix}${Subcat} در ${AllIran}    timeout=3
  Run Keyword If                 not ${Status}                                  Page Should Contain            ${NORESULT}


Check Cat
    [Arguments]                 ${cat}
    ${CatLink}                  make link clickable    ${cat}
    Set Test Variable           ${CATLINK}    ${CatLink}
    GO TO                       ${SERVER}/ایران/${CATLINK}
    Check Cat Result            ${cat}
    Assign ID to Element        ${SecondBC}    CatElementID
    SeleniumLibrary.Element Text Should Be     CatElementID      ${cat}
    Assign ID to Element        ${TAG1}        TagA
    SeleniumLibrary.Element Text Should Be     TagA     ${cat}

Check Cat Result
    [Arguments]     ${cat}
    ${Status}                      Run Keyword And Return Status                  Wait Until Page Contains       آگهی های ${cat} در ${AllIran}    timeout=3
    Run Keyword If                 not ${Status}                                  Page Should Contain            ${NORESULT}

make link clickable
    [Arguments]     ${link}
    ${link}         Set Variable If
    ...  '${link}' == 'اجاره کوتاه مدت ویلا، سوئیت'     ${short_Rent}
    ...  '${link}' == 'رهن و اجاره خانه و آپارتمان'    ${real_estate_Rent}
    ...  '${link}' == 'خرید و فروش خانه و آپارتمان'    ${real_estate_trade}
    ...  '${link}' == 'رهن و اجاره اداری، تجاری و صنعتی'      ${buisness_Rent}
    ...  '${link}' == 'خرید و فروش اداری، تجاری و صنعتی'     ${buisness_trade}
    ...  ${link}

    ${names}  	    Create List   @{EXCEPTIONS}
    remove The و string in cats         ${link}
    ${link}   Remove String                ${link}	 \|
    ${link}   Replace String Using Regexp  ${link}	 ${SPACE}،${SPACE} 	   ${SPACE}
    ${link}   Replace String Using Regexp  ${link}	 ،${SPACE} 	           ${SPACE}
    ${link}   Replace String Using Regexp  ${link}	 ${SPACE}، 	           ${SPACE}
    ${link}   Replace String Using Regexp  ${link}	 ${SPACE}${SPACE}	   ${SPACE}
    ${link}   Strip String                 ${link}
    ${link}   Replace String Using Regexp  ${link}	 ${SPACE}	           -
    [return]      ${link}

remove The و string in cats
    [Arguments]     ${link}
    ${linkBeta}=   Replace String Using Regexp  ${link}	 ${SPACE}و${SPACE}	 ${SPACE}
    Set Test Variable    ${link}   ${linkBeta}

Unicode Test
    [Arguments]     ${content}
    ${byte_string}=  Encode String To Bytes     ${content}  UTF-8
    ${_string} =  Decode Bytes To String  ${byte_string}  UTF-8
    [return]   ${_string}
