*** Settings ***
Documentation    Check Listing detail Utilities
Test Setup        Open test browser
Test Teardown     Clean Up Tests
Resource         ..${/}..${/}resources${/}androidBrowser.resource
Test Timeout     10 minutes
*** Test Cases ***
Check Listing Options
  [Tags]                                Options   notest
  Wait Until Page Contains              ${IranAllH1}
  Check Image Filter
  Check Contact Visibility in Description
  Share Pop UP
  Report Listing
  Favorite

*** keywords ***
Check Image Filter
  Scroll Page To Bottom
  Assign ID to Element                  xpath=//*[@id="pagination"]/ul/li[1]/strong[3]    Results
  ${resultA} =   Get Text               Results
  Click By Css Selector                 [data-popup="popup-filters"]
  Checkbox Should Not Be Selected       name=wi
  click element                         css=.icon-indicator
  Click By Css Selector                 [data-close-popups]
  wait until page contains              ${IranAllH1}
  Scroll Page To Bottom
  Assign ID to Element                  xpath=//*[@id="pagination"]/ul/li[1]/strong[3]    Results
  ${resultB} =   Get Text               Results
  Should Not Be Equal    ${resultA}     ${resultB}
  Scroll Page To Top
  ${TitleSerp}=                         Get Text     //*[@*]/div[2]/h2/a
  click link                            ${TitleSerp}
  wait until page contains              تماس
  ${TitleDetail} =                      Get Text       //section[@id="item-details"]//h1
  Should Be Equal      ${TitleSerp}     ${TitleDetail}
  Set Test Variable    ${SerpTitle}     ${TitleSerp}
  # fav Icon
  click element                         css=.initialized
  Set Test Variable    ${SerpTitle}    ${TitleSerp}

Check Contact Visibility in Description
  Assign ID to Element                  css=.underlined     MobileB
  ${NuberFiltered} =     Get Text       MobileB
  Element Should Contain                MobileB    XXX
  Click Element                         MobileB
  Wait Until Page Does Not Contain     (نمایش کامل)
  Element Should Not Contain            xpath=//*[@id="item-details"]/p[2]/strong    XXX

Share Pop UP
  Click By Css Selector                 [data-popup="popup-share-by-email"]
  Wait Until Page Contains              به اشتراک گذاری آگهی
  click link                            بازگشت
  wait until page contains              ${SerpTitle}

Report Listing
  Click By Css Selector                 [data-popup="popup-report-listing"]
  Wait Until Page Contains              لطفا دلیل گزارش این آگهی را انتخاب کنید
  click element	                        xpath=//*[@id="popup-report-listing"]/div/div/form/p[2]/label[8]/span
  input text                            email             qa@mielse.com
  input text                            mobile            09001000000
  input text                            message           آگهی نامرتبط و مشکوک است.
  Click element                         xpath=//*[@id="popup-report-listing"]/div/div/form/p[6]/button
  wait until page contains              آگهی مورد نظر با موفقیت گزارش گردید
  click link                            بازگشت
  wait until page contains              ${SerpTitle}

Favorite
  Page Should Contain Element           css=.saved
  click link                            بازگشت
  wait until page contains              ${IranAllH1}
  #حساب من
  Click By Css Selector                 [data-popup="popup-main-menu"]
  click link                            پسندیده‌ها
  wait until page contains              ${SerpTitle}
  click element                         css=.saved
  Wait Until Keyword Returns Passed     3    1         Page Should Contain            آگهی‌های مورد علاقه خود را توسط دکمه
