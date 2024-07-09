*** Settings ***
Documentation                                          add new package pricing
...                                                    edit packages price
Test Setup                                             Open test browser
Resource                                               ../../resources/setup.resource
library                                                SeleniumLibrary

*** Variables ***
${New_Price}                                          bump-price-new
${History_Button}                                     //td[text()='خراسان رضوی']/following-sibling::td//a[contains(text(),'تاریخچه')]

*** Test Cases ***
Package Pricing Scenarios
    [Tags]                                            pricing   packages   notest   paid_features
    Login Trumpet Admin Page
    Go To                                             ${SERVER}/trumpet/bump-price/search
    Wait Until Page Contains Element                  class:${New_Price}                              timeout=10s
    Click By Css Selector                             .${New_Price}
    Wait Until Page Contains                          مبلغ بسته بروزرسان                              timeout=10s
    Create New Package Pricing
    Pricing Validation                                خراسان رضوی


*** Keywords ***
Create New Package Pricing
    [Arguments]                                      ${City}=12            ${Bump_Type}=2         ${Category}=4          ${Price}=100000
    Click Element                                    id:BumpId
    Wait Until Page Contains                         ۳ بروزرسانی / روزی ۱ بار                         timeout=10s
    Click Element                                    //*[@id="BumpId"]/optgroup[1]/option[${Bump_Type}]
    Click Element                                    id:BumpId
    Click Element                                    id:RegionId
    Wait Until Page Contains                         چهارمحال و بختیاری                               timeout=10s
    Click Element                                    //*[@id="RegionId"]/option[${City}]
    Click Element                                    id:RegionId
    Click Element                                    id:CategoryId
    Click Element                                    //*[@id="CategoryId"]/option[${Category}]
    Click Element                                    id:CategoryId
    Input Text                                       id:Price                                         ${Price}
    Click Element                                    class:btn.btn-success.pull-left
    Wait Until Page Contains                         عملیات با موفقیت انجام شد                        timeout=10s
    Wait Until Page Does Not Contain                 عملیات با موفقیت انجام شد                        timeout=10s
    # ${Price_Info}                                    Get WebElement                                   class=odd
    # ${Price_Info}                                    Get Text                                         ${Price_Info}
    # Set Test Variable                                ${Price_Info}                                    ${Price_Info}

Pricing Validation
    [Arguments]                                      ${City_Name}
    Set Test Variable                                ${History_Button}                               //td[text()='${City_Name}']/following-sibling::td//a[contains(text(),'تاریخچه')]
    Click Element                                    ${History_Button}
    Switch Window                                    locator=NEW
    Wait Until Page Contains Element                 class=odd                                       timeout=10s
    Page Should Contain                              گزارش قیمت گذاری بسته های افزایش بازدید
    ${History}                                       Get WebElement                                  class=odd
    ${History}                                       Get Text                                        ${History}
    Switch Window	                                   locator=MAIN
    ${location}	                                     Get Location
    Log To Console                                   ${location}
