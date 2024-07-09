*** Settings ***
Documentation                                   Test the scenario of creating a new shop with secure purchase and post by seller,
...                                             Set posting cost of securepurchase via admin,
...                                             registering an ad into shop by shop owner, buying an ad as Customer,
...                                             and checking the secure purchase process.
Test Setup                                      Open test browser
Test Teardown                                   Clean Up Tests
Resource                                        ../../resources/SecurePurchase.resource

*** Variables ***
${Origin}                                       2:313
${Origin_id}                                    8
${origin_city}                                  شهریار
${Destination}                                  2:313
${Destination_id}                               313
${Destination_Name}                             شهریار

${destination_change}                           2:291
${destination_name_change}                      اسلامشهر
${customer_cityid_change}                       291
${customer_district_change}                     زرافشان
${customer_address_change}                      تهران، اسلامشهر، نشانی دقیق مشتری

${Post_Provider}                                1                               #الوپیک
${Provider_Posting_Cost}                        7000
${Post_Provider_Name}                           الوپیک

${Ad_province}                                  تهران
${Ad_province_Id}                               8
${Ad_City}                                      شهریار
${Ad_City_Id}                                   313
${Ad_Region}                                    ${EMPTY}
${Ad_Region_Id}                                 ${EMPTY}
${Ad_Category}                                  لوازم خانگی
${Ad_SubCategory}                               ظروف و لوازم آشپزخانه
${Ad_CategoryID}                                43608
${Ad_SubCategoryID}                             43610

${Secure_Purchase_With_PostListing}             ${2}
${Posting_Cost_City}                            10000
${Posting_Cost_State}                           11000
${Posting_Cost_Country}                         12000

${Number_Of_Photos}                             ${2}

${Customer_ProvinceId}                          8                               #تهران
${Customer_CityId}                              313                             #شهریار
${Customer_City}                                شهریار
${Customer_District}                            شهرک رفاه
${Customer_Address}                             تهران، شهریار، نشانی دقیق مشتری
${Customer_Plaque}                              ${4}
${Customer_Unit_Num}                            ${3}
${Number_Goods}                                 ${3}

${sp_required}                                 ${TRUE}

*** Test Cases ***
Secure Purchase With Delivery Flow
    [Tags]               Shop        SecurePurchase     Posted By Seller     With Delivery
    Set Web Toggles For Shop SecurePurchase Testing
    Set Posting Cost Based On Origin And Destination Via Admin By Backend
    Create A New Shop with SecurePurchase And Posted By Seller
    Login With The Shop Owner Phone
    Post Listing With Secure Purchase Capability
    Get ListingID And Accept Listing
    Logout Seller User
    Check Home Page
    Validate Ad Details With SecurePurchase On Serp Page And Click On It
    Validate Ad Details On Listing Details Page
    SecurePurchase With Delivery
    Validate Successful Payment Page And Track Post
    Validate Chat Page Of Buyer After Successful Payment
    Validate Success Payment Via Admin


*** Keywords ***
Create A New Shop with SecurePurchase And Posted By Seller
    Create Shop In Sheypoor       Category=${Ad_CategoryID}                                   securepurchase=${Secure_Purchase_With_PostListing}
    ...     shipping_type=1       city_shipping_cost=${Posting_Cost_City}                     state_shipping_cost=${Posting_Cost_State}
    ...     country_shipping_cost=${Posting_Cost_Country}

Post Listing With Secure Purchase Capability
    Go To Post Listing Page
    Post A New Listing      ${Number_Of_Photos}          ${Ad_CategoryID}                     ${Ad_SubCategoryID}
    ...                     state=${Ad_province_Id}      city=${Ad_City_Id}                   region=${Ad_Region_Id}
    ...                     tel=${Shop_owner_phone}
