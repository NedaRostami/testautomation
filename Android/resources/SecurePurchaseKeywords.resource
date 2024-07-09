*** Settings ***
Resource          common.resource

*** Variables ***
${State}                                        مازندران
${City}                                         بابلسر
${Region}                                       بلوار ساحلی
${Sleep_time}                                   2s
${Timeout}                                      10s

${Category}                                     لوازم شخصی
${SubCategory}                                  لباس ، کیف و کفش
${Category_ID}                                  43612
${Price}                                        1000000
${Kind}                                         ${EMPTY}
${NewUsed}                                      ${EMPTY}
${CheckNewUsed}                                 ${EMPTY}
${Delivery_Price_City}                          7000
${Delivery_Price_State}                         8000
${Delivery_Price_Country}                       9000

${Secure_Purchase_Type}                         ${2}               #secure purchase + Post
${Number_Of_Photos}                             3

${Customer_Name}                                علی علوی
${Customer_Lat}                                 35.75440641962015      # lat/lng: (35.75440641962015,51.415340043604374)
${Customer_Lat_4}                               35.7544
${Customer_Long}                                51.415340043604374
${Customer_Long_4}                              51.4153
${Customer_Alt}                                 1182
${Customer_State}                               تهران       #based on lat and long
${Customer_Address_Total}                       تهران، محله ونک (کاووسيه)، بلوار نلسون ماندلا، ژوبین، پلاک 20، واحد 14
${Customer_Address}                             تهران، محله ونک (کاووسيه)، بلوار نلسون ماندلا، ژوبین
${Customer_House_Num}                           20
${Customer_Unit_Num}                            14
${Number_Goods}                                 1

${Default_Lat}                                  35.7000
${Default_Long}                                 51.4000

*** Keywords ***
Set Android Toggles For Shop SecurePurchase Testing
    Set Toggles For Shop SecurePurchase Testing         android          ${1}

Set Android Toggles For User SecurePurchase Testing
    Set Toggles For User SecurePurchase Testing         android          ${1}

Post A New Listing With Secure Purchase From a Shop
    Create Shop With Delivery
    Get Members Phone Numbers
    Post A New Listing Without Payment                  ${Category_ID}  Num_Of_Photo=${Number_Of_Photos}    Category=${Category}
    ...         SubCategory=${SubCategory}              State=${State}              City=${City}            Region=${Region}
    ...         User_Mobile=${Consultant_Phones[0]}     Price=${Price}              NewUsed=${NewUsed}      Kind=${Kind}
    Back To Home Page           1
    Log Out From Sheypoor

Create Shop With Delivery
    Create Shop In Sheypoor                             ${Category_ID}              ${Secure_Purchase_Type}
    ...         shipping_type=1                         city_shipping_cost=${Delivery_Price_City}
    ...         state_shipping_cost=${Delivery_Price_State}      country_shipping_cost=${Delivery_Price_Country}

Post A New Listing With Secure Purchase In Background
    Create Shop In Sheypoor                             ${Category_ID}              ${Secure_Purchase_Type}
    Post Listing By Backend

Post Listing By Backend
    Get Members Phone Numbers
    Post Listing In Background Via Python               ${Category}                 ${SubCategory}              ${Price}
    ...         ${State}              ${City}           ${Region}                   ${Consultant_Phones[0]}
    ...         ${Number_Of_Photos}   ${NewUsed}        ${FALSE}                    ${Kind}

Filter Category and SubCategory For Serp Page As a Customer
    Filter Category For General Category                ${Category}                 ${SubCategory}

Select Listing With Secure Purchase In Serp
    Check Listing With Secure Purchase In Serp          ${listingId}                ${Title_Words}           ${Category}
    ...            ${SubCategory}                       ${State}                    ${City}                  ${Region}
    Click Listing In Serp                               ${listingId}                ${Title_Words}

Validate Listing Details Items In Listing Details Page
    Validate Secure Purchase Detail In Listing Details Page
    Validate Listing Details Items                      ${Category}                 ${SubCategory}           ${State}
    ...             ${City}         ${Region}           ${Price}                    NewUsed=${NewUsed}       SellerORCustomer=Customer
    ...             Kind=${Kind}                        Seller_Number=${Consultant_Phones[0]}
    Validate Shop Name in Listing Details Page          ${Shop_title}

Press Secure Purchase Button In Listing Details Page
    Click Element                                       ${PURCHASE_BUTTON}
