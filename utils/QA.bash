#!/bin/bash
PRID=$1
RESPONSE_CODE=`curl -s -o /dev/null -w "%{http_code}" https://token-wzwvm:jtkd4dqb2sb7s94n7mqm9kf48czzqwlpgv4qbl2dffqgzwhsht7vtg@rancher.mielse.com:8443/v3/cluster/c-cjdh2/namespaces/$PRID`
echo "$PRID returned $RESPONSE_CODE"
if [ $RESPONSE_CODE != "200" ]; then echo Error: Pr is not running or has been killed by someone && exit 1; fi


