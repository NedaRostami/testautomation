*** Settings ***
Documentation                                 add a new car listing with One image New User
...                                           while not logged in
...                                           Mobile Registeration
...                                           check the moderatin to accept it.
...                                           fav and unfav listing
Test Setup                                    Open test browser
Test Teardown                                 Clean Up Tests
Resource                                       ../../resources/setup.resource

*** Variables ***
${Categories}                                  form>div:nth-child(1)>div:nth-child(3)>div:nth-child(4)>input
${Car_Attribute}                               section#item-details>table:nth-child(3)>tbody>tr:nth-child(1)
${Moderation_Car_Attr}                         section#reviewForm_1>fieldset>form>div:nth-child(1)>div:nth-child(3)
${RejectTxt}                                   گروهبندی اشتباه: شما می بایست آگهی خود را در گروه "صنعتی، اداری و تجاری > لوازم اداری" ثبت کنید.
# ${RejectTxt}                                   گروهبندی اشتباه: شما می بایست آگهی خود را در گروه &quot;صنعتی، اداری و تجاری > لوازم اداری&quot; ثبت کنید.
*** Test Cases ***
Edit Listing Category In Moderation
    [Tags]                                          trumpet   edit_Listing
    Add New Listing In Car Category
    Login Trumpet Admin Page
    # Find Listing In Moderation
    Edit Listing Category By ID In Trumpet
    Verify Advertise By ID in trumpet
    Sleep           1s
    Check Listing Attributes
    Refresh And Check Listing Attributes In Moderation

*** Keywords ***
Add New Listing In Car Category
    Go To Post Listing Page
    Post A New Listing                              ${1}  43626  43627   43973  model=a68142  model_id=440655   logged_in=${FALSE}
    Login OR Register In Listing By New Mobile
    Verify Post Listing Is done
    Check My Listing
    Check My Listing Image Count                    1

Edit Listing Category By ID In Trumpet
    Go To                                           ${SERVER}/trumpet/listing/moderation?AdsId=${AdsId}
    Wait Until Page Contains                       شناسه آگهی: ${AdsId}    timeout=10s
    Change Listing Category In Moderation
    Click Button                                    تایید
    ${confirmed}                                    Is Confirm Button Worked?
    Run Keyword If                                  '${confirmed}' == 'False'     Fail    msg=Can not confirm listing

Find Listing In Moderation
    Wait Until Page Contains                        داشبورد     timeout=5s
    Click Link                                      آگهی ها
    Click Link                                      جستجوی آگهی ها
    Wait Until Page Contains                        جستجوی آگهی ها    timeout=10s
    Input Text                                      id:id                  ${AdsId}
    Click Button                                    جستجو
    Wait Until Page Contains                        ${Title_Words}     timeout=10s
    Wait Until Page Contains                        بررسی     timeout=10s
    Wait Until Keyword Succeeds                     5x  3s   Click Link   بررسی

Change Listing Category In Moderation
    Click By Css Selector                           ${Categories}
    Execute Javascript                              $('a.icon-category-43631').click()
    Execute Javascript                              $('[data-category-name="لوازم اداری"]').click()
    # FOR    ${INDEX}    IN RANGE    1   7
    #   ${TxtArea}           Execute Javascript      return window.jQuery('[placeholder="دلیل حذف یا رد کردن"]').val()
    #   Exit For Loop If    '${TxtArea}' == '${RejectTxt}'
    #   Sleep     500ms
    # END
    # Run Keyword If                                  '${TxtArea}' != '${RejectTxt}'                  Fail    Reject Reason is not changed
    # ${TxtArea}                                      SeleniumLibrary.Get Element Attribute           css:[placeholder="دلیل حذف یا رد کردن"]          value
    # Should Be Equal                                 ${RejectTxt}         ${TxtArea}
    # ${RejectResonSelector}                          get webelement               //*[@id="reviewForm_1"]//select
    # Select From List By Label                       ${RejectResonSelector}       انتخاب دلیل رد کردن

Refresh And Check Listing Attributes In Moderation
    Go To                                           ${SERVER}/trumpet/listing/moderation?AdsId=${AdsId}
    Wait Until Page Contains                        شناسه آگهی: ${AdsId}    timeout=10s
    Element Should Not Contain                      css:${Moderation_Car_Attr}      نوع شاسی

Check Listing Attributes
    Go To                                           ${SERVER}/${AdsId}
    Wait Until Page Contains                        ${Title_Words}     timeout=10s
    Element Should Not Be Visible                   css:${Car_Attribute}           نوع شاسی
