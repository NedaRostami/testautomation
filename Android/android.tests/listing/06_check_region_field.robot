*** Settings ***
Documentation                                       Fill Listing Form, when the neighborhood field is set separately.
...                                                 And check its existence on my ads page and on the ad details page
Resource                                            ..${/}..${/}resources${/}common.resource
Suite Setup                                         Set Suite Environment
Test Setup                                          start app
Test Teardown                                       Close test application For Insert Photos


*** variables ***
${State}                                            کهگیلویه و بویراحمد
${City}                                             یاسوج
${Region}                                           بلوار انقلاب
${Furniture_Cat_Id}                                 43609
${Image_Count}                                      2
${Price_Value}                                      92000000


*** Test Case ***
Fill Region Field And Check Its Value
    [Tags]                                          Listing                     Location
    Login to Sheypoor
    Go To Post Listing Page
    Fill Listing Form For Home Appliances Category
    Submit Post Listing                             ${TRUE}                     ${TRUE}
    Get AdID And Accept Listing
    Check Listing Status in My Listings Page By Click NOTNOW Button
    Check Listing Title In My Listing Page
    Check Location In Listing Details Page


*** Keywords ***
Fill Listing Form For Home Appliances Category
    Get Random Listing                              ${Furniture_Cat_Id}
    Insert Photos                                   ${Image_Count}
    Input Home Appliances Attribute
    Input Title And Decription
    Select Location                                 ${State}                    ${City}            ${Region}

Input Home Appliances Attribute
    Select Home Appliances Category
    Select Furniture And Wooden Accessories

Select Home Appliances Category
    Click Category Spinner
    Scroll The List                                 لوازم خانگی

Select Furniture And Wooden Accessories
    Scroll The List                                 مبلمان و لوازم چوبی

Check Location In Listing Details Page
    Check Listing Details Page Is Loaded
    Find Text By Swipe in loop                     ${State}، ${City}، ${Region}
