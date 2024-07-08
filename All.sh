#!/bin/bash
############################################################################################################################
########################################### Functions ######################################################################
############################################################################################################################
GetSP ()
{
  local  __resultvar="SP_$1"
  if [ ! -f ${logs}/$1_SP_log.txt ]; then
    local  myresult=0
  else
    local  myresult=$(<${logs}/${1}_SP_log.txt)
    if [ -z "$myresult" ];then
      local  myresult=0
    fi
  fi
  eval $__resultvar=$myresult
}

TestiOS ()
{
    bash ./Apps.sh iOS
}

TestGradle ()
{
    bash ./gradle_test.sh ${PR} ${build}
}

TestMobCh ()
{
    bash ./web.sh MobCh
    rebot --logtitle Tests_on_MobCh__On_PR_${trumpet_prenv_id} --name ${trumpet_prenv_id} -d $logs -o output_${trumpet_prenv_id}_MobCh.xml -l ${trumpet_prenv_id}_MobCh_log.html -r ${trumpet_prenv_id}_MobCh_report.html  $logs/MobCh/output_merged.xml
    cp $logs/MobCh/*.png $logs/
    rm -rf $logs/MobCh
    # bash ./metrics.sh MobCh

}

TestWebFF ()
{
    bash ./web.sh ff &
    wait
    # bash ./metrics.sh ff
}

TestWebCH ()
{
    bash ./web.sh ch &
    wait
    # bash ./metrics.sh ch
}

TestMobileWeb ()
{
    bash ./Apps.sh mob
    # bash ./metrics.sh mob Mobile_Site
}

TestAndroid ()
{
    bash ./Apps.sh app
		: $(ssh mabdoli@${GRID_SERVER} './home/mabdoli/auto-tests/service.sh custom')
}

TestApi ()
{
    bash ./fastapi.sh
    rebot --logtitle api__On_PR_${trumpet_prenv_id} --name ${trumpet_prenv_id} -d $logs -o output_${trumpet_prenv_id}_api.xml -l ${trumpet_prenv_id}_api_log.html -r ${trumpet_prenv_id}_api_report.html $PWD/api_$logs/*/api/output_merged_*.xml
		robot --nostatusrc -v xmlFile:$logs/output_${trumpet_prenv_id}_api.xml -v LogPath:$logs -v TestKind:api --output NONE --report NONE --log NONE  ./web/analyize_output.robot
		GetSP api
		if [[ $SP_api -le 99 ]]; then
			rebot --logtitle api__On_PR_${trumpet_prenv_id} --name ${trumpet_prenv_id} -d $logs  --exclude passed -o NONE -l ${trumpet_prenv_id}_failed_api_log.html -r ${trumpet_prenv_id}_failed_api_report.html $PWD/api_$logs/*/api/output_merged_*.xml
		fi
		# bash ./metrics.sh api
}

TestProTools ()
{
    bash ./protools.sh 1 &
		wait
    bash ./protools.sh 2 &
		wait
		rebot --logtitle protools_api__On_PR_${trumpet_prenv_id} --name ${trumpet_prenv_id} -d $logs -o output_${trumpet_prenv_id}_protools_api.xml -l ${trumpet_prenv_id}_protools_api_log.html -r ${trumpet_prenv_id}_protools_api_report.html $logs/protools/output_merged_*.xml
		robot --nostatusrc -v xmlFile:$logs/output_${trumpet_prenv_id}_protools_api.xml -v LogPath:$logs -v TestKind:protools_api --output NONE --report NONE --log NONE  ./web/analyize_output.robot
		GetSP protools_api
		if [[ $SP_protools_api -le 99 ]]; then
			rebot --logtitle protools_api__On_PR_${trumpet_prenv_id} --name ${trumpet_prenv_id} -d $logs  --exclude passed -o NONE -l ${trumpet_prenv_id}_failed_protools_api_log.html -r ${trumpet_prenv_id}_failed_protools_api_report.html $logs/protools/output_merged_*.xml
		fi
	# bash ./metrics.sh protools_api
}

TestWebProoTools ()
{
    bash ./web.sh protools_web &
    wait
    # bash ./metrics.sh protools_web
}

TestAlounakApp ()
{
    bash ./alounak.sh 2 &
    wait
}

CheckServer ()
{
    local  __resultvar="Health"
    robot -d  $logs/smoke -P ./lib/ -P ./ -v ServerType:${ServerType} -v general_api_version:${general_api_version} -v trumpet_prenv_id:${trumpet_prenv_id} -o output_${trumpet_prenv_id}_smoke.xml -l ${trumpet_prenv_id}_smoke_log.html -r ${trumpet_prenv_id}_smoke_report.html  ./Smoke/smoke_test.robot
    # robot -d  $logs/smoke -P ./lib/ -P ./ -v trumpet_prenv_id:${trumpet_prenv_id} --output NONE --report NONE --log NONE ./Smoke/smoke_test.robot
    if [[ $? = 0 ]]; then
      local  myresult=0
    else
      local  myresult=1
			cp $logs/smoke/* $logs/
    fi
    eval $__resultvar=$myresult
    echo "$myresult" > ./Health.txt
    rm -rf $logs/smoke
}

Auto ()
{
if [ $backendChanged = true ]; then
	TestProTools &
  TestMobileWeb &
	TestWebCH &
	TestWebProoTools &
	TestApi &
	TestAndroid &
  TestAlounakApp &
	wait
else
  TestMobileWeb &
  TestWebCH &
	wait
fi
}

SheypoorX ()
{
if [ $backendChanged = true ]; then
  TestProTools &
  TestMobileWeb &
  TestWebCH &
  TestApi &
  wait
else
  TestMobileWeb &
  TestWebCH &
	wait
fi
}

Executor ()
{
	if [[ "$TestKind" = 'Android' ]]; then
	  TestAndroid
	elif [[ "$TestKind" = 'Chrome' ]]; then
		TestWebCH
	elif [[ "$TestKind" = 'ProToolsWeb' ]]; then
		TestWebProoTools
	elif [[ "$TestKind" = 'Firefox' ]]; then
		TestWebFF
	elif [[ "$TestKind" = 'Mobile' ]]; then
		TestMobileWeb
	elif [[ "$TestKind" = 'iOS' ]]; then
		TestiOS
	elif [[ "$TestKind" = 'mobileEmulation' ]]; then
		TestMobCh
  elif [[ "$TestKind" = 'sheypoor_api' ]]; then
      TestApi
  elif [[ "$TestKind" = 'protools_api' ]]; then
      TestProTools
  elif [[ "$TestKind" = 'alounak_app' ]]; then
      TestAlounakApp
	elif [[ "$TestKind" = 'Gradle' ]]; then
		TestGradle
	elif [[ "$TestKind" = 'Auto' ]]; then
    if [[ "$ServerType" = 'SheypoorX' ]]; then
      SheypoorX
    else
      Auto
    fi
	else
	    echo "no test kind is matched"
	fi

}
########################## set Vars Defaults ###############################
trumpet_prenv_id="${trumpet_prenv_id:=staging}"
REMOTE_TEST="${REMOTE_TEST:=Grid}"
backendChanged="${backendChanged:=false}"
build="${build:=test}"
file_url="${file_url:=http://trumpetbuild.mielse.com:8001/android_build/v5.8.1/debug/Sheypoor-PlayStoreDebug.apk}"
file_version="${file_version:=6.4.0}"
general_api_version="${general_api_version:=6.4.0}"
TestKind="${TestKind:=Auto}"
ServerType="${ServerType:=Staging}"

export LIVE_IP="79.175.191.72"
export STAGING_IP="95.156.254.82"
export QA_IP="148.251.88.101"
export QA2_IP="88.198.62.229"
export PRS_IP="10.10.0.15"
export GRID_SERVER="10.10.0.9"
export QA_SERVER="qa.mielse.com"
export QA2_SERVER="qa2.mielse.com"
export logs="Reports"
export REMOTE_TEST="${REMOTE_TEST}"
export PR="${trumpet_prenv_id}"
export trumpet_prenv_id="${trumpet_prenv_id}"
export build="${build}"
export general_api_version="${general_api_version}"


# if [[ "$trumpet_prenv_id" == '1089' ]]; then
#   git checkout -b android origin/android || true
# fi

if [[ ${ServerType} == "Staging" ]]; then
	export trumpet_prenv_id="staging"
else
	export trumpet_prenv_id="${trumpet_prenv_id}"
fi

if [[ ${trumpet_prenv_id} == "Live" ]]; then
	SUT="sheypoor.com"
	SUT_IP="${LIVE_IP}"
elif [[ ${trumpet_prenv_id} == "staging" ]]; then
	SUT="staging.mielse.com"
	SUT_IP="${STAGING_IP}"
elif [ $ServerType == "ProTools" ]; then
	SUT="protools${trumpet_prenv_id}.mielse.com"
	SUT_IP="${PRS_IP}"
	export TestKind="ProToolsWeb"
	export PRID="protools${trumpet_prenv_id}"
elif [ $ServerType == "SheypoorX" ]; then
	SUT="shx${trumpet_prenv_id}.mielse.com"
	SUT_IP="${STAGING_IP}"
	export PRID="shx${trumpet_prenv_id}"
else
	SUT="pr${trumpet_prenv_id}.mielse.com"
	SUT_IP="${PRS_IP}"
	export PRID="pr${trumpet_prenv_id}"
fi

export SUT="${SUT}"
export SUT_IP="${SUT_IP}"

# echo "${SUT_IP} ${SUT}" | sudo tee -a /etc/hosts


############################################################################################################################
##################################### Run ##################################################################################
############################################################################################################################
# if [[ "$trumpet_prenv_id" == '10335' ]]; then
#   git checkout -b post-listing origin/post-listing || true
# fi


# if [[ "$trumpet_prenv_id" != 'staging' ]]; then
# 	RESPONSE_CODE=`curl -s -o /dev/null  --insecure -w "%{http_code}" https://token-n7ncf:79ndwg5hfg84g9dmzjnhzc7vpzn85vw5mj96wsm7h5w8gfcp9mbdnx@rancher.mielse.com:8443/v3/cluster/c-mv7js/namespaces/$PRID`
# 	echo "$PRID returned $RESPONSE_CODE"
# 	if [ $RESPONSE_CODE != "200" ]; then
# 		echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
# 		echo "XXXXXXXXXXXXXXXXXXXXXX  Error: The $SUT is not running or has been killed by someone XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
# 		echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
# 		exit 1
# 	fi
# fi


CheckServer  ${trumpet_prenv_id}
if [[ $Health -eq 0 ]]; then
	echo "✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️  The $SUT is WARMMMMMMMMMMMMED UPPPPPPPPPPPPP ✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️✔️"
	Executor
else
	echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
	echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    The $SUT is unreachable :$Health XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
	echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
	exit 0
fi
