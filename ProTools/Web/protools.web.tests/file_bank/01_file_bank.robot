
***Settings***
Documentation                                            In This Scenario The Categories In File Bank
...                                                      Are Purchased
Resource                                                 ../../resources/setup.resource
Test Setup                                               Run Keywords    Open test browser
Test Teardown                                            Clean Up Tests

***Variables***
${Tehran_City}                                           area_301
${A_Month_Price_All_City}                                پرداخت ۵۹,۰۰۰ تومان
${A_Month_Price_7_Districts}                             پرداخت ۳۹,۰۰۰ تومان
${District_12}                                           آبشار - منطقه 12
${Area_Text}                                             area_n5262

***Test Cases***
Buy Different File Bank Categories
  [Tags]                                                 File Bank                             Packge
  Create Shop In Sheypoor
  Login To ProTools
  Add All City Package
  Add 7 Districts Package

***Keywords***
Add All City Package
  Add New Package By Location Type                       ${FB_One_Month_Package_Txt}           ${A_Month_Price_All_City}      ${Choose_Whole_City_Txt}

Add 7 Districts Package
  Add New Package By Location Type                       ${FB_One_Month_Package_Txt}           ${A_Month_Price_7_Districts}   ${Choose_7_Districts_Txt}

Add New Package By Location Type
  [Arguments]                                            ${Package_Subscribe}                  ${Price_Button}                ${Location_Type}
  Go To File Bank
  Create A New File Bank
  Choose File Bank Category                              ${Location_Type}
  Purchase A Subscription                                ${Package_Subscribe}                  ${Price_Button}
  Go Back To File Bank Page
  Check Package Filtering

Go To File Bank
  Click By Name                                          ${FB_Menu}

Create A New File Bank
  ${Status}                                              Run Keyword And Return Status         Wait Until Page Contains Element     ${Add_FB_Btn}                    timeout=5s
  IF                                                     ${Status}
    Click By Name                                        ${Add_A_FB_Btn}
  ELSE
    Click By Name                                        ${Add_New_FB_Btn}
  END

Choose File Bank Category
  [Arguments]                                            ${Package_Type}
  Choose District                                        ${Package_Type}

Choose District
  [Arguments]                                            ${Package_Type}                       ${Province}=${Province_Txt}                                                     ${City_Name}=${Tehran_City}
  Click By Text                                          ${Package_Type}
  Validate Click By Name is Done                         ${FB_Choose_Action_Btn}               ${FB_Choose_Area_Txt}
  Click By Name                                          ${Province}
  ${Passed}             Run Keyword And Return Status    Click By Name                         ${City_Name}
  Run Keyword If                                         ${Passed}                             Validate Click By Name is Done    ${FB_Choose_Action_Btn}                              ${FB_Chosen_city_Area_Txt}
  Run Keyword Unless                                     ${Passed}                             Choose Packages District          ${Province_Txt} > ${Province_Txt}      ${District_12}       ${Area_Text}

Choose Packages District
  [Arguments]                                            ${City}=${Province_Txt} > ${Province_Txt}                 ${District_For_Validation}=${District_12}      @{args}
  Click By Name                                          ${City}
  Wait Until Page Contains                               ${District_For_Validation}            timeout=10s
  Click By Name                                          ${Area_Text}
  Validate Click By Name is Done                         ${FB_Choose_Action_Btn}               ${FB_Chosen_city_Area_Txt}

Purchase A Subscription
  [Arguments]                                            ${Package_Subscribe}                  ${Price_Button}
  FOR       ${INDEX}    IN RANGE    0    3
    Wait Until Page Contains                             ${FB_One_Month_Package_Txt}           timeout=15s
    Click By Text                                        ${Package_Subscribe}
    ${Status}           Run Keyword And Return Status    Click By Text                         ${Price_Button}
    Exit For Loop If                                     ${Status}
  END
  Wait Until Page Does Not Contain                      ${FB_One_Month_Package_Txt}            timeout=10s

Check If The Operation Was Successful
  Wait Until Page Contains                               ${FB_Successful_Purchase_Txt}         timeout=10s

Go Back To File Bank Page
  Click Button                                           ${FB_Submit_Payment}
  Wait Until Page Contains                               ${FB_Successful_Purchase_Txt}         timeout=5s
  Click Link                                             ${FB_Back_Home_Page_Txt}

Check Package Filtering
  Page Should Contain Element                            ${FB_Add_New_File_Btn}
