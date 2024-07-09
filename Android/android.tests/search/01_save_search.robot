*** Settings ***
Resource        ..${/}..${/}resources${/}common.resource
Suite Setup      Set Suite Environment
Test Setup       start app
Test Teardown    Close test application
Test Timeout     10 minutes

*** Variables ***

*** Test Cases ***
Save Search
    [Tags]    savesearch
    Filter Car In Tehran
    Validate State and Category
    click element             ${SAVE_SEARCH}
    Do Save Search
    check save search
    Check Home And Serp
    check save search
    Delete Save Search

*** Keywords ***
Check Home And Serp
    click the link                 ${SearchTitle}
    Validate State and Category
    # Click Back Button
    # Click Toolbar Account
    # Click Toolbar Items             ${SERP_LINK}
    # Validate First Initial Serp

Validate State and Category
    Wait Until Page Contains Element    ${FILTER_COUNT}       timeout=20
    ${ilter_count}     get text         ${FILTER_COUNT}
    Should Be True     ${ilter_count} > 12
    ${passed} =	Run Keyword And Return Status    Page Should Contain Text            پراید
    Run Keyword Unless    ${passed}  Page Should Contain Text       خودرو
    Element Should Contain Text    ${REGION_HEADER}       تهران
    Page Should Contain Text           تهران

Login By New Mobile
    Mobile Generator A
    Wait Until Page Contains Element       ${Mail_Number}                    timeout=10s
    Input Text    ${Mail_Number}      ${Random_User_Mobile_A}
    Sleep    2s
    Run Keyword And Ignore Error        Hide Keyboard
    Click Login Register Button
    Input SMS Code                      ${Random_User_Mobile_A}
    Run Keyword And Ignore Error        Hide Keyboard
    Sleep                               1s

check save search
    Click Back Button
    Click Toolbar Account
    Click Toolbar Items                  جستجوهای ذخیره شده
    Wait Until Page Contains Element     id=${APP_PACKAGE}:id/savedSearchToolbar                 timeout=10
    ${old}                               Set Variable              پراید صبا (صندوقدار) | تهران, تهران, آجودانیه
    ${new}                               Set Variable              1 مدل خودرو | آجودانیه
    ${SearchTitle}                       Set Variable If           ${MultiBrand}     ${new}     ${old}
    Wait Until Page Contains             ${SearchTitle}            timeout=10
    Run Keyword If                       ${MultiBrand}             Check Filter Count
    Set Test Variable                    ${SearchTitle}

Check Filter Count
    ${FiltersCount}                      get text              id=${APP_PACKAGE}:id/tv_otherFiltersCount
    Should Be Equal                      ${FiltersCount}       5

Delete Save Search
    click element                        id=${APP_PACKAGE}:id/deleteImageView
    # Wait Until Page Contains             آیا مطمئن هستید که میخواهید این جستجو را حذف کنید؟      timeout=5
    Wait Until Page Contains             آیا از حذف این جستجو اطمینان دارید؟      timeout=5
    click element                        id=android:id/button1
    Wait Until Page Contains             با استفاده از قابلیت ذخیره جستجوها می‌توانید جستجوهای مورد نظرتان را ذخیره کنید و به صورت روزانه از به‌روزرسانی نتایج جستجوی خود مطلع شوید.     timeout=10
