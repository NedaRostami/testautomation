#!/bin/bash
export SP="0"
noncritical="--skiponfailure noncritical"
excl="notest"

if [ "$1" = 'app' ]; then
	suite="./Android/android.tests"
	TestType="Android_App"
	rerunPercent=60
	processes=14
elif [ "$1" = 'iOS' ]; then
	suite="./iOS/iOS.Tests"
	TestType="iOS_App"
	rerunPercent=80
	processes=14
elif [ "$1" = 'mob' ]; then
	suite="./Mobile/mobilesite.tests"
  TestType="Mobile_Site"
	rerunPercent=40
	processes=4
elif [ "$1" = 'ff' ]; then
	suite="./web/desktop.tests"
	TestType="Firefox"
	rerunPercent=40
	processes=5
elif [ "$1" = 'MobCh' ]; then
	suite="./MobCh/MobCh.Tests"
  TestType="Mobile_Chrome"
	rerunPercent=40
  processes=5
elif [ "$1" = 'smoke' ]; then
	suite="./Smoke"
  TestType="Smoke"
  rerunPercent=40
  processes="5"
elif [ "$1" = 'protools_web' ]; then
  suite="./ProTools/Web/protools.web.tests"
	TestType="Chrome"
	rerunPercent=40
  processes=8
elif [ "$1" = 'ch' ]; then
	suite="./web/desktop.tests"
	TestType="Chrome"
  rerunPercent=40
  processes=15
elif [ "$1" = 'protool_api' ]; then
	suite="./ProTools/api/protools.api.tests"
	TestType="protool_api"
  rerunPercent=40
  processes=50
	version=$2
fi

# --RemoveKeywords WUKS
COMMON_OPTIONS="--processes $processes -d $logs/$1 -P ./lib/:./ $noncritical -v PR:${PR} -A ./vars/$1.txt -v HEADLESS:Yes -l NONE -r NONE --exclude $excl"
OPTIONS="-v PR:${PR} -A ./vars/$1.txt -v HEADLESS:Yes"

function FIRST ()
{
    echo "######################  Start $TestType ##############################"
    pabot $OPTIONS -v Round:1 -o output_first_run.xml $suite
    : $(robot -d $logs  --nostatusrc -v xmlFile:$logs/output_first_run.xml -v LogPath:$logs  -v TestKind:$1  --output NONE --report NONE --log NONE  ./web/analyize_output.robot)
}

function SECOND ()
{
		echo "##############  Running again failed in $TestType **** first Run :$SP  ##############"
    pabot $OPTIONS -R $logs/$1/output_first_run.xml -o output_second_run.xml -v Round:2 --exclude Chat $suite
}

function run ()
{
FIRST $1 &
wait
SP=$(<${logs}/${1}_SP_log.txt)

if [ "$SP" -le 99 -a "$SP" -ge $rerunPercent ]; then
  rm $logs/$1/*.png
  SECOND $1
fi

rebot --logtitle ${TestType}_On_${PR}_${trumpet_prenv_id} --name ${PR} $noncritical -d $logs -o output_${PR}_${TestType}.xml -l ${PR}_${TestType}_log.html -r ${PR}_${TestType}_report.html -R $logs/${1}/output_*_run.xml
robot -d  $logs  --nostatusrc -v xmlFile:$logs/output_${PR}_${TestType}.xml -v PR:${PR} -v LogPath:$logs  -v TestKind:${1}  --output NONE --report NONE --log NONE  ./web/analyize_output.robot

cp $logs/$1/*.png $logs/
rm -rf $logs/${1}

}

run $1
