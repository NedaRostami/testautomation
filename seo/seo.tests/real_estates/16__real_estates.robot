*** Settings ***
resource                                               ../../resources/seo.resource
Suite Setup                                            Create Initial Data                               category=املاک
Test Setup                                             Set Test Environment
Test Template                                          Validate Seo Rules of ${data}
Force Tags                                             Seo
Test Teardown                                          TearDown Tasks

*** Variables ***
${Parent_Type}                                         realestate
${short_Rent}                                          اجاره روزانه ویلا سوئیت اقامتگاه
${real_estate_Rent}                                    اجاره خانه و آپارتمان
${real_estate_trade}                                   خرید خانه و آپارتمان
${buisness_Rent}                                       اجاره اداری و تجاری
${buisness_Rent_Header}                                رهن و اجاره اداری و تجاری
${buisness_trade}                                      خرید اداری و تجاری
${buisness_trade_Header}                               خرید و فروش اداری و تجاری

@{Rent_realestateType}                                 خانه و آپارتمان     آپارتمان    خانه             ویلا
@{Trade_realestateType}                                خانه و آپارتمان     آپارتمان    خانه و کلنگی     ویلا
@{buisness_realestateType}                             اداری و تجاری       اداری       تجاری و مغازه    صنعتی (سوله، انبار، کارگاه)     دامداری و کشاورزی


*** Test Cases ***
Validate Seo Description And Title For Realestate
    [Tags]                                              realestate
    FOR        ${data}     IN      @{random_data}
      ${data}
    END

*** Keywords ***
Validate Seo Rules of ${data}
    Set Test Variable                                   ${data}
    Get The Title Description And Header From Page
    Set The Seo Rules Values
    Validate Title Seo Rules
    Validate Description Seo Rules
    Validate Header Seo Rules

Create Initial Data
    [Arguments]                                         ${category}                   ${province}=${EMPTY}
    Set Suite Variable                                  ${category}
    ${Main_Cat}                                         Create List                   ${category}
    ${sub_cats}                                         Get All Sub Category          ${category}
    ${cat_subcats}                                      Combine Lists                 ${Main_Cat}                          ${sub_cats}
    ${length}                                           Get Length                    ${cat_subcats}
    ${province_count}                                   Convert To Integer            ${length * 0.65}
    ${city_count}                                       Set Variable                  ${length -1 -${province_count}}
    ${Location_List}                                    Make Locations List           province_count=${province_count}       city_count=${city_count}     province=${province}
    ${random_data}                                      Create List
    FOR    ${location}  ${cat_or_subcat}  IN ZIP        ${Location_List}              ${cat_subcats}
      ${subcat}                                         Set Variable If               '${category}' != '${cat_or_subcat}'    ${cat_or_subcat}             ${EMPTY}
      ${subcat}                                         make Cat link In URL Useable  ${subcat}
      Choose Realestate Type                            ${category}                   ${cat_or_subcat}
      ${URL}                                            Create Suitable URL           ${Location}[1]                          ${category}                 ${subcat}               ${realestateType_URL}
      ${data}                                           Create List                   ${location}  ${cat_or_subcat}  ${URL}   ${realestateType}
      Append To List                                    ${random_data}                ${data}
    END
    Set Suite Variable                                  ${random_data}



Choose Realestate Type
    [Arguments]                                               ${category}     ${cat_or_subcat}
    @{list}                                                   Create List
    ${subcat}                                                  Set Variable If               '${category}' != '${cat_or_subcat}'    ${cat_or_subcat}             ${EMPTY}
    @{List}                                                   Set Variable If
    ...  '${subcat}' == 'رهن و اجاره خانه و آپارتمان'         ${Rent_realestateType}
    ...  '${subcat}' == 'خرید و فروش خانه و آپارتمان'         ${Trade_realestateType}
    ...  '${subcat}' == 'رهن و اجاره اداری، تجاری و صنعتی'    ${buisness_realestateType}
    ...  '${subcat}' == 'خرید و فروش اداری، تجاری و صنعتی'    ${buisness_realestateType}
    Set Random RealestateType                                 ${list}
    ${realestateType}                                         Set Variable If
    ...  '${Random_realestateType}' == '${EMPTY}'             ${EMPTY}
    ...   ${Random_realestateType}
    Set Suite Variable                                        ${realestateType}
    ${realestateType_URL}                                     Set Variable If
    ...  '${subcat}' == '${EMPTY}'                            ${EMPTY}                              ### املاک
    ...  '${realestateType}' == 'خانه و آپارتمان'             ${EMPTY}
    ...  '${realestateType}' == 'اداری و تجاری'               ${EMPTY}
    ...  ${realestateType}
    Set Suite Variable                                         ${realestateType_URL}

Set Random RealestateType
    [Arguments]                                               ${list}
    ${length}                                                 Get Length        ${list}
    ${Random_realestateType}                                  Run Keyword If    ${length} != ${0}       Evaluate      random.choice($List)   random
    ${Random_realestateType}                                  Set Variable If
    ...  '${Random_realestateType}' != '${NONE}'              ${Random_realestateType}
    ...  ${EMPTY}
    Set Suite Variable                                        ${Random_realestateType}


Set The Seo Rules Values
    ${Type}                                                   Set Variable If
    ...  '${data}[1]' == '${category}'                        ${Parent_Type}
    ...  '${data}[1]' == 'رهن و اجاره خانه و آپارتمان'        realestate_rent
    ...  '${data}[1]' == 'خرید و فروش خانه و آپارتمان'        realestate_sell
    ...  '${data}[1]' == 'رهن و اجاره اداری، تجاری و صنعتی'   realestate_commerical_rent
    ...  '${data}[1]' == 'خرید و فروش اداری، تجاری و صنعتی'   realestate_commerical_sell
    ...  '${data}[1]' == 'اجاره کوتاه مدت ویلا، سوئیت'         realestate_villa_suite
    ...   realestate_land_garden
    ${title_exp}   ${desc_exp}   ${h1_exp}                    Set Expected Variables
    ...  adsCount=${Count}   Type=${Type}   locationName=${data}[0][2]    categoryName=${data}[1]     realestateType=${data}[3]
    Set Test Variable                                         ${title_exp}
    Set Test Variable                                         ${desc_exp}
    Set Test Variable                                         ${Type}

make Cat link In URL Useable
    [Arguments]                                               ${subcat}
    ${subcat}                                                 Set Variable If
    ...  '${subcat}' == 'رهن و اجاره خانه و آپارتمان'         ${real_estate_Rent}
    ...  '${subcat}' == 'خرید و فروش خانه و آپارتمان'         ${real_estate_trade}
    ...  '${subcat}' == 'رهن و اجاره اداری، تجاری و صنعتی'    ${buisness_Rent}
    ...  '${subcat}' == 'خرید و فروش اداری، تجاری و صنعتی'    ${buisness_trade}
    ...  '${subcat}' == 'اجاره کوتاه مدت ویلا، سوئیت'          ${short_Rent}
    ...  ${subcat}
    [return]                                                  ${subcat}

Set Realestate Type
    [Arguments]                                               ${subcat}
    ${subcat}                                                 Set Variable If
    ...  '${subcat}' == 'رهن و اجاره خانه و آپارتمان'         ${real_estate_Rent}
    ...  '${subcat}' == 'خرید و فروش خانه و آپارتمان'         ${real_estate_trade}
    ...  '${subcat}' == 'رهن و اجاره اداری، تجاری و صنعتی'    ${buisness_Rent}
    ...  '${subcat}' == 'خرید و فروش اداری، تجاری و صنعتی'    ${buisness_trade}
    ...  '${subcat}' == 'اجاره کوتاه مدت ویلا، سوئیت'          ${short_Rent}
    ...  ${subcat}
    [return]                                                  ${subcat}
