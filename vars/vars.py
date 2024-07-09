import os
from messages import *
jenkinsID = os.getenv('BUILD_NUMBER','0000')
REMOTE_TEST= os.getenv('REMOTE_TEST','Local')
TestKind = os.getenv('TestKind','Auto')
ServerType = os.getenv('ServerType','PR')
trumpet_prenv_id = os.getenv('trumpet_prenv_id','staging')
PR = os.getenv('PR',trumpet_prenv_id)
general_api_version = os.getenv('general_api_version','6.4.0')

if ServerType == "Staging":
    trumpet_prenv_id = "staging"
else:
    trumpet_prenv_id = os.getenv('trumpet_prenv_id','')



admin_user = "admin1060@mielse.com"
MOBILE = "09001000000"
EMAIL = "testQA@mielse.com"
DELAY = "1.5s"
build = jenkinsID

JENKINS_NODE = '10.10.0.241'
HUB_SERVER = "polsrv07.mielse.com"
HUB_SERVER_IP = "10.10.0.9"
QA_SERVER = "qa.mielse.com"
# QA_SERVER = "10.10.0.200"
QA2_SERVER = "qa2.mielse.com"

HUB_USER = 'mabdoli'
HRTZ_USER = 'root'

JENKINS_SSH_KEY_PATH = '/home/jenkins/.ssh/id_rsa'
HRTZ_SSH_KEY_PATH = '/root/.ssh/id_rsa'
HRTZ_LOGS_PATH = "/home/qa/web/videos"
HUB_LOGS_PATH = "/var/lib/docker/qa/vids"
HRTZ_SERVICE_PATH = "/home/qa/dockers/auto-tests/service.sh"
SERVICE_PATH = "/home/mabdoli/auto-tests/service.sh"


#Android App Grid
APP_SERVER = HUB_SERVER
APP_SERVER_USER = HUB_USER
APP_SSH_KEY_PATH = JENKINS_SSH_KEY_PATH
APP_DOCKER_NAME = "Android"
APP_URL = "http://" + HUB_SERVER_IP + ":4444/wd/hub"
APP_LOGS = "http://" + APP_SERVER + "/vids/AndroidApp"
APP_LOGS_PATH = HUB_LOGS_PATH + "/AndroidApp"
APP_SERVICE_PATH = SERVICE_PATH
APP_LOCAL_SERVICE_PATH = '/home/service.sh'

#Mobile Site Grid
MOB_SERVER = HUB_SERVER
MOB_SERVER_USER = HUB_USER
MOB_SSH_KEY_PATH = JENKINS_SSH_KEY_PATH
MOB_DOCKER_NAME = "Android"
MOB_URL = "http://" + HUB_SERVER_IP + ":4444/wd/hub"
MOB_LOGS = "http://" + MOB_SERVER + "/vids/AndroidApp"
MOB_LOGS_PATH = HUB_LOGS_PATH + "/AndroidApp"
MOB_SERVICE_PATH = SERVICE_PATH
MOB_LOCAL_SERVICE_PATH = '/home/service.sh'

#web GRID:
WEB_SERVER = QA_SERVER
WEB_SERVER_USER = HRTZ_USER
WEB_SSH_KEY_PATH = JENKINS_SSH_KEY_PATH
WEB_DOCKER_NAME = "zalenium"
WEB_URL = "http://qa:1qaz3edc@" + WEB_SERVER + ":8899/wd/hub"
WEB_LOGS = "http://" + WEB_SERVER + ":8088/Web"
WEB_LOGS_PATH = HRTZ_LOGS_PATH + "/Web"
WEB_VIDEO_DIR = "/tmp/videos"


#Protools web GRID:
PROOTOOLS_SERVER = QA2_SERVER
PROOTOOLS_SERVER_USER = HRTZ_USER
PROOTOOLS_SSH_KEY_PATH = JENKINS_SSH_KEY_PATH
PROOTOOLS_DOCKER_NAME = "zalenium"
PROOTOOLS_URL = "http://qa:1qaz3edc@" + PROOTOOLS_SERVER + ":8899/wd/hub"
PROOTOOLS_LOGS = "http://" + PROOTOOLS_SERVER + ":8088/Web"
PROOTOOLS_LOGS_PATH = HRTZ_LOGS_PATH + "/Web"
PROOTOOLS_VIDEO_DIR = "/tmp/videos"


SUT_NAME = "Build" + jenkinsID + "_PR" + PR

Domian = "mielse.com"
Live = "sheypoor.com"

APPIUM_LOCAL = "http://127.0.0.1:4723/wd/hub"
SELENIUM_LOCAL = "http://127.0.0.1:4444/wd/hub"
