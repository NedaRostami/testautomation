*** Settings ***
Documentation                                      filter car in serp
Test Setup                                         Open test browser
Test Teardown                                      Clean Up Tests
Resource                                           ../../../resources/serp.resource


*** Variables ***
${CarTAG_Tag_Index}                                1
${CarBrandBreadcamp_Tag_Index}                     2
${CarModelBreadcamp_Tag_Index}                     3
${CarTypeBreadcamp_Tag_Index}                      4
${PaymentType_Tag_Index}                           5
${CarAge_Tag_Index}                                6
${ProductYearMin_Tag_Index}                        7
${ProductYearMax_Tag_Index}                        8
${KmMin_Tag_Index}                                 9
${KmMax_Tag_Index}                                 10
${Colour_Tag_Index}                                11
${GearBox_Tag_Index}                               12
${CarBody_Tag_Index}                               13
${MinPrice_Tag_Index}                              14
${MaxPrice_Tag_Index}                              15



*** Test Cases ***
Filter Cars in Serp
    [Tags]                                         serp      search    filter
    # Post New Pride Listing
    Go To Serp Page
    Filter Car And Validate Breadcrumbs
    Filter Pride Brand
    Select Payment
    Select Car Age
    Select Product year Min
    Select Product year Max
    Select KM Min
    Select KM Max
    Select Colour
    Select GearBox
    Select Body Status
    Input Min Price
    Input Max Price
    Check Reset

*** Keywords ***
Post New Pride Listing
    Add Car By All Attributes                      43976     a68143    440665            #صبا (صندوقدار)

Filter Pride Brand
    Select Car Brand
    Select By Label And Validate Tag               ${Serp_F_Car_Chassis}                   سدان (سواری)      ${CarTypeBreadcamp_Tag_Index}    نوع شاسی: سدان (سواری)

Filter Car And Validate Breadcrumbs
    click element                                  ${Serp_F_Category_Menu}
    Click Link                                     خودرو
    Set Serp Breadcrumbs And Validate Position     4                                     خودرو
    Set Serp Tag Variable And Validate Position    1                                     خودرو

Check Reset
    Click Element                                           ${Serp_F_Brand_Menu}
    Click Element                                  //span[text()= 'همه برندهای گروه خودرو']
    ${Location}                                    Get Location
    Should Not Contain                             ${Location}                          صبا-صندوقدار

Add Car By All Attributes
    [Arguments]                                    ${Brand}                             ${Model}      ${ModelNo}
    Login OR Register By Random OR New Mobile      ${Auth_Session_Position}
    Go To Post Listing Page
    Post A New Listing                             ${1}  43626  43627  ${Brand}  model=${Model}  model_id=${ModelNo}    tel=${Random_User_Mobile_B}
    Verify Post Listing Is done
    Check My Listing
    Check My Listing Image Count                   1
    Verify Advertise By ID in trumpet
    Check My Ads Has been Verified
    Click Link                                     ${AllAdvs}
    Wait Until Page Contains                       ${IranAllH1}
    Wait Until Page Is Loaded
    ${passed}                                      Run Keyword And Return Status     Wait Until Keyword Returns Passed    5   2    Page Should Contain    ${Title_Words}
    Run Keyword If	   not ${passed}               Search Listing                    ${Title_Words}

Select label
    [Arguments]                                      ${locator}                        ${label}
    Wait Until Keyword Succeeds     3x    2s         Select From List By Label         ${locator}    ${label}

Select By Label And Validate Tag
    [Arguments]                                      ${locator}     ${label}           ${index}       ${Validator}
    Select From List By Label                        ${locator}     ${label}
    Set Serp Tag Variable And Validate Position      ${index}       ${Validator}

Select Car Brand
    click element                                  ${Serp_F_Brand_Menu}
    click element                                  ${Serp_F_Brand_By_ID.format(43976)}              #پراید
    click element                                  ${Serp_F_Model_By_ID.format(440665)}             #صبا (صندوقدار)
    Set Serp Tag Variable And Validate Position    ${CarBrandBreadcamp_Tag_Index}                   پراید
    Set Serp Tag Variable And Validate Position    ${CarModelBreadcamp_Tag_Index}                   مدل خودرو: صبا (صندوقدار)
    Set Serp Breadcrumbs And Validate Position     5                                                پراید
    Set Serp Breadcrumbs And Validate Position     6                                                صبا (صندوقدار)

Select Product year Min
    Click Element                                  ${Serp_F_Car_Min_Year}
    Click Element                                  ${Serp_F_Attribute_By_Filter_Param.format("mn68101=442253")}
    Set Serp Tag Variable And Validate Position    ${ProductYearMin_Tag_Index}   حداقل سال تولید: ۱۳۶۵ (۱۹۸۶)


Select Product year Max
    Click Element                                  ${Serp_F_Car_Max_Year}
    Click Element                                  ${Serp_F_Attribute_By_Filter_Param.format("mx68101=442222")}
    Set Serp Tag Variable And Validate Position    ${ProductYearMax_Tag_Index}   حداکثر سال تولید: ۱۳۹۶ (۲۰۱۷)

Select KM Min
    Click Element                                  ${Serp_F_Car_Min_Km}
    Click Element                                  ${Serp_F_Attribute_By_Filter_Param.format("mn68102=442254")}
    Set Serp Tag Variable And Validate Position   ${KmMin_Tag_Index}            حداقل کیلومتر: ۰

Select KM Max
    Click Element                                  ${Serp_F_Car_Max_Km}
    Click Element                                  ${Serp_F_Attribute_By_Filter_Param.format("mx68102=442259")}
    Set Serp Tag Variable And Validate Position    ${KmMax_Tag_Index}            حداکثر کیلومتر: ۵۰۰۰

Select Colour
    Click Element                                  ${Serp_F_Car_Color}
    Click Element                                  ${Serp_F_Attribute_By_Filter_Param.format("a69130=445243")}
    Set Serp Tag Variable And Validate Position    ${Colour_Tag_Index}           رنگ: سفید


Select GearBox
    Select By Label And Validate Tag              ${Serp_F_Car_Gearbox}           دنده‌ای                   ${GearBox_Tag_Index}        گیربکس: دنده‌ای

Select Body Status
    Select By Label And Validate Tag              ${Serp_F_Car_Body_Condition}    سالم بدون خط و خش        ${CarBody_Tag_Index}         وضعیت بدنه: سالم بدون خط و خش

Select Payment
    Select By Label And Validate Tag              ${Serp_F_Car_Payment_Type}      نقدی                     ${PaymentType_Tag_Index}      نقدی/اقساطی: نقدی

Select Car Age
    Select By Label And Validate Tag              ${Serp_F_Car_Used_Status}       نو                       ${CarAge_Tag_Index}           نو / کارکرده: نو

Input Min Price
    Input Text                                    ${Serp_F_Min_Price}          1000000
    Press Keys	                                  ${Serp_F_Max_Price}      	   RETURN
    Wait Until Page Is Loaded
    Set Serp Tag Variable And Validate Position   ${MinPrice_Tag_Index}                  قیمت از (تومان): ۱,۰۰۰,۰۰۰


Input Max Price
    Input Text	                                  ${Serp_F_Max_Price}           50000000
    Press Keys	                                  ${Serp_F_Min_Price}          	RETURN
    Wait Until Page Is Loaded
    Set Serp Tag Variable And Validate Position   ${MaxPrice_Tag_Index}         قیمت تا (تومان): ۵۰,۰۰۰,۰۰۰
