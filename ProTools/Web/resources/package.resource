*** Settings ***
Resource         setup.resource


*** Variables ***
${duration}                            30
${shopLimit}                           100
${refresh}                             15
${vitrine_24}                          10
${vitrine_48}                          5
${limit}                               3
${PaymentLink}                         //*[@id="shop-package-results-generic"]/tbody/tr/td[10]/a   #لینک پرداخت
${Selected_Package}                    //*[@id="newShopProfileForm"]/form/div/div/div[3]/label/input     #Package C

*** Keywords ***
Enable Shop Package
    Go to                             ${SERVER}/trumpet/shop/profile
    Login Trumpet Admin Page
    Click Buy Package Button
    Package Is Selected               Package C
    input text                        price                                     10000
    input text                        duration                                  ${duration}
    input text                        shopPackageListingLimit                   ${shopLimit}
    input text                        paid_features[1]                          ${refresh}
    input text                        paid_features[2]                          ${vitrine_24}
    input text                        paid_features[3]                          ${vitrine_48}
    input text                        paid_features[4]                          ${limit}
    click element                     //input[@value='افزودن']
    Wait Until Page Contains          عملیات با موفقیت انجام شد                timeout=5s
    Wait Until Page Contains          نام بسته: Package C                      timeout=5s
    Wait Until Page Contains          ایجاد توکن                               timeout=5s
    SeleniumLibrary.Element Text Should Be            //*[@id="shop-package-results-generic"]/tbody/tr/td[3]    30
    SeleniumLibrary.Element Text Should Be           //*[@id="shop-package-results-generic"]/tbody/tr/td[4]    100
    click element                     //*[@class="btn btn-success fr-remove btn-block package-activate"]
    Wait Until Page Contains Element  xpath://div[@class='alert alert-danger']//h4
    Wait Until Element Contains       xpath://div[@class='alert alert-danger']//h4                        با فعال سازی این بسته سایر بسته ها غیر فعال خواهند شد، آیا از فعال سازی اطمینان دارید؟           timeout=10s
    click button                      بله
    Wait Until Page Contains          عملیات با موفقیت انجام شد               timeout=5s
    Wait Until Page Contains Element  //*[@class="btn btn-danger fr-remove btn-block package-inactivate"]           timeout=5s
    Wait Until Page Contains          غیر فعال کردن                            timeout=5s
    Click Payment Link And Validate

Click Payment Link And Validate
    FOR   ${i}    IN RANGE     3
      Run Keyword And Ignore Error      click element                             ${PaymentLink}
      ${status}                         Run Keyword And Return Status             Wait Until Page Contains            بانک سامان                      timeout=5s
      Exit For Loop If                  ${status}
      ${status}                         Run Keyword And Return Status             Page Should Contain                 بانک تست
      Exit For Loop If                  ${status}
    END

Package Is Selected
    [Arguments]                       ${Package}
    FOR       ${INDEX}    IN RANGE    0    3
      Click By Text                   ${Package}
      ${Status}                       Run Keyword And Return Status    Checkbox Should Be Selected     ${Selected_Package}
      Exit For Loop If                ${status}
    END

Click Buy Package Button
    FOR   ${i}    IN RANGE     3
      ${status}                         Run Keyword And Return Status
      ...                               Wait Until Page Contains Element  //td[text()='${Shop_Slug}']/following-sibling::td//a[contains(text(),'بسته')]        timeout=5s
      Run Keyword If                    ${status}                  Click Element                     //td[text()='${Shop_Slug}']/following-sibling::td//a[contains(text(),'بسته')]
      ${status}                         Run Keyword And Return Status
      ...                               Wait Until Page Contains                                     مدیریت بسته / فروشگاه: ${Shop_Title}     timeout=5s
      Exit For Loop If                  ${status}
    END

Validate Shop Package From Protools
    [Arguments]                                                 ${Refresh}                                ${Vitrine24}         ${Vitrine48}      ${Limitation}
    Click To Show Page                                          real-estate                               packages             list-item-packageManagement
    Reload Page To Find Text                                    مدیریت بسته های تیم
    ${Refresh}                                                  Convert Digits                            ${Refresh}           En2Fa
    Element Text Should Be                                      name:refresh                              ${Refresh} بسته
    Convert Digits                                              ${Vitrine24}                              En2Fa
    ${Vitrine24}                                                Convert Digits                            ${Vitrine24}         En2Fa
    Element Text Should Be                                      name:vitrine_24                           ${Vitrine24} بسته
    Convert Digits                                              ${Vitrine48}                              En2Fa
    ${Vitrine48}                                                Convert Digits                            ${Vitrine48}         En2Fa
    Element Text Should Be                                      name:vitrine_48                           ${Vitrine48} بسته
    Convert Digits                                              ${Limitation}                             En2Fa
    ${Limitation}                                               Convert Digits                            ${Limitation}        En2Fa
    Element Text Should Be                                      name:limitation                          ${Limitation} بسته

Buy Hybrid Packages
    [Arguments]                                                 ${Package_Type}                           ${Package_Price}
    FOR       ${INDEX}    IN RANGE    0    3
      Click By Name                   buy-packages
      ${Status}                       Run Keyword And Return Status    Wait Until Page Contains           پیشنهاد ویژه        timeout=10s
      Exit For Loop If                ${status}
    END
    Click By Name                                               ${Package_Type}
    ${Price}                                                    Get Text                                name:${Package_Price}
    ${Apply_Btn_Text}                                           Get Text                                name:${SUBMIT_FILE}
    Should Be Equal                                             پرداخت ${Price} تومان                   ${Apply_Btn_Text}
    FOR       ${INDEX}    IN RANGE    0    3
      Click By Name                                               ${SUBMIT_FILE}
      ${Status}        Run Keyword And Return Status    Wait Until Page Contains                        پرداخت شما با موفقیت انجام شد.          timeout=5s
      Exit For Loop If       ${Status}
    END
    Click Link                                                  بازگشت به برنامه
    Wait Until Page Contains                                    پخش کردن بسته‌ها                         timeout=10s

Add Package Items
    [Arguments]                                                 ${Package_Item}              ${Package_Num}              ${Package_Num_Validation}
    FOR      ${i}     IN RANGE    0                             ${Package_Num_Validation}
        Click By Name                                           ${Package_Item}
    END
    ${Package_Num_Validation}                               Convert Digits               ${Package_Num_Validation}   En2Fa
    Element Text Should Be                                  name:${Package_Num}          ${Package_Num_Validation}

Assign Package To Shop Member
    [Arguments]                                                 ${Refresh_Assigned_Number}=${EMPTY}        ${Vitrine24_Assigned_Number}=${EMPTY}       ${Vitrine48_Assigned_Number}=${EMPTY}        ${Limitation_Assigned_Number}=${EMPTY}
    ${Consultant_Phones}                                        Get Values From List                      ${Shop_Consultant_List}                  phone
    Set Suite Variable                                          ${Consultant_Phones}                      ${Consultant_Phones}
    Click By Name                                               ${Consultant_Phones}[0]_package
    Wait Until Page Contains Element                            name:approved-action
    Run Keyword If	  '${Limitation_Assigned_Number}' != '${EMPTY}'  Add Package Items    limitation-add    limitation-pick-number       ${Limitation_Assigned_Number}
    Run Keyword If	  '${Refresh_Assigned_Number}' != '${EMPTY}'     Add Package Items    refresh-add       refresh-pick-number          ${Refresh_Assigned_Number}
    Run Keyword If	  '${Vitrine24_Assigned_Number}' != '${EMPTY}'   Add Package Items    vitrine24-add     vitrine24-pick-number        ${Vitrine24_Assigned_Number}
    Run Keyword If	  '${Vitrine48_Assigned_Number}' != '${EMPTY}'   Add Package Items    vitrine48-add     vitrine48-pick-number        ${Vitrine48_Assigned_Number}
    Click By Name                                               ${APPROVED}
    Wait Until Page Does Not Contain Element                    name:${APPROVED}
    Sleep    2s
    Run Keyword If	  '${Limitation_Assigned_Number}' != '${EMPTY}'  Element Text Should Be   name:${Consultant_Phones}[0]-limitation_${Limitation_Assigned_Number}   ${Limitation_Assigned_Number}
    Run Keyword If	  '${Refresh_Assigned_Number}' != '${EMPTY}'     Element Text Should Be   name:${Consultant_Phones}[0]-refresh_${Refresh_Assigned_Number}         ${Refresh_Assigned_Number}
    Run Keyword If	  '${Vitrine24_Assigned_Number}' != '${EMPTY}'   Element Text Should Be   name:${Consultant_Phones}[0]-vitrin24_${Vitrine24_Assigned_Number}      ${Vitrine24_Assigned_Number}
    Run Keyword If	  '${Vitrine48_Assigned_Number}' != '${EMPTY}'   Element Text Should Be   name:${Consultant_Phones}[0]-vitrin48_${Vitrine48_Assigned_Number}      ${Vitrine48_Assigned_Number}

Delete Assigned Packge
    Click By Name                                               ${TEAM_MANAGEMENT_ITEM}
    Wait Until Page Contains                                    افزودن همکار جدید                         timeout=10s
    Delete Colleagues                                           ${Consultant_Phones}[0]
