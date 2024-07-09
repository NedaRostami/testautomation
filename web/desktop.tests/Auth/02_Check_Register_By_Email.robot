*** Settings ***
Documentation                                 Check registration, Login by Email
Test Setup                                    Open test browser
Test Teardown                                 Clean Up Tests
Resource                                      ../../resources/setup.resource

*** Test Cases ***
Register By New Email
    [Tags]                                    register  email  login   auth
    Go To Login Page
    Input Email
    Click On Enter OR Register Button
    Validate Login By Email


*** Keywords ***
Go To Login Page
    Go To                                     ${SERVER}/session
    Wait Until Page Contains Element          ${Auth_Username_Xpath}            timeout=10s


Input Email
    Email Generator A
    Input Text                                ${Auth_Username_Xpath}            ${Random_User_Email_A}

Click On Enter OR Register Button
    Wait Until Page Contains Element          ${Auth_Login_OR_Register_Btn}     timeout=5s
    Click Element                             ${Auth_Login_OR_Register_Btn}

Validate Login By Email
    ${CompleteField}                          Run Keyword And Return Status     Wait Until Page Contains               ${Auth_Complete_Field_Val_Msg}      timeout=2s
    IF   '${CompleteField}' == '${FALSE}'
      Wait Until Page Does Not Contain        ${Auth_Mobile_Field_Xpah}         timeout=3s                             error=The user can log in by email
      Wait Until Page Does Not Contain        ${Auth_Modify_Email_Text}         timeout=1s                             error=The user can log in by email
    END
