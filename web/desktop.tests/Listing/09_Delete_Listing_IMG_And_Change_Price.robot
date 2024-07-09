*** Settings ***
Documentation                                          Edit a Listing
...                                                    Remove 1 Image
Test Setup                                             Open test browser
Test Teardown                                          Clean Up Tests
Resource                                               ../../resources/setup.resource


*** Variables ***
${state_id}                                          27       # مازندران
${city_id}                                           966      # رامسر
${region_id}                                         7614     #جواهرده

*** Test Case ***
Delete And Edit Listing Images And Change Price
    [Tags]                                             Listing              edit    edit_Listing
    Add New Listing Min By New Mobile and accept
    Edit Listing Price And Delete All Images Then Add New Image
    Listing Must Be On Check State
    Verify Advertise By ID in trumpet
    Check My Ads Has been Verified
    Check My Listing Image Count                       1
    Validate Changes


*** Keywords ***
Add New Listing Min By New Mobile and accept
    Go To Post Listing Page
    Check Backend Errors                               failure=${TRUE}
    Post A New Listing                                 ${2}   43619   43622  state=${state_id}    city=${city_id}    region=${region_id}  logged_in=${FALSE}
    Login OR Register In Listing By New Mobile
    Verify Post Listing Is done
    Check My Listing
    Check My Listing Image Count                       2
    Check My Ads Has been Verified

Edit Listing Price And Delete All Images Then Add New Image
    Click Button                                       ویرایش
    Wait Until Page Contains                           ${PL_Post_Img}     timeout=5s
    Check Backend Errors                               failure=${TRUE}
    Delete All And Add One Image
    Change Price
    Sleep                                              2s                   reason=None
    Submit post listings                               ${TRUE}              ${TRUE}


Delete All And Add One Image
    Is Image Uploaded
    Delete Images                                  ALL
    Wait Until Page Contains Element               ${image_holder}          timeout=10s
    ${NORMAL_PATH_UPLOAD_FILE_NAME}                Normalize Path           ${PROJECT_ROOT_PATH}/lib/Sheypoor/libraries/Images/static/sports/8.jpg
    Choose File                                    ${image_holder}          ${NORMAL_PATH_UPLOAD_FILE_NAME}
    Is Image Uploaded
    Set Test Variable                              ${IMGcount}              ${1}


Change Price
    Input Text                                     ${PL_Form_Price}         1,400,000
    Set Focus To Element                           ${PL_Form_Title}

Validate Changes
    Click Button                                   ویرایش
    Wait Until Page Contains Element               name=price
    SeleniumLibrary.Element Text Should Be         name=price               یک میلیون و چهارصد هزار تومان
