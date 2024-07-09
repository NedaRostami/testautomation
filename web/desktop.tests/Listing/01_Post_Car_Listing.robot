*** Settings ***
Documentation                                       add a new car listing with One image New User
...                                                 while not logged in
...                                                 Mobile Registeration
...                                                 check the moderatin to accept it.
...                                                 fav and unfav listing
Test Setup                                          Open test browser
Test Teardown                                       Clean Up Tests
Resource                                            ../../resources/setup.resource

*** Variables ***
${Car_Listing_Limit}                                1
${Car_Listing_Limit_en}                             1
${Listing_limit_duration}                           30
${Limit_price}                                      5000

*** Test Cases ***
Post Listing In Cars By All Attributes
    [Tags]                                          Listing                    car
    Login OR Register By Random OR New Mobile       ${Auth_Session_Position}
    # Add Car By All Attributes                     43973                      a68142       442203                   #پارس سایر
    Add Car By All Attributes                       43973                      a68142       440655                   #۲۰۶ (تیپ۲)
    # Add Car By All Attributes                     43973                      a68142       445011                   #۲۰۰۸
    Add Car By All Attributes                       43973                      a68142       440657                   #۲۰۶ SD (صندوق دار)
    # Add Car By All Attributes                     43973                      a68142       440663                   #سایر
    # Add Car By All Attributes                     43969                      a68144       440673                   #۳۱۵ صندوقدار
    # Add Car By All Attributes                     43969                      a68144       440672                   #۱۱۰
    # Add Car By All Attributes                     43969                      a68144       442053                   #۱۱۰S
    # Add Car By All Attributes                     43969                      a68144       440678                   #X۳۳
    # Add Car By All Attributes                     43969                      a68144       440679      ${TRUE}      #سایر


*** Keywords ***
Add Car By All Attributes
    [Arguments]                                    ${Brand}     ${Model}     ${ModelNo}
    Go To Post Listing Page
    Post A New Listing                             ${1}         43626        43627          ${Brand}
    ...         model=${Model}                     model_id=${ModelNo}       tel=${Random_User_Mobile_B}
    Verify Post Listing Is done
    Check My Listing
    Check My Listing Image Count                   1
    Verify Advertise By ID in trumpet
    Check My Ads Has been Verified
