#!/bin/bash
GRID="polsrv07.mielse.com"
qa2="polsrv07.mielse.com"
PROJECTS="1564155 1485854 1497322 2135233 1566837 1975863 2193084"
pivotal_api_token="9db9d99f6c0ede4d927d104f575a90bb"
logs="Reports"
MORE_INFO="\\n\\n*** More info:***"
ANDROiD="\\n\\n*** Android Tests: ***"
WEB="\\n*** Web Browser: ***"
iOS="\\n\\n*** iOS Tests: ***"
Results="\\n\\n*** Results: ***"
SUT="https://pr5555.mielse.com"

SPch=85
SPprotools_web=75
SPff=0
SPmob=35
SPapp=85
SPnew_app=0
SPiOS=0
SPapi=88
SPapi=99
SPprotools_api=0

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
  GRID="$apiBadges $apiBadges $protools_apiBadges $badgesCH $badgesprotools_web $badgesff $MobileBadges $AppBadges $NewAppBadges $iOSBadges  $Results $api_COMMENT $api_COMMENT $protools_api_COMMENT $CH_COMMENT $protools_web_COMMENT $FF_COMMENT $MOB_COMMENT $APP_COMMENT $NewAPP_COMMENT $iOS_COMMENT "
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
