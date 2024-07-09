*** Settings ***
Documentation                                            In this scenario, every chip in filtering header is tested,
...                                                      after that each one is validated.
Resource                                                 ..${/}..${/}resources${/}common.resource
Suite Setup                                              Set Suite Environment
Test Setup                                               start app
Test Teardown                                            Close test application
Test Timeout                                             10 minutes

*** Variables ***
${real_stste}                                            املاک
${apartment_house_rent_mortgage}                         رهن و اجاره خانه و آپارتمان
${mortgage}                                              رهن
${min_mortgage}                                          حداقل رهن (تومان)
${min_mortgage_price}                                    5000000
${max_mortgage}                                          حداکثر رهن (تومان)
${max_mortgage_price}                                    100000000
${mortage_filter_num}                                    2
${rent}                                                  اجاره
${min_rent}                                              حداقل اجاره (تومان)
${min_rent_price}                                        500000
${max_rent}                                              حداکثر اجاره (تومان)
${max_rent_price}                                        100000000
${rent_filter_num}                                       4
${area}                                                  متراژ
${min_area}                                              حداقل متراژ
${min_area_price}                                        50
${max_area}                                              حداکثر متراژ
${max_area_price}                                        500
${area_filter_num}                                       6
${room}                                                   تعداد اتاق
${room_num}                                              ۲
${room_filter_num}                                       7
${real_state_listing}                                    آگهی املاک
${total_filter_num}                                      8

*** Test Cases ***
Chips Real State Filtering
  [Tags]                                                 Filtering                    Chips
  Set Chips Variables
  Appartment And House Rent And Mortgage Filtering
  Mortgage Filtering and validation
  Rent Filtering and validation
  Area Filtering and validation
  Number Of Rooms Filtering and validation
  Filter Location From Header
  Validate Filtered Serp Page

*** Keywords ***
Set Chips Variables
  Set Mortgage Variables
  Set Rent Variables
  Set Area Variables

Set Mortgage Variables
  @{mortgage_variables}                                  Create List                  ${mortgage}     ${min_mortgage}     ${min_mortgage_price}     ${max_mortgage}     ${max_mortgage_price}     ${mortage_filter_num}
  Set Test Variable                                      ${mortgage_variables}

Set Rent Variables
  @{rent_variables}                                      Create List                  ${rent}         ${min_rent}         ${min_rent_price}         ${max_rent}         ${max_rent_price}         ${rent_filter_num}
  Set Test Variable                                      ${rent_variables}

Set Area Variables
  @{area_variables}                                      Create List                  ${area}         ${min_area}         ${min_area_price}         ${max_area}         ${max_area_price}         ${area_filter_num}
  Set Test Variable                                      ${area_variables}

Appartment And House Rent And Mortgage Filtering
  Filter Category                                        ${real_stste}                ${apartment_house_rent_mortgage}
  Validate Selected Apartment Category

Mortgage Filtering and validation
  Input Chips Data                                       ${mortgage_variables}

Rent Filtering and validation
  Input Chips Data                                       ${rent_variables}

Area Filtering and validation
  Input Chips Data                                       ${area_variables}

Input Chips Data
  [Arguments]                                            ${chips_variable}
  Go To Next Chip
  Click Text                                             ${chips_variable}[0]
  Input Attribute                                        ${chips_variable}[1]                         ${chips_variable}[2]
  Input Attribute                                        ${chips_variable}[3]                         ${chips_variable}[4]
  Show Result
  Validate Filtered chips                                ${chips_variable}[5]

Number Of Rooms Filtering and validation
  Go To Next Chip
  Click Text                                             ${room}
  Click Text                                             ${room_num}
  Wait Until Page Does Not Contain Element               ${SERP_FILTER_BOTTOM_POPUP}                  timeout=5s
  Validate Filtered chips                                ${room_filter_num}

Show Result
  Click Element                                          ${FILTER_RESULT_BTN}
  Wait Until Page Does Not Contain Element               ${SERP_FILTER_BOTTOM_POPUP}                  timeout=5s

Go To Next Chip
  swipe by percent                                       10    15   70    15   1000

Validate Filtered chips
  [Arguments]                                            ${COUNT_OF_FILTERS}
  Wait Until Keyword Succeeds                            4x    2s                                     Element Text Should Be
  ...                                                    ${FILTER_COUNT}                              ${COUNT_OF_FILTERS}

Validate Selected Apartment Category
  IF                                                    '${file_version}' < '5.9.0'
    Element Should Contain Text                          ${TOTAL_NUMBER_TEXT}                         ${real_state_listing}
  ELSE
    Element Should Contain Text                          ${CATEGORY_HEADER}                           ${apartment_house_rent_mortgage}
  END

Validate Filtered Serp Page
  Wait Until Page Contains Element                       ${FILTER_COUNT}                              timeout=10s
  Validate Filtered chips                                ${total_filter_num}
