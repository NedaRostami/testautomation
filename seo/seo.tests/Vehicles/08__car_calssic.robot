*** Settings ***
resource                                               ../../resources/seo.resource
Suite Setup                                            Create Initial Data           category=وسایل نقلیه                 subcategory=کشاورزی و عمرانی
Test Setup                                             Set Test Environment
Test Template                                          Validate Seo Rules of ${data}
Force Tags                                             Seo
Test Teardown                                          TearDown Tasks

*** Variables ***
${Type}                                                cars_classic

*** Test Cases ***
Validate Seo Description And Title For Classic Cars
    [Tags]                                              car   classic
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
    ${Location_List}                                    Make Locations List           province_count=1                     city_count=1                   province=${province}
    ${random_data}                                      Create List
    FOR    ${location}    IN                            @{Location_List}
      ${URL}                                            Create Suitable URL           ${Location}[1]                       ${category}                    ${subcategory}
      ${data}                                           Create List                   ${location}  ${subcategory}  ${URL}
      Append To List                                    ${random_data}                ${data}
    END
    Set Suite Variable                                  ${random_data}

Set The Seo Rules Values
    ${title_exp}     ${desc_exp}                        ${h1_exp}                     Set Expected Variables
    ...  adsCount=${Count}  Type=${Type}                locationName=${data}[0][2]    categoryName=${data}[1]
    Set Test Variable                                   ${title_exp}
    Set Test Variable                                   ${desc_exp}
    Set Test Variable                                   ${h1_exp}
    Set Test Variable                                   ${Type}
