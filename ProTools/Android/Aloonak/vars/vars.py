import os

apk_version = "1.20.2"
alpha = "1.18"
APP_PACKAGE = 'com.protoolsmobileapp.debug'
file_version = os.getenv('alounak_version',apk_version)
file_url_Grid = os.getenv('alounak_file','http://trumpetbuialphald.mielse.com:8001/protools/estate/v' + file_version + '/debug/app-estate-debug.apk')
REMOTE_TEST= os.getenv('REMOTE_TEST','Local')

# if "android_build" in file_url_Grid:
#     file_version = file_version
# else:
#     file_version = apk_version
#     file_url_Grid = 'http://trumpetbuialphald.mielse.com:8001/protools/android_build/' + file_version + '/debug/app-estate-debug.apk'
#

if REMOTE_TEST == "Local":
    file_version = alpha
