*** Settings ***
Resource                                      ../../../../resources/application.resource
Variables                                     ../vars/vars.py
Resource                                      versions${/}${file_version}.resource
Variables                                     ..${/}vars/Variables.py                                     ${file_version}

*** Variables ***
${First_Header}                               ثبت و مدیریت رایگان فایل
${Second_Header}                              ثبت درخواست‌های مشتریان
${Third_Header}                               همراه فایل
${Fourth_Header}                              ثبت و مدیریت آگهی
${First_Body}                                 فایل‌های خود را ثبت و در زمان مناسب
${Second_Body}                                با ثبت اطلاعات تماس و جزئیات ملک درخواستی مشتریان، لیست فایل‌های متناسب به شما نمایش داده می‌شود
${Third_Body}                                 با همراه فایل به لیست مالکان و متقاضیان شخصی املاک در سراسر ایران دسترسی پیدا می‌کنید
${Fourth_Body}                                به آسانی آگهی‌های خود را در شیپور ثبت، ویرایش و بروزرسانی کنید
${Enter_Button}                               accessibility_id=app-intro-button3
@{Slider_Header}                              ${Second_Header}                  ${Third_Header}                ${Fourth_Header}
@{Slider_Body}                                ${Second_Body}                    ${Third_Body}                  ${Fourth_Body}
${Submit_Phone_Number}                        accessibility_id=submitPhone
*** Keywords ***
prepare app for test
  start app
  Skip Slider

Skip Slider
  Wait Until Page Contains                    ${First_Header}                   timeout=10s
  Page Should Contain Text                    ${First_Body}
  Move Slider To Enter App


Move Slider To Enter App
  FOR    ${INDEX}                             IN RANGE       3
    Swipe Slider
    ${Status}                                 Run Keyword And Return Status     Check If This Is A Correct Slider[${INDEX}]
  END
  Sleep                                       5s
  Click Element                               ${Enter_Button}

Check If This Is A Correct Slider
  [Arguments]                                 ${Slider_Header}                  ${Slider_Body}
  Wait Until Page Contains                    ${Slider_Header}                  timeout=5s
  Should Contain                              ${Slider_Body}


Swipe Slider
  swipe by percent                            90    20   10    20    1000

Login By Mobile
    [Arguments]                               ${Mobile}=${EMPTY}
    Run Keyword If                            '${Mobile}'=='${EMPTY}'           Mobile Generator A
    ...   ELSE                                Set Suite Variable                ${Random_User_Mobile_A}         ${Mobile}
    Wait Until Page Contains Element          ${Mail_Number}
    Input Text                                ${Mail_Number}                    ${Random_User_Mobile_A}
    Run Keyword And Ignore Error              Hide Keyboard
    Click Login Register Button
    Input SMS Code                            ${Random_User_Mobile_A}
    Click Confirm SMS

Mobile Generator A
    ${Random_Number}                          Generate Random String            7                               [NUMBERS]
    Set Suite Variable                        ${Random_User_Mobile_A}           0900${Random_Number}

Click Login Register Button
   Click Element                              ${Submit_Phone_Number}

Input SMS Code
   [Arguments]                                ${MobileNo}
   FOR  ${INDEX}                              IN RANGE  0   3
      ${status}                               Run Keyword And Return Status     Wait Until Page Contains Element
      ...                                     ${Confirm_Digit}                  timeout=10
      Exit For Loop If                        ${status}
      Run Keyword If                          not ${status}                     Click Login Register Button
   END
   Run Keyword If                             not ${status}                     Fail       Can't click register Btn
   Tap                                        ${Confirm_Digit}
   ${Code}                                    Wait Until Keyword Succeeds       3x    1s    Verify Code From Server  ${MobileNo}
   Insert Code                                ${Code}

Insert Code
   [Arguments]                                ${Number}
   ${Length}                                  get Length                        ${Number}
   FOR   ${index}                             IN RANGE   0                      ${Length}
       ${Char}  	                            Get From List	                    ${Number}	                           ${index}
       ${key}                                 Evaluate                          ${Char} + 7
       Press Keycode                          ${key}
       Wait Until Keyword Succeeds            3x    1s                          Element Text Should Be
       ...                                    accessibility_id=codeField_${index+1}                                  ${char}
   END

Click Confirm SMS
   FOR    ${Index}                           IN RANGE   1    3
     ${Sent}                                 Run Keyword And Return Status      Wait Until Page Does Not Contain
     ...                                     ارسال مجدد کد                      timeout=30s
     Exit For Loop If                        ${Sent}
     ${final_confirm}                        Run Keyword And Return Status      Page Should Contain Text             تایید
     Run Keyword If                          ${final_confirm}                   Click The Link                       تایید
   END

Click The Link
   [Arguments]                               ${option}
   Wait Until Page Contains Element          android = UiSelector().text("${option}")                               timeout=5s
   Click Element                             android = UiSelector().text("${option}")

Verify Code From Server
   [Arguments]                               ${MobileNo}
   ${Code}                                   Mock Login Get Code                ${MobileNo}
   ${stripped}                               Strip String                       ${Code}
   ${characters}                             Split String To Characters         ${stripped}
   [Return]                                  ${characters}
