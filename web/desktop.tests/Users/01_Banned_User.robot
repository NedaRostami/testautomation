*** Settings ***
Documentation                                  Banned User Number And Check It In Moderation
...                                            Author:Hamid Heravi
Test Setup                                     Open Admin browser
Test Teardown                                  Clean Up Tests
Resource                                       ../../resources/setup.resource

*** Variables ***
${state_id}                                    27                #مازندران
${city_id}                                     984               #کلاردشت
${Region}                                      7880              #رودبارک

*** Test Cases ***
Check Banned User
  [Tags]                                        User      Banned
  Go To Mobile Filter Page
  Add Random Mobile To Blacklist
  Login OR Register By Mobile                   ${Random_User_Mobile_B}           ${Auth_Session_Position}
  Go To Post Listing Page
  Post A New Listing                            ${1}    43626    43627    43973   state=${state_id}    city=${city_id}    region=${Region}   model=a68142  model_id=440657   tel=${Random_User_Mobile_B}
  Verify Post Listing Is done
  Get ListingID
  Listing Must Not Be On Check State
  Go To                                         ${SERVER}/trumpet
  Check The Listing In Blacklist Page

*** Keywords ***
Go To Mobile Filter Page
  go to                                         ${SERVER}/trumpet/filter/search/phone
  Wait Until Page Contains element              id=filters-results-generic      timeout=5s
  page should contain                           آی پی

Add Random Mobile To Blacklist
  Mobile Generator B
  Input Text                                    name=Text                        ${Random_User_Mobile_B}
  Click Button                                  افزودن موبایل به لیست سیاه
  Wait Until Page Contains                      عملیات با موفقیت انجام شد      timeout=5s
  wait until page loading is finished
  Sleep   3
  Input Text                                    name=s                           ${Random_User_Mobile_B}
  # Wait Until Element Is Visible                 class=btn-primary
  # Wait Until Element Is Enabled                 class=btn-primary
  Click Button                                  جستجو
  Wait Until Element Contains                   id:filters-results-generic       ${Random_User_Mobile_B}      timeout=3s

Check The Listing In Blacklist Page
    Wait Until Page Contains                      خوش آمدید                       timeout=3s
    ${BlackNo}                                    get text                        xpath://ul[@class="list-group"]/li[4]
    Click Link                                    لیست سیاه
    FOR   ${i}      IN RANGE     20
      ${HasList}                                   Run Keyword And Return Status     Wait Until Page Contains Element            css:button.btn.btn-success.btn-lg.btn-block    timeout=5s
      Exit For Loop If                            not ${HasList}
      ${Mobile}                                   Run Keyword And Return Status     Page Should Not Contain           ${Random_User_Mobile_B}
      ${Listing}                                  Run Keyword And Return Status    Page Should Not Contain          ${AdsId}
      Exit For Loop If    ${Mobile} and ${Listing}
      Reject Listings
    END

Reject Listings
    Wait Until Page Contains Element             xpath://div[@class="text-left"]/label[@class="control-label"]
    ${elements}                                  Get WebElements                 xpath://div[@class="text-left"]/label[@class="control-label"]
    FOR   ${elem}      IN  @{elements}
      ${ListingID}                               SeleniumLibrary.Get Element Attribute         ${elem}       data-clipboard
      Mock Listing Moderate                      reject      ${ListingID}
    END
    reload Page
    Wait Until Page Is Loaded in Moderation
