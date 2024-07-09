import os
apk_version = "6.4.1"
alpha = "6.5.0"
APP_PACKAGE = 'com.sheypoor.mobile.debug'
file_version = os.getenv('file_version',apk_version)
file_url_Grid = os.getenv('file_url','http://trumpetbuild.mielse.com:8001/android_build/v' + file_version + '/debug/Sheypoor-PlayStoreDebug.apk')
REMOTE_TEST= os.getenv('REMOTE_TEST','Local')

if REMOTE_TEST == "Local":
    file_version = alpha
# else:
#     if "pr-build" in file_url_Grid:
#         file_version = alpha
#     else:
#         file_version = apk_version
#         file_url_Grid = 'http://trumpetbuild.mielse.com:8001/android_build/v' + file_version + '/debug/Sheypoor-PlayStoreDebug.apk'
