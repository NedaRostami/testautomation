*** Settings ***
resource                                               ../../resources/seo.resource
Suite Setup                                            Create Initial Data           category=وسایل نقلیه                 subcategory=خودرو
Test Setup                                             Set Test Environment
Test Template                                          Validate Seo Rules of ${data}
Force Tags                                             Seo
Test Teardown                                          TearDown Tasks

*** Variables ***
${Type}                                               cars_brand_models

*** Test Cases ***
Validate Seo Description And Title For Random Car Models
    [Tags]                                              car   model
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
    [Arguments]                                         ${category}                   ${subcategory}                       ${province}=${EMPTY}
    ${brand}   ${model_List}                            Get Random Model Of A Brand   category=${category}                 subcategory=${subcategory}     counter=30
    ${length}                                           Get Length                    ${model_List}
    ${province_count}                                   Convert To Integer            ${length * 0.65}
    ${city_count}                                       Set Variable                  ${length -1 -${province_count}}
    ${Location_List}                                    Make Locations List           province_count=${province_count}     city_count=${city_count}        province=${province}
    ${random_data}                                      Create List
    FOR  ${location}  ${model}  IN ZIP                  ${Location_List}              ${model_List}
      ${URL}                                            Create Suitable URL           ${Location}[1]                       ${category}                       ${subcategory}           ${brand}     ${model}
      ${data}                                           Create List                   ${location}  ${brand}  ${URL}  ${model}
      Append To List                                    ${random_data}                ${data}
    END
    Set Suite Variable                                  ${random_data}

Set The Seo Rules Values
    ${title_exp}     ${desc_exp}         ${h1_exp}                     Set Expected Variables
    ...  adsCount=${Count}  Type=${Type}  locationName=${data}[0][2]   brand=${data}[1]  model=${data}[3]   bodyType=${EMPTY}   paymentType=${EMPTY}
    Set Test Variable                                   ${title_exp}
    Set Test Variable                                   ${desc_exp}
    Set Test Variable                                   ${h1_exp}
    Set Test Variable                                   ${Type}
