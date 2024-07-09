*** Settings ***
Documentation                                   check image filter and upload
Test Setup                                      Open test browser
Test Teardown                                   Clean Up Tests
Resource                                        ../../resources/serp.resource

*** Test Cases ***
Check Listing Image
  [Tags]                                        image  Listing   serp
  Login OR Register By Random OR New Mobile     ${Auth_Session_Position}
  Go To Post Listing Page
  Post A New Listing                            ${1}  43619  43625  tel=${Random_User_Mobile_B}
  Verify Post Listing Is done
  Check My Listing
  Check My Listing Image Count                  1
  # Login Trumpet Admin Page
  # Verify Advertise By ID in trumpet
  Verify Advertise By ID
  Check My Ads Has been Verified
  Check listing in Serp
  Assert an image is visible

*** Keywords ***
Check listing in Serp
  FOR  ${index}   IN RANGE   1   5
    Go To                                       ${SERVER}/ایران/ورزش-فرهنگ-فراغت/انواع-ساز-آلات-موسیقی
    Wait Until Page Contains                    آگهی های انواع ساز و آلات موسیقی در ${AllIran}        timeout=10s
    ${ststus}                                   Run Keyword And Return Status    Page Should Contain    ${Title_Words}
    Exit For Loop If    ${ststus}
    reload page
  END
