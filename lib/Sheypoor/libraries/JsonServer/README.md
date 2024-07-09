# Json Server Lib


To include this library:
```
*** Settings ***
Library             JsonServer          staging             6.2.0
```

## Categories
usage:

```
${Vehicles}         Get Category Object         category=وسایل نقلیه
Log                 ${Vehicles}
```

would result in:
```
{
    categoryID: "43606"
    categoryTitle: "وسایل نقلیه"
    ...
}
```

if id parameter is set:
```
${Vehicles_Id}         Get Category Object         category=وسایل نقلیه     id=${True}
Log                    ${Vehicles_Id}
```

would result in:
```
43606
```

you can get objects as deep as attributeOptions:

```
${Pride_111}            Get Category Object         category=وسایل نقلیه     sub_category=خودرو         brand=پراید      attribute=مدل خودرو    option=۱۱۱
Log                     ${Pride_111}
```

## Locations

usage:

```
${Pounak}           Get Location Object         location=تهران         city=تهران           district=پونک
Log                 ${Pounak}
```

would result in:
```
{
    provinceID: 8
    name=تهران
    ...
}
```

if id parameter is set:

```
${Tehran_Id}            Get Location Object         location=تهران         id=${True}
Log                     ${Tehran_Id}
```

would result in:
```
8
```


## Listings

Return a listing from Sheypoor's production environment

usage:
```
${Random_Listing}               Random Live Listing                 category=46303        location=8    location_type=province
```
when providing location you should always provide location_type with one of province, city or district based on your location

would return a listing object:

```
{'attributes': {'68099': '434989', '68101': '2011', '68102': '175000', '68148': '440728', '69130': '445243', '69140': '445313', '69150': '445097', '69160': '445317'},
 'categoryID': 43958,
 'description': 'کیا موهاوی 8 سیلندر 2011 سفید/7 نفر/بدون هیچگونه رنگ و خط و خش/داخل چرم کرم/موتور و گیربکس پلمپ/بیمه 12 ماه / بیمه بدنه/تخفیف بیمه 8 سال/فول کامل شرکتی/تنظیم ارتفاع/دودیفرانسیل/درب صندوق عقب برقی/ شیشه ها دودی رفلکس/10ایربک/کولر دوال دیجیتال سه ردیفه/صندلی برقی/مموری صندلی/آینه ها تاشو برقی/ فروان و پدال برقی/شیب سنج/سیستم ESP/دوربین عقب روی آینه فابریک /شیشه شور جلو/کیلس '
                'استارت/ریموت روی فرمان /لاستیک ها نو/کروز کنترل /4 گرمکن صندلی/2 سرد کن /سانروف 3 حالته /تمامی سرویسهای خودرو به تازگی انجام گردیده /لطفا مصرف کننده تماس بگیرد.پیامک نزنید.\n'
                '\n',
 'email': 'www.hasanhabibifar77.ir@gmail.com',
 'hiddenPhoneNumber': '0910103XXXX',
 'isChatEnabled': False,
 'lastModifiedDate': '2019-06-02 11:17:25.0000',
 'listingID': '176959192',
 'locationID': 887,
 'locationName': 'تهران، نارمک',
 'locationType': 2,
 'price': 'توافقی',
 'title': 'کیا موهاوی 8 سیلندر 2011 '}
```
