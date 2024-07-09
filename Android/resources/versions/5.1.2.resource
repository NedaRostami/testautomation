*** Settings ***
Resource               5.1.1.resource

*** Variables ***


*** Keywords ***
Succes Payment From Android App
  Click Element                      ${APPLY_BUTTON}
  Wait Until Page Contains           WebView Browser Tester                      timeout=20s
  Click Text                         WebView Browser Tester
  ${status}                          Run Keyword And Return Status               Wait Until Page Contains           Open with        timeout=30s
  Run Keyword If                     ${status}                                   Open Test Browser and set default
  Wait Until Page Contains           پرداخت شما با موفقیت انجام شد               timeout=30s
  Wait Until Page Contains           ${Price}               timeout=5s
  Get Source
  ${ReturnApp}                       Run Keyword And Return Status    Click Element                      ${ReturnAppDesc}
  Run Keyword If                     not ${ReturnApp}                 Click Element                      ${ReturnAppText}


Open Test Browser and set default
    ${status}                          Run Keyword And Return Status      Page Should Contain Text        WebView Browser
    Run Keyword If                     ${status}                          Click Text                      WebView Browser
    Run Keyword If                     ${status}                          Run Keyword And Ignore Error    Click Text         ALWAYS
    Run Keyword Unless                 ${status}                          Click Back Button
    Run Keyword And Ignore Error       Click Element                      accessibility_id=Load URL

Handle Location PopUp
   No Operation
