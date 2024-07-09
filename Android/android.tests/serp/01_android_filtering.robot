*** Settings ***
Resource                                 ..${/}..${/}resources${/}common.resource
Suite Setup                              Set Suite Environment
Test Setup                               start app
Test Teardown                            Close test application
Test Timeout                             10 minutes

*** Test Cases ***
Android Filtering
    [Tags]                               Filtering
    Filter Category                      وسایل نقلیه      خودرو
    Click Filter
    Filter Car Brand
    Click Spinner                        نوع شاسی
    Scroll The List                      سدان (سواری)
    Click Spinner                        نقدی/اقساطی
    Scroll The List                      نقدی
    Click Spinner                        نو / کارکرده
    Scroll The List                      کارکرده
    Click Spinner                        حداقل سال تولید
    Scroll The List                      ۱۳۷۸ (۱۹۹۹)
    Click Spinner                        حداکثر سال تولید
    Scroll The List                      ۱۳۹۶ (۲۰۱۷)
    Click Spinner                        حداقل کیلومتر
    Scroll The List                      ۱۰۰۰۰
    Click Spinner                        حداکثر کیلومتر
    Scroll The List                      ۱۰۰۰۰۰
    Click Spinner                        رنگ
    Scroll The List                      سفید
    Click Spinner                        گیربکس
    Scroll The List                      دنده‌ای
    Click Spinner                        وضعیت بدنه
    Scroll The List                      دو لکه رنگ
    Click The Switch                     کارشناسی شده    0
    Input Attribute                      قیمت از (تومان)        10000000
    Input Attribute                      قیمت تا (تومان)     80000000
    Filter Location
    #Run Keyword And Ignore Error         click element     id=${APP_PACKAGE}:id/fragmentPostAdButton
    Wait Until Page Contains Element     ${FILTER_BUTTON}
    Click Element                        ${FILTER_BUTTON}
    Validate State and Category

*** Keywords ***
Validate State and Category
  Wait Until Page Contains Element       ${FILTER_COUNT}    timeout=20
  ${ilter_count}                         get text         ${FILTER_COUNT}
  Should Be True                         ${ilter_count} > 12
  Run Keyword If                         '${file_version}' < '5.9.0'    Element Should Contain Text    ${TOTAL_NUMBER_TEXT}    آگهی وسایل نقلیه
  ...  ELSE                              Element Should Contain Text    ${CATEGORY_HEADER}    خودرو
  Element Should Contain Text            ${REGION_HEADER}      تهران
  Page Should Contain Text               تهران
