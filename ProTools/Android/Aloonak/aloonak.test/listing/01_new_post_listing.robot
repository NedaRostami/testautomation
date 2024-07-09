*** Settings ***
#                                            ثبت فایل زمین و باغ و آگهی کردن فایل
Documentation                                In this scenario a new file is created
...                                          and is converted to a listing.
Resource                                     ../../resources/common.resource
Test Setup                                   Run Keywords                       prepare app for test
Test Teardown                                Close Application
Test Timeout                                 10 minutes

*** Variables ***
${Profile_Complation}                        accessibility_id=edit-profile-button
${User_Name}                                 accessibility_id=name
${First_Last_Name}                           زیبا راد
${Work_Envelope}                             accessibility_id=locations
${Choose_Work_Envelope}                      accessibility_id=categoryItem_0
${Choose_Button}                             accessibility_id=save-button
${Region}                                    ارجمند
${Submit_Change}                             ثبت تغییرات
${Open_Menu}                                 accessibility_id=hamburger
${Add_File_Listing}                          ثبت آگهی و فایل
${Add_Images}                                accessibility_id=route-to-add-new-pics
${Choose_Cat_Txt}                            یک دسته‌بندی را انتخاب کنید
${Choose_Cat}                                accessibility_id=categoryItem_5
${Location}                                  accessibility_id=location
${Price}                                     accessibility_id=price
${Land_Use_Type}                             نوع کاربری
${Residential_Txt}                           مسکونی
${Residential}                               accessibility_id=undefined_item_0
${Add_Button}                                accessibility_id=undefined_add
${Area}                                      accessibility_id=a68085
${Input_Area}                                100
${Input_Price}                               100000000
${Register_Button}                           accessibility_id=register-button
${Post_File}                                 accessibility_id=post-this-file
${Description}                               accessibility_id=description
${Description_Txt}                           زمین نزدیک اتوبان و در بهترین منطقه قرار گرفته است.
${Register_Listing}                          accessibility_id=register-advertisement
${Show_Listing_btn}                          accessibility_id=advertisements-list
${Listing_Title}                             فروش زمین مسکونی ۱۰۰ متر در ارجمند

*** Test Cases ***
Add New File And Convert To Listing
  [Tags]                                     Listing                            File
  Login By Mobile
  Check Home page
  Go to post listing
  Fill in post listing requirements
  Convert File To Listing
  Check in my listing


*** Keywords ***
Check Home page
  Handle Complete Pofile Popup

Fill in post listing requirements
  Choose Category
  Select Sub Category

Handle Complete Pofile Popup
  Wait Until Page Contains Element            ${Profile_Complation}             timeout=10s
  Click Element                               ${Profile_Complation}
  Wait Until Page Contains Element            ${User_Name}                      timeout=10s
  Input Text                                  ${User_Name}                      ${First_Last_Name}
  Click Element                               ${Work_Envelope}
  Wait Until Page Contains Element            ${Choose_Work_Envelope}           timeout=15s
  Click Element                               ${Choose_Work_Envelope}
  Wait Until Page Contains                    ${Region}                         timeout=10s
  Click Text                                  ${Region}
  Wait Until Page Contains Element            ${Choose_Button}                  timeout=10s
  Click Element                               ${Choose_Button}
  Wait Until Page Contains                    ${Submit_Change}                  timeout=10s
  Click Text                                  ${Submit_Change}

Go to post listing
  Wait Until Page Contains Element            ${Open_Menu}                      timeout=10s
  Click Element                               ${Open_Menu}
  Wait Until Page Contains                    ${Add_File_Listing}               timeout=10s
  Click Text                                  ${Add_File_Listing}

Choose Category
  Wait Until Page Contains Element            ${Add_Images}                     timeout=10s
  Click Text                                  ${Choose_Cat_Txt}
  Wait Until Page Contains Element            ${Choose_Cat}                     timeout=10s
  Click Element                               ${Choose_Cat}

Select Sub Category
  Wait Until Page Contains Element            ${Location}                       timeout=10s
  Click Element                               ${Location}
  Wait Until Page Contains Element            ${Choose_Work_Envelope}           timeout=10s
  Click Element                               ${Choose_Work_Envelope}
  Wait Until Page Contains Element            ${Price}                          timeout=10s
  Click Text                                  ${Land_Use_Type}
  Wait Until Page Contains                    ${Residential_Txt}                    timeout=10s
  Click Element                               ${Residential}
  Click Element                               ${Add_Button}
  Wait Until Page Contains Element            ${Price}                          timeout=10s
  Input Text                                  ${Area}                           ${Input_Area}
  Swipe By Percent                            15   70   15   10                 1000
  Input Text                                  ${Price}                          ${Input_Price}
  Click Element                               ${Register_Button}

Convert File To Listing
  Wait Until Page Contains Element            ${Post_File}                      timeout=10s
  Click Element                               ${Post_File}
  Wait Until Page Contains Element            ${Description}                    timeout=10s
  Input Text                                  ${Description}                    ${Description_Txt}
  Click Element                               ${Register_Listing}

Check in my listing
  Wait Until Page Contains Element            ${Show_Listing_btn}               timeout=10s
  Click Element                               ${Show_Listing_btn}
  Wait Until Page Contains                    ${Listing_Title}                  timeout=10s
