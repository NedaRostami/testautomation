*** Settings ***
Documentation                                 Check Listing breadcrumbs and Tags
Test Setup                                    Open test browser
Test Teardown                                 Clean Up Tests
Resource                                      ../../../resources/setup.resource

*** Variables ***
${HOME}                                       xpath=//*[@id="breadcrumbs"]/ul/li[1]/a
${FirstBC}                                    xpath=//*[@id="breadcrumbs"]/ul/li[2]
${SecondBC}                                   xpath=//*[@id="breadcrumbs"]/ul/li[3]
${ThirdBC}                                    xpath=//*[@id="breadcrumbs"]/ul/li[4]
${FourthBC}                                   xpath=//*[@id="breadcrumbs"]/ul/li[5]
${FifthBC}                                    xpath=//*[@id="breadcrumbs"]/ul/li[6]
${FIRSTLISTING}                               xpath=//*[starts-with(@id,'listing')]/div[2]/h2/a
${TAG1}                                       xpath=//*[@id="tags"]/span[1]
${TAG2}                                       xpath=//*[@id="tags"]/span[2]
${TAG3}                                       xpath=//*[@id="tags"]/span[3]
${Close3}                                     xpath=//*[@id="tags"]/span[3]/span
${Close2}                                     xpath=//*[@id="tags"]/span[2]/span
${Close1}                                     xpath=//*[@id="tags"]/span/span


*** Test Cases ***
Check Breadcrumbs And Tags
  [Tags]                                      breadcrumbs    notest   serp  listing_details
  Go to                                       ${SERVER}/تهران
  Wait Until Page Contains                    همه آگهی ها در تهران
  Go To First Listing
  Assign Breadcrumbs Elements
  Get Breadcrumbs Values
  click element                               SubCatElementID
  click element                               ${Close3}
  Check City
  Go Back
  Check SubCat
  click element                               CatElementID
  click element                               ${Close3}
  Check City
  Go Back
  Check Cat
  click element                               CityElementID
  click element                               ${Close1}
  Sleep   1s
  Check State
  Go Back
  Sleep   1s
  Check City
  click element                               StateElementID
  click element                               ${Close1}
  Sleep   1s
  click element                               ${Close1}
  Wait Until Page Contains                    ${IranAllH1}                  timeout=5s
  Assign ID to Element                        ${FirstBC}                    Country
  SeleniumLibrary.Element Text Should Be      Country                       همه ایران
  Go Back
  Sleep   1s
  Check State
  Check Home

*** Keywords ***
Go To First Listing
  @{elements}                                get webelements                ${FIRSTLISTING}
  ${FirstListingTitle}                       Get Text                       ${elements}[7]
  ${FirstListingTitle}                       Replace String Using Regexp    ${FirstListingTitle}    ${SPACE}+    ${SPACE}
  click element                              ${elements}[7]
  Wait Until Page Contains                   گزارش آگهی                    timeout=10s
  ${listing_detail_title}                    Get Text                       //h1
  ${listing_detail_title}                    Replace String Using Regexp    ${listing_detail_title}    ${SPACE}+    ${SPACE}
  Should Be Equal                            ${FirstListingTitle}           ${listing_detail_title}

Check Close TAG
  Click Link                                 ${AllAdvs}
  Wait Until Page Contains                   همه آگهی ها در ${State}       timeout=5s
  Go To First Listing
  click element                              ${FifthBC}/a
  Check Cat
  click element                              ${Close2}
  Check City
  click element                              ${Close1}
  Sleep   1s
  Check State
  click element                              ${Close1}
  Wait Until Page Contains                   ${IranAllH1}                   timeout=5s
  Assign ID to Element                       ${FirstBC}                     Region
  SeleniumLibrary.Element Text Should Be     Region                         همه ایران

Assign Breadcrumbs Elements
  Assign ID to Element                       ${FirstBC}/a                   StateElementID
  Assign ID to Element                       ${SecondBC}/a                  CityElementID
  Assign ID to Element                       ${ThirdBC}/a                   RegionElementID
  Assign ID to Element                       ${FourthBC}/a                  CatElementID
  Assign ID to Element                       ${FifthBC}/a                   SubCatElementID

Get Breadcrumbs Values
  ${StateTXT}                               Get Text                        StateElementID
  ${CityTXT}                                Get Text                        CityElementID
  ${RegionTXT}                              Get Text                        RegionElementID
  ${CatTXT}                                 Get Text                        CatElementID
  ${SubCatTXT}                              Get Text                        SubCatElementID
  ${CITY_STATE}                             Set Variable If                '${CityTXT}' == '${StateTXT}'     استان ${StateTXT}    ${StateTXT}
  Set Test Variable                         ${State}                        ${StateTXT}
  Set Test Variable                         ${City}                         ${CityTXT}
  Set Test Variable                         ${Region}                       ${RegionTXT}
  Set Test Variable                         ${Cat}                          ${CatTXT}
  Set Test Variable                         ${SubCat}                       ${SubCatTXT}
  Set Test Variable                         ${CITY_STATE}                   ${CITY_STATE}

Check SubCat
  Wait Until Page Is Loaded
  Element Should Contain                    //*[@id="serp-title"]/h1        آگهی های ${SubCat} در
  Element Should Contain                    //*[@id="serp-title"]/h1        ${Region}
  Element Should Contain                    //*[@id="serp-title"]/h1        ${City}
  Assign ID to Element                      ${FifthBC}                      SubCatElementID
  Assign ID to Element                      ${FourthBC}/a                   CatElementID
  Assign ID to Element                      ${ThirdBC}/a                    RegionElementID
  Assign ID to Element                      ${SecondBC}/a                   CityElementID
  Assign ID to Element                      ${FirstBC}/a                    StateElementID
  SeleniumLibrary.Element Text Should Be    SubCatElementID                 ${SubCat}
  SeleniumLibrary.Element Text Should Be    CatElementID                    ${Cat}
  SeleniumLibrary.Element Text Should Be    RegionElementID                 ${Region}
  SeleniumLibrary.Element Text Should Be    CityElementID                   ${City}
  SeleniumLibrary.Element Text Should Be    StateElementID                  ${State}
  Assign ID to Element        ${TAG1}       TagA
  Assign ID to Element        ${TAG2}       TagB
  Assign ID to Element        ${TAG3}       TagC
  SeleniumLibrary.Element Text Should Be    TagA                            شهر: ${City}
  ${Region}                                 Convert Digits                  ${Region}                En2Fa
  SeleniumLibrary.Element Text Should Be    TagB                            محله: ${Region}
  SeleniumLibrary.Element Text Should Be    TagC                            ${SubCat}

Check Cat
  Wait Until Page Is Loaded
  Element Should Contain                     //*[@id="serp-title"]/h1       آگهی های ${Cat} در
  Element Should Contain                     //*[@id="serp-title"]/h1       ${Region}
  Element Should Contain                     //*[@id="serp-title"]/h1       ${City}
  Assign ID to Element                       ${FourthBC}                    CatElementID
  Assign ID to Element                       ${ThirdBC}/a                   RegionElementID
  Assign ID to Element                       ${SecondBC}/a                  CityElementID
  Assign ID to Element                       ${FirstBC}/a                   StateElementID
  SeleniumLibrary.Element Text Should Be     CatElementID                   ${Cat}
  SeleniumLibrary.Element Text Should Be     RegionElementID                ${Region}
  SeleniumLibrary.Element Text Should Be     CityElementID                  ${City}
  SeleniumLibrary.Element Text Should Be     StateElementID                 ${State}
  Assign ID to Element        ${TAG1}        TagA
  Assign ID to Element        ${TAG2}        TagB
  Assign ID to Element        ${TAG3}        TagC
  SeleniumLibrary.Element Text Should Be     TagA                           شهر: ${City}
  ${Region}                                  Convert Digits                 ${Region}                En2Fa
  SeleniumLibrary.Element Text Should Be     TagB                           محله: ${Region}
  SeleniumLibrary.Element Text Should Be     TagC                           ${Cat}

Check City
  Wait Until Page Contains                   همه آگهی ها در ${City}
  Assign ID to Element                       ${SecondBC}                    CityElementID
  Assign ID to Element                       ${FirstBC}                     StateElementID
  SeleniumLibrary.Element Text Should Be     CityElementID                  ${City}
  SeleniumLibrary.Element Text Should Be     StateElementID                 ${State}
  Assign ID to Element        ${TAG1}        TagA
  SeleniumLibrary.Element Text Should Be     TagA                           شهر: ${City}

Check State
  Wait Until Page Contains                    همه آگهی ها در ${CITY_STATE}    timeout=5s
  Assign ID to Element                        ${FirstBC}                       StateElementID
  SeleniumLibrary.Element Text Should Be      StateElementID                   ${State}
  Assign ID to Element                        ${TAG1}                          TagA
  SeleniumLibrary.Element Text Should Be      TagA                             استان: ${State}

Check Home
  click element   ${HOME}
  Wait Until Page Contains                    خرید و فروش خودرو، املاک، آپارتمان، گوشی موبایل، تبلت، لوازم خانگی، لوازم دست دوم، استخدام و هر چه فکر کنید      timeout=5s
  #Page Should Contain                        همه آگهی‌های استان ${State}
