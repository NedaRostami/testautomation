*** Settings ***
resource                                               ../../resources/seo.resource
Suite Setup                                            Create Initial Data                               category=خدمات و کسب و کار
Test Setup                                             Set Test Environment
Test Template                                          Validate Seo Rules of ${data}
Force Tags                                             Seo
Test Teardown                                          TearDown Tasks

*** Variables ***
${Child_Type}                                          buisness_services_children
${Parent_Type}                                         buisness_services

*** Test Cases ***
Validate Seo Description And Title For mobiles
    [Tags]                                              buisness
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
      ${URL}                                            Create Suitable URL           ${Location}[1]                         ${category}                  ${subcat}
      ${data}                                           Create List                   ${location}  ${cat_or_subcat}  ${URL}
      Append To List                                    ${random_data}                ${data}
    END
    Set Suite Variable                                  ${random_data}


Set The Seo Rules Values
    ${Type}                                             Set Variable If
    ...  '${data}[1]' == '${category}'                  ${Parent_Type}
    ...  '${data}[1]' == 'آموزش'                        buisness_services_education
    ...  '${data}[1]' == 'مراسم و کترینگ'               buisness_services_kettering
    ...  '${data}[1]' == 'آرایشگری و زیبایی'            buisness_services_beauty
    ...  '${data}[1]' == 'تعمیرات'                      buisness_services_repairs
    ...  '${data}[1]' == 'ترجمه و تایپ'                 buisness_services_translation
    ...  '${data}[1]' == 'خرید و فروش عمده'             buisness_services_wholesale
    ...  '${data}[1]' == 'سایر خدمات'                   buisness_services_other
    ...   ${Child_Type}
    ${title_exp}     ${desc_exp}                        ${h1_exp}                     Set Expected Variables
    ...  adsCount=${Count}  Type=${Type}                locationName=${data}[0][2]    categoryName=${data}[1]
    Set Test Variable                                   ${title_exp}
    Set Test Variable                                   ${desc_exp}
    Set Test Variable                                   ${h1_exp}
    Set Test Variable                                   ${Type}
