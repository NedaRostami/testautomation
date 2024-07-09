*** Settings ***
Documentation                        Basket details of specific of listing
Resource                             ../versions/v${api_version}/keywords.resource
Suite Setup                          Set Suite Environment
Test Setup                           Set Test Environment
Test Teardown                        Clean Up Test

*** Variables ***
${Basket_Schema}                    ${ROOT_PATH}/api.tests/basket/versions/v${api_version}/schema/basket.json

${Category_ID}                      43612        # لوازم شخصی
${No_Sec_Pur_Type}                  ${0}
${Secure_Purchase_Type}             ${2}


*** Test Cases ***
Basket Endpoint
    [Tags]                          basket          notest        5.6.0
    Check Version
    ${Listing_Id}                   Post A Listing With Secure Purchase        ${Category_ID}          ${Secure_Purchase_Type}
    Expect Response                 ${Basket_Schema}
    Request Basket Endpoint         ${Listing_Id}
    Integer                         response status               200

Basket Endpoint Without Secure Purchase Listing
    [Tags]          basket          notest
    ${Listing_Id}                   Post A Listing With Secure Purchase        ${Category_ID}          ${No_Sec_Pur_Type}
    Expect Response                 #${Basket_Schema}      invalid schema
    Request Basket Endpoint         ${Listing_Id}
    String                          response body error errorMessage                    "آگهی مورد نظر امکان خرید امن ندارد"
    Integer                         response body error errorCode                       0


#    TODO:   Parssing values of images and icon for having absolute address

#    Output Schema	            response	${CURDIR}/response_Basket_schema.json

#{'body':
#        {
#        'banner':
#                {
#                    'description': 'مبلغی که پرداخت می\u200cکنید به امانت نزد شیپور می\u200cماند، کالا برای شما ارسال می\u200cشود و بعد از دریافت و تاییدِ شما مبلغ را منتقل می\u200cکنیم. در صورت مطابقت نداشتن کالای ارسالی با توضیحات فروشنده مبلغ پرداختی به شما بازگردانده می\u200cشود.',
#                    'icon': '',
#                    'links': [],
#                    'slogan': None,
#                    'title': 'با خیال راحت خرید کنید'
#                },
#        'deliveryPrice': 'محاسبه در مرحله بعدی',
#        'products': [{  'down': {'count': 1, 'message': 'حداقل باید یک عدد از کالا انتخاب شود.'},
#                        'id': '314939612',
#                        'image': 'https://pr8291.mielse.com/imgs/2020/08/17/314939612/225x225_af/314939612_a4fed759a55443ac8ac448ebb95a91c8.webp',
#                        'price': '570000',
#                        'priceString': '570,000 تومان',
#                        'shop':
#                              {'icon': None,
#                               'id': '28',
#                               'image': 'https://pr8291.mielse.com/img/placeholders/shop-serp.png',
#                               'title': 'سيمان بجنورد'
#                               },
#                        'title': 'سبد حمل نوزاد',
#                        'up': {'count': 1, 'message': 'در حال حاضر امکان انتخاب تعداد وجود ندارد. ما تلاش می\u200cکنیم این سرویس به زودی فعال شود.'}
#                     }],
#        'totalPrice': 570000
#        }
#}
