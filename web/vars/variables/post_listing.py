# Variables naming :
# Desc =  Description
# Att = Attribute
# Img = Image
# Loc = Location
# Txt = Text


PL_Desc_Field = "id:item-form-description"
PL_Cats_Menu = "css:[data-popup='popup-categories']"
PL_Cats_Popup = "popup-categories"
PL_Cat_Subcat_Selector = "span.t-cat-"
PL_Second_Cat = "class:mode-subCategory"
PL_Status_Field = "css:a[data-popup*='item-form-a9015']"
PL_Status_Field_Open = "xpath://div[contains(@id,'item-form-a9015') and contains(@class, 'open')]"
PL_Att_Field_CSS = "class:icon-attr-{}"
PL_Item_Form = "[data-popup='item-form-{}']"
PL_Att_Field_Class = "class=icon-attr-{}"
PL_Product_Year_Field = "id:a68101"
PL_Kilometer_Field = "id:a68102"
PL_Area_Field = "id:a68085"
PL_Mortgage_Field = "id:a68090"
PL_Rent_Field = "id:a68092"
PL_Form_Title = "id:item-form-title"
PL_Form_Price = "id:item-form-price"
PL_Loc_Menu = "css:[data-popup='popup-locations']"
PL_Loc_Popup = "popup-locations"
PL_Form_Telephone = "id:item-form-telephone"
PL_Hide_Phone_Number = "xpath://span[text()='مخفی کردن شماره تماس در آگهی']"
PL_Suggested_Price = "//span[@class='suggested-price text-small']/span"
PL_Clear_Form = "css:[data-popup='popup-clear-form-confirmation']"
PL_Clear_Form_Popup = "popup-clear-form-confirmation"
PL_Reset_Form_Btn = "css:button[data-bind$='resetForm']"
PL_Img_Selector = "//img[@class='qq-thumbnail-selector']"
PL_Open_Img_Icon = "class:icon-down-open"
PL_Icon_Trash = "css:span.icon-trash"
# PL_Loc = "bee('#popup-locations li span:contains({})')"
PL_Loc_State = "css:#popup-locations .t-province-{}"
PL_City_Popup = "class:mode-city"
PL_Loc_City = "css:#popup-locations .t-city-{}"
PL_Loc_Region = "css:#popup-locations .t-district-{}"
PL_Region_Popup = "class:mode-district"
PL_Region_Field = "id:neighbourhood"
# PL_Valid_Region_Value = "class:valid"
PL_Upload_Img_Msg = "عکس ها در حال بارگذاری هستند"
PL_Upload_Img = f'xpath://*[contains(@data-bind,\"uploaderMessageForceShow\") and contains(text(),\"${PL_Upload_Img_Msg}\")]'
PL_Uploaded_Img_Index = "css:.qq-file-id-{}"

PL_EMPTY_Field_Error = "css:.validationMessage[data-bind$='{}']"
PL_EMPTY_Cat_Error = PL_EMPTY_Field_Error.format("category")
PL_EMPTY_Title_Error = PL_EMPTY_Field_Error.format("name")
PL_EMPTY_Description_Error = PL_EMPTY_Field_Error.format("description")
PL_EMPTY_Loc_Error = PL_EMPTY_Field_Error.format("geo.city")
PL_EMPTY_Phone_Error = PL_EMPTY_Field_Error.format("telephone")
PL_EMPTY_Field_Error_Msg = "لطفا این قسمت را تکمیل کنید"

PL_Education_Level = "css:" + PL_Item_Form.format("a68221")
PL_Contract_Type = "css:" + PL_Item_Form.format("a68222")
PL_Salary = "css:" + PL_Item_Form.format("a69300")
PL_Gender = "css:" + PL_Item_Form.format("a69197")


PL_Convert_Mortgage_Rent_Option = "قابلیت تبدیل مبلغ رهن و اجاره"
PL_Parking_Txt = "پارکینگ"
PL_Warehouse_Txt = "انباری"
PL_Elevator_Txt = "آسانسور"
PL_Propos_Price_Txt = "قیمت پیشنهادی"
PL_Without_Img = "ثبت آگهی بدون عکس"
PL_Post_Img = "عکس آگهی"
