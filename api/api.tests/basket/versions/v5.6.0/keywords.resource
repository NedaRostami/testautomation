*** Settings ***
Resource                                ../default/default-keywords.resource

*** Keywords ***
Post A Listing With Secure Purchase
    [Arguments]             ${Category_ID}          ${Secure_Purchase_Type}
    Create Shop In Sheypoor         ${Category_ID}                  ${Secure_Purchase_Type}
    Get Members Phone Numbers
    Login To Service                ${Consultant_Phones[0]}
    ${Listing_Id}                   Post a Listing            Custom_Price=123456      category=لوازم شخصی
    [Return]                        ${Listing_Id}

Check Version
    No Operation
