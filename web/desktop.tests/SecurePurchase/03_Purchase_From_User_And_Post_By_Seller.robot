*** Settings ***
Documentation                                   Secure purchase and shipping scenario by a seller who is not a member of the shop.
...                                             Set Toggle For SecurePurchase,
...                                             Set posting cost of securepurchase via admin,
...                                             Post an ad by a seller who is not a member of the shop,
...                                             Buy ads registered by the customer,
...                                             And check the non-repurchase of registered ads for sale.
Test Setup                                      Open test browser
Test Teardown                                   Clean Up Tests
Resource                                        ../../resources/SecurePurchase.resource

*** Variables ***
${Origin}                                       2:1065              #همدان-تویسرکان
${Origin_id}                                    30
${origin_city}                                  تویسرکان
${Destination}                                  1:7
${Destination_id}                               7
${Destination_Name}                             بوشهر
${Post_Provider}                                4                               #تیپاکس
${Provider_Posting_Cost}                        20000
${Post_Provider_Name}                           تیپاکس

${destination_change}                           2:271
${destination_name_change}                      بنک
${customer_cityid_change}                       271
${customer_district_change}                     شهر بنک
${customer_address_change}                      بوشهر، شهر بنک، نشانی دقیق مشتری

${Ad_province}                                  همدان
${Ad_province_Id}                               30
${Ad_City}                                      تویسرکان
${Ad_City_Id}                                   1065
${Ad_Region}                                    ${EMPTY}
${Ad_Region_Id}                                 ${EMPTY}
${Ad_Category}                                  لوازم شخصی
${Ad_SubCategory}                               لباس ، کیف و کفش
${Ad_CategoryID}                                43612
${Ad_SubCategoryID}                             43613

${Number_Of_Photos}                             ${3}

${Customer_ProvinceId}                          7                               #بوشهر
${Customer_CityId}                              272                             #بوشهر
${Customer_City}                                بوشهر
${Customer_District}                            محله فردوسی
${Customer_Address}                             بوشهر، محله فردوسی، نشانی دقیق مشتری
${Customer_Plaque}                              ${4}
${Customer_Unit_Num}                            ${3}
${Number_Goods}                                 ${1}

${Seller_ProvinceId}                          30                              #همدان
${Seller_CityId}                              1065                            #تویسرکان
${Seller_City}                                تویسرکان
${Seller_District}                            تویسرکان
${Seller_Address}                             همدان، تویسرکان، نشانی دقیق مشتری
${Seller_PLAQUE}                              ${2}
${Seller_Unit_Num}                            ${1}

${show_sp_popup}                                ${TRUE}
${sp_required}                                  ${TRUE}
${shop_seller}                                  ${FALSE}
${Has_Delivery_Time}                            ${FALSE}

*** Test Cases ***
Secure Purchase With Delivery Flow
    [Tags]               Customer       SecurePurchase     Posted By Seller     With Delivery
    Set Web Toggles For User SecurePurchase Testing
    Set Posting Cost Based On Origin And Destination Via Admin By Backend
    Generate Phone Number For The Seller User And Login With It
    Post Listing With Secure Purchase Capability By Seller
    Get ListingID And Accept Listing
    Logout Seller User
    Check Home Page
    Validate Ad Details With SecurePurchase On Serp Page And Click On It
    Validate Ad Details On Listing Details Page
    SecurePurchase With Delivery
    Validate Successful Payment Page And Track Post
    Validate Chat Page Of Buyer After Successful Payment
    Validate Success Payment Via Admin
    Logout Buyer User
    Login With The Phone Number Of The Seller User
    Validate Chat Page Of Seller After Successful Payment
    Send Goods By The Seller
    Validate Chat Page Of Seller After Send Goods
    Logout Seller User
    Login With The Phone Number Of The Buyer User
    Validate Chat Page Of Buyer After Send Goods
    Confirmation And Transfer Of Funds By Buyer
    Logout Buyer User
    Validate The Non Purchase Of The Purchased Ad On The Ad Details Page


*** Keywords ***
Post Listing With Secure Purchase Capability By Seller
    Go To Post Listing Page
    Post A New Listing                      ${Number_Of_Photos}          ${Ad_CategoryID}              ${Ad_SubCategoryID}
    ...                                     state=${Ad_province_Id}      city=${Ad_City_Id}            region=${Ad_Region_Id}
    ...                                     tel=${Seller_User_Phone}
