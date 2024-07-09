*** Settings ***
Documentation                                    Fill listing form then clear it,
...                                              in the first test case in the furniture category with region selection,
...                                              in the second test case in the hiring category without region selection
Test Setup                                       Open test browser
Test Teardown                                    Clean Up Tests
Resource                                         ../../resources/setup.resource

*** Variables ***
${not_filled_error}                              The filled {} does not exist correctly in the form.
${not_cleared_error}                             The {} field must be cleared.
${doc_based_on_resource}                         Values ​​are validate based on the common.resource.

*** Test Case ***
Fill and Clear Furniture Listing Fields
    [Tags]                                       Listing                                                Clear
    Login by Random Phone Number
    Set The Furniture Variables
    Go To Post Listing Page
    Fill Listing Form And Come Back
    Go To Post Listing Page
    Validate Furniture Listing Filled Form
    Clear Listing Form
    Validate That All Images Is Deleted
    Validate That All Fields Is Cleared

Fill and Clear Programmer Hiring Listing Fields
    [Tags]                                       Listing                                                Clear
    Set The Hiring Variables
    Go To Post Listing Page
    Fill Listing Form And Come Back
    Go To Post Listing Page
    Validate Hiring Listing Filled Form
    Clear Listing Form
    Validate That All Images Is Deleted
    Validate That All Fields Is Cleared

*** Keywords ***
Login by Random Phone Number
    Login OR Register By Random OR New Mobile    ${Auth_Session_Position}

Set The Furniture Variables
    Set Test Variable                            ${pictures_count}                                      ${2}
    Set Test Variable                            ${cat_id}                                              43608
    Set Test Variable                            ${cat_name}                                            لوازم خانگی
    Set Test Variable                            ${subCat_id}                                           43609
    Set Test Variable                            ${subCat_name}                                         مبلمان و لوازم چوبی
    Set Test Variable                            ${state_id}                                            5
    Set Test Variable                            ${state_name}                                          البرز
    Set Test Variable                            ${city_id}                                             1117
    Set Test Variable                            ${city_name}                                           فردیس
    Set Test Variable                            ${region_id}                                           7069
    Set Test Variable                            ${region_name}                                         خوشنام
    Set Test Variable                            ${logged_in}                                           ${TRUE}
    Set Test Variable                            ${user_phone_number}                                   ${Random_User_Mobile_B}

Set The Hiring Variables
    Set Test Variable                            ${pictures_count}                                      No-Image
    Set Test Variable                            ${cat_id}                                              43618
    Set Test Variable                            ${cat_name}                                            استخدام
    Set Test Variable                            ${subCat_id}                                           44305
    Set Test Variable                            ${subCat_name}                                         برنامه نویس | کارشناس شبکه
    Set Test Variable                            ${state_id}                                            20
    Set Test Variable                            ${state_name}                                          کردستان
    Set Test Variable                            ${city_id}                                             730
    Set Test Variable                            ${city_name}                                           سنندج
    Set Test Variable                            ${region_id}                                           ${EMPTY}
    Set Test Variable                            ${region_name}                                         ${EMPTY}
    Set Test Variable                            ${logged_in}                                           ${FALSE}
    Set Test Variable                            ${user_phone_number}                                   ${EMPTY}

Fill Listing Form And Come Back
    Post A New Listing                           ${pictures_count}                                      ${cat_id}
    ...                                          ${subCat_id}                                           state=${state_id}
    ...                                          city=${city_id}                                        region=${region_id}
    ...                                          logged_in=${logged_in}                                 submit=${FALSE}
    ...                                          tel=${user_phone_number}
    Check Home Page

Validate Furniture Listing Filled Form
    Validate Common Fields
    Validate Selected Goods Status
    Validate Inputed Price

Validate Hiring Listing Filled Form
    Validate Common Fields
    Validate Selected Education Level
    Validate Selected Contract Type
    Validate Selected Salary
    Validate Selected Gender

Validate Common Fields
    Run Keyword Unless                          '${pictures_count}' == 'No-Image'                       Validate Uploaded Images
    Validate Selected Category
    Validate Inputed Title
    Validate Inputed Description
    Validate Selected Location
    IF                                           ${logged_in}
        Validate Filled Seller Phone Number
    END

Validate Uploaded Images
    Is Image Uploaded
    FOR     ${index}       IN RANGE              ${pictures_count}
        Page Should Contain Element              ${PL_Uploaded_Img_Index.format("${index}")}
    END

Validate Selected Category
    SeleniumLibrary.Element Text Should Be       ${PL_Cats_Menu}                                        ${cat_name} > ${subCat_name}
    ...                                          message=${not_filled_error.format("category")}

Validate Selected Goods Status
    [Documentation]                              ${doc_based_on_resource}
    SeleniumLibrary.Element Text Should Be       ${PL_Status_Field}                                     در حد نو
    ...                                          message=${not_filled_error.format("goods status")}

Validate Inputed Title
    Textfield Value Should Be                    ${PL_Form_Title}                                       ${Title_Words}
    ...                                          message=${not_filled_error.format("title")}

Validate Inputed Description
    Textarea Value Should Be                     ${PL_Desc_Field}                                       ${Title_Description}
    ...                                          message=${not_filled_error.format("description")}

Validate Inputed Price
    ${expected_price}                            Evaluate                                               f'{${Price}:,}'
    Textfield Value Should Be                    ${PL_Form_Price}                                       ${expected_price}
    ...                                          message=${not_filled_error.format("price")}

Validate Selected Location
    IF                                          '${region_id}' == '${EMPTY}'
      SeleniumLibrary.Element Text Should Be     ${PL_Loc_Menu}                                         ${state_name} > ${city_name}
      ...                                        message=${not_filled_error.format("location")}
      Textfield Value Should Be                  ${PL_Region_Field}                                     ${region_name}
      ...                                        message=${not_filled_error.format("region")}
    ELSE
      SeleniumLibrary.Element Text Should Be     ${PL_Loc_Menu}                                         ${state_name} > ${city_name} > ${region_name}
      ...                                        message=${not_filled_error.format("location")}
    END

Validate Filled Seller Phone Number
    Textfield Value Should Be                    ${PL_Form_Telephone}                                   ${user_phone_number}
    ...                                          message=${not_filled_error.format("telephone")}

Validate Selected Education Level
    [Documentation]                              ${doc_based_on_resource}
    SeleniumLibrary.Element Text Should Be       ${PL_Education_Level}                                  کارشناسی
    ...                                          message=${not_filled_error.format("education level")}

Validate Selected Contract Type
    [Documentation]                              ${doc_based_on_resource}
    SeleniumLibrary.Element Text Should Be       ${PL_Contract_Type}                                    تمام وقت
    ...                                          message=${not_filled_error.format("contract type")}

Validate Selected Salary
    [Documentation]                              ${doc_based_on_resource}
    SeleniumLibrary.Element Text Should Be       ${PL_Salary}                                           توافقی
    ...                                          message=${not_filled_error.format("salary")}

Validate Selected Gender
    [Documentation]                              ${doc_based_on_resource}
    SeleniumLibrary.Element Text Should Be       ${PL_Gender}                                           مرد
    ...                                          message=${not_filled_error.format("gender")}

Clear Listing Form
    Click Element                                ${PL_Clear_Form}
    Wait Until Page Contains Element             ${Open_Popup.format("${PL_Clear_Form_Popup}")}         timeout=5s
    Click Button                                 ${PL_Reset_Form_Btn}

Validate That All Images Is Deleted
    IF                                          '${pictures_count}' != 'No-Image'
      Wait Until Page Does Not Contain Element   ${in-progress}                                         timeout=10s
      FOR     ${index}       IN RANGE            ${pictures_count}
          Page Should Not Contain Element        ${PL_Uploaded_Img_Index.format("${index}")}
      END
    END

Validate That All Fields Is Cleared
    Click Post Listing Button
    SeleniumLibrary.Element Text Should Be       ${PL_EMPTY_Cat_Error}                                  ${PL_EMPTY_Field_Error_Msg}
    ...                                          message=${not_cleared_error.format("category")}
    SeleniumLibrary.Element Text Should Be       ${PL_EMPTY_Title_Error}                                ${PL_EMPTY_Field_Error_Msg}
    ...                                          message=${not_cleared_error.format("title")}
    SeleniumLibrary.Element Text Should Be       ${PL_EMPTY_Description_Error}                          ${PL_EMPTY_Field_Error_Msg}
    ...                                          message=${not_cleared_error.format("description")}
    SeleniumLibrary.Element Text Should Be       ${PL_EMPTY_Loc_Error}                                  ${PL_EMPTY_Field_Error_Msg}
    ...                                          message=${not_cleared_error.format("location")}
    IF                                           ${logged_in}
        SeleniumLibrary.Element Text Should Be   ${PL_EMPTY_Phone_Error}                                ${PL_EMPTY_Field_Error_Msg}
        ...                                      message=${not_cleared_error.format("telephone")}
    END

Click Post Listing Button
    Click Element                                ${Ad_Registration_Button}
