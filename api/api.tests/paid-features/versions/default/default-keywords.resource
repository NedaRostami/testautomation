*** Settings ***
Resource                                ../../../../resources/resource.resource


*** Variables ***


*** Keywords ***
# ---------------------------------------------- Hamrah Mechanic ---------------------------------------------------
Post a Mapped ${Category} Listing Outside Tehran
    Set Random Phone Number
    Login To Service
    Hamrah Mechanic Mapped Outside Tehran Post Listing
    Integer                         response status             minimum=200     maximum=202
    ${Post_Listing_Message}         Set Variable                ${Response['message']}
    Pass Execution If               "تعداد مجاز رایگان" in "${Post_Listing_Message}"                Encountered listing limit
    Set Test Variable               ${Response}                 ${Response}

Post a Mapped ${Category} Listing Tehran
    Set Random Phone Number
    Login To Service
    Hamrah Mechanic Mapped Tehran Post Listing
    Integer                         response status             minimum=200     maximum=202
    ${Post_Listing_Message}         Set Variable                ${Response['message']}
    Pass Execution If               "تعداد مجاز رایگان" in "${Post_Listing_Message}"                Encountered listing limit
    Set Test Variable               ${Response}                 ${Response}

Post a Normal ${Category} Listing
    Set Random Phone Number
    Login To Service
    ${Location}                     Get Location Object         location=تهران  city=تهران  id=${True}
    Run Keyword                     Post A ${Category} Listing  validate=true   location=${Location}    location_type=city     brand=دیگر
    Integer                         response status             minimum=200     maximum=202
    ${Response}                     Get Object                  response body
    ${Post_Listing_Message}         Get String                  response body message
    Set Test Variable               ${Response}                 ${Response}
    Pass Execution If               "تعداد مجاز رایگان" in "${Post_Listing_Message}"                Encountered listing limit

Hamrah Mechanic Mapped Tehran Post Listing
    ${Attributes}                   Evaluate                    [{"attributeID": 68148,"attributeValue": "440719"},{"attributeID": 69150,"attributeValue": "445097"},{"attributeID": 69601,"attributeValue": "450674"},{"attributeID": 68101,"attributeValue": "2009"},{"attributeID": 68102,"attributeValue": "130000"},{"attributeID": 69130,"attributeValue": "445243"},{"attributeID": 69140,"attributeValue": "445313"},{"attributeID": 69160,"attributeValue": "445317"},{"attributeID": 1,"attributeValue": "210000000"}]
    ${Body}                         Create Dictionary           title=کیا همراه مکانیک              description=همراه مکانیک مرا به کشتن داده است مرگ بر همراه مکانیک
    ...                             categoryID=43958            locationID=5364                     locationType=2
    ...                             telephone=${PHONE_NUMBER}   userType=0                          attributes=${Attributes}
    Post In Retry                   /listings                   ${Body}                             headers=${Listing_Headers}
    ${Response}                     Get Object                  response body
    Pass Execution If               'error' in ${Response}      Encounterd listing limit
    ${Post_Listing_Message}         Get String                  response body message
    Set Test Variable               ${Response}                 ${Response}
    Pass Execution If               "تعداد مجاز رایگان" in "${Post_Listing_Message}"                Encountered listing limit

Hamrah Mechanic Mapped Outside Tehran Post Listing
    ${Attributes}                   Evaluate                    [{"attributeID": 68148,"attributeValue": "440719"},{"attributeID": 69150,"attributeValue": "445097"},{"attributeID": 69601,"attributeValue": "450674"},{"attributeID": 68101,"attributeValue": "2009"},{"attributeID": 68102,"attributeValue": "130000"},{"attributeID": 69130,"attributeValue": "445243"},{"attributeID": 69140,"attributeValue": "445313"},{"attributeID": 69160,"attributeValue": "445317"},{"attributeID": 1,"attributeValue": "210000000"}]
    ${Body}                         Create Dictionary           title=کیا همراه مکانیک              description=همراه مکانیک مرا به کشتن داده است مرگ بر همراه مکانیک
    ...                             categoryID=43958            locationID=295                      locationType=1
    ...                             telephone=${PHONE_NUMBER}   userType=0                          attributes=${Attributes}
    Post In Retry                   /listings                   ${Body}                             headers=${Listing_Headers}
    ${Response}                     Get Object                  response body
    Pass Execution If               'error' in ${Response}      Encountered listing limit
    ${Post_Listing_Message}         Get String                  response body message
    Set Test Variable               ${Response}                 ${Response}
    Pass Execution If               "تعداد مجاز رایگان" in "${Post_Listing_Message}"                Encountered listing limit

Hamrah Mechanic Should Be Visible
    ${Config}                       Get Environment Config Tehran For Hamrah Mechanic
    Set Test Variable               ${Config}                   ${Config}
    Run Keyword If                  ${Config.should_see_hamrah_mechanic}        Hamrah Mechanic Should Be In Response

Hamrah Mechanic Should Not Be Visible
    ${Config}                       Get Environment Config Outside Tehran For Hamrah Mechanic
    Set Test Variable               ${Config}                   ${Config}
    Run Keyword If                  ${Config.should_see_hamrah_mechanic}        Hamrah Mechanic Should Not Be In Response

Hamrah Mechanic Should Be In Response
    Dictionary Should Contain Key  ${Response}                                  paidFeatures
    ${Status}                       Set Variable                                ${False}
    FOR     ${I}        IN          @{Response['paidFeatures']['items']}
        ${Status}                   Set Variable If                             '${I['analyticsKey']}' == 'hamrahMechanic'          ${True}
    END
    Run Keyword If   not ${Status}  Fail                                        Hamrah Mechanic not found in response

Hamrah Mechanic Should Not Be In Response
    Dictionary Should Contain Key  ${Response}                                  paidFeatures
    ${Status}                       Set Variable                                ${False}
    FOR     ${I}        IN          @{Response['paidFeatures']['items']}
        ${Status}                   Set Variable If                             '${I['analyticsKey']}' == 'hamrahMechanic'          ${True}
    END
    Run Keyword If       ${Status}  Fail                                        Hamrah Mechanic should not be in response

# ---------------------------------------------- Hamshahri ---------------------------------------------------
Post A Job Listing Tehran
    Set Random Phone Number
    Login To Service
    ${Tehran_City}                  Get Location Object     location=تهران              city=تهران          id=${True}
    Post a Job Listing              validate=True           location=${Tehran_City}     location_type=city
    Integer                         response status         minimum=200                 maximum=202
    ${Response}                     Get Object              response body
    Set Test Variable               ${Response}             ${Response}
    ${Post_Listing_Message}         Set Variable            ${Response['message']}
    Pass Execution If               "تعداد مجاز رایگان" in "${Post_Listing_Message}"    Encountered listing limit

Post A Job Listing Outside Tehran
    Set Random Phone Number
    Login To Service
    ${Tehran_City}                  Get Location Object     location=تهران              city=پرند          id=${True}
    Post a Job Listing              validate=True           location=${Tehran_City}     location_type=city
    Integer                         response status         minimum=200                 maximum=202
    ${Response}                     Get Object              response body
    Pass Execution If               'error' in ${Response}  Encountered listing limit
    Set Test Variable               ${Response}             ${Response}
    ${Post_Listing_Message}         Set Variable            ${Response['message']}
    Pass Execution If               "تعداد مجاز رایگان" in "${Post_Listing_Message}"    Encountered listing limit

Get Environment Config Tehran For Hamrah Mechanic
    ${Toggles}                     Get Config                   android
    ${Config}                      Get Paid Feature Attributes  category=car    city=tehran         store=google    toggles=${Toggles}
    Pass Execution If              not ${Config.should_see_paid_features} and not ${Response['paidFeatures']}        No reason to conitnue
    [Return]                       ${Config}

Get Environment Config Outside Tehran For Hamrah Mechanic
    ${Toggles}                     Get Config                   android
    ${Config}                      Get Paid Feature Attributes  category=car    city=outside        store=google    toggles=${Toggles}
    Pass Execution If              not ${Config.should_see_paid_features} and not ${Response['paidFeatures']}        No reason to conitnue
    [Return]                       ${Config}

Get Environment Config Tehran For Hamshahri
    ${Toggles}                     Get Config                   android
    ${Config}                      Get Paid Feature Attributes  category=jobs    city=tehran         store=google    toggles=${Toggles}
    Pass Execution If              not ${Config.should_see_paid_features} and not ${Response['paidFeatures']}        No reason to conitnue
    [Return]                       ${Config}

Get Environment Config Outside Tehran For Hamshahri
    ${Toggles}                     Get Config                   android
    ${Config}                      Get Paid Feature Attributes  category=jobs    city=outside       store=google    toggles=${Toggles}
    Pass Execution If              not ${Config.should_see_paid_features} and not ${Response['paidFeatures']}        No reason to conitnue
    [Return]                       ${Config}

Get Environment Config Tehran For Bumps
    ${Toggles}                     Get Config                   android
    ${Config}                      Get Paid Feature Attributes  category=jobs    city=tehran        store=google    toggles=${Toggles}
    [Return]                       ${Config}

Get Environment Config Outside Tehran For Bumps
    ${Toggles}                     Get Config                   android
    ${Config}                      Get Paid Feature Attributes  category=jobs    city=outside           store=google    toggles=${Toggles}
    [Return]                       ${Config}

Hamshahri Should Be Visible
    ${Config}                       Get Environment Config Tehran For Hamshahri
    Set Test Variable               ${Config}                   ${Config}
    Run Keyword If                  ${Config.should_see_hamshahri}        Hamshahri Should Be In Response

Hamshahri Should Not Be Visible
    ${Config}                       Get Environment Config Outside Tehran For Hamshahri
    Set Test Variable               ${Config}                   ${Config}
    Run Keyword If                  ${Config.should_see_hamshahri}        Hamshahri Should Not Be In Response

Hamshahri Should Be In Response
    Dictionary Should Contain Key  ${Response}                                  paidFeatures
    ${Status}                       Set Variable                                ${False}
    FOR     ${I}        IN          @{Response['paidFeatures']['items']}
        ${Status}                   Set Variable If                             '${I['analyticsKey']}' == 'hamshahri'          ${True}
    END
    Run Keyword If   not ${Status}  Fail                                        Hamshahri not found in response

Hamshahri Should Not Be In Response
    Pass Execution If              not ${Config.should_see_paid_features} and not {Response['paidFeatures']}        No reason to conitnue
    Dictionary Should Contain Key  ${Response}                                  paidFeatures
    ${Status}                       Set Variable                                ${False}
    FOR     ${I}        IN          @{Response['paidFeatures']['items']}
        ${Status}                   Set Variable If                             '${I['analyticsKey']}' == 'hamshahri'          ${True}
    END
    Run Keyword If       ${Status}  Fail                                        Hamshahri should not be in response

# ---------------------------------------------- Paid Feature bump ---------------------------------------------------
Post A Bump Listing Tehran
    Set Random Phone Number
    Login To Service
    ${Tehran_City}                  Get Location Object     location=تهران              city=تهران          id=${True}
    Post a Car Listing              validate=True           location=${Tehran_City}     location_type=city
    Integer                         response status         minimum=200                 maximum=202
    ${Response}                     Get Object              response body
    Pass Execution If               'error' in ${Response}  Encountered listing limit
    Set Test Variable               ${Response}             ${Response}
    ${Post_Listing_Message}         Set Variable            ${Response['message']}
    Pass Execution If               "تعداد مجاز رایگان" in "${Post_Listing_Message}"    Encountered listing limit

Post A Bump Listing Outside Tehran
    ${Tehran_City}                  Get Location Object     location=تهران              city=پرند          id=${True}
    Post a House Listing            validate=True           location=${Tehran_City}     location_type=city
    Integer                         response status         minimum=200                 maximum=202
    ${Response}                     Get Object              response body
    Pass Execution If               'error' in ${Response}  Encountered Listing Limit
    Set Test Variable               ${Response}             ${Response}
    ${Post_Listing_Message}         Set Variable            ${Response['message']}
    Pass Execution If               "تعداد مجاز رایگان" in "${Post_Listing_Message}"    Encountered listing limit


Paid Feature Bump Should Be Visible
    ${Config}                       Get Environment Config Tehran For Bumps
    Run Keyword If                  ${Config.should_see_bump}           Validate Bump In Paid Feature

Validate Bump In Paid Feature
    Dictionary Should Contain Key   ${Response}                                 paidFeatures
    ${refresh}                      Set Variable                                ${False}
    ${top3}                         Set Variable                                ${False}
    ${top3x2}                       Set Variable                                ${False}
    FOR     ${I}        IN          @{Response['paidFeatures']['items']['bumps']}
        ${refresh}                  Set Variable If                             '${I['analyticsKey']}' == 'refresh'          ${True}
        ${top3}                     Set Variable If                             '${I['analyticsKey']}' == 'refresh_top3'     ${True}
        ${top3x2}                   Set Variable If                             '${I['analyticsKey']}' == 'refresh_top3_2x'  ${True}
    END
    Run Keyword If   not ${refresh}     Fail                                    Bump not found in response
    Run Keyword If   not ${top3}        Fail                                    Bump not found in response
    Run Keyword If   not ${top3x2}      Fail                                    Bump not found in response
