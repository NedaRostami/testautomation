#################   LOCAL RUN TEST SAMPLES IN LOCAL

SMOKETESTS

robot -d  Reports/smoke -P auto-tests/lib/:auto-tests/  -v isSheypoorX:True -v ServerType:SheypoorX -v general_api_version:6.3.2 -v trumpet_prenv_id:205   auto-tests/Smoke/smoke_test.robot

#############################################################################
Sheypoor API

robot -P auto-tests/lib/:auto-tests/ -d Reports/api -v ServerType:SheypoorX -v general_api_version:5.0.3 -v trumpet_prenv_id:205 -v api_version:5.0.3 auto-tests/api/api.tests/post_listing/tests/post-a-car_listing.robot
pabot  --processes 20 -P auto-tests/lib/:auto-tests/ -d Reports/api -v general_api_version:6.3.2 -v trumpet_prenv_id:10398 -v api_version:5.0.3 auto-tests/api/api.tests/chat/tests/chat-with-user.robot



#########################################################################################
DESKTOP

robot -P auto-tests/:auto-tests/lib/ -L trace -d  Reports/Local/web -A auto-tests/vars/ch.txt -v ServerType:Staging -v HEADLESS:No -v RecordV:Yes -v REMOTE_TEST:Local -v Round:1 -v general_api_version:6.3.2 -v trumpet_prenv_id:staging  auto-tests/web/desktop.tests/Rating/01_rate_from_listing_details.robot

#########################################################################################
MOBILESITE

robot -P auto-tests/:auto-tests/lib/ -L trace -d  Reports/app -A auto-tests/vars/mob.txt  -v general_api_version:6.3.2 -v trumpet_prenv_id:staging -v REMOTE_TEST:Grid  auto-tests/Mobile/mobilesite.tests/Listing/012__Add_RealEstate_Max_New_Mobile.robot

###########################################################################################

ANDROID APP

robot -P auto-tests/:auto-tests/lib/ -L trace -d  Reports/mob -A auto-tests/vars/app_local.txt -v general_api_version:6.3.2 -v trumpet_prenv_id:staging -v REMOTE_TEST:Local  auto-tests/Android/android.tests/chat/02_chat_customer_with_seller.robot
pabot  --processes 20 -P auto-tests/:auto-tests/lib/ -L trace -d  Reports/mob -A auto-tests/vars/app_local.txt -v general_api_version:6.3.2 -v trumpet_prenv_id:staging -v REMOTE_TEST:Local  auto-tests/Android/android.tests/chat/02_chat_customer_with_seller.robot

########################################################################

PROTOOLS API
robot -P auto-tests/lib/:auto-tests/ -L trace -d  Reports/api -v ServerType:ProTools -v protools_version:2 -v general_api_version:6.3.2 -v trumpet_prenv_id:205  auto-tests/ProTools/api/protools.api.tests/auth/tests/car-login.robot
#################################################################################################

PROTOOLS WEB

robot -P auto-tests/lib/:auto-tests/ -L trace -d  Reports/Local/web -v ServerType:ProTools -A auto-tests/vars/ch.txt -v HEADLESS:No -v RecordV:No -v Round:1 -v REMOTE_TEST:Local -v protools_version:2 -v general_api_version:6.3.2 -v trumpet_prenv_id:588  auto-tests/ProTools/Web/protools.web.tests/create_listings/02_create_rental_real_estate_listing.robot
######################################################################################

Alounak APP
robot -A auto-tests/vars/local/alounak_app.txt -v REMOTE_TEST:Local -v ServerType:PR -v general_api_version:6.4.0 -v trumpet_prenv_id:10655  auto-tests/ProTools/Android/Aloonak/aloonak.test/listing/01_new_post_listing.robot
robot -P auto-tests/:auto-tests/lib/ -L trace -d  Reports/app -A auto-tests/vars/alounak_app.txt -v general_api_version:6.3.2 -v protools_version:1 -v trumpet_prenv_id:staging -v REMOTE_TEST:Grid auto-tests/ProTools/Android/Aloonak/aloonak.test/listing/01_new_post_listing.robot
