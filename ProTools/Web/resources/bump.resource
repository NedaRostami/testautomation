*** Settings ***
Resource         setup.resource



*** Variables ***
${refresh}                                           refresh-package
${refresh_24}                                        vitrine_24-package
${refresh_48}                                        vitrine_48-package

*** Keywords ***
Login To Admin Page To Create Discount Code
    Go To                                            ${SERVER}/trumpet/coupon/search
    ${status}                                        Run Keyword And Return Status      Wait Until Page Contains           نوع کوپن      timeout=10s
    Run Keyword If                                   not ${status}                      Login Trumpet Admin Page

Create Discount Code
    [Arguments]                                       ${BumpeType}
    Wait Until Page Contains                          نوع کوپن      timeout=10s
    # click element                                     //*[@id="bump-coupon-search"]/button
    Click New Coupon And Validate
    Input Discount Code
    Input Text                                        id:ciscount                   100
    Select Start And End Date
    # click element                                     id:coupon_type
    Select From List By Value                         id:coupon_type          ${BumpeType}
    # Click Element                                     ${bump_type}
    Input Text                                        id:uses_total            10000
    Input Text                                        id:uses_user             10000
    Execute Javascript                                jQuery('#coupon-modal [type="submit"]').click()   #تایید
    Wait Until Page Contains                          ثبت کد تخفیف فعال               timeout=3s    error=None
    Execute Javascript                                jQuery('[class="yes btn btn-primary"]').click()  #بله
    Wait Until Page Is Loaded in Moderation
    FOR  ${INDEX}   IN RANGE   1   6
      ${Cupon}                                       get text                         //*[@id="coupon-results"]/tbody/tr[${INDEX}]/td[3]
      ${status}                                      Run Keyword And Return Status    Should Be Equal    ${Cupon}    ${Random_Code}
      Exit For Loop If                               ${status}
    END
    Run Keyword Unless                                ${status}      Fail    Can Not Create Discount Bump

Click New Coupon And Validate
   FOR   ${i}    IN RANGE     3
     Run Keyword And Ignore Error      click button                              کد تخفیف جدید
     ${status}                         Run Keyword And Return Status             Wait Until Page Contains Element              css:div.modal.in            timeout=3s     error=new coupon form is not visible
     Exit For Loop If                  ${status}
   END

Select Start And End Date
    Set Discount Start And End date
    click Element                     id:sd
    Wait Until Page Contains element  //span[@unixdate='${SDED}[0]']
    click element                     //span[@unixdate='${SDED}[0]']
    click element                     id:ed
    @{elements}                       get Webelements    //span[@unixdate='${SDED}[1]']
    ${Status}                         Run Keyword And Return Status    Page Should Contain Element    ${elements}[1]
    Run Keyword If    ${Status}       click element   ${elements}[1]    ELSE    Select Next Month

Select Next Month
   @{nexts}                           get Webelements                  css=.btn-next
   click element                      ${nexts}[1]
   ${NextMonth}                       Convert To Integer                             ${SDED}[1]
   ${NextMonth}                       Set Variable                                   ${NextMonth+3600000}
   ${Status}                          Run Keyword And Return Status    Page Should Contain Element     //span[@unixdate='${NextMonth}']
   ${NextDay}                         Set Variable If    ${Status}     //span[@unixdate='${NextMonth}']   //span[@unixdate='${NextMonth-7200000}']
   @{ENDDATE}                         get Webelements                  ${NextDay}
   Wait Until Keyword Succeeds        3x  3s                           click element                      ${ENDDATE}[1]

Set Discount Start And End date
   ${date}  	          Get Current Date	  result_format=datetime                    exclude_millis=True
   ${DayStr}            Convert To String   ${date.day}
   ${DLength}           Get Length          ${DayStr}
   ${Day}               Set Variable If     ${DLength} == ${1}                        0${date.day}      ${date.day}
   ${MonthStr}          Convert To String   ${date.month}
   ${MLength}           Get Length          ${MonthStr}
   ${Month}             Set Variable If     ${MLength} == ${1}                        0${date.month}    ${date.month}
   ${Date}  	          Convert Date	      ${date.year}${Month}${Day} 00:00:00.0
   ${Start}             Convert Date	      ${Date}                                   epoch             exclude_millis=yes
   ${StartStr}          Convert To String   ${Start}
   ${END}               Set Variable        ${Start+86400}
   ${END}               Convert To String   ${END}
   ${StartDate}         Replace String      ${StartStr}                               .0               000
   ${EndDate}           Replace String      ${END}                                    .0               000
   Set Test Variable    @{SDED}             ${StartDate}       ${EndDate}

Input Discount Code
    ${Random_String}        Generate Random String      24
    Set Test Variable       ${Random_Code}              ${Random_String}
    Input Text    id:code   ${Random_Code}

Bump a listing In Protools Successfully For ${BumpeType} by ${Bump_Price}
    Set Test Payment Gateway            success
    Set Test Variable                   ${BumpeType}
    Create New Listing                  Land Main Attribute For Rent    1    44099    house   District=n1203
    Validate Advertise is Verified
    FOR       ${INDEX}    IN RANGE    0    3
      Click To Show Page     real-estate          listings         ${LISTINGS_LIST}
      ${Status}                           Run Keyword And Return Status         Page Should Contain Element        name:${BUMP}
      Exit For Loop If                    ${Status}
    END
    Click By Name                       ${BUMP}
    Wait Until Page Contains            بسته مورد نظر را انتخاب کنید            timeout=10s
    Sleep                               2s
    Click Element                       name:${Bump_Price}
    Click By Name                       ${APPLY_BUMP}
    Wait Until Page Contains           پرداخت شما با موفقیت انجام شد.           timeout=10s
    Click Link                          بازگشت به برنامه
    Wait Until Page Contains            مدیریت آگهی‌ها                           timeout=10s
    Delete Listing

Bump a listing Unsuccessfully For ${BumpeType} by ${Bump_Price}
    Set Test Payment Gateway            failure
    Set Test Variable                   ${BumpeType}
    Create New Listing                  Land Main Attribute For Rent    1    44099    house    District=n1216
    Validate Advertise is Verified
    FOR       ${INDEX}    IN RANGE    0    3
      Click To Show Page     real-estate          listings        ${LISTINGS_LIST}
      ${Status}                           Run Keyword And Return Status           Page Should Contain Element        name:${BUMP}
      Exit For Loop If                    ${Status}
    END
    Click By Name                       ${BUMP}
    Wait Until Page Contains            بسته مورد نظر را انتخاب کنید
    Sleep                               2s
    Click Element                       name:${Bump_Price}
    Click By Name                       ${APPLY_BUMP}
    Wait Until Page Contains            عملیات پرداخت شما ناموفق بود.           timeout=10s
    Click Link                          بازگشت به برنامه
    Wait Until Page Contains            مدیریت آگهی‌ها

Bump ${BumpeType} with Discount Code by ${Bump_Price}
    Login To Admin Page To Create Discount Code
    Create Discount Code                ${BumpeType}
    Set Test Payment Gateway            success
    Set Test Variable                   ${BumpeType}
    Set Test Variable                   ${Bump_Price}
    Go to                               ${SERVER}/pro/real-estate/listings
    Create New Listing                  Land Main Attribute For Rent    1    44099    house     District=n4696
    Validate Advertise is Verified
    FOR       ${INDEX}    IN RANGE    0    3
      Click To Show Page     real-estate          listings        ${LISTINGS_LIST}
      ${Status}                           Run Keyword And Return Status           Page Should Contain Element        name:${BUMP}
      Exit For Loop If                    ${Status}
    END
    Click By Name                       ${BUMP}
    Wait Until Page Contains            بسته مورد نظر را انتخاب کنید            timeout=10s
    Sleep                               2s
    Click Element                       name:${Bump_Price}
    Input By Name                       coupon                                  ${Random_Code}
    Click By Name                       apply-coupon
    Wait Until Page Contains            کد تخفیف با موفقیت ثبت شد               timeout=10s
    Wait Until Page Does Not Contain    کد تخفیف با موفقیت ثبت شد               timeout=10s
    Click By Name                       ${APPLY_BUMP}
    Wait Until Page Contains            پرداخت شما با موفقیت انجام شد.                  timeout=10s
    Click Link                          بازگشت به برنامه
    Wait Until Page Contains            مدیریت آگهی‌ها                           timeout=10s
    Delete Listing
