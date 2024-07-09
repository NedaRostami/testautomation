*** Settings ***
Documentation                              check duplicate algoritm for 100% and 80% and 50%
...                                        duplicate listing to compare the listings of a user
...                                        and comparing the listings of the two users together.
Resource                                   ../../resources/setup.resource
Test Setup                                 Run Keywords      Open test browser   Login by User A   Login Trumpet Admin Page    Prepare Randoms
Test Teardown                              Clean Test
Test Template                              Check Duplicate Algoritm For ${PostListing_Type} and ${CatID} and ${SubCatID} Round: ${Round}

*** Variables ***
# ${Title_Text0}                             آزمایش تکرار آگهی
# ${Title_Text1}                             آزمایش تکرار آگهی
# ${Title_Text2}                             آگهیه 80% مشابه
# ${Title_Text3}                             آگهیه 50٪ تکراری
# ${Title_Text4}                             آزمایش تکرار آگهی
# ${Description_Text0}                       تست الگوریتم تکراری برای یک کاربر
# ${Description_Text1}                       تست الگوریتم تکراری برای یک کاربر
# ${Description_Text2}                       تست آگهیه 80٪ مشابه برای یک کاربر
# ${Description_Text3}                       تست آگهیه 50٪ تکراری
# ${Description_Text4}                       تست الگوریتم تکراری برای یک کاربر
# ${Duplicat_Percent}                        Get Text                      jquery:table.table-condensed tbody tr:nth-child(1) > td:nth-child(6)
${Reason_Text}                              بر اساس اطلاعیه پلیس فتا هرگونه آگهی مربوط به بزرگ کننده یا کوچک کننده اعضای بدن، محصولات لاغری و چاقی غیر مجاز می باشد.
@{Listing_Ids}

*** Test Cases ***
Check Duplicate Algoritm
    [Tags]                                 trumpet         notest
    New                                    43631    43634   ${0}
    100%                                   43631    43634   ${0}
    80%                                    43631    43634   ${1}                  #post listing with diffrent title and description
    50%                                    43631    43635   ${2}                  #post listing with diffrent title and description and brand
    100%_another_user                      43631    43635   ${2}                  #post listing with new user

*** Keywords ***
Check Duplicate Algoritm For ${PostListing_Type} and ${CatID} and ${SubCatID} Round: ${Round}
    [Tags]                                 admin    duplicate
    # Run Keyword If                             '${PostListing_Type}' != '100%'   Post A ${PostListing_Type} Listing on Cat ${CatID} SubCat ${SubCatID} Round: ${Round}
    # ...  ELSE                                  Complete Duplicate Listing category ${CatID} and sub ${SubCatID} round: ${Round}
    Post A ${PostListing_Type} Listing on Cat ${CatID} SubCat ${SubCatID} Round: ${Round}

Prepare Randoms
    Genrate Random Title
    Genrate Random Description

Genrate Random Title
    FOR  ${INDEX}                          IN RANGE    0   3
      ${Title}                             FakerLibrary.Sentence	nb_words=5  variable_nb_words=ّFalse
      ${Title}                             Fetch From left     ${Title}  .
      ${Title}                             Replace String      ${Title}  ي  ی
      ${Title}                             Replace String      ${Title}  ك  ک
      ${Title}                             Convert Digits      ${Title}  Fa2EN
      Set Test Variable                    ${Title_Text${INDEX}}    ${Title}
    END

Genrate Random Description
    FOR  ${INDEX}                          IN RANGE    0   3
        ${Description}                     FakerLibrary.Paragraph	nb_sentences=5  variable_nb_sentences=ّFalse
        ${Description}                     Replace String      ${Description}   ي  ی
        ${Description}                     Replace String      ${Description}   ك  ک
        ${Description}                     Convert Digits      ${Description}   Fa2EN
        Set Test Variable                  ${Description_Text${INDEX}}    ${Description}
    END

Complete Duplicate Listing category ${CatID} and sub ${SubCatID} round: ${Round}
    Go To                                 ${SERVER}
    Go To Post Listing Page
    Post A New Listing                    ${2}   ${CatID}   ${SubCatID}    title_description=${Description_Text${Round}}   title_words=${Title_Text${Round}}    tel=${Random_User_Mobile_A}
    Verify Post Listing Is done
    Check My Listing Without Limit For Duplicate Listing
    Remember Listing Id
    Check Duplicate Deleted Listing In Moderation

Check Duplicate Deleted Listing In Moderation
    Go To                                   ${SERVER}/trumpet/listing/moderation?AdsId=${AdsId}
    Wait Until Page Contains Element        css:[data-clipboard="${AdsId}"]      timeout=10s
    Checkbox Should Be Selected             //tr[@class='alert-danger']/td/input[@type='checkbox']
    Assign Id To Element                    //tr[@class='alert-danger']/td[@data-bind="text: pct"]        pct
    SeleniumLibrary.Element Text Should Be              id:pct                                                        100
    Page Should Contain                     حذف اتوماتیک


Check My Listing Without Limit For Duplicate Listing
    Get ListingID
    Listing Must Not Be On Check State

Post A ${PostListing_Type} Listing on Cat ${CatID} SubCat ${SubCatID} Round: ${Round}
    Go To                                         ${SERVER}
    Go To Post Listing Page
    Post A New Listing                            ${2}   ${CatID}   ${SubCatID}    title_description=${Description_Text${Round}}   title_words=${Title_Text${Round}}    tel=${Random_User_Mobile_A}
    Verify Post Listing Is done
    Check My Listing
    Remember Listing Id
    Confirm Advertise And Delete Duplicate        ${PostListing_Type}
    Check Listing Status In MyListing             ${PostListing_Type}
    Run Keyword If                                '${PostListing_Type}' == '50%'     Logout user A And Login By User B

Login by User A
    Mobile Generator A
    Login OR Register By Mobile                    ${Random_User_Mobile_A}           ${Auth_Session_Position}

Confirm Advertise And Delete Duplicate
    [Arguments]                                    ${PostListing_Type}
    ${duplicate}                                   Run Keyword And Return Status    Should Contain    ${PostListing_Type}    100%
    Run Keyword If                                 not ${duplicate}     Verify Advertise By ID in trumpet
    ...  ELSE                                      Delete Duplicate Listing     ${PostListing_Type}

Check Listing Status In MyListing
    [Arguments]                                    ${PostListing_Type}
    ${duplicate}                                   Run Keyword And Return Status    Should Contain              ${PostListing_Type}    100%
    Run Keyword If                                 not ${duplicate}                 Check My Ads Has been Verified   ELSE  Check Duplicate Ads Has been Deleted By Admin

Logout user A And Login By User B
    Logout User A
    Mobile Generator B
    Login OR Register By Mobile                   ${Random_User_Mobile_B}           ${Auth_Session_Position}

Remember Listing Id
    Append To List                                ${Listing_Ids}                       ${AdsId}
    Set Suite Variable                            ${Listing_Ids}                       ${Listing_Ids}

Clean Test
    # Delete All Listing
    Clean Up Tests

Open Listing In Moderation
    Go to                                        ${SERVER}/trumpet/listing/moderation?AdsId=${AdsId}
    Wait Until Page Contains                     شناسه آگهی: ${AdsId}    timeout=10s

Logout User A
     Go to                                       ${SERVER}/session/logout
     Wait Until Page Contains                    ورود / ثبت نام

Delete Duplicate Listing
    [Arguments]                                ${PostListing_Type}
    Open Listing In Moderation
    Wait Until Page Contains Element           css:[data-bind="foreach: item.activeDuplicates"]
    @{Trumpet_Checkbox}                        Get Web Elements                                          jquery:table.table-condensed input[type="checkbox"]
    Run Keyword If                             '${PostListing_Type}' == '100%'                           Checkbox Should Be Selected                                 ${Trumpet_Checkbox}[0]
    ...  ELSE                                  click element                                             ${Trumpet_Checkbox}[0]
    Click Button                               حذف
    Is Delete Button Worked?

Delete Listing With Reason
    Select From List By Index                  xpath://option[contains(text(),"انتخاب دلیل حذف کردن")]/parent::select            5
    ${Element_Text}                            Get Value                                                 css:textarea[rows="3"]
    Should Be Equal As Strings                 ${Element_Text}                                           ${Reason_Text}
    Click Button                               حذف
    Is Delete Button Worked?

Delete All Listing
    FOR    ${I}    IN        @{Listing_Ids}
        Go to                                   ${SERVER}/trumpet/listing/moderation?AdsId=${I}
        Wait Until Page Contains                شناسه آگهی: ${I}    timeout=10s
        Delete Listing With Reason
    END


Is Delete Button Worked?
    FOR    ${INDEX}    IN RANGE    1    50
        ${FormClass}=                          SeleniumLibrary.Get Element Attribute                      id:reviewForm_1  class
        ${passed} =	                          Run Keyword And Return Status                              Should Contain  ${FormClass}  bg-danger
        Exit For Loop If                       ${passed}
        Click Button                           حذف
        BuiltIn.Sleep                          200ms
    END
    Run Keyword If                            '${passed}' == 'False'                                     Fail    msg=Can not De listing
