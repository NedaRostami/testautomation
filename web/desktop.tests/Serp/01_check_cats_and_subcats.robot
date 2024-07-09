*** Settings ***
Documentation                           Check All Cats and subCats links for health and breadcrumbs and tags
Library                                 String
Library                                 Collections
Library                                 Sheypoor                                platform=seo              env=${trumpet_prenv_id}    general_api_version=${general_api_version}
Test Setup                              Set Log Level                           Trace


*** Variables ***

${kASBOKAR_PRE}                         خدمات
${kASBOKAR_ETC}                         آگهی‌های سایر خدمات و کسب و کار
${JOB_PRE}                              استخدام
${OTHER_PRE}                            آگهی های
${CAR_PRE}                              خرید فروش انواع خودرو صفر و کارکرده
${NORESULT}                             متاسفانه نتیجه‌ای پیدا نشد.
${short_Rent}                           اجاره روزانه ویلا سوئیت اقامتگاه
${buisness_Rent}                        اجاره اداری و تجاری
${buisness_Rent_Header}                 رهن و اجاره اداری و تجاری
${buisness_trade}                       خرید اداری و تجاری
${buisness_trade_Header}                خرید و فروش اداری و تجاری


*** Test Cases ***
Check All Categories And SubCategories
  [Tags]                                seo          serp         cats
  Get All Cat And Subcat Names From Static Data
  FOR    ${key}    IN                   @{CATS.keys()}
    Open Cat in Serp And Validate for ${key}
    Open Subcat in Serp And Validate
  END

*** Keywords ***
Get All Cat And Subcat Names From Static Data
  ${CATS}                               Get Categories
  Set Test Variable                     ${CATS}

Open Cat in Serp And Validate for ${key}
    @{Subcats}                          Get From Dictionary                     ${CATS}                       ${key}
    Set Test Variable                   ${cat}                                  ${key}
    Set Test Variable                   ${Subcats}
    ${CatLink}                          make link clickable                     ${cat}
    Set Test Variable                   ${CATLINK}                              ${CatLink}
    ${cat_resp}  ${subcat_resp}         ${h1_resp}  ${tag_resp}                 Check Cat And SubCat           cat                       /ایران/${CATLINK}
    Should Be Equal                     ${cat_resp}                             ${cat}
    Should Be Equal                     ${tag_resp}                             ${cat}
    Validate Cat Header                 ${h1_resp}

Validate Cat Header
    [Arguments]                         ${h1_resp}
    ${Status}                           Run Keyword And Return Status           Should Be Equal                ${h1_resp}                   آگهی های ${cat} در ایران
    Run Keyword If                      not ${Status}                           Should Be Equal                ${h1_resp}                   ${NORESULT}


Open Subcat in Serp And Validate
  FOR    ${Subcat}    IN                @{Subcats}
    Set Test Variable                   ${Subcat}
    ${SubCatLink}                       make link clickable                     ${Subcat}
    ${cat_resp}  ${subcat_resp}         ${h1_resp}  ${tag_resp}                 Check Cat And SubCat             subcat                    /ایران/${CATLINK}/${SubCatLink}
    Should Be Equal                     ${cat_resp}                             ${cat}
    Should Be Equal                     ${subcat_resp}                          ${Subcat}
    Should Be Equal                     ${tag_resp}                             ${Subcat}
    Validate Subcat Header              ${h1_resp}
  END

Validate Subcat Header
  [Arguments]                           ${h1_resp}
  # ${Subcat}                             Set Variable If
  # ...  '${Subcat}' == 'رهن و اجاره اداری، تجاری و صنعتی'                      ${buisness_Rent_Header}
  # ...  '${Subcat}' == 'خرید و فروش اداری، تجاری و صنعتی'                      ${buisness_trade_Header}
  # ...   ${Subcat}
  Set Expected Header of ${Subcat}
  ${Status}                             Run Keyword And Return Status           Should Be Equal                  ${h1_resp}                ${ExpHeader}
  Run Keyword If                        not ${Status}                           Should Be Equal                  ${h1_resp}                ${NORESULT}

make link clickable
    [Arguments]                         ${link}
    ${link}                             Set Variable If
    ...  '${link}' == 'رهن و اجاره اداری، تجاری و صنعتی'                      ${buisness_Rent}
    ...  '${link}' == 'خرید و فروش اداری، تجاری و صنعتی'                      ${buisness_trade}
    ...  '${link}' == 'اجاره کوتاه مدت ویلا، سوئیت'                            ${short_Rent}
    ...   ${link}
    remove The و string in cats         ${link}
    ${link}                             Remove String                           ${link}	    \|
    ${link}                             Replace String Using Regexp             ${link}	    ${SPACE}،${SPACE} 	   ${SPACE}
    ${link}                             Replace String Using Regexp             ${link}	    ،${SPACE} 	           ${SPACE}
    ${link}                             Replace String Using Regexp             ${link}	    ${SPACE}، 	           ${SPACE}
    ${link}                             Replace String Using Regexp             ${link}	    ${SPACE}${SPACE}	     ${SPACE}
    ${link}                             Strip String                            ${link}
    ${link}                             Replace String Using Regexp             ${link}	    ${SPACE}	             -
    [return]                            ${link}

remove The و string in cats
    [Arguments]                         ${link}
    ${linkBeta}                         Replace String Using Regexp             ${link}	 ${SPACE}و${SPACE}	 ${SPACE}
    Set Test Variable                   ${link}                                 ${linkBeta}

Set Expected Header of ${Subcat}
  ${ExpHeader}                          Set Variable If
  ...                                  '${cat}' == 'استخدام'                   ${JOB_PRE}${SPACE}${Subcat}
  ...                                  '${Subcat}' == 'خودرو'                  ${CAR_PRE}
  ...                                  '${cat}' == 'املاک'                      ${Subcat}
  ...                                  '${cat}' == 'خدمات و کسب و کار' and '${Subcat}' != 'سایر خدمات'   ${OTHER_PRE}${SPACE}${kASBOKAR_PRE}${SPACE}${Subcat}
  ...                                  '${Subcat}' == 'سایر خدمات'             ${kASBOKAR_ETC}
  ...                                   ${OTHER_PRE}${SPACE}${Subcat}
  Set Test Variable                     ${ExpHeader}                            ${ExpHeader} در ایران
