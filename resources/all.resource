*** Settings ***
Documentation                        Base resource file for All tests
Variables                           ../vars/vars.py

*** Variables ***
${PROJECT_ROOT_PATH}                 ${CURDIR}/..
${Has_Delivery_Time}                 ${TRUE}
${shop_seller}                       ${TRUE}

*** Keywords ***
Set Test Server Environment
    IF                      '${trumpet_prenv_id}' == 'Live'
      Set Live Server
    ELSE IF                 '${trumpet_prenv_id}' == 'staging'
      Set staging Server
    ELSE IF                 '${trumpet_prenv_id}' == 'dev'
      Set dev Server
    ELSE IF                 '${ServerType}' == 'ProTools'
      Set ProTools Server
    ELSE IF                 '${ServerType}' == 'SheypoorX'
      Set SheypoorX Server
    ELSE
      Set PR Server
    END

Set dev Server
    Set Global Variable    ${SERVER}          http://trumpet.app
    Set Global Variable    ${EXACTDOMAIN}     trumpet.app
    Set Global Variable    ${MockSERVER}      http://trumpet.app
    Set Global Variable    ${SERVER_KIND}     DEVss

Set Live Server
    Set Global Variable    ${EXACTDOMAIN}     ${Live}
    Set Global Variable    ${SERVER_KIND}     NOPR
    Set Global Variable    ${HTTP-Scheme}     https
    Set Global Variable    ${SERVER}          ${HTTP-Scheme}://${Live}
    Set Global Variable    ${MockSERVER}      ${SERVER}
    Set Global Variable    ${Pserver}         ${SERVER}

Set ProTools Server
    Set Global Variable    ${HTTP-Scheme}     https
    Set Global Variable    ${SERVER_KIND}     protools
    Set Global Variable    ${EXACTDOMAIN}     protools${trumpet_prenv_id}.${Domian}
    Set Global Variable    ${SERVER}          ${HTTP-Scheme}://${EXACTDOMAIN}
    Set Global Variable    ${MockSERVER}      ${HTTP-Scheme}://${EXACTDOMAIN}
    Set Global Variable    ${Pserver}         ${HTTP-Scheme}://${EXACTDOMAIN}

Set SheypoorX Server
    Set Global Variable    ${HTTP-Scheme}     https
    Set Global Variable    ${SERVER_KIND}     shx
    Set Global Variable    ${EXACTDOMAIN}     shx${trumpet_prenv_id}.${Domian}
    Set Global Variable    ${SERVER}          ${HTTP-Scheme}://${EXACTDOMAIN}
    Set Global Variable    ${MockSERVER}      ${HTTP-Scheme}://${EXACTDOMAIN}
    Set Global Variable    ${Pserver}         ${HTTP-Scheme}://${EXACTDOMAIN}

Set PR Server
    Set Global Variable    ${HTTP-Scheme}     https
    Set Global Variable    ${SERVER_KIND}     PR
    Set Global Variable    ${EXACTDOMAIN}     pr${trumpet_prenv_id}.${Domian}
    Set Global Variable    ${SERVER}          ${HTTP-Scheme}://${EXACTDOMAIN}
    Set Global Variable    ${MockSERVER}      ${HTTP-Scheme}://${EXACTDOMAIN}
    Set Global Variable    ${Pserver}         ${HTTP-Scheme}://${EXACTDOMAIN}

Set staging Server
    Set Global Variable    ${HTTP-Scheme}     https
    Set Global Variable    ${SERVER_KIND}     NOPR
    Set Global Variable    ${SERVER}          ${HTTP-Scheme}://${trumpet_prenv_id}.${Domian}
    Set Global Variable    ${EXACTDOMAIN}     ${trumpet_prenv_id}.${Domian}
    Set Global Variable    ${MockSERVER}      ${HTTP-Scheme}://${trumpet_prenv_id}.${Domian}
    Set Global Variable    ${Pserver}         ${HTTP-Scheme}://${trumpet_prenv_id}.${Domian}


Check Backend Errors
    [Arguments]                               ${failure}=${FALSE}
    ${Has_Error}    ${notice}                 Get Page Errors
    Run Keyword If                            ${Has_Error}
    ...  Set Test Message                     *HTML* There is Some Errors in Page:<br> ${notice}             append=yes
    Run Keyword If                            ${Has_Error} and ${failure}                                    Capture Page Screenshot           EMBED
    Run Keyword If                            ${Has_Error} and ${failure}                                    Fail    *HTML* There is Some Errors in Page:<br> ${notice}       notice_error  nosecond

Set Listing Limit For Cat per locations
    [Arguments]                               ${parentid}  ${catid}  ${regid}  ${cityid}  ${nghid}  ${limitcount}=${25}  ${limitprice}=${11000}
    Set All Limits For Category               parentid=${parentid}  catid=${catid}  regid=${regid}  cityid=${cityid}  nghid=${nghid}  limitcount=${limitcount}  limitprice=${limitprice}
    ${get_limits}                             Get Limits By Cat And Location            catid=${catid}  regid=${regid}  cityid=${cityid}  nghid=${nghid}
    log                                       ${get_limits}

Create Shop In Sheypoor
    [Arguments]                               ${Category}=43603      ${securepurchase}=${0}     ${shipping_type}=0   ${city_shipping_cost}=0   ${state_shipping_cost}=0  ${country_shipping_cost}=0   ${price_offer}=${0}
    ${securepurchase}                         Convert To Integer     ${securepurchase}
    ${price_offer}                            Convert To Integer     ${price_offer}
    ${Shop}                                   Create Shop            category_id=${Category}    securepurchase=${securepurchase}    shipping_type=${shipping_type}     city_shipping_cost=${city_shipping_cost}    state_shipping_cost=${state_shipping_cost}    country_shipping_cost=${country_shipping_cost}     price_offer=${price_offer}
    FOR   ${key}       IN                     @{Shop.keys()}
        ${detail}      Get From Dictionary    ${Shop}                            ${key}
        Run Keyword If    "${key}" == "title" or "${key}" == "description" or "${key}" == "address" or "${key}" == "tag_line"
        ...  Replace Arabic Fonts             ${detail}
        Run Keyword If    "${key}" == "consultant_list" or "${key}" == "secretary_list"
        ...  Set Consultants And Secretary Variables    ${detail}   ${key}
        Set Suite Variable                    ${Shop_${key}}                       ${detail}
    END
    log              	                        ${Shop}

Replace Arabic Fonts
    [Arguments]                               ${detail}
    ${detail}                                 Replace String         ${detail}  ي  ی
    ${detail}                                 Replace String         ${detail}  ى  ی
    ${detail}                                 Replace String         ${detail}  ك  ک
    Set Test Variable                         ${detail}
    Return From Keyword                       ${detail}

Set Consultants And Secretary Variables
    [Arguments]                               ${ListOfDic}                       ${Kind}
    ${Kind}                                   Remove String                      ${Kind}                _list
    Set List Of Dict Variables                ${ListOfDic}                       ${Kind}                 phone
    Set List Of Dict Variables                ${ListOfDic}                       ${Kind}                 name

Set List Of Dict Variables
    [Arguments]                               ${ListOfDic}                       ${Kind}                 ${key}
    ${Vals}                                   Get Values From List               ${ListOfDic}            ${key}
    @{List}                                   Create List
    FOR  ${item}  IN  @{Vals}
      ${item}                                   Replace String                   ${item}                 ي  ی
      ${item}                                   Replace String                   ${item}                 ى  ی
      ${item}                                   Replace String                   ${item}                 ك  ک
      Append To List                            ${List}                          ${item}
    END
    Set Suite Variable                        ${${Kind}_${key}s}                 ${List}

Get Members Phone Numbers
#    Create Shop In Sheypoor
    ${Consultant_Phones}                      Get Values From List                               ${Shop_Consultant_List}                  phone
    Set Test Variable                         ${Consultant_Phones}
    ${Secretary_Phones}                       Get Values From List                               ${Shop_Secretary_List}                   phone
    Set Test Variable                         ${Secretary_Phones}

Post Listing In Background Via Python
    [Arguments]                         ${Cat}         ${SubCat}       ${Price}       ${State}
    ...    ${City}     ${Region}       ${Seller_Num}   ${Num_Photo}    ${NewUsed}     ${chip_discount}   ${Kind}

    ${listing_info}                 Wait Until Keyword Succeeds     5x   5s                    Post Listing In Background
    ...  listing_cat=${Cat}         listing_sub_cat=${SubCat}
    ...  price=${Price}             state=${State}                  city=${City}               region=${Region}
    ...  seller_phone_number=${Seller_Num}                          listing_img_count=${Num_Photo}
    ...  new_used=${NewUsed}        chip_discount=${chip_discount}  kind=${Kind}

    ${listingId}                    Get From Dictionary             ${listing_info}             listingId
    Set Test Variable               ${listingId}                    ${listingId}
    ${Listings_title}               Get From Dictionary             ${listing_info}             Listings_title
    Set Test Variable               ${Listings_title}               ${Listings_title}
    ${Listings_description}         Get From Dictionary             ${listing_info}             Listings_description
    Set Test Variable               ${Listings_description}         ${Listings_description}
    Get Real Title
    Get Real Description

Get Real Title
    ${Words}                Set Variable            ${Listings_title}
    ${Words}                Strip String            ${Words}
    ${Words}                Convert Digits          ${Words}            Fa2EN
    Set Test Variable       ${Title_Words}          ${Words}

Get Real Description
    ${Words}                Set Variable            ${Listings_description}
    ${Words}                Strip String            ${Words}
    ${Words}                Convert Digits          ${Words}            Fa2EN
    Set Test Variable       ${Title_Description}    ${Words}


Set Toggles For Shop SecurePurchase Testing
    [Arguments]                   ${platform_name}       ${status}
    Mock Toggle Set               ${platform_name}       secure-purchase                               ${status}
    Mock Toggle Set               ${platform_name}       shop-secure-purchase-in-post-listing          ${status}
    Mock Toggle Set               ${platform_name}       secure-purchase-delivery                      ${status}

Set Toggles For User SecurePurchase Testing
    [Arguments]                   ${platform_name}       ${status}
    Mock Toggle Set               ${platform_name}       secure-purchase                               ${status}
    Mock Toggle Set               ${platform_name}       user-secure-purchase-in-post-listing          ${status}
    Mock Toggle Set               ${platform_name}       secure-purchase-delivery                      ${status}

Set Posting Cost Based On Origin And Destination Via Admin By Backend
    ${change_new_posting_cost}  ${change_price_value}    Set Posting Cost Based On Origin And Destination Via Admin     ${Origin}                    ${Origin_id}
                                                         ...                                                            ${Destination}               ${Destination_id}
                                                         ...                                                            ${destination_change}        ${Post_Provider}
                                                         ...                                                            ${shop_seller}               ${Provider_Posting_Cost}     ${Has_Delivery_Time}
    IF        ${change_new_posting_cost}
              Set Test Variable                          ${Destination}             ${destination_change}
              Set Test Variable                          ${Destination_Name}        ${destination_name_change}
              IF                                         ${sp_required}
                Set Test Variable                        ${Customer_CityId}         ${customer_cityid_change}
                Set Test Variable                        ${Customer_City}           ${destination_name_change}
                Set Test Variable                        ${Customer_District}       ${customer_district_change}
                Set Test Variable                        ${Customer_Address}        ${customer_address_change}
              END
    ELSE IF   ${change_price_value} != -1
              Set Test Variable                          ${Provider_Posting_Cost}   ${change_price_value}
    END
