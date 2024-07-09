*** Settings ***
Resource                             ..${/}..${/}resources${/}common.resource
Suite Setup                          Set Suite Environment
Test Setup                           start app
Test Teardown                        Close test application
Test Timeout                         10 minutes

*** Test Cases ***
Check Listing Next Navigation
  [Tags]                              Listing   navigation   notest
  Open First Listing
  Set Test Variable                   ${Nav0}     ${FirstTitle}
  Is Next Listing Loaded Correctly

*** Keywords ***
Is Next Listing Loaded Correctly
    FOR    ${i}    IN RANGE    1    5
       ${unavailable}                 Run Keyword And Return Status    Page Should Contain Element    id=${APP_PACKAGE}:id/adDetailsDeletedState
       Run Keyword If                 ${unavailable}     Swipe Next
       Continue For Loop If           ${unavailable}
       ${ListingTitle}                Get Text           ${OfferID}
       Set Test Variable              ${Nav${i}}         ${ListingTitle}
       ${status}                      Run Keyword And Return Status    Should Not Be Equal  ${Nav${i-1}}  ${Nav${i}}
       Exit For Loop If               ${status}
       Swipe Next
    END
    Run Keyword unless                ${status}     Fail    Listing details failed on swipe ${i}


Swipe Next
    swipe by percent     80   80   20   80   500
    Sleep     500ms
