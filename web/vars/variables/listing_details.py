# PU = popup
LD_Seller_Details = "id:item-seller-details"
LD_Seller_Nickname = LD_Seller_Details + " >> css:strong"
LD_Shop_Logo = "class:shop-logo"
LD_Chat_Btn_Not_Loggedin = LD_Seller_Details + " >> css:a[class*='icon-chat']"
LD_Chat_Btn_Loggedin = LD_Seller_Details + " >> css:span[class*='icon-chat']"
LD_Call_Btn = LD_Seller_Details + ">> xpath://*[contains(@class,'button') and contains(text(),'تماس با')]"
Ld_Send_Messages_Input = "name:message"
LD_Send_Messages_Btn = "css:[type='submit'][class='icon-paper-airplane']"
LD_Chat_Nickname = "css:[data-bind*='nickname']"
LD_Received_Messages = "css:[class='message receive']"
LD_Messages_Sent = "css:[class='message send']"
LD_Price_Offer_Btn = "xpath://*[@id='item-seller-details']//a[contains(@class,'secure-purchase-price-suggestion')]"
LD_Securepurchase_Btn = "xpath://*[@id='item-seller-details']//*[contains(@class,'icon-secure-purchase')]"
LD_Breadcrumbs = "id:breadcrumbs"
LD_Img_Container = "xpath://*[@id='item-images']"
LD_Total_Img = LD_Img_Container + "//*[@class='swiper-pagination-total']"
LD_Listing_Details = "id:item-details"
LD_Price = "xpath://*[@id='item-details']//*[contains(@class,'item-price')]"
LD_Location = "xpath://*[@id='item-details']//span[contains(@class,'small-text')]"
LD_Goods_Status = "xpath://*[@id='item-details']//*[contains(@class,'key-val')]"
LD_Description = "id:description"
LD_Delivery_Pricing = "id:delivery-pricing"
LD_Chat_Xpath = "id:chat-listing-details"
LD_Propose_Price_Popup_Open = "xpath://*[@id='popup-price-suggestion' and contains(@class,'open')]"
LD_Chat_Window_Xpath = "//*[@class='chat-user']"
LD_SP_Chat_Xpath = "xpath://*[@class='chat-wall fixed secure-purchase']"
LD_Biling_Page_Xpath= "id: billing"
LD_Leads_View = "id:leads-view"
LD_Graph_Bar = "css:div.bar"
LD_Item_Detail_Header = "xpath://section[@id='item-details']//h1"
LD_Item_Seller = "xpath://*[@id='item-seller-details']/span[{}]"
LD_Underlined = "css:.underlined"
LD_Item_Seller_Details = "xpath://*[@id='item-details']/p[2]/strong"
LD_Share_Listing = "[data-popup='popup-listing-share-by-email']"
LD_Share_Listing_PU_Close = "xpath://*[@id='popup-listing-share-by-email']/div/div[1]/span"
LD_Listing_Report_PU = "[data-popup='popup-report-listing']"
LD_Complain_Type_PU = "class:icon-indicator"
LD_Report_Email_PU = "id:email"
LD_Report_Mobile_PU = "id:mobile"
LD_Report_PU_Close = "//*[@id='popup-report-listing']//span[contains(@class,'icon-close')]"
LD_Post_Listing_Report = "xpath://*[@id='item-actions']//li[2]/span"
LD_Choose_Favorite = "xpath://*[@id='item-actions']//span"
LD_Rate = "css:[data-popup='popup-rating']"
LD_Rate_Popup = "popup-rating"
LD_Main_Rate_Stars = f'id:{LD_Rate_Popup} >> class:icon-star'
LD_Detailed_Rates_Stars = f'id:{LD_Rate_Popup} >> css:.icon-star.qu-star'
LD_Rate_Comment_Input = f'id:{LD_Rate_Popup} >> css:textarea'
LD_Rate_Submit_Btn = "css:button[data-bind*='ratingSubmit']"
LD_Seller_Call_Button = "xpath://*[@id='item-seller-details']//span[contains(@class, 'button')][1]"



LD_Propose_Price_Text = "قیمت پیشنهادی خود را وارد کنید"
LD_Chat_Text = "چت با"
LD_SP_Text = "خرید امن"
LD_General_Review = "بازدید کل"
LD_Display_On_Page = "نمایش در صفحه"
LD_Review_Growth = "افزایش بازدید"
LD_Next_Listing = "بعدی"
LD_Lising_Report = "گزارش آگهی"
LD_Contact_Show_More = "نمایش بیشتر"
LD_Show_Complete = "(نمایش کامل)"
LD_Share_Listing_PU = "به اشتراک گذاری آگهی"
LD_Reason_To_Report_PU = "لطفا دلیل گزارش این آگهی را انتخاب کنید"
LD_Input_Txt_Report_PU = "آگهی نامرتبط و مشکوک است."
LD_Goods_Status_Txt_1 = "وضعیت کالا"
LD_Goods_Status_Txt_2 = "در حد نو"
LD_Delivery_Pricing_Txt = "سراسر ایران"
