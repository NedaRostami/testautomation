*** Settings ***
Resource        ..${/}..${/}resources${/}common.resource
Suite Setup      Set Suite Environment
Test Setup       start app
Test Teardown    Close test application
Test Timeout     10 minutes


*** Test Cases ***
fav funcionality
    [Tags]                              utility
    Open First Listing
    Select Favorit Icon In Listing Details Page
    Click Back Button
    # Sleep              1s
    # Validate First Initial Serp
    Validate Back To Serp
    Check The Presence Of The Favorite Ads On The Favorites Section

Full Image
    [Tags]    image     notest
    Open First Listing
    click element    ${APP_PACKAGE}:id/gallery_image_layout
    Wait Until Page Contains Element  ${APP_PACKAGE}:id/pager
    Wait Until Keyword Succeeds    5x    2s    click element     ${APP_PACKAGE}:id/action_close

# TODO: ListingSHARE id
# Share
#     [Tags]    share
#     Open First Listing
#     Sleep              5s
#     Click Element   ${SHARE_ICON}
#     Run Keyword And Ignore Error    Wait Until Page Contains           اشتراک‌گذاری توسط        timeout=15
#     Press Keycode                      4
#     Capture Custom App Screenshots
#     #click element    android:id/contentPanel

*** Keywords ***
Validate Back To Serp
    Find Element By Swipe Up                    id=${MAIN_MENU}

Select Favorit Icon In Listing Details Page
    Wait Until Page Contains Element            ${ListingFav}              timeout=3s
    Click element                               ${ListingFav}

Check The Presence Of The Favorite Ads On The Favorites Section
    Click Toolbar Account
    Click Toolbar Items                         ${FAV_LINK}
    Wait Until Page Contains                    ${FirstTitle}              timeout=15s
