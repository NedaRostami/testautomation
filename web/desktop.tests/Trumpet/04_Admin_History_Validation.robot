*** Settings ***
Documentation                                    Admin history activities
Test Setup                                       Open test browser
Test Teardown                                    Clean Up Tests
Resource                                         ../../resources/setup.resource
Library                                          SeleniumLibrary

*** Variables ***
${DescriptionXpath}                               //*[@id="reviewForm_1"]/fieldset/form/div[3]/table/tbody/tr[*]/td[3]
${StatusXpath}                                    //*[@id="reviewForm_1"]/fieldset/form/div[3]/table/tbody/tr[*]/td[2]
${DeletedLabelOnImage}                            //*[@id="reviewForm_1"]/fieldset/form/div[1]/div[4]/div[1]/div/div/ul/li[*]/div[2]/span[1]
${NewLabelOnImage}                                //*[@id="reviewForm_1"]/fieldset/form/div[1]/div[4]/div[1]/div/div/ul/li[*]/div[2]/span[2]
${ApprovalMessage}                                شما تایید شیپور شد

*** Test Cases ***
Admin history activities
  [Tags]                                          trumpet    history     notest
  Add New Listing By New Mobile and accept
  Scrooll Admin Page
  First Time Validation
  Second Time Validation
  third Time Validation
  Edit Listing's Description Validation
  Edit Listing's Price Validation
  Delete Listing Validation

*** Keywords ***
Add New Listing By New Mobile and accept
  Go To Post Listing Page
  Post A New Listing                              ${1}  43619  43625   logged_in=${FALSE}
  Login OR Register In Listing By New Mobile
  Verify Post Listing Is done
  Check My Listing
  Check My Listing Image Count                    1
  Login Trumpet Admin Page
  Verify Advertise By ID in trumpet

Scrooll Admin Page
  Reload Page
  Execute Javascript                               window.scrollTo(0,5000);
  #Execute Javascript                              bee($('.scrollable').scrollTop($('.scrollable table').height()));
  Execute Javascript                               document.getElementsByClassName('scrollable')[0].scrollTo(0,500);

Validate Admin History Table
  [Arguments]                                      ${Count}      ${Comment}      ${Xpath}
  ${list}                                          Create List by Column         ${Xpath}
  Should Contain Match                             ${list}                       ${Comment}
  ${accept}    Get Match Count                     ${list}                       ${Comment}
  Should Be Equal As Integers                      ${accept}                     ${Count}

Create List by Column
  [Arguments]                                     ${XPATH}
  @{descriptions}                                  get webelements   ${XPATH}
  @{list}                                          Create List
  FOR        ${desc}    IN    @{descriptions}
    ${ListStatus}                                 get text   ${desc}
    Append To List                                ${list}    ${ListStatus}
  END
  [Return]                                         ${list}

Edit Listing And Add Images
  # Wait Until Page Contains                         ${Title_Words}
  Wait Until Element Contains                      //*[starts-with(@id,'listing-${AdsId}')]//*/h2/a      ${Title_Words}
  Click Element                                    css=.icon-pencil
  Attach Listing Image                             ${2}   43619
  Click Button                                     xpath=//*[@id="item-form"]/div/div[2]/form/p[2]/button
  Verify Advertise By ID in trumpet

Delete images And Add Some New
  Click Link    ویرایش
  Wait Until Page Contains    ${PL_Post_Img}     timeout=5s
  Is Image Uploaded
  Delete Images            ALL
  Is Image Uploaded
  Attach Listing Image     ${3}    43619
  Sleep    2s    reason=None
  Submit post listings     ${TRUE}
  Sleep    1s
  Listing Must Be On Check State
  Verify Advertise By ID in trumpet

Verify Advertise By ID in trumpet                  #تغییرش دادم
  Go to                                            ${SERVER}/trumpet
  Wait Until Page Contains                         داشبورد     timeout=5s
  Click Link                                       آگهی ها
  Click Link                                       جستجوی آگهی ها
  Wait Until Page Contains                         جستجوی آگهی ها    timeout=10s
  Input Text    id:id                              ${AdsId}
  Click Button                                     جستجو
  Wait Until Page Contains                         ${Title_Words}     timeout=10s
  Wait Until Page Contains                         بررسی     timeout=10s
  Wait Until Keyword Succeeds                      5x  3s   Click Link   بررسی
  #Click Link                                     بررسی
  FOR                                             ${INDEX}    IN RANGE    1    6
    Reload Page
    ${status}                                     Run Keyword And Return Status     Wait Until Page Contains       شناسه آگهی: ${AdsId}    timeout=3s
    Exit For Loop If                              ${status}
  END
  # Is Image Uploaded in Moderation Page
  Click Button                                     تایید
  ${confirmed}                                     Is Confirm Button Worked?
  Run Keyword If                                   '${confirmed}' == 'False'     Fail    msg=Can not confirm listing

Check New Images Attached
  [Arguments]                                      ${Message}   ${XPATH}
  @{descriptions}                                  get webelements   ${XPATH}
  ${length}                                        Get Length    ${descriptions}
  FOR         ${desc}    IN    @{descriptions}
    ${New_Images}                                 get text   ${desc}
    ${status}                                     Run Keyword And Return Status     Should Be Equal     ${New_Images}    ${Message}
    Exit For Loop If                              ${status}
  END
  Run Keyword Unless                               ${status}       Fail     ${Message} یاقت نشد

Check Old Images Deleted
  [Arguments]                                      ${Message}   ${XPATH}
  @{descriptions}                                  get webelements   ${XPATH}
  ${length}                                        Get Length    ${descriptions}
  FOR        ${desc}    IN    @{descriptions}
    ${Old_Images}                                 get text   ${desc}
    ${status}                                     Run Keyword And Return Status     Should Be Equal     ${Old_Images}    ${Message}
    Exit For Loop If                              ${status}
  END
  Run Keyword Unless                              ${status}        Fail     ${Message} یاقت نشد

First Time Validation
  Validate Admin History Table                    1            آگهی جدید توسط کاربر       ${StatusXpath}
  Validate Admin History Table                    1            ویرایش کاربر               ${StatusXpath}
  Validate Admin History Table                    1            1 تصویر بارگذاری شد        ${DescriptionXpath}
  Validate Admin History Table                    1            پذیرفتن                    ${StatusXpath}
  Validate Admin History Table                    1            پیام رسانی شد              ${StatusXpath}
  Validate Admin History Table                    1            *${ApprovalMessage}*       ${DescriptionXpath}

Second Time Validation
  Check My Ads Has been Verified
  Edit Listing And Add Images
  Reload Page
  Validate Admin History Table                    2            ویرایش کاربر               ${StatusXpath}
  Validate Admin History Table                    1            2 تصویر بارگذاری شد        ${DescriptionXpath}
  Validate Admin History Table                    2            پذیرفتن                    ${StatusXpath}
  Validate Admin History Table                    2            پیام رسانی شد              ${StatusXpath}
  Validate Admin History Table                    2            *${ApprovalMessage}*       ${DescriptionXpath}
  Check My Ads Has been Verified

third Time Validation
  Delete images And Add Some New
  Execute Javascript                                           window.scrollTo(0,5000);
  Validate Admin History Table                    4            ویرایش کاربر               ${StatusXpath}
  Validate Admin History Table                    1            3 تصویر بارگذاری شد        ${DescriptionXpath}
  Validate Admin History Table                    1            3 تصویر حذف گردید          ${DescriptionXpath}
  Validate Admin History Table                    3            پذیرفتن                    ${StatusXpath}
  Check New Images Attached                      جدید         ${NewLabelOnImage}
  Check Old Images Deleted                       حذف شده      ${DeletedLabelOnImage}
  Reload Page
  Validate Admin History Table                    3            پیام رسانی شد              ${StatusXpath}
  Validate Admin History Table                    3            *${ApprovalMessage}*       ${DescriptionXpath}
  Check My Ads Has been Verified

Edit Listing's Description Validation
  # Wait Until Page Contains                         ${Title_Words}
  Wait Until Element Contains                      //*[starts-with(@id,'listing-${AdsId}')]//*/h2/a        ${Title_Words}
  Click Element                                    css=.icon-pencil
  Input Text    ${PL_Desc_Field}                  تست تاریخچه ادمین در شیپور تست تاریخچه ادمین در شیپور تست تاریخچه ادمین در شیپور
  Click Button                                     xpath=//*[@id="item-form"]/div/div[2]/form/p[2]/button
  Verify Advertise By ID in trumpet
  Reload Page
  Validate Admin History Table                    5            ویرایش کاربر               ${StatusXpath}
  Validate Admin History Table                    1            ویرایش                     ${StatusXpath}
  Admin History Description Edit                ${2}                                      توضیحات از
  Validate Admin History Table                    4            پذیرفتن                    ${StatusXpath}
  Validate Admin History Table                    4            پیام رسانی شد              ${StatusXpath}
  Validate Admin History Table                    4            *${ApprovalMessage}*       ${DescriptionXpath}
  Check My Ads Has been Verified

Edit Listing's Price Validation
  # Wait Until Page Contains                         ${Title_Words}
  Wait Until Element Contains                      //*[starts-with(@id,'listing-${AdsId}')]//*/h2/a        ${Title_Words}
  Click Element                                    css=.icon-pencil
  Input Text    ${PL_Form_Price}                   5000000
  Click Button                                     xpath=//*[@id="item-form"]/div/div[2]/form/p[2]/button
  Verify Advertise By ID in trumpet
  Reload Page
  Validate Admin History Table                    6            ویرایش کاربر               ${StatusXpath}
  Validate Admin History Table                    2            ویرایش                     ${StatusXpath}
  Admin History Price Edit                        ${2}                                       قیمت از
  Validate Admin History Table                    5            پذیرفتن                    ${StatusXpath}
  Validate Admin History Table                    5            پیام رسانی شد              ${StatusXpath}
  Validate Admin History Table                    5            *${ApprovalMessage}*       ${DescriptionXpath}
  Check My Ads Has been Verified

Delete Listing Validation
  # Wait Until Page Contains                         ${Title_Words}
  Wait Until Element Contains                      //*[starts-with(@id,'listing-${AdsId}')]//*/h2/a        ${Title_Words}
  Click Element                                    css=.icon-trash
  Wait Until Page Contains                         آیا از حذف این آگهی مطمئن هستید؟                     timeout=3s
  Click Button                                     بله
  Verify Advertise By ID in trumpet
  Reload Page
  Validate Admin History Table                    1           حذف کاربر              ${StatusXpath}
  Validate Admin History Table                    6            پذیرفتن                    ${StatusXpath}


Admin History Description Edit
  [Arguments]                                      ${EditedDescriptionDuplication}            ${ApprovedMessage}
  ${list}                                          Create List by Column                      ${DescriptionXpath}
  ${accept}    Get Match Count                     ${list}                                    توضیحات از*
  Should Be Equal                                  ${accept}                                  ${EditedDescriptionDuplication}

Admin History Price Edit
  [Arguments]                                      ${EditedPriceDuplication}                  ${ApprovedMessage}
  ${list}                                          Create List by Column                      ${DescriptionXpath}
  ${accept}    Get Match Count                     ${list}                                    قیمت از*
  Should Be Equal                                  ${accept}                                  ${EditedPriceDuplication}
