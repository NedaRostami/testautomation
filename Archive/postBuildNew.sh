#!/bin/bash
chromeVersion="79"
FirefoxVersion="71"
SPch=0
SPprotools_web=0
SPff=0
SPmob=0
SPapp=0
SPnew_app=0
SPiOS=0
SPapi=0
SPapi=0
SPprotools_api=0
PROJECTS="1564155 1485854 1497322 2135233 1566837 1975863 2193084"
pivotal_api_token="9db9d99f6c0ede4d927d104f575a90bb"
logs="Reports"
MORE_INFO="\\n\\n*** More info:***"
ANDROiD="\\n\\n*** Android Tests: ***"
WEB="\\n*** Web Browser: ***"
iOS="\\n\\n*** iOS Tests: ***"
SheypoorResults="\\n\\n*** Sheypoor Test Results: ***"
ProToolsResults="\\n\\n*** Pro-tools Test Results: ***"

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
elif [[ ${ServerType} == "ProTools" ]]; then
	SUT="protools${trumpet_prenv_id}.mielse.com"
else
	SUT="https://pr${trumpet_prenv_id}.mielse.com"
fi

setmarker ()
{
  if [[ $1 -eq 100 ]]; then
    echo "+"
  else
    echo "-"
  fi
}

SetSheildBadges ()
{
	if [[ $1 -eq 100 ]]; then
		echo "https://img.shields.io/badge/$2-brightgreen.svg?longCache=true&style=plastic"
	else
		echo "https://img.shields.io/badge/$2-red.svg?longCache=true&style=plastic"
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
    local  myresult=0
  else
    local  myresult=$(<${logs}/${1}_SP_log.txt)
    if [ -z "$myresult" ];then
      local  myresult=0
    fi
  fi
	GetStatus $myresult
  eval $__resultvar=$myresult
}

GetStatus ()
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

bit.ly()
{
  BitlyURL='https://api-ssl.bitly.com/v4/bitlinks'
	#BitlyAuth='8b33f9cc12d82baa15527f9fd49dbcbddf3375ce'
	if (( RANDOM % 2 )); then
		BitlyAuth='bccfe21b6955b97ca860771857397f0763d2de61'
	else
		BitlyAuth='8b33f9cc12d82baa15527f9fd49dbcbddf3375ce'
	fi
  longURL=$1
	curl -s \
	-H "Content-Type: application/json" \
	-H "Authorization: Bearer $BitlyAuth" \
	-d '{"long_url": "'$longURL'"}' \
	-X POST $BitlyURL | jq -r '.link'
}

TestReport ()
{
  GetSP $1
  if [[ $SPch -ge 15 ]]; then
		Marker=$(setmarker $SPch)
    EMOJ=$(sucessEMOJ $SPch)
    JLink="http://trumpetbuild.mielse.com/view/All/job/Acceptance-Web-Pr/${BUILD_NUMBER}/robot/report/${trumpet_prenv_id}_${1}_metrics.html"
    jenkinsLog=$(bit.ly $JLink)
    badgesCH="[![Grid Test Status](https://badges.herokuapp.com/browsers?googlechrome=${chMarker}${chromeVersion}&versionDivider=true&labels=longName)]($jenkinsLog)"
    CH_COMMENT="\\n $chEMOJ Desktop Tests:** %$SPch ** Success"
  else
    CH_COMMENT=""
    badgesCH=""
  fi
}

TestReport ch
ChTest ()
{
  GetSP ch
  if [[ $SPch -ge 15 ]]; then
		chMarker=$(setmarker $SPch)
    chEMOJ=$(sucessEMOJ $SPch)
    JLink="http://trumpetbuild.mielse.com/view/All/job/Acceptance-Web-Pr/${BUILD_NUMBER}/robot/report/${trumpet_prenv_id}_ch_metrics.html"
    jenkinsLog=$(bit.ly $JLink)
    badgesCH="[![Grid Test Status](https://badges.herokuapp.com/browsers?googlechrome=${chMarker}${chromeVersion}&versionDivider=true&labels=longName)]($jenkinsLog)"
    CH_COMMENT="\\n $chEMOJ Desktop Tests:** %$SPch ** Success"
  else
    CH_COMMENT=""
    badgesCH=""
  fi
}

FfTest ()
{
  GetSP ff
  if [[ $SPff -ge 15 ]]; then
    ffMarker=$(setmarker $SPff)
    ffEMOJ=$(sucessEMOJ $SPff)
    JLink="http://trumpetbuild.mielse.com/view/All/job/Acceptance-Web-Pr/${BUILD_NUMBER}/robot/report/${trumpet_prenv_id}_ff_metrics.html"
    jenkinsLogff=$(bit.ly $JLink)
    linkff="\\n- [Firefox Browser Reports]($jenkinsLogff) \\n"
    badgesff="[![Grid Test Status](https://badges.herokuapp.com/browsers?firefox=${ffMarker}${FirefoxVersion}&versionDivider=true&labels=longName)]($jenkinsLogff)"
    FF_COMMENT="\\n $ffEMOJ Firefox Tests:** %$SPff ** Success "
  else
    FF_COMMENT=""
    badgesff=""
    linkff=""
  fi
}

MobileSite ()
{
  GetSP mob
  #Mobile WEB APP Reports
  if [[ $SPmob -ge 15 ]]; then
    mobMarker=$(setmarker $SPmob)
    mobEMOJ=$(sucessEMOJ $SPmob)
    JLink="http://trumpetbuild.mielse.com/view/All/job/Acceptance-Web-Pr/${BUILD_NUMBER}/robot/report/${PR}_Mobile_Site_metrics.html"
    MobileWebLog=$(bit.ly $JLink)
    MobileBadges="[![Mobile Site](https://badges.herokuapp.com/browsers?android=${mobMarker}Chrome&versionDivider=true&labels=longName)]($MobileWebLog)"
    MobileWeblink="\\n- [Mobile Site Report]($MobileWebLog)"
    MOB_COMMENT="\\n $mobEMOJ Mobile Site Tests:** %$SPmob ** Success"
  else
    MOB_COMMENT=""
    MobileBadges=""
    MobileWeblink=""
  fi
}

AndroidApp ()
{
  #ANDOID APP Reports
  GetSP app
  if [[ $SPapp -ge 15 ]]; then
    appMarker=$(setmarker $SPapp)
    appEMOJ=$(sucessEMOJ $SPapp)
    JLink="http://trumpetbuild.mielse.com/view/All/job/Acceptance-Web-Pr/${BUILD_NUMBER}/robot/report/${PR}_Android_App_metrics.html"
    AndroidAppLog=$(bit.ly $JLink)
    AppBadges="[![Android App](https://badges.herokuapp.com/browsers?android=${appMarker}$file_version&versionDivider=true)]($AndroidAppLog)"
    AndroidApplink="\\n- [Android App Report]($AndroidAppLog)"
    APP_COMMENT="\\n $appEMOJ Android App Tests:** %$SPapp ** Success "
  else
    APP_COMMENT=""
    AppBadges=""
    AndroidApplink=""
  fi
}

AndroidAppNew ()
{
  #ANDOID New APP Reports
  GetSP new_app
  if [[ $SPnew_app -ge 15 ]]; then
    new_appMarker=$(setmarker $SPnew_app)
    new_appEMOJ=$(sucessEMOJ $SPnew_app)
    JLink="http://trumpetbuild.mielse.com/view/All/job/Acceptance-Web-Pr/${BUILD_NUMBER}/robot/report/${PR}_New_Android_App_metrics.html"
    AndroidAppLog=$(bit.ly $JLink)
    NewAppBadges="[![Android New App](https://badges.herokuapp.com/browsers?android=${new_appMarker}$file_version&versionDivider=true)]($AndroidAppLog)"
    AndroidApplink="\\n- [Android New App Report]($AndroidAppLog)"
    NewAPP_COMMENT="\\n $new_appEMOJ Android App Tests:** %$SPnew_app ** Success "
  else
    NewAPP_COMMENT=""
    NewAppBadges=""
    AndroidApplink=""
  fi
}

iOSApp ()
{
#iOS APP Reports
  GetSP iOS
  if [[ $SPiOS -ge 15 ]]; then
    iOSMarker=$(setmarker $SPiOS)
    iOSEMOJ=$(sucessEMOJ $SPiOS)
    JLink="http://trumpetbuild.mielse.com/view/All/job/Acceptance-Web-Pr/${BUILD_NUMBER}/robot/report/${trumpet_prenv_id}_iOS_metrics.html"
    iOSAppLog=$(bit.ly $JLink)
    iOSBadges="[![iOS App](https://badges.herokuapp.com/browsers?iphone=${iOSMarker}7&versionDivider=true)]($iOSAppLog)"
    iOSApplink="\\n- [iOS App Report]($iOSAppLog)"
    iOS_COMMENT="\\n $iOSEMOJ iOS Tests:** %$SPiOS ** Success "
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
  if [[ $SPapi -ge 15 ]]; then
    apiBadgesLink=$(SetSheildBadges $SPapi API-3.0)
		apiEMOJ=$(sucessEMOJ $SPapi)
    JLink="http://trumpetbuild.mielse.com/view/All/job/Acceptance-Web-Pr/${BUILD_NUMBER}/robot/report/${trumpet_prenv_id}_api_metrics.html"
    apiLog=$(bit.ly $JLink)
    apiBadges="[![api](${apiBadgesLink})]($apiLog)"
    apilink="\\n- [api Report]($apiLog)"
		if [[ $SPapi -ne 100 ]]; then
			mention="@alirezatjk !?"
			# mention=""
		else
			mention=""
		fi
    api_COMMENT="\\n $apiEMOJ api 3.02 to 3.1.2 Tests:** %$SPapi ** Success . $mention "
  else
    api_COMMENT=""
    apiBadges=""
    apilink=""
  fi
}

NewApiTest ()
{
#api Reports
  GetSP api
  if [[ $SPapi -ge 15 ]]; then
    apiBadgesLink=$(SetSheildBadges $SPapi API)
		apiEMOJ=$(sucessEMOJ $SPapi)
    JLink="http://trumpetbuild.mielse.com/view/All/job/Acceptance-Web-Pr/${BUILD_NUMBER}/robot/report/${trumpet_prenv_id}_api_metrics.html"
    apiLog=$(bit.ly $JLink)
    apiBadges="[![api](${apiBadgesLink})]($apiLog)"
    apilink="\\n- [api Report]($apiLog)"
		if [[ $SPapi -ne 100 ]]; then
			mention="@alirezatjk !?"
			# mention=""
		else
			mention=""
		fi
    api_COMMENT="\\n $apiEMOJ API Tests:** %$SPapi ** Success . $mention "
  else
    api_COMMENT=""
    apiBadges=""
    apilink=""
  fi
}

protools_webTest ()
{
  GetSP protools_web
  #Grid Reports
  if [[ $SPprotools_web -ge 15 ]]; then
		if [[ $SPprotools_web -ne 100 ]]; then
			mention="@Fatemeh_Ghorbani !?"
		else
			mention=""
		fi
		protools_webMarker=$(SetSheildBadges $SPprotools_web 'ProTool Web-${chromeVersion}')
    protools_webEMOJ=$(sucessEMOJ $SPprotools_web)
    JLink="http://trumpetbuild.mielse.com/view/All/job/Acceptance-Web-Pr/${BUILD_NUMBER}/robot/report/${trumpet_prenv_id}_protools_web_metrics.html"
    jenkinsLogprotools_web=$(bit.ly $JLink)
		badgesprotools_web="[![protools_web](${protools_webMarker})]($jenkinsLogprotools_web)"
    linkprotools_web="\\n- [protools web Reports]($jenkinsLogprotools_web) \\n"
    # badgesprotools_web="[![Grid Test Status](https://badges.herokuapp.com/browsers?googlechrome=${protools_webMarker}79&versionDivider=true&labels=longName)]($jenkinsLogprotools_web)"
    protools_web_COMMENT="\\n $protools_webEMOJ protools web Tests:** %$SPprotools_web ** Success . $mention "
  else
    protools_web_COMMENT=""
    badgesprotools_web=""
    linkprotools_web=""
  fi
}

ProToolsApiTest ()
{
#protoolsapi Reports
  GetSP protools_api
  if [[ $SPprotools_api -ge 15 ]]; then
		if [[ $SPprotools_api -ne 100 ]]; then
			mention="@Fatemeh_Ghorbani !?"
		else
			mention=""
		fi
    protools_apiBadgesLink=$(SetSheildBadges $SPprotools_api 'Pro Tools Api')
		protools_apiEMOJ=$(sucessEMOJ $SPprotools_api)
    JLink="http://trumpetbuild.mielse.com/view/All/job/Acceptance-Web-Pr/${BUILD_NUMBER}/robot/report/${trumpet_prenv_id}_protools_api_metrics.html"
    protools_apiLog=$(bit.ly $JLink)
    protools_apiBadges="[![protools_api](${protools_apiBadgesLink})]($protools_apiLog)"
    protools_apilink="\\n- [protools_apiReport]($protools_apiLog)"
    protools_api_COMMENT="\\n $protools_apiEMOJ ProTools Api Tests:** %$SPprotools_api** Success . $mention "
  else
    protools_api_COMMENT=""
    protools_apiBadges=""
    protools_apilink=""
  fi
}

Auto ()
{
  AndroidApp && AndroidAppNew && ChTest && protools_webTest && FfTest && MobileSite && iOSApp && ApiTest && NewApiTest && ProToolsApiTest
}

PrComment ()
{
  for p in $PROJECTS ;do
    for s in $pivotal_story ; do
      curl -X POST -H "X-TrackerToken: $pivotal_api_token" -H "Content-Type: application/json" -d '{"text":"'"$1"'"}' "https://www.pivotaltracker.com/services/v5/projects/$p/stories/$s/comments"
    done
  done
}

Executor ()
{
  if [[ $TestKind = 'Android' ]]; then
    AndroidApp
  elif [[ $TestKind = 'Chrome' ]]; then
  	ChTest
  elif [[ $TestKind = 'protoolsWeb' ]]; then
  	protools_webTest
  elif [[ $TestKind = 'Firefox' ]]; then
    FfTest
  elif [[ $TestKind = 'Mobile' ]]; then
  	MobileSite
  elif [[ $TestKind = 'iOS' ]]; then
  	iOSApp
  elif [[ $TestKind = 'Api' ]]; then
  	ApiTest
  elif [[ $TestKind = 'api' ]]; then
  	NewApiTest
  elif [[ $TestKind = 'protools_api' ]]; then
  	ProToolsApiTest
  else
    Auto
  fi
  #common
  echo "SPch=$SPch"
  echo "SPprotools_web=$SPprotools_web"
  echo "SPff=$SPff"
  echo "SPmob=$SPmob"
  echo "SPapp=$SPapp"
  echo "SPnew_app=$SPnew_app"
  echo "SPiOS=$SPiOS"
  echo "SPapi=$SPapi"
  echo "SPapi=$SPapi"
  echo "SPprotools_api=$SPprotools_api"
  if [ $SPch -ge 15 -o $SPprotools_web -ge 15 -o $SPff -ge 15 -o $SPmob -ge 15 -o $SPapp -ge 15 -o $SPnew_app -ge 15 -o $SPiOS -ge 15 -o $SPapi -ge 15 -o $SPapi -ge 15 -o $SPprotools_api -ge 15 ]; then
	  GRID="$apiBadges $apiBadges $protools_apiBadges $badgesCH $badgesprotools_web $badgesff $MobileBadges $AppBadges $NewAppBadges $iOSBadges  $SheypoorResults $api_COMMENT $api_COMMENT $CH_COMMENT $FF_COMMENT $MOB_COMMENT $APP_COMMENT $NewAPP_COMMENT $iOS_COMMENT $ProToolsResults $protools_api_COMMENT $protools_web_COMMENT"
	  PRCOMMENT="### ${PR} Automatic Tests: ###\\n  $GRID"
	  for p in $PROJECTS ;do
	    for s in $pivotal_story ;do
	      status=$(curl --write-out 'http%{http_code}\n' -X GET --silent -H "X-TrackerToken: $pivotal_api_token" -H "Content-Type: application/json" -I "https://www.pivotaltracker.com/services/v5/projects/$p/stories/$s" | grep http200)
				echo $status
	      if [ "$status" == "http200" ];then
	        curl -X POST -H "X-TrackerToken: $pivotal_api_token" -H "Content-Type: application/json" -d '{"text":"'"$PRCOMMENT"'"}' "https://www.pivotaltracker.com/services/v5/projects/$p/stories/$s/comments"
					# if [ "$AT" == "0" ];then
					# 	curl -X POST -H "X-TrackerToken: $pivotal_api_token" -H "Content-Type: application/json" -d '{"name":"'"auto-test-failure"'"}' "https://www.pivotaltracker.com/services/v5/projects/$p/stories/$s/labels"
					# fi
	      fi
	    done
	  done
  else
    echo "we have problem:"
    echo "SPch=$SPch"
    echo "SPprotools_web=$SPprotools_web"
    echo "SPff=$SPff"
    echo "SPmob=$SPmob"
    echo "SPapp=$SPapp"
    echo "SPnew_app=$SPnew_app"
    echo "SPiOS=$SPiOS"
    echo "SPapi=$SPapi"
    echo "SPapi=$SPapi"
    echo "SPprotools_api=$SPprotools_api"
  fi
}

Health
if [[ $HEALTH -eq 0 ]]; then
	Executor
else
  JLink="http://trumpetbuild.mielse.com/view/All/job/Acceptance-Web-Pr/${BUILD_NUMBER}/robot/report/log.html"
  jenkinsLog=$(bit.ly $JLink)
	smokeBadgesLink=$(SetSheildBadges 0 'Smoke Test')
	smokeResult=$(<./smoke_test_error.txt)
	smokeBadges="[![API](${smokeBadgesLink})]($jenkinsLog)"
	GRID="$smokeBadges \\n The $SUT is unstable . \\n\\n  ** Details info : **  \\n$smokeResult\\n\\n ** more info : ** \\n  $jenkinsLog"
  PRCOMMENT="### PR ${trumpet_prenv_id} Automatic Tests Results: ###\\n  $GRID"
  for p in $PROJECTS ;do
    for s in $pivotal_story ;do
      status=$(curl --write-out 'http%{http_code}\n' -X GET --silent -H "X-TrackerToken: $pivotal_api_token" -H "Content-Type: application/json" -I "https://www.pivotaltracker.com/services/v5/projects/$p/stories/$s" | grep http200)
      if [ "$status" == "http200" ];then
        curl -X POST -H "X-TrackerToken: $pivotal_api_token" -H "Content-Type: application/json" -d '{"text":"'"$PRCOMMENT"'"}' "https://www.pivotaltracker.com/services/v5/projects/$p/stories/$s/comments"
      fi
    done
  done
fi

exit 0
#👍👎✔️❌

# curl -X POST -H "X-TrackerToken: 1f9ea564881613825d5b00c11e46b7ee" -H "Content-Type: application/json" -d '{"name":"my new label"}' "https://www.pivotaltracker.com/services/v5/projects/$p/stories/$s/labels"
