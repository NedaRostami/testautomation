*** Settings ***
Documentation                                             First, check the page AMP validation using the console output,
...                                                       then check the existence of correct AMP url in html tags.
Resource                                                  ../../resources/setup.resource
Test Setup                                                Open Browser And Generate Required Dynamic URLs
Test Teardown                                             Close Browser
Test Template                                             Check AMP Validation Of Pages

*** Variables ***
${successful_AMP_validation_console_msg}                  AMP validation successful.
${failed_AMP_validation_console_msg}                      AMP validation had errors:
${failed_AMP_validation_msg}                              AMP validation failed in console log.
${not_exist_AMP_validation_msg}                           Does not exist AMP validation message in console log.

*** Test Cases ***
Check AMP Validation Successful
    [Tags]                                                amp                                                         lxml
    ایران
    استان-تهران/املاک
    مازندران/وسایل-نقلیه
    استان-اصفهان/استخدام
    آذربایجان-شرقی/خدمات-کسب-کار
    البرز/لوازم-خانگی
    خراسان-رضوی/ورزش-فرهنگ-فراغت
    فارس/لوازم-الکترونیکی
    گیلان/صنعتی-اداری-تجاری
    خوزستان/موبایل-تبلت-لوازم
    استان-قم/لوازم-شخصی
    ${listing_details_url}
    shops/ایران
    ${shop_details_url}
    agents/ایران

*** Keywords ***
Check AMP Validation Of Pages
    [Arguments]                                           ${url}
    Set Url As Test Variable For Use In Other Keywords    ${url}
    Go To Desired AMP Page
    Wait Until AMP Validation To Appear In Console Log
    Console Log AMP Validation Should Be Successful
    AMP Url Should Be Exist Correctly In html Tags

Open Browser And Generate Required Dynamic URLs
    Open test browser
    Get Current Active Selenium Webdriver
    Generate Some Required Dynamic URLs

Get Current Active Selenium Webdriver
    ${selenium}                                           Get Library Instance                                        SeleniumLibrary
    Set Test Variable                                     ${webdriver}                                                ${selenium._drivers.active_drivers}[0]

Generate Some Required Dynamic URLs
    Generate Random Listing Details URL
    Generate Random Shop Details URL

Generate Random Listing Details URL
    ${listing_details_url}                                Get First Listing Details URL From Home Page
    Should Contain                                        ${listing_details_url}                                      ${SERVER}/
    ...                                                   Could not get listing details url correctly.                values=${FALSE}
    ${listing_details_url}                                Fetch From Right                                            ${listing_details_url}
    ...                                                   ${SERVER}/
    Set Test Variable                                     ${listing_details_url}

Generate Random Shop Details URL
    ${shop_details_url}                                   Get First Shop Details URL From Shops Page
    Should Contain                                        ${shop_details_url}                                         ${SERVER}/
    ...                                                   Could not get shop details url correctly.                   values=${FALSE}
    ${shop_details_url}                                   Fetch From Right                                            ${shop_details_url}
    ...                                                   ${SERVER}/
    Set Test Variable                                     ${shop_details_url}

Set Url As Test Variable For Use In Other Keywords
    [Arguments]                                           ${page_url}
    Set Test Variable                                     ${page_url}

Go To Desired AMP Page
    Go To                                                 ${SERVER}/amp/${page_url}#development=1
    Wait Until Page Is Loaded

Wait Until AMP Validation To Appear In Console Log
    ${existence_AMP_validation}                           Run Keyword And Return Status                               Wait Until Keyword Succeeds
    ...                                                   10x    1s                                                   Get AMP Validation Status From Console Log
    Run Keyword Unless                                    ${existence_AMP_validation}           Fail                  ${not_exist_AMP_validation_msg}

Get AMP Validation Status From Console Log
    Get Browser Console Log Entries
    Find AMP Validation Message From Console Log

Get Browser Console Log Entries
    ${log_entries}                                        Evaluate                                                    $webdriver.get_log('browser')
    ${log_entries_count}                                  Get Length                                                  ${log_entries}
    Run Keyword If                                        ${log_entries_count} == ${0}          Fail                  ${not_exist_AMP_validation_msg}
    Set Test Variable                                     ${log_entries}

Find AMP Validation Message From Console Log
    FOR                                                   ${log_entrie}                         IN                    @{log_entries}
        ${successful_AMP_validation}                      Run Keyword And Return Status                               Should Contain
        ...                                               ${log_entrie}[message]                                      ${successful_AMP_validation_console_msg}
        Exit For Loop If                                  ${successful_AMP_validation}
        ${failed_AMP_validation}                          Run Keyword And Return Status                               Should Contain
        ...                                               ${log_entrie}[message]                                      ${failed_AMP_validation_console_msg}
        Exit For Loop If                                  ${failed_AMP_validation}
    END
    Run Keyword Unless                                    ${successful_AMP_validation} or ${failed_AMP_validation}    Fail
    ...                                                   ${not_exist_AMP_validation_msg}
    Set Test Variable                                     ${successful_AMP_validation}

Console Log AMP Validation Should Be Successful
    Run Keyword Unless                                    ${successful_AMP_validation}          Fail                  ${failed_AMP_validation_msg}

AMP Url Should Be Exist Correctly In html Tags
    ${AMP_url_link}                                       Get AMP Url From html Tags                                  ${page_url}
    IF                                                   '${AMP_url_link}' == 'There are no ads on this page.'
        Log                                               ${AMP_url_link}
    ELSE IF                                              '${AMP_url_link}' == 'amphtml does not exist.'
        Fail                                              Does not exist AMP html tag in page.
    ELSE
        Should Be Equal                                   ${AMP_url_link}                                             ${SERVER}/amp/${page_url}
    END
