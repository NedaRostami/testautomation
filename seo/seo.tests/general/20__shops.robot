*** Settings ***
resource                                               ../../resources/seo.resource
Suite Setup                                            Create Initial Data
Test Setup                                             Set Test Environment
Test Template                                          Validate Seo Rules of ${data}
Force Tags                                             Seo
Test Teardown                                          TearDown Tasks

*** Variables ***
${Type}                                                shops_list
&{CATS}                                                all=${EMPTY}
...  43626=وسایل نقلیه
...  43603=املاک
...  43618=استخدام
...  43633=خدمات و کسب و کار
...  43608=لوازم خانگی
...  43619=ورزش فرهنگ فراغت
...  43596=لوازم الکترونیکی
...  43631=صنعتی، اداری و تجاری
...  44096=موبایل، تبلت و لوازم
...  43612=لوازم شخصی


*** Test Cases ***
Validate Seo Description And Title For Shops
    [Tags]                                              shops
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
    ${Location_List}                                    Make Locations List by ID     province_count=5               city_count=5
    ${random_data}                                      Create List
    FOR    ${location}  ${catID}  IN ZIP                ${Location_List}              ${CATS.keys()}
      ${query}                                          Set Variable If               '${location}[0]' != 'ایران'    ?c=${catID}&${Location}[1]       ${EMPTY}
      ${URL}                                            Create Suitable URL           shops${query}
      # ${cat}                                            Get From Dictionary           ${CATS}                      ${catID}
      ${data}                                           Create List                   ${location}                    ${CATS}[${catID}]             ${URL}
      Append To List                                    ${random_data}                ${data}
    END
    Set Suite Variable                                  ${random_data}

Set The Seo Rules Values
    ${title_exp}     ${desc_exp}                        ${h1_exp}                     Set Expected Variables
    ...  shopCount=${Count}    Type=${Type}             locationName=${data}[0][0]    categoryName=${data}[1]
    Set Test Variable                                   ${title_exp}
    Set Test Variable                                   ${desc_exp}
    Set Test Variable                                   ${h1_exp}
    Set Test Variable                                   ${Type}

Make Locations List by ID
  [Arguments]                                           ${province_count}                  ${city_count}
  ${total}                                              Set Variable                       ${${province_count}+${city_count}}
  ${Location_List}                                      Get Random Location ID And Slug    counter=${total}
  ${IRAN}                                               Create List                        ایران     ${EMPTY}
  ${result}                                             Create List                        ${IRAN}
  FOR  ${i}  IN RANGE   0  ${province_count}
    ${Province_Slug_Name}                               handle Slug As Expected            ${Location_List}[${i}][province_name]   ${Location_List}[${i}][province_slug]
    ${province_List}                                    Create List                        ${Province_Slug_Name}                   r=${Location_List}[${i}][provinceID]
    Append To List                                      ${result}                          ${province_List}
  END
  FOR  ${i}  IN RANGE   ${province_count}               ${total}
    ${City_Slug_Name}                                   handle Slug As Expected            ${Location_List}[${i}][city_name]       ${Location_List}[${i}][city_slug]
    ${city_List}                                        Create List                        ${City_Slug_Name}                       r=${Location_List}[${i}][provinceID]&ct=${Location_List}[${i}][cityID]
    Append To List                                      ${result}                          ${city_List}
  END
  [Return]                                              ${result}
