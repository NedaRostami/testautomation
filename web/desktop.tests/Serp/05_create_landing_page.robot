*** Settings ***
Documentation                   In this scenario, existing "بنز" , "آپارتمان" landings are deactivated first,
...                             then create a landing for vehicles and a landing for realEstate.
...                             After validation, the landings which have been made at the end of the suite are removed.
...                             this test is not using selenium webdriver.
Suite Setup                     Setup Init
Suite Teardown                  Delete All Created Landings
Resource                        ../../resources/serp.resource

*** Variables ***
@{car_landing_attrs}            بنزکلاسیک         خرید بنزکلاسیک         توضیحات بنز         1          عنوان جایگزین بنزکلاسیک
    ...                         43627              43636          8         301                  5316                   27
    ...                         972                4586           1         ${EMPTY}             302
    ...                         محتوای خودرو بنز             یادداشت خودرو بنز           پرسش و پاسخ خودرو بنز
@{realEstate_landing_attrs}     آپارتمان نوساز    پیش خرید آپارتمان    توضیحات آپارتمان         1          عنوان جایگزین آپارتمان
    ...                         43606              44115          13        476                  4194
    ...                         17                 647            4080      ${EMPTY}             ${EMPTY}               301
    ...                         محتوای آپارتمان نوساز       یادداشت آپارتمان نوساز      پرسش و پاسخ آپارتمان نوساز
@{landing_ids_list}

*** Test Cases ***
Create Car Landing And Validate It
    [Tags]                      serp       landing      lxml
    Set Variables For Car Landing Test
    Create Car Landing Page
    Add Created Landing Id To List of IDs
    Create A Dictionary From Landing Attributes
    Get Values ​​Of Created Landing Elements From Serp
    Validate Landing Elements On Serp
    Validate Serp Redirection After Search By Landing

Create RealEstate Landing And Validate It
    [Tags]                      serp       landing      lxml
    Set Variables For RealEstate Landing Test
    Create RealEstate Landing Page
    Add Created Landing Id To List of IDs
    Create A Dictionary From Landing Attributes
    Get Values ​​Of Created Landing Elements From Serp
    Validate Landing Elements On Serp
    Validate Serp Redirection After Search By Landing

*** Keywords ***
Setup Init
    Deactivate Existing "بنز" , "آپارتمان" landings
    Generate Random Attribute Name For Create Landing
    Generate Query String Parameters

Deactivate Existing "بنز" , "آپارتمان" landings
    Delete Landings By Searching By Path                          بنز
    Delete Landings By Searching By Path                          آپارتمان

Generate Random Attribute Name For Create Landing
    Generate Unique Random Numbers For Create Landing
    Insert Unique Attribute To Lists

Generate Unique Random Numbers For Create Landing
    FOR  ${i}  IN RANGE  5
        ${random_landing}       Generate Random String            4       [NUMBERS]
        ${search_landing}       Search Landing                    ${random_landing}
        ${unique}               Run Keyword And Return Status     Length Should Be
        ...                     ${search_landing}                 ${0}
        Exit For Loop If        ${unique}
    END
    Run Keyword Unless          ${unique}                         Fail          Cannot generate a unique name.
    Set Suite Variable          ${random_landing}

Insert Unique Attribute To Lists
    Insert Into List            ${car_landing_attrs}              ${0}          بنز_${random_landing}
    Insert Into List            ${car_landing_attrs}              ${6}          لینک بنز ${random_landing}
    Insert Into List            ${car_landing_attrs}              ${17}         جستجوی خرید بنزکلاسیک ${random_landing}
    Insert Into List            ${realEstate_landing_attrs}       ${0}          آپارتمان_${random_landing}
    Insert Into List            ${realEstate_landing_attrs}       ${6}          لینک آپارتمان ${random_landing}
    Insert Into List            ${realEstate_landing_attrs}       ${17}         جستجوی خرید آپارتمان ${random_landing}

Generate Query String Parameters
    ${Key}                      Generate Random String            4     [LOWER]
    ${Value}                    Generate Random String            4     [NUMBERS]
    Set Suite Variable          ${query_parameters}               ?${Key}=${Value}

Set Variables For Car Landing Test
    Set Test Variable           ${landing_attrs}                  ${car_landing_attrs}
    Set Test Variable           ${cat_name}                       خودرو
    Set Test Variable           ${city_name}                      تهران
    Set Test Variable           ${district_name}                  پرستار
    Set Test Variable           ${serp_origin_url}                ساری/آزادی/وسایل-نقلیه/خودرو-کلاسیک${query_parameters}

Set Variables For RealEstate Landing Test
    Set Test Variable           ${landing_attrs}                  ${realEstate_landing_attrs}
    Set Test Variable           ${cat_name}                       رهن و اجاره خانه و آپارتمان
    Set Test Variable           ${city_name}                      اهواز
    Set Test Variable           ${district_name}                  بهارستان
    Set Test Variable           ${serp_origin_url}                شیراز/سعدیه/املاک/سایر-املاک${query_parameters}

Create Car Landing Page
    Create New Landing Page

Create RealEstate Landing Page
    Create New Landing Page

Create New Landing Page
    ${landing_id}               Create Landing In Background      @{landing_attrs}
    Set Test Variable           ${landing_id}

Add Created Landing Id To List of IDs
    Append To List              ${landing_ids_list}               ${landing_id}

Create A Dictionary From Landing Attributes
    ${landing_data_expected}    Create Dictionary                 link=${landing_attrs}[6]           search_params=${landing_attrs}[1]
    ...                         title=${landing_attrs}[2]         content=${landing_attrs}[19]       city=${city_name}
    ...                         district=${district_name}         city_tag=${city_name}              search_params_tag=${landing_attrs}[1]
    ...                         cat_tag=${cat_name}               cat_link=${cat_name}               district_tag=${district_name}
    ...                         cat=${cat_name}
    Set Test Variable           ${landing_data_expected}

Get Values ​​Of Created Landing Elements From Serp
    ${landing_data_existed}     Get Landing Elements Value From Serp       ${serp_origin_url}
    Set Test Variable           ${landing_data_existed}

Validate Landing Elements On Serp
    FOR   ${key}                IN                                @{landing_data_expected.keys()}
        Should Contain          ${landing_data_existed}[${key}]   ${landing_data_expected}[${key}]
    END

Validate Serp Redirection After Search By Landing
    ${search_terms}             Set Variable                      ${landing_attrs}[17]
    ${expected_url}             Set Variable                      ${landing_attrs}[0]
    ${redirected_url}           Get Redirected Page Url           search?q=${search_terms}
    ${redirected_url}           Fetch From Right                  ${redirected_url}                  /
    Should Be Equal             ${expected_url}                   ${redirected_url}

Delete All Created Landings
    Delete Landings By Id       @{landing_ids_list}
