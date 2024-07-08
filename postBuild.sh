#!/bin/bash
export GRID_SERVER="polsrv07.mielse.com"
export QA_SERVER="qa.mielse.com"
export QA2_SERVER="qa2.mielse.com"
export CHROME_VERSION=91
export FIREFOX_VERSION=88

# trumpet_prenv_id="${trumpet_prenv_id:=staging}"
# ServerType="${ServerType:=Staging}"
# BUILD_NUMBER="${BUILD_NUMBER:=00000}"
# export logs="Reports"
# ssh mabdoli@${GRID_SERVER} 'docker restart selenium_app_hub'

#docker stop $(docker ps -aq) && docker rm $(docker ps -aq)

PROJECTS="1564155 1485854 1497322 2135233 1566837 1975863 2193084"
pivotal_api_token="9db9d99f6c0ede4d927d104f575a90bb"
logs="Reports"
MORE_INFO="\\n\\n*More info*"
ANDROiD="\\n\\n*Android Tests*"
WEB="\\n*Web Browser*"
iOS="\\n\\n*iOS Tests*"
export PR="${trumpet_prenv_id}"
if [[ ${ServerType} == "Staging" ]]; then
	export trumpet_prenv_id="staging"
else
	export trumpet_prenv_id="${trumpet_prenv_id}"
fi
if [[ ${trumpet_prenv_id} == "Live" ]]; then
	SUT="https://www.sheypoor.com"
elif [[ ${trumpet_prenv_id} == "staging" ]]; then
	SUT="https://staging.mielse.com"
else
	SUT="https://pr${trumpet_prenv_id}.mielse.com"
fi
SPch=-1
SPff=-1
SPmob=-1
SPapp=-1
SPiOS=-1
SPapi=-1
SPprotools_web=-1
SPprotools_api=-1
SPalounak_app=-1

setmarker ()
{
  if [[ $1 -eq 100 ]]; then
    echo "+"
  else
    echo "-"
  fi
}

setApiBadges ()
{
  if [[ $1 -eq 100 ]]; then
    echo "https://img.shields.io/badge/API-brightgreen.svg?longCache=true&style=plastic"
  else
    echo "https://img.shields.io/badge/API-red.svg?longCache=true&style=plastic"
  fi
}

setProToolsApiBadges ()
{
  if [[ $1 -eq 100 ]]; then
    echo "https://img.shields.io/badge/ProToolApi-v1-brightgreen.svg?longCache=true&style=plastic"
  else
    echo "https://img.shields.io/badge/ProToolApi-v1-red.svg?longCache=true&style=plastic"
  fi
}

setProToolsWebBadges ()
{
  if [[ $1 -eq 100 ]]; then
    echo "https://img.shields.io/badge/ProTool Web-${CHROME_VERSION}-brightgreen.svg?longCache=true&style=plastic"
  else
    echo "https://img.shields.io/badge/ProTool Web-${CHROME_VERSION}-red.svg?longCache=true&style=plastic"
  fi
}

setAlounakAppBadges ()
{
  if [[ $1 -eq 100 ]]; then

    echo "https://img.shields.io/badge/android-v$file_version-brightgreen.svg?longCache=true&style=plastic&label=alounak&logo=android"
  else
    echo "https://img.shields.io/badge/android-v$file_version-red.svg?longCache=true&style=plastic&label=alounak&logo=android"
  fi
}

setSmokeTestBadges ()
{
  if [[ $1 -eq 1 ]]; then
    echo "https://img.shields.io/badge/Smoke Test-brightgreen.svg?longCache=true&style=plastic"
  else
    echo "https://img.shields.io/badge/Smoke Test-red.svg?longCache=true&style=plastic"
  fi
}
sucessEMOJ ()
{
  if [[ $1 -eq 100 ]]; then
    echo "👍"
  else
    echo "👎"
  fi
}

GetSP ()
{
  local  __resultvar="SP$1"
  if [ ! -f ${logs}/$1_SP_log.txt ]; then
    local  myresult=-1
  else
    local  myresult=$(<${logs}/${1}_SP_log.txt)
    if [ -z "$myresult" ];then
      local  myresult=-1
    fi
  fi
	GetStaus $myresult
  eval $__resultvar=$myresult
}

GetStaus ()
{
	local  __resultvar="AT"
  if [ $1 -ge 1 -a $1 -lt 100 ]; then
    local  myresult=0
  else
    local  myresult=1
  fi
  eval $__resultvar=$myresult
}

Health ()
{
  local  __resultvar="HEALTH"
  if [ ! -f ./Health.txt ]; then
    local  myresult=1
  else
    local  myresult=$(<./Health.txt)
    if [ -z "$myresult" ];then
      local  myresult=1
    fi
  fi
  eval $__resultvar=$myresult
}
goo.gl() {
  # Get you API key from Google:
  # https://developers.google.com/url-shortener/v1/getting_started#APIKey
  API_key='AIzaSyD53HZiBJ7F5tNd47jPibjzsazwNHsZtLc'
  GoogleURL='https://www.googleapis.com/urlshortener/v1/url?key='$API_key
  longURL=$1

  # -f to supress fail messages, -s for silent to supress progress reportingq, remove
  # them for debugging.
  # curl -f -s $GoogleURL -H 'Content-Type: application/json' -d "{'longUrl': '$longURL'}" | awk '/id/ { printf $2}' | awk -F\" '{ printf $2 }'
	echo "$1"
  # If you want the output to be followed by a new line replace the second 'printf' with 'print' in the awk statment
}
bit.ly()
{
  BitlyURL='https://api-ssl.bitly.com/v4/bitlinks'
	tajious='8b33f9cc12d82baa15527f9fd49dbcbddf3375ce'
	mehrdad='bccfe21b6955b97ca860771857397f0763d2de61'
	# BitlyAuth='00ba0a7ed408a1b70fbaa3e55a0a2f1546be40fd'
	if (( RANDOM % 2 )); then
		#mehrdad
		BitlyAuth=$mehrdad
	else
		#tajious
		BitlyAuth=$tajious
	 fi

  longURL=$1
	curl -s -x 'http://devopt.net:8888' \
	-H "Content-Type: application/json" \
	-H "Authorization: Bearer $BitlyAuth" \
	-d '{"long_url": "'$longURL'"}' \
	-X POST $BitlyURL | jq -r '.link'
}
ChTest ()
{
  # SPch=$(<${logs}/ch_SP_log.txt)
  GetSP ch
  #Grid Reports
  if [[ $SPch -ge 1 ]]; then
		chMarker=$(setmarker $SPch)
    chEMOJ=$(sucessEMOJ $SPch)
    JLink="http://trumpetbuild.mielse.com/view/All/job/Acceptance-Web-Pr/${BUILD_NUMBER}/robot/report/${trumpet_prenv_id}_ch_report.html#totals?all"
    # jenkinsLog=$(bit.ly $JLink)
    jenkinsLog=$JLink
    badgesCH="[!https://badges.herokuapp.com/browsers?googlechrome=${chMarker}${CHROME_VERSION}&versionDivider=true&labels=longName!|$jenkinsLog] "
    CH_COMMENT="\\n $chEMOJ Desktop Tests:*%$SPch* Success"

  else
    CH_COMMENT=""
    badgesCH=""
  fi
}

FfTest ()
{
  GetSP ff
  #Grid Reports
  if [[ $SPff -ge 1 ]]; then
    ffMarker=$(setmarker $SPff)
    ffEMOJ=$(sucessEMOJ $SPff)
    JLink="http://trumpetbuild.mielse.com/view/All/job/Acceptance-Web-Pr/${BUILD_NUMBER}/robot/report/${trumpet_prenv_id}_ff_report.html#totals?all"
    jenkinsLogff=$JLink
    badgesff="[!https://badges.herokuapp.com/browsers?firefox=${ffMarker}${FIREFOX_VERSION}&versionDivider=true&labels=longName!|$jenkinsLogff] "
    FF_COMMENT="\\n $ffEMOJ Firefox Tests:*%$SPff* Success "
  else
    FF_COMMENT=""
    badgesff=""
  fi
}

MobileSite ()
{
  GetSP mob
  #Mobile WEB APP Reports
  if [[ $SPmob -ge 1 ]]; then
    mobMarker=$(setmarker $SPmob)
    mobEMOJ=$(sucessEMOJ $SPmob)
    JLink="http://trumpetbuild.mielse.com/view/All/job/Acceptance-Web-Pr/${BUILD_NUMBER}/robot/report/${PR}_Mobile_Site_report.html#totals?all"
    MobileWebLog=$JLink
    MobileBadges="[!https://badges.herokuapp.com/browsers?android=${mobMarker}Chrome&versionDivider=true&labels=longName!|$MobileWebLog] "
    MOB_COMMENT="\\n $mobEMOJ Mobile Site Tests:*%${SPmob}* Success"
  else
    MOB_COMMENT=""
    MobileBadges=""
  fi
}

AndroidApp ()
{
  #ANDOID APP Reports
  GetSP app
  if [[ $SPapp -ge 1 ]]; then
    appMarker=$(setmarker $SPapp)
    appEMOJ=$(sucessEMOJ $SPapp)
    JLink="http://trumpetbuild.mielse.com/view/All/job/Acceptance-Web-Pr/${BUILD_NUMBER}/robot/report/${PR}_Android_App_report.html#totals?all"
    AndroidAppLog=$JLink
    AppBadges="[!https://badges.herokuapp.com/browsers?android=${appMarker}$file_version&versionDivider=true!|$AndroidAppLog] "
    APP_COMMENT="\\n $appEMOJ Android App Tests:*%$SPapp* Success"
  else
    APP_COMMENT=""
    AppBadges=""
  fi
}


iOSApp ()
{
#iOS APP Reports
  GetSP iOS
  if [[ $SPiOS -ge 1 ]]; then
    iOSMarker=$(setmarker $SPiOS)
    iOSEMOJ=$(sucessEMOJ $SPiOS)
    JLink="http://trumpetbuild.mielse.com/view/All/job/Acceptance-Web-Pr/${BUILD_NUMBER}/robot/report/${trumpet_prenv_id}_iOS_report.html#totals?all"
    iOSAppLog=$JLink
    iOSBadges="[!https://badges.herokuapp.com/browsers?iphone=${iOSMarker}7&versionDivider=true!|$iOSAppLog] "
    iOSApplink="\\n- [iOS App Report]($iOSAppLog)"
    iOS_COMMENT="\\n $iOSEMOJ iOS Tests:*%$SPiOS* Success "
  else
    iOS_COMMENT=""
    iOSBadges=""
    iOSApplink=""
  fi
}

ApiTest ()
{
#api Reports
  GetSP api
  if [[ $SPapi -ge 1 ]]; then
    apiBadgesLink=$(setApiBadges $SPapi)
		apiEMOJ=$(sucessEMOJ $SPapi)
    if [[ $SPapi -ne 100 ]]; then
			mention=""
			JLink="http://trumpetbuild.mielse.com/view/All/job/Acceptance-Web-Pr/${BUILD_NUMBER}/robot/report/${trumpet_prenv_id}_failed_api_report.html#totals?all"
		else
			mention=""
			JLink="http://trumpetbuild.mielse.com/view/All/job/Acceptance-Web-Pr/${BUILD_NUMBER}/robot/report/${trumpet_prenv_id}_api_report.html#totals?all"
		fi
		apiLog=$JLink
		apiBadges="[!${apiBadgesLink}!|$apiLog] "
    api_COMMENT="\\n $apiEMOJ api Tests:*%$SPapi* Success "
  else
    api_COMMENT=""
    apiBadges=""
  fi
}

ProToolsApiTest ()
{
#protoolsapi Reports
  GetSP protools_api
  if [[ $SPprotools_api -ge 1 ]]; then
		protools_apiBadgesLink=$(setProToolsApiBadges $SPprotools_api)
		protools_apiEMOJ=$(sucessEMOJ $SPprotools_api)
		if [[ $SPprotools_api -ne 100 ]]; then
			mention=""
			JLink="http://trumpetbuild.mielse.com/view/All/job/Acceptance-Web-Pr/${BUILD_NUMBER}/robot/report/${trumpet_prenv_id}_protools_api_report.html#totals?all"
		else
			mention=""
			JLink="http://trumpetbuild.mielse.com/view/All/job/Acceptance-Web-Pr/${BUILD_NUMBER}/robot/report/${trumpet_prenv_id}_protools_api_report.html#totals?all"
		fi
    protools_apiLog=$JLink
    protools_apiBadges="[!${protools_apiBadgesLink}!|$protools_apiLog] "
    protools_api_COMMENT="\\n $protools_apiEMOJ ProTools Api Tests:*%$SPprotools_api* Success "
  else
    protools_api_COMMENT=""
    protools_apiBadges=""
  fi
}

AlounakAppTest ()
{
#protoolsapi Reports
  GetSP alounak_app
  if [[ $SPalounak_app -ge 1 ]]; then
		alounak_appBadgesLink=$(setAlounakAppBadges $SPalounak_app)
		alounak_appEMOJ=$(sucessEMOJ $SPalounak_app)
		if [[ $SPalounak_app -ne 100 ]]; then
			mention=""
			JLink="http://trumpetbuild.mielse.com/view/All/job/Acceptance-Web-Pr/${BUILD_NUMBER}/robot/report/${trumpet_prenv_id}_alounak_app_report.html#totals?all"
		else
			mention=""
			JLink="http://trumpetbuild.mielse.com/view/All/job/Acceptance-Web-Pr/${BUILD_NUMBER}/robot/report/${trumpet_prenv_id}_alounak_app_report.html#totals?all"
		fi
    alounak_appLog=$JLink
    alounak_appBadges="[!${alounak_appBadgesLink}!|$alounak_appLog] "
    alounak_app_COMMENT="\\n $alounak_appEMOJ Alounak App Tests:*%$SPalounak_app* Success "
  else
    alounak_app_COMMENT=""
    alounak_appBadges=""
  fi
}

protools_webTest ()
{
  GetSP protools_web
  #Grid Reports
  if [[ $SPprotools_web -ge 1 ]]; then
		if [[ $SPprotools_web -ne 100 ]]; then
			mention=""
		else
			mention=""
		fi
		protools_webMarker=$(setProToolsWebBadges $SPprotools_web)
    protools_webEMOJ=$(sucessEMOJ $SPprotools_web)
    JLink="http://trumpetbuild.mielse.com/view/All/job/Acceptance-Web-Pr/${BUILD_NUMBER}/robot/report/${trumpet_prenv_id}_protools_web_report.html#totals?all"
    jenkinsLogprotools_web=$JLink
		badgesprotools_web="[!${protools_webMarker}!|$jenkinsLogprotools_web] "
    # badgesprotools_web="[![Grid Test Status](https://badges.herokuapp.com/browsers?googlechrome=${protools_webMarker}${CHROME_VERSION}&versionDivider=true&labels=longName)]($jenkinsLogprotools_web)"
    protools_web_COMMENT="\\n $protools_webEMOJ protools web Tests:*%$SPprotools_web* Success  "
  else
    protools_web_COMMENT=""
    badgesprotools_web=""
  fi
}

Auto ()
{
  AndroidApp && ChTest && protools_webTest && FfTest && MobileSite && iOSApp && ApiTest && ProToolsApiTest && AlounakAppTest
}

PrComment ()
{
	export {http,https,ftp}_proxy='http://devopt.net:8888'
	for p in $PROJECTS ;do
		for s in $pivotal_story ;do
			status=$(curl --write-out 'http%{http_code}\n' -X GET --silent -H "X-TrackerToken: $pivotal_api_token" -H "Content-Type: application/json" -I "https://www.pivotaltracker.com/services/v5/projects/$p/stories/$s" | grep http200)
			echo $status
			if [ "$status" == "http200" ];then
				curl -X POST -H "X-TrackerToken: $pivotal_api_token" -H "Content-Type: application/json" -d '{"text":"'"$1"'"}' "https://www.pivotaltracker.com/services/v5/projects/$p/stories/$s/comments"
				# if [ "$AT" == "0" ];then
				# 	curl -X POST -H "X-TrackerToken: $pivotal_api_token" -H "Content-Type: application/json" -d '{"name":"'"auto-test-failure"'"}' "https://www.pivotaltracker.com/services/v5/projects/$p/stories/$s/labels"
				# fi
			fi
		done
	done
	unset {http,https,ftp}_proxy
}

JiraComment ()
{
  # RequestTitle=$(echo $gitlabMergeRequestTitle | cut -d ']' -f2  | cut -b 2-)
	# issue="${issue:=$RequestTitle}"
	echo "this is jira comment"
	# echo "$1"
	echo "curl --location --request POST -u jenkins:8f03e6227807603eb4717934 --header \"Content-Type: application/json\" --data '{\"body\":\"$1\"}' https://jira.mielse.com/rest/api/2/issue/$issue/comment" | bash
}
curl --location --request POST -u jenkins:8f03e6227807603eb4717934 --header \"Content-Type: application/json\" --data '{\"body\":\"test comment\"}' https://jira.mielse.com/rest/api/2/issue/SPT-588/comment
Executor ()
{
  if [[ $TestKind = 'Android' ]]; then
    AndroidApp
  elif [[ $TestKind = 'Chrome' ]]; then
  	ChTest
  elif [[ $TestKind = 'Firefox' ]]; then
    FfTest
  elif [[ $TestKind = 'Mobile' ]]; then
  	MobileSite
  elif [[ $TestKind = 'iOS' ]]; then
  	iOSApp
  elif [[ $TestKind = 'api' ]]; then
  	ApiTest
	elif [[ $TestKind = 'protoolsWeb' ]]; then
		protools_webTest
	elif [[ "$TestKind" = 'alounak_app' ]]; then
      AlounakAppTest
  elif [[ $TestKind = 'protools_api' ]]; then
  	ProToolsApiTest
  else
    Auto
  fi
  echo "SPch=$SPch"
  # echo "SPff=$SPff"
  echo "SPmob=$SPmob"
  echo "SPapp=$SPapp"
  # echo "SPiOS=$SPiOS"
  echo "SPapi=$SPapi"
	echo "SPprotools_web=$SPprotools_web"
  echo "SPprotools_api=$SPprotools_api"
  echo "SPalounak_app=$SPalounak_app"
	if [ $SPch -ge 1 -o $SPff -ge 1 -o $SPmob -ge 1 -o $SPapp -ge 1 -o $SPiOS -ge 1 -o $SPapi -ge 1 ]; then
		SheypoorResults="\\n\\n h2. Sheypoor Test Results"
	elif [$SPprotools_web -ge 1 -o $SPprotools_api -ge 1 -o $SPalounak_app -ge 1]; then
		ProToolsResults="\\n\\n h2. Pro-tools Test Results"
	fi
  if [ $SPch -ge 1 -o $SPprotools_web -ge 1 -o $SPff -ge 1 -o $SPmob -ge 1 -o $SPapp -ge 1 -o $SPiOS -ge 1 -o $SPapi -ge 1 -o $SPprotools_api -ge 1 -o $SPalounak_app -ge 1 ]; then
	  GRID="$apiBadges $protools_apiBadges $badgesCH $badgesprotools_web $badgesff $MobileBadges $AppBadges $iOSBadges $alounak_appBadges $SheypoorResults $api_COMMENT $CH_COMMENT $FF_COMMENT $MOB_COMMENT $APP_COMMENT $NewAPP_COMMENT $iOS_COMMENT $ProToolsResults $protools_api_COMMENT $protools_web_COMMENT $alounak_app_COMMENT"
	  COMMENT="h1. PR${PR} Automatic Tests \\n  $GRID"
    # PrComment "$COMMENT"
		JiraComment "$COMMENT"
  else
    echo "we have problem:"
    echo "SPch=$SPch"
    echo "SPprotools_web=$SPprotools_web"
    # echo "SPff=$SPff"
    echo "SPmob=$SPmob"
    echo "SPapp=$SPapp"
    # echo "SPiOS=$SPiOS"
    echo "SPapi=$SPapi"
    echo "SPprotools_api=$SPprotools_api"
    echo "SPalounak_app=$SPalounak_app"
  fi
}
Health
if [[ $HEALTH -eq 0 ]]; then
	Executor
else
  JLink="http://trumpetbuild.mielse.com/view/All/job/Acceptance-Web-Pr/${BUILD_NUMBER}/robot/report/${trumpet_prenv_id}_smoke_test_log.html"
  jenkinsLog=$JLink
	smokeBadgesLink=$(setSmokeTestBadges 0)
	smokeBadges="[!${smokeBadgesLink}!|$jenkinsLog]"
	GRID="$smokeBadges \\n The $SUT is unstable . \\n\\n  View logs for more info:  $jenkinsLog"
  COMMENT="h1. PR${trumpet_prenv_id} Automatic Tests \\n  $GRID"
	JiraComment "$COMMENT"
fi

##################CLEAN UP #########################################
echo " Dockers in QA1 "
# curl -sSL http://qa:1qaz3edc@${QA_SERVER}:8899/dashboard/cleanup?action=doCleanupActiveSessions
curl -sSL http://qa:1qaz3edc@${QA_SERVER}:8899/grid/sessions?action=doCleanup
ssh root@${QA_SERVER} '/usr/local/bin/dockercompose_restart.sh'
echo " Dockers in QA2 "
# curl -sSL http://qa:1qaz3edc@${QA2_SERVER}:8899/dashboard/cleanup?action=doCleanupActiveSessions
curl -sSL http://qa:1qaz3edc@${QA2_SERVER}:8899/grid/sessions?action=doCleanup
ssh root@${QA2_SERVER} '/usr/local/bin/dockercompose_restart.sh'

sudo rm -rf /var/lib/jenkins/workspace/Acceptance-Web-Pr*
exit 0

#👍👎✔️❌
