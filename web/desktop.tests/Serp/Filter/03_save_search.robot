*** Settings ***
Documentation                                          At first search for real estate and login
...                                                    to save the search.Then validate search fields.
...                                                    Then try to save the same search again
...                                                    but get the message that it is repetitive.
...                                                    At the end delete saved search.
Test Setup                                             Open test browser
Test Teardown                                          Clean Up Tests
Resource                                               ../../../resources/serp.resource

*** Variables ***
${advanced_search}                                     لرستان-خرم-آباد/املاک/رهن-اجاره-خانه-آپارتمان/آپارتمان?a68133=439414&a68190=true&a69189=445359&a92000=true&mn68085=50&mn68090=10000000&mn68092=1000000&mx68085=500&mx68090=200000000&mx68092=4000000
@{tags}                                                شهر: خرم آباد
...                                                    رهن و اجاره خانه و آپارتمان
...                                                    حداقل رهن: ۱۰,۰۰۰,۰۰۰
...                                                    حداکثر رهن: ۲۰۰,۰۰۰,۰۰۰
...                                                    حداقل اجاره: ۱,۰۰۰,۰۰۰
...                                                    حداکثر اجاره: ۴,۰۰۰,۰۰۰
...                                                    قابلیت تبدیل مبلغ رهن و اجاره
...                                                    نوع ملک: آپارتمان
...                                                    سن بنا: ۲-۵ سال
...                                                    حداقل متراژ: ۵۰
...                                                    حداکثر متراژ: ۵۰۰
...                                                    تعداد اتاق: ۱
...                                                    فقط آگهی‌های آژانس‌های املاک

*** Test Cases ***
Save Search
    [Tags]                                             save search                                   my search                   serp
    Open Serp With Ready Search Attributes
    Validate Serp Filter
    Save Search
    Go To My Saved Search Page
    Validate Saved Search Tags
    Click Search Link
    Validate Serp Filter
    Try To Save The Search Again
    Delete Saved Search

*** Keywords ***
Open Serp With Ready Search Attributes
    Go To                                              ${SERVER}/${advanced_search}
    Wait Until Page Contains Element                   ${Serp_Filter}                                timeout=10s

Validate Serp Filter
    Validate Serp Advanced Search Section
    Validate Serp Tags

Validate Serp Advanced Search Section
    Element Should Contain                             ${Serp_F_Category_Menu}                       رهن و اجاره خانه و آپارتمان
    Element Should Contain                             ${Serp_F_Location_Menu}                       شهر خرم آباد
    Textfield Should Contain                           ${Serp_F_Re_Min_Mortgage}                     10,000,000
    Textfield Should Contain                           ${Serp_F_Re_Max_Mortgage}                     200,000,000
    Textfield Should Contain                           ${Serp_F_Re_Min_Rent}                         1,000,000
    Textfield Should Contain                           ${Serp_F_Re_Max_Rent}                         4,000,000
    Textfield Should Contain                           ${Serp_F_Re_Min_Area}                         50
    Textfield Should Contain                           ${Serp_F_Re_Max_Area}                         500
    List Selection Should Be                           ${Serp_F_Re_Type}                             آپارتمان
    List Selection Should Be                           ${Serp_F_Re_Building_Age}                     ۲-۵ سال
    List Selection Should Be                           ${Serp_F_Re_Num_Of_Rooms}                     ۱
    # Checkbox Should Be Selected                        name:a68190
    # Checkbox Should Be Selected                        name:a92000
    ${no_result}                                       Run Keyword And Return Status                 Page Should Contain Element            ${Serp_F_No_Result}
    Run Keyword Unless                                 ${no_result}                                  Page Should Contain                    رهن و اجاره خانه و آپارتمان در خرم آباد

Validate Serp Tags
    FOR      ${index}    ${tag}    IN ENUMERATE        @{tags}                                       start=1
        Set Serp Tag Variable And Validate Position    ${index}                                      ${tag}
    END

Save Search
    Click Element                                      ${Serp_F_Save_Search_Btn}
    Wait Until Page Contains Element                   ${Serp_F_Save_Search_Popup}                   timeout=5s
    Login By Random User
    Click Button                                       ${Serp_Save_Search_Btn_Popup}
    Wait Until Page Contains                           ${Msg_Of_Successfully_Save_Search}            timeout=5s

Go To My Saved Search Page
    go to                                              ${SERVER}/session/mySavedSearches
    Refresh Varnish
    Wait Until Page Contains Element                   ${My_Search_Items}                            timeout=10s
    Check Backend Errors                               failure=${TRUE}

Validate Saved Search Tags
    FOR     ${index}    ${tag}    IN ENUMERATE         @{tags}                                       start=1
      Set My Search Tag Variable And Validate          ${index}                                      ${tag}
    END

Set My Search Tag Variable And Validate
    [Arguments]                                        ${index}                                      ${Txt}
    ${tag_selector}                                    Set Variable                                  ${My_Search_Tag.format(${index},'${Txt}')}
    Wait Until Page Contains Element                   ${tag_selector}                               timeout=5s

Login By Random User
    Click Link                                         ${Auth_Login_Btn_In_Save_Search}
    Register User By Mobile for Save Search

Register User By Mobile for Save Search
    Login OR Register By Random OR New Mobile          ${Auth_Save_Search_Position}

Click Search Link
    Click Link                                         رهن و اجاره خانه و آپارتمان
    Wait Until Page Contains Element                   ${Serp_Filter}                                timeout=10s

Try To Save The Search Again
    Click Element                                      ${Serp_F_Save_Search_Btn}
    Wait Until Page Contains Element                   ${Serp_F_Save_Search_Popup}                   timeout=5s
    Click Button                                       ${Serp_Save_Search_Btn_Popup}
    Wait Until Page Contains Element                   ${Serp_Save_Search_Duplicate_Popup}           timeout=5s

Delete Saved Search
    Click Link                                         مشاهده جستجوها
    Wait Until Page Contains Element                   ${My_Search_Items}                            timeout=10s
    Click Button                                       ${My_Search_Delete_Btn}
    Wait Until Page Contains Element                   ${My_Search_Empty_Btn}                        timeout=5s
    SeleniumLibrary.Element Text Should Be             ${My_Search_Empty_Msg_Element}                ${My_Search_Empty_Msg}
