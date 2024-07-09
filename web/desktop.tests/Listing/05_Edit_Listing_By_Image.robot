*** Settings ***
Documentation                                        Test Listing detail performance
Test Setup                                           Open test browser
Test Teardown                                        Clean Up Tests
Resource                                             ../../resources/setup.resource


*** variables ***
${State}                                             فارس
${City}                                              اردکان
${Region}                                            ${EMPTY}


*** Test Cases ***
Multiple Editing
    [Tags]                                           Listing                    edit
    Add New Listing Min By New Mobile And Accept
    Edit and Accept Listing     ${3}
    Delete images And Add Some New


*** Keywords ***
Add New Listing Min By New Mobile And Accept
    Go To Post Listing Page
    Post A New Listing                               ${1}     43619    44230    logged_in=${FALSE}
    Login OR Register In Listing By New Mobile
    Verify Post Listing Is done
    Check My Listing
    Check My Listing Image Count                     1
    Login Trumpet Admin Page
    Verify Ads And Check images in Moderation        1
    Check My Ads Has been Verified

Edit and Accept Listing
    [Arguments]    ${PIC_NO}
    ${SubmitStatus}                                  Set Variable               ${FALSE}
    Click Button                                     ویرایش
    Is Image Uploaded
    Attach Listing Image                             ${PIC_NO}                  43619
    Submit post listings                             ${TRUE}                    ${TRUE}
    Listing Must Be On Check State In My Listing
    Verify Ads And Check images in Moderation        4
    Check My Ads Has been Verified
    Check My Listing Image Count                     4

Verify Ads And Check images in Moderation
    [Arguments]                                      ${Limit}
    ${Limit}                                         Convert To Integer         ${Limit}
    Go to                                            ${SERVER}/trumpet/listing/moderation?AdsId=${AdsId}
    Wait Until Page Contains                         شناسه آگهی: ${AdsId}       timeout=10s
    Wait Until Page Is Loaded in Moderation
    FOR   ${i}                                       IN RANGE                   5
      ${count}                                       SeleniumLibrary.Get Element Count    xpath://li[contains(@class,'qq-upload-success')]/img[contains(@src,'data:image/jpeg;base64')]
      ${status}                                      Run Keyword And Return Status        Should Be Equal                     ${count}   ${Limit}
      Exit For Loop If                               ${status}
      Sleep                                          3s
    END
    Run Keyword unless                               ${status}                  Fail      images are not loaded corectly
    Is Image Uploaded in Moderation Page
    Click Button                                     تایید
    ${confirmed}                                     Is Confirm Button Worked?
    Run Keyword If                                  '${confirmed}' == 'False'   Fail      msg=Can not confirm listing

Delete images And Add Some New
    ${SubmitStatus}                                  Set Variable               ${FALSE}
    Click Button                                     ویرایش
    Wait Until Page Contains                         ${PL_Post_Img}           timeout=5s
    Is Image Uploaded
    Delete Images                                    ALL
    Is Image Uploaded
    Attach Listing Image                             ${1}                       43619
    Submit post listings                             ${TRUE}                    ${TRUE}
    Listing Must Be On Check State
    Verify Ads And Check images in Moderation        5
    Check My Ads Has been Verified
    Check My Listing Image Count                     1
