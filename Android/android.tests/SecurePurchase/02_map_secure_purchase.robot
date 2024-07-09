*** Settings ***
Resource        ..${/}..${/}resources${/}common.resource
Suite Setup      Set Suite Environment
Test Setup       start app
#Test Teardown    Close test application
Test Teardown    Close test application For Insert Photos
Test Timeout     10 minutes

*** Variables ***
${State}                                         تهران
${City}                                          تهران
${Region}                                        آجودانیه
${Sleep_time}                                    2s
${Timeout}                                       10s
${Category}                                     لوازم خانگی
${SubCategory}                                  مبلمان و لوازم چوبی
${Category_ID}                                  43608
${Secure_Purchase_Type}                         ${2}               #secure purchase + Post
${Number_Of_Photos}                             1
${Customer_Name}                                علی علوی
${Customer_Lat}                                 35.693512
${Customer_Long}                                51.438452
${Customer_Alt}                                 1182
${Customer_State}                               تهران       #based on lat and long
${Customer_Address_Total}                       تهران، محله ونک (کاووسيه)، بلوار نلسون ماندلا، ژوبین، پلاک 20، واحد 14
${Customer_Address}                             تهران، محله ونک (کاووسيه)، بلوار نلسون ماندلا، ژوبین
${Customer_House_Num}                           3
${Customer_Unit_Num}                            14

*** Test Cases ***
Use Search Location For Address From Map in Secure Purchase With Delivery
    [Tags]    SecurePurchase      Map    notest

    Check Min Accepted Version Is  5.6.0

    Post a new secure purchase listing with delivery feature

    select the new listing by customer

    validate listing details based on submited listing

    select online shoping process by cutomer

    compelete step one in secure purchase flow ( change number of product )

    select location based on search in map (do not use on current location)

    validate adress in step 2 in secure purchase flow

    validate step 3 and click on payment button

    validate chat of customer

    validate chat on seller

*** Keywords ***

