*** Settings ***
resource                                               ../../resources/seo.resource
Suite Setup                                            Create Initial Data              category=وسایل نقلیه         subcategory=خودرو
Test Setup                                             Set Test Environment
Test Template                                          Validate Seo Rules of ${data}
Force Tags                                             Seo
Test Teardown                                          TearDown Tasks

*** Variables ***
${Type}                                                cars_with_filter
${isCertified}                                         کارشناسی شده
${isCertified_URL}                                     کارشناسی خودرو
${bodyType}                                            سدان (سواری)

@{zeroWorkedList}                                      نو/کارکرده    نو      کارکرده
${zero_title_desc}                                     صفر و انواع ماشین نو
${worked_title_desc}                                   کارکرده و دست دوم
${ZeroWorked_title}                                    صفر و کارکرده
${ZeroWorked_desc}                                     دست دوم و نو
${zero_h1}                                             صفر
${worked_h1}                                           کارکرده

@{PaymentType}                                         نقدی/اقساطی   نقدی    اقساطی

*** Test Cases ***
Validate Seo Description And Title For Car With Filters
    [Tags]                                              car   filter
    FOR        ${data}     IN      @{random_data}
      ${data}
    END

*** Keywords ***
Validate Seo Rules of ${data}
    Set Test Variable                                   ${data}
    log all Variables
    Get The Title Description And Header From Page
    Set The Seo Rules Values
    Validate Title Seo Rules
    Validate Description Seo Rules
    Validate Header Seo Rules

log all Variables
    FOR  ${item}  IN   @{data}
      log  ${item}
    END


Create Initial Data
    [Arguments]                                         ${category}                   ${subcategory}                       ${province}=${EMPTY}
    ${brand}   ${model_List}                            Get Random Model Of A Brand   category=${category}                 subcategory=${subcategory}     counter=30
    ${length}                                           Get Length                    ${model_List}
    ${province_count}                                   Convert To Integer            ${length * 0.65}
    ${city_count}                                       Set Variable                  ${length -1 -${province_count}}
    ${Location_List}                                    Make Locations List           province_count=${province_count}     city_count=${city_count}        province=${province}
    ${random_data}                                      Create List
    FOR  ${location}  ${model}  IN ZIP                  ${Location_List}              ${model_List}
      Set Random Payment Type
      Set Random Zero Worked
      ${URL}                                            Create Suitable URL           ${Location}[1]                       ${category}    ${subcategory}    ${brand}    ${isCertified_URL}   ${bodyType}   ${model}   ${ZeroWorked_URL}   ${paymentType_URL}
      ${data}                                           Create List                   ${location}  ${brand}    ${URL}   ${model}   ${Random_ZeroWorked}    ${Random_PaymentType}
      Append To List                                    ${random_data}                ${data}
    END
    Set Suite Variable                                  ${random_data}

Set The Seo Rules Values
    ${title_exp}     ${desc_exp}                        ${h1_exp}                              Set Expected Variables
    ...  adsCount=${Count}                              Type=${Type}                           locationName=${data}[0][2]       brand=${data}[1]
    ...  model=${data}[3]                               bodyType=${bodyType}                   paymentType=${data}[5]
    ...  new_used_title=${data}[4][0]                   new_used_description=${data}[4][1]     new_used_h1=${data}[4][2]        isCertified=${isCertified}
    Set Test Variable                                   ${title_exp}
    Set Test Variable                                   ${desc_exp}
    Set Test Variable                                   ${h1_exp}
    Set Test Variable                                   ${Type}

Set Random Payment Type
    ${Random_PaymentType}                               Evaluate                      random.choice($PaymentType)   random
    ${paymentType_URL}                                  Set Variable If
    ...  '${Random_PaymentType}' == 'نقدی/اقساطی'       ${EMPTY}
    ...   ${Random_PaymentType}
    ${Random_PaymentType}                               Set Variable If
    ...  '${Random_PaymentType}' == 'نقدی/اقساطی'       ${EMPTY}
    ...   به صورت ${Random_PaymentType}
    Set Suite Variable                                  ${Random_PaymentType}
    Set Suite Variable                                  ${paymentType_URL}

Set Random Zero Worked
    ${Random_ZeroWorked}                                Evaluate                      random.choice($zeroWorkedList)   random
    ${ZeroWorked_URL}                                   Set Variable If
    ...  '${Random_ZeroWorked}' == 'نو/کارکرده'         ${EMPTY}
    ...   ${Random_ZeroWorked}

    ${new_used_title}                                   Set Variable If
    ...  '${Random_ZeroWorked}' == 'نو/کارکرده'         ${ZeroWorked_title}
    ...  '${Random_ZeroWorked}' == 'نو'                 ${zero_title_desc}
    ...  '${Random_ZeroWorked}' == 'کارکرده'            ${worked_title_desc}

    ${new_used_description}                                   Set Variable If
    ...  '${Random_ZeroWorked}' == 'نو/کارکرده'         ${ZeroWorked_desc}
    ...  '${Random_ZeroWorked}' == 'نو'                 ${zero_title_desc}
    ...  '${Random_ZeroWorked}' == 'کارکرده'            ${worked_title_desc}

    ${new_used_h1}                                      Set Variable If
    ...  '${Random_ZeroWorked}' == 'نو/کارکرده'         ${EMPTY}
    ...  '${Random_ZeroWorked}' == 'نو'                 ${zero_h1}
    ...  '${Random_ZeroWorked}' == 'کارکرده'            ${worked_h1}

    ${Random_ZeroWorked}                                Create List        ${new_used_title}     ${new_used_description}    ${new_used_h1}
    Set Suite Variable                                  ${Random_ZeroWorked}
    Set Suite Variable                                  ${ZeroWorked_URL}
