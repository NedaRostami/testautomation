# Variables naming :
# B =  Breadcrumbs
# F = Filter
# H = header
# L = Listing
# Moto = Motorcycle
# Re = RealEstate
# Of = Office
# P = Pagination
# Sp = Secure purchase
# Se = Search
# T = Tags
# Vi = Villa

##################### Attributes  ########################
Serp_F_Attribute_By_Data_Popup = "css:[data-popup='filter-{}']"
Serp_F_Attribute_By_Filter_Param = "css:[data-filter-param='{}']"
Serp_F_Attribute_By_Name = "name:{}"

# ###################  Breadcrumbs  #################
Serp_B_Nav = "id:breadcrumbs"
Serp_B_li = "xpath://*[@id='breadcrumbs']/ul/li[{}]/*[contains(text(),'{}')]"

# ###################  Tags text By position #################
Serp_Tag = "xpath://*[@id='tags']/span[{}][contains(text(),'{}')]"
Serp_Tag_Close = "xpath://*[@id='tags']/span[{}]/span"

# ###################  headers  #################
Serp_H_Title = "id:serp-title"

# ###################  Listing  #################
Serp_All_L_Article = "css:article.list[id^='listing-']"
Serp_ALL_L_Date = "css:[id^='listing-']>div.content>p>time"
Serp_All_L_Favorite = "css:span.icon-star-empty"
Serp_ALL_L_Price = "css:[id^='listing-']>div.content>div.to-bottom>p.price>strong"
Serp_All_L_Title = "css:article>div.content>h2"
Serp_L_Article = "id:listing-{}"
Serp_L_Call_Btn = "css:[data-reveal-number='{}']"
Serp_L_Img_Container = Serp_L_Article + " >> class:image"
Serp_L_Camera_Icon = Serp_L_Img_Container + " >> css:[class$='icon-camera']"
Serp_L_Certified = "css:[class^='icon-certified']"
Serp_L_Date = Serp_L_Article + " >> css:time"
Serp_L_Favorite_Cheked = "css:span.icon-star-empty[class$='saved']"
Serp_L_Favorite_Icon = "css[data-save-item='{}']"
Serp_L_Img = Serp_L_Img_Container + " >> css:img"
Serp_L_Location = Serp_L_Article + " >> xpath://*[@class='content']/p[2]"
Serp_L_Price = Serp_L_Article + " >> class:item-price"
Serp_L_SP_Icon = Serp_L_Article + " >> css:[class^='icon-secure-purchase']"
Serp_L_Title = Serp_L_Article + " >> css:h2"

# ###################  Pagination  #################
Serp_P_Nav = "id:pagination"
Serp_P_Next = "css:[class$='next']"
Serp_P_Prev = "css:[class$='prev']"

# ###################  Secure purchase  #################
Serp_Sp_Section = "id:serp-secure-purchase-section"
Serp_Sp_Section_All_L = Serp_Sp_Section + " >> css:article"
Serp_Sp_Section_Icon = Serp_Sp_Section + " >> css:[class*='icon-secure-purchase large-icon']"
Serp_Ad_SP_Icon = "xpath://*[@id='listing-{}']//*[contains(@class,'icon-secure-purchase')]"
Serp_Ad_SP_Price = "xpath://*[@id='listing-{}']//*[contains(@class,'item-price')]"

# ###################  Filter & Search - Common #################
Serp_Filter = "id:advanced-search"
Serp_F_Brand_Menu = "css:[data-popup='popup-brands']"
Serp_F_Section_Subs = "id:categories"
Serp_F_Brand_Popup = "popup-brands"
Serp_F_Brand_By_ID = "css:span.t-br-{}"
Serp_F_Model_By_ID = "css:span.t-md-{}"
Serp_F_Main_Category = "xpath://strong[text()='{}']"
Serp_F_Category_Menu = Serp_Filter + " >> css:[class^='form-select'][class*='category']"
Serp_F_Category_Popup = "categories-expandable"
Serp_F_Category_Subs = "//*[@id='categories']//span[contains(text(),'{}')]"
Serp_F_City_Popup = "class:mode-city"
Serp_F_District_Menu = "css:[data-popup='popup-districts']"
Serp_F_District_Popup = "popup-districts"
Serp_F_District_Submit = Serp_F_District_Popup + " >> css:[type='submit']"
Serp_F_New_Used_Status = "css:[name^='a9015']"
Serp_F_Input = Serp_F_Attribute_By_Name.format("q")
Serp_F_Location_Menu = "css:[data-popup='popup-locations']"
Serp_F_Location_Popup = "popup-locations"
Serp_F_Location_Province = "class:t-province-{}"
Serp_F_Location_City = "class:t-city-{}"
Serp_F_Location_District = "css:[data-district-id='{}']"
Serp_F_Location_List = Serp_F_Section_Subs
Serp_F_Max_Price = "id:mxp"
Serp_F_Min_Price = "id:mnp"
Serp_F_No_Result = "id:no-results"
Serp_F_Province_Popup = "class:mode-province"
Serp_F_Remove_Global_Listing = Serp_Filter + " >> xpath://span[contains(text(),'حذف آگهی‌های سراسری')]"
Serp_F_Save_Search_Btn = "css:#save-search>span"
Serp_F_Save_Search_Popup = "css:#popup-save-search.open"
Serp_F_Save_Search_Popup_message = "برای ذخیره‌ی جستجوی خود باید وارد سایت شوید"
Serp_F_SP_Checkbox = Serp_Filter + " >> xpath://span[text()='فقط خرید امن']"
Serp_F_Subcat_Link = Serp_F_Category_Popup + " >> xpath://a[text()='{}']"
Serp_F_Vehicle_Accessories_Type = Serp_F_Attribute_By_Name.format("a75030")
Serp_Save_Search_Btn_Popup = "ذخیره جستجو"
Serp_Save_Search_Duplicate_Popup = "css:.show-save-search[style='display: block;']"

# ###################  Filter & Search - Car #################
Serp_F_Car_Bachelor = Serp_Filter + " >> xpath://span[text()='کارشناسی شده']"
Serp_F_Car_Body_Condition = Serp_F_Attribute_By_Name.format("a69160")
Serp_F_Car_Chassis = Serp_F_Attribute_By_Name.format("a68099")
Serp_F_Car_Color = Serp_F_Attribute_By_Data_Popup.format("a69130")
Serp_F_Car_Color_Popup = "filter-a69130"
Serp_F_Car_Fuel_Type = Serp_F_Attribute_By_Name.format("a69602")
Serp_F_Car_Gearbox = Serp_F_Attribute_By_Name.format("a69140")
Serp_F_Car_Max_Km = Serp_F_Attribute_By_Data_Popup.format("mx68102")
Serp_F_Car_Max_Km_Popup = "filter-mx68102"
Serp_F_Car_Max_Year = Serp_F_Attribute_By_Data_Popup.format("mx68101")
Serp_F_Car_Max_Year_Popup = "filter-mx68101"
Serp_F_Car_Min_Km = Serp_F_Attribute_By_Data_Popup.format("mn68102")
Serp_F_Car_Min_Km_Popup = "filter-mn68102"
Serp_F_Car_Min_Year = Serp_F_Attribute_By_Data_Popup.format("mn68101")
Serp_F_Car_Min_Year_Popup = "filter-mn68101"
Serp_F_Car_Model_Popup = "class:mode-model"
Serp_F_Car_Payment_Type = Serp_F_Attribute_By_Name.format("a69150")
Serp_F_Car_Used_Status = Serp_F_Attribute_By_Name.format("a68102")

# ###################  Filter & Search - Motorcycle #################
Serp_F_Moto_Color = Serp_F_Attribute_By_Data_Popup.format("a93000")
Serp_F_Moto_Color_Popup = "filter-a93000"
Serp_F_Moto_Engine = Serp_F_Attribute_By_Name.format("a68105")
Serp_F_Moto_Gearbox = Serp_F_Attribute_By_Name.format("a92350")
Serp_F_Moto_Payment_Type = Serp_F_Attribute_By_Name.format("a92360")
Serp_F_Moto_Max_Km = Serp_F_Attribute_By_Data_Popup.format("mx68141")
Serp_F_Moto_Max_Km_Popup = "filter-mx68141"
Serp_F_Moto_Max_Year = Serp_F_Attribute_By_Data_Popup.format("mx68140")
Serp_F_Moto_Max_Year_Popup = "filter-mx68140"
Serp_F_Moto_Min_Km = Serp_F_Attribute_By_Data_Popup.format("mn68141")
Serp_F_Moto_Min_Km_Popup = "filter-mn68141"
Serp_F_Moto_Min_Year = Serp_F_Attribute_By_Data_Popup.format("mn68140")
Serp_F_Moto_Min_Year_Popup = "filter-mn68140"
Serp_F_Moto_Style = Serp_F_Attribute_By_Name.format("a91888")

# ###################  Filter & Search - RealEstate #################
Serp_F_Re_Building_Type = "css:[name^='a6809']"
Serp_F_Re_Convert_Mortgage_To_Rent = Serp_Filter + " >> xpath://span[text()='قابلیت تبدیل مبلغ رهن و اجاره']"
Serp_F_Re_Max_Area = "id:mx68085"
Serp_F_Re_Min_Area = "id:mn68085"
Serp_F_Re_Show_Agency_Listings = Serp_Filter + " >> xpath://span[text()='فقط آگهی‌های آژانس‌های املاک']"
Serp_F_Re_Building_Age = "css:[name^='a6918']"
Serp_F_Re_Min_Mortgage = "id:mn68090"
Serp_F_Re_Max_Mortgage = "id:mx68090"
Serp_F_Re_Min_Rent = "id:mn68092"
Serp_F_Re_Max_Rent = "id:mx68092"
Serp_F_Re_Num_Of_Rooms = Serp_F_Attribute_By_Name.format("a68133")
Serp_F_Re_Type = Serp_F_Attribute_By_Name.format("a68096")
Serp_F_Re_Vi_Capacity = "id:a70019"
Serp_F_Re_Vi_Max_Daily_Rent = "id:mx70020"
Serp_F_Re_Vi_Min_Daily_Rent = "id:mn70020"

# ###################  Filter & Search - Office #################
Serp_F_Of_Max_Mortgage = "id:mx68091"
Serp_F_Of_Max_Rent = "id:mx68093"
Serp_F_Of_Min_Mortgage = "id:mn68091"
Serp_F_Of_Min_Rent = "id:mn68093"

# ###################  Filter & Search - Employment #################
Serp_F_Contract_Type = Serp_F_Attribute_By_Name.format("a68222")
Serp_F_Education_Level = Serp_F_Attribute_By_Name.format("a68221")
Serp_F_Gender = Serp_F_Attribute_By_Name.format("a69197")
Serp_F_Hiring_Checkbox = Serp_Filter + " >> xpath://span[text()='استخدام می‌کنم']"
Serp_F_Insurance_Checkbox = Serp_Filter + " >> xpath://span[text()='بیمه دارد']"
Serp_F_Looking_For_Job_Checkbox = Serp_Filter + " >> xpath://span[text()='دنبال کار می‌گردم']"
Serp_F_Salary = Serp_F_Attribute_By_Name.format("a69300")
# ###################  Sort  ######################
Serp_Sort_L = "xpath://*[@id='serp-intro']//select"

Serp_L_Photo_Galery = "gallery"

# ###################  Vitrin Section  ######################
Serp_All_Vitrin_Link = "css:.serp-top3-container .show-all-link"
Serp_All_Vitrin_Page = "css:#serp-section.show-all"
Serp_Vitrin_Section = "css:#serp-section"
Serp_Vitrin_L_Article = Serp_Vitrin_Section + ">#listing-{}"
Serp_Vitrin_L_Title = Serp_Vitrin_L_Article + " h2"
Serp_Vitrin_All_L = Serp_Vitrin_Section + ">article"

# ###################  Messages  ######################
Msg_Of_Successfully_Save_Search = "جستجوی شما ذخیره شد. روزانه آگهی‌های جدید مطابق با این جستجو به شما پیام رسانی می‌شود."
