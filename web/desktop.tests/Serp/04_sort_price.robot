*** Settings ***
Documentation                        Sort Cheapest and Most Expensive
Test Setup                           Open test browser
Test Teardown                        Clean Up Tests
Resource                             ../../resources/serp.resource

*** Test Cases ***
Sort Listing By Price
    [Tags]                           sort   serp
    Go To Serp Page
    Sort Cheapest Listings
    Sort Most Expensive Listings

*** Keywords ***
Sort Cheapest Listings
    Change Serp sort                 pa
    Append Items to List
    Price Comparison                 >

Sort Most Expensive Listings
    Change Serp sort                 pd
    Append Items to List
    Price Comparison                 <

Append Items to List
    ${PriceList}                     Create List
    Set Test Variable                ${Price_List}                     ${PriceList}
    ${PriceElements}                 Get WebElements                   ${Serp_ALL_L_Price}
    Check Num Of Listings In Serp    ${PriceElements}
    FOR     ${ELEMENT}               IN   @{PriceElements}
      ${Price}                       get text                          ${ELEMENT}
      ${Price}                       Remove String                     ${Price}    ,
      ${Price}                       Convert Digits                    ${Price}    Fa2En
      Append To List                 ${Price_List}                     ${Price}
    END

Price Comparison
    [Arguments]                       ${Operator}
    ${Counter}                        Get Length              ${Price_List}
    FOR    ${i}                       IN RANGE                ${Counter-1}
      Should Not Be True              ${Price_List}[${i}] ${Operator} ${Price_List}[${i+1}]
    END
