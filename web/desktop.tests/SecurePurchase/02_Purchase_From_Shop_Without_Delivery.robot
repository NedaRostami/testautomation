*** Settings ***
Documentation                                   Test the scenario of creating a new shop with secure purchase without post listing,
...                                             registering an ad into shop by shop owner, buying an ad as Customer,
...                                             and checking the secure purchase process.
Test Setup                                      Open test browser
Test Teardown                                   Clean Up Tests
Resource                                        ../../resources/SecurePurchase.resource

*** Variables ***
${Secure_Purchase_Without_PostListing}          ${1}
${Active_Price_offer}                           ${1}
${Ad_CategoryID}                                43596
${Ad_Category}                                  لوازم الکترونیکی
${Ad_SubCategory}                               لپ تاپ و کامپیوتر
${Price}                                        25000000
${Ad_province}                                  فارس
${Ad_City}                                      شیراز
${Ad_Region}                                    حافظیه
${Number_Of_Photos}                             ${1}
${NewUsed}                                      ${EMPTY}
${chip_discount}                                ${FALSE}
${Kind}                                         ${EMPTY}
${Customer_LoggedIn}                            ${FALSE}
${Customer_Price_Offer}                         20000000
${Seller_Price_Offer}                           23000000
${Number_Goods}                                 ${2}
${send_time}                                    ${FALSE}

*** Test Cases ***
Secure Purchase Without Delivery Flow
    [Tags]               Shop        SecurePurchase     Without Delivery
    Set Web Toggles For Shop SecurePurchase Testing
    Create A New Shop with SecurePurchase Without Delivery And With Price Offer
    Post Listing By Backend By Shop Owner
    Validate Ad Details With SecurePurchase On Home Page And Click On It
    Validate Ad Details On Listing Details Page
    Send The Price Offer To The Seller As Customer
    Logout Buyer User
    Login With The Shop Owner Phone
    Go To Chat Page And Validate Ad For Price Offer Status
    Validate Seller Chat Page When Received Price Offer From Customer
    Send The Price Offer To The Customer
    Logout Seller User
    Login With The Phone Number Of The Buyer User
    Go To Chat Page And Validate Ad For Ready Pay Status
    Validate Customer Chat Page When Received Price Offer From Seller
    SecurePurchase With Seller's Price Offer And Without Delivery
    Validate Successful Payment Page And Track Post
    Validate Chat Page Of Buyer After Successful Payment
    Validate Success Payment Via Admin

*** Keywords ***
Create A New Shop with SecurePurchase Without Delivery And With Price Offer
    Create Shop In Sheypoor       Category=${Ad_CategoryID}        securepurchase=${Secure_Purchase_Without_PostListing}
    ...                           price_offer=${Active_Price_offer}

Post Listing By Backend By Shop Owner
    Post Listing In Background Via Python    ${Ad_Category}        ${Ad_SubCategory}         ${Price}
    ...                                      ${Ad_province}        ${Ad_City}                ${Ad_Region}
    ...                                      ${Shop_owner_phone}   ${Number_Of_Photos}       ${NewUsed}
    ...                                      ${chip_discount}      ${Kind}
    Set Test Variable                        ${AdsId}              ${listingID}
    Verify Advertise By ID

SecurePurchase With Seller's Price Offer And Without Delivery
    Set Test Variable                        ${Price}              ${Seller_Price_Offer}
    Click Button                             ${Chat_Sp_Btn}
    Validate Checkout Page Witout Delivery
    Click Payment Button

Go To Chat Page And Validate Ad For Price Offer Status
    Go To Chat Page And Validate Ad                   ${Chat_SP_Price_Offer_Status}

Go To Chat Page And Validate Ad For Ready Pay Status
    Go To Chat Page And Validate Ad                    ${Chat_SP_Ready_Pay_Status}
