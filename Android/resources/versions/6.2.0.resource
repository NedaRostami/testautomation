*** Settings ***
Resource                 6.1.0.resource

*** Variables ***


*** Keywords ***
Handle Location PopUp
  ${status}         Run Keyword And Return Status    Wait Until Page Contains element     ${Location_Popup}      timeout=5s
  Run Keyword If      ${status}                      Click Back Button
