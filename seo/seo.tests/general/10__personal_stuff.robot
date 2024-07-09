*** Settings ***
resource                                               ../../resources/seo.resource
Suite Setup                                            Create Initial Data                               category=لوازم شخصی
Test Setup                                             Set Test Environment
Test Template                                          Validate Seo Rules of ${data}
Force Tags                                             Seo
Test Teardown                                          TearDown Tasks

*** Variables ***
${Child_Type}                                          general
${Parent_Type}                                         general

*** Test Cases ***
Validate Seo Description And Title For Personal Stuff
    [Tags]                                             personal_stuff
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
    ${cat_subcats}                                      Combine Lists                 ${Main_Cat}                            ${sub_cats}
    ${length}                                           Get Length                    ${cat_subcats}
    ${province_count}                                   Convert To Integer            ${length * 0.75}
    ${city_count}                                       Set Variable                  ${length -1 -${province_count}}
    ${Location_List}                                    Make Locations List           province_count=${province_count}       city_count=${city_count}     province=${province}
    ${random_data}                                      Create List
    FOR    ${location}  ${cat_or_subcat}  IN ZIP        ${Location_List}              ${cat_subcats}
      ${subcat}                                         Set Variable If               '${category}' != '${cat_or_subcat}'    ${cat_or_subcat}             ${EMPTY}
      ${URL}                                            Create Suitable URL           ${Location}[1]                         ${category}                  ${subcat}
      ${data}                                           Create List                   ${location}                            ${cat_or_subcat}             ${URL}
      Append To List                                    ${random_data}                ${data}
    END
    Set Suite Variable                                  ${random_data}

Set The Seo Rules Values
    ${Type}                                             Set Variable If               '${data}[1]' == '${category}'          ${Parent_Type}                ${Child_Type}
    ${title_exp}     ${desc_exp}                        ${h1_exp}                     Set Expected Variables
    ...  adsCount=${Count}  Type=${Type}                locationName=${data}[0][2]    categoryName=${data}[1]
    Set Test Variable                                   ${title_exp}
    Set Test Variable                                   ${desc_exp}
    Set Test Variable                                   ${h1_exp}
    Set Test Variable                                   ${Type}
