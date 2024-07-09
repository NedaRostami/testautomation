*** Settings ***
Documentation                               Test Seo Rules on Title ,Description and H1
Library                                     String
Library                                     Collections
Library                                     Sheypoor                             platform=seo              env=${trumpet_prenv_id}    general_api_version=${general_api_version}
Library                                     OperatingSystem
Variables                                   ../variables/Variables.py            ${trumpet_prenv_id}       ${general_api_version}

*** Variables ***
${title}                                    ${EMPTY}
${desc}                                     ${EMPTY}
${h1}                                       ${False}
${tot}                                      0
${Title_desc_Doc_URL}                       https://docs.google.com/document/d/17F_cvCJMdZpGaskIa9MZWDvvWgwlAS0L
${Headerc_Doc_URL}                          https://docs.google.com/document/d/1dWjo8NDUw4a1dDdaviy1DBfI_8k59cVY
${NORESULT}                                 متاسفانه نتیجه‌ای پیدا نشد.
@{Report}
# cat	subcat	categoryName	attributes	locationName	Seo Type	title currrent	title exp	desc current	desc exp	h1 current	h1 exp	URL	Status

*** Keywords ***
Set Test Environment
  Set Log Level                             Trace

Log Test Status
  [Arguments]                               ${Full_URL}   ${type}   ${error_type}   ${current}  ${expeced}  ${status}
  Append To File                            ${CURDIR}/data/log.txt     ${Full_URL};;;${type};;;${error_type};;;${current};;;${expeced};;;${status}${\n}

TearDown Tasks
    No Operation

Get Seo Values
  [Arguments]                               ${URL}
  Set Test Variable                         ${Full_URL}                          ${SERVER}${URL}
  ${title}  ${desc}  ${h1}  ${tot}          Get Seo Page Details                 ${URL}
  ${title}                                  Clean All Extra Spaces               ${title}
  ${desc}                                   Clean All Extra Spaces               ${desc}
  [return]                                  ${title}  ${desc}  ${h1}  ${tot}

Set Expected Variables
  [Arguments]                               ${adsCount}=0                        &{kwargs}
  # Arguments
  #  General :                              Type  locationName  categoryName  adsCount
  #  realestate:                            realestateType
  #  cars:                                  brand  model  bodyType  paymentType  isCertified
  #  shop:                                  shopCount
  @{items}                                  Create List                   adsCount='${adsCount}'
  FOR  ${key}                               IN                            @{kwargs}
    ${value}                                Get From Dictionary           ${kwargs}                                                      ${key}
    # ${value}                                Set Variable If               '${key}' == 'paymentType'        به صورت ${value}              ${value}
    Append To List                          ${items}                                                                                     ${key}='${value}'
  END
  ${params}                                 Catenate                      SEPARATOR=,${SPACE}                                            @{items}
  ${title}                                  set variable                  ${${kwargs.Type}_title.format(${params})}
  ${desc}                                   set variable                  ${${kwargs.Type}_description.format(${params})}
  ${h1}                                     set variable                  ${${kwargs.Type}_h1.format(${params})}
  ${title}                                  Clean All Extra Spaces        ${title}
  ${desc}                                   Clean All Extra Spaces        ${desc}
  ${h1}                                     Clean All Extra Spaces        ${h1}
  [return]                                  ${title}                      ${desc}      ${h1}


Get Random Category Or subCategory
  [Arguments]                               ${category}=${EMPTY}
  ${Cat}     ${subCat}                      Get Random Category           category=${category}
  [Return]                                  ${Cat}                        ${subCat}

Get Random Brand Of A Category
  [Arguments]                               ${category}                   ${subcategory}
  ${brand}                                  Get Random Brand              category=${category}             subcategory=${subcategory}
  [Return]                                  ${brand}

Get Random Model Of A Brand
  [Arguments]                               ${category}                   ${subcategory}                   ${brand}=${EMPTY}                  ${counter}=5
  ${model}                                  Get Random model              category=${category}             subcategory=${subcategory}         brand=${brand}    counter=${counter}
  [Return]                                  ${model}

Make Brand List
  [Arguments]                               ${category}                   ${subcategory}                   ${counter}=5
  ${Brand_List}                             Get Random Brand              category=${category}             subcategory=${subcategory}    counter=${counter}
  [Return]                                  ${Brand_List}

Make Locations List
  [Arguments]                               ${province_count}             ${city_count}                    ${province}=${EMPTY}
  ${total}                                  Set Variable                  ${${province_count}+${city_count}}
  ${Location_List}                          Get Random Location           counter=${total}    province=${province}
  ${IRAN}                                   Create List                   ایران    ایران   ایران
  ${result}                                 Create List                   ${IRAN}
  FOR  ${i}  IN RANGE   0  ${province_count}
    ${Province_Slug_Name}                   handle Slug As Expected        ${Location_List}[${i}][province_name]   ${Location_List}[${i}][province_slug]
    ${province_List}                        Create List                    ${Location_List}[${i}][province_name]   ${Location_List}[${i}][province_slug]         ${Province_Slug_Name}
    Append To List                          ${result}                      ${province_List}
  END
  FOR  ${i}  IN RANGE   ${province_count}   ${total}
    ${City_Slug_Name}                       handle Slug As Expected        ${Location_List}[${i}][city_name]   ${Location_List}[${i}][city_slug]
    ${city_List}                            Create List                    ${Location_List}[${i}][city_name]   ${Location_List}[${i}][city_slug]    ${City_Slug_Name}
    Append To List                          ${result}                      ${city_List}
  END
  [Return]                                  ${result}

handle Slug As Expected
  [Arguments]                              ${name}                         ${Slug}
  Run Keyword If                           '${Slug}' == '${EMPTY}'         Fail    location slug is empty
  Run Keyword If                           '${name}' == '${EMPTY}'         Fail    location name is empty
  ${Slug}                                  Set Variable                    ${Slug.replace('-', ' ')}
  ${match}   ${value}                      Run Keyword And Ignore Error    Should Contain    ${Slug}     استان
  ${ret}                                   Set Variable If  '${match}' == 'PASS'   ${Slug}   ${name}
  [Return]                                 ${ret}



Create Suitable URL
    [Arguments]                            @{arguments}
    ${URL}                                 Set Variable                    ${EMPTY}
    FOR  ${argument}  IN  @{arguments}
      Continue For Loop If                 '${argument}' == '${EMPTY}'
      ${argument}                          Strip String                    ${argument}
      ${argument}                          Set Variable                    ${argument.replace(' - ', ' ')}
      ${argument}                          Set Variable                    ${argument.replace('(', '')}
      ${argument}                          Set Variable                    ${argument.replace(')', '')}
      ${argument}                          Set Variable                    ${argument.replace(' | ', '-')}
      ${argument}                          Set Variable                    ${argument.replace(' ، ', ' ')}
      ${argument}                          Set Variable                    ${argument.replace('، ', ' ')}
      ${argument}                          Set Variable                    ${argument.replace(' ،', ' ')}
      ${argument}                          Set Variable                    ${argument.replace(' و ', ' ')}
      # ${argument}                          Set Variable                    ${argument.replace('  ', ' ')}
      ${argument}                          Set Variable                    ${argument.replace(' ', '-')}

      ${argument}                          Convert Digits                  ${argument}    fa2en
      ${argument}                          Set Variable                    ${argument.lower()}
      ${URL}                               Set Variable                    ${URL}/${argument}
    END
    [Return]                               ${URL}

Validate Title Seo Rules
    Run Keyword And Continue On Failure    Should Be Equal                 ${title}     ${title_exp}
    ...  msg=Seo Title did not match the provided pattern in ${Full_URL} as: \nCURRENT: ${title}\n\nEXPECTED: ${title_exp}\n\nmore info: ${Title_desc_Doc_URL}      values=False
    ${status}                                  Run Keyword And Return Status            Should Be Equal       ${title}   ${title_exp}
    Run Keyword Unless                    ${status}                      Log Test Status   ${Full_URL}  ${type}   Title   ${title}  ${title_exp}   ${status}
    # Log Test Status   ${Full_URL}  ${type}   Title   ${title}  ${title_exp}   ${status}


Validate Description Seo Rules
    Run Keyword And Continue On Failure           Should Be Equal        ${desc}     ${desc_exp}
    ...  msg=Seo description did not match the provided pattern in ${Full_URL} as: \nCURRENT: ${desc}\n\nEXPECTED: ${desc_exp}\n\nmore info: ${Title_desc_Doc_URL}     values=False
    ${status}                                  Run Keyword And Return Status            Should Be Equal       ${desc}   ${desc_exp}
    Run Keyword Unless                    ${status}                       Log Test Status   ${Full_URL}  ${type}   Description   ${desc}  ${desc_exp}  ${status}
    # Log Test Status   ${Full_URL}  ${type}   Description   ${desc}  ${desc_exp}  ${status}


Validate Header Seo Rules
    ${header1}                             Set Variable If                     '${h1}' == 'False'            ${False}       ${h1}
    Run Keyword If  '${header1}' != 'False'
    ...  Validate Real H1                  ${header1}                          ${h1_exp}

Validate Real H1
    [Arguments]                            ${h1}                               ${h1_exp}
    ${h1}                                  Clean All Extra Spaces              ${h1}
    Run Keyword And Continue On Failure         Should Be Equal               ${h1}                         ${h1_exp}
    ...  msg=Seo H1 did not match the provided pattern in ${Full_URL} as: \nCURRENT: ${h1}\n\nEXPECTED: ${h1_exp}\n\nmore info: ${Headerc_Doc_URL}     values=False
    ${status}                                  Run Keyword And Return Status            Should Be Equal       ${h1}   ${h1_exp}
    Run Keyword Unless                    ${status}                       Log Test Status   ${Full_URL}  ${type}   Description   ${h1}  ${h1_exp}  ${status}
    # Log Test Status   ${Full_URL}  ${type}   Description   ${h1}  ${h1_exp}  ${status}

Get The Title Description And Header From Page
    ${title}  ${desc}  ${h1}  ${Count}     Get Seo Values                URL=${data}[2]
    Set Test Variable                      ${title}
    Set Test Variable                      ${desc}
    Set Test Variable                      ${h1}
    Set Test Variable                      ${Count}
