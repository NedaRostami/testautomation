#!/bin/bash
export SP="0"
if [ "$1" = 'app' ]; then
	suite="./Android/android.tests"
	case="Android_App"
  Remote="Grid"
  excl="--exclude notest --exclude wrongprices"
	noncritical="--skiponfailure noncritical"
	rerunPercent=50
	processes=12
elif [ "$1" = 'iOS' ]; then
	suite="./iOS/iOS.Tests"
	case="iOS App"
  Remote="Grid"
	excl=""
	noncritical="--skiponfailure noncritical"
	rerunPercent=50
	processes=5
else
	suite="./Mobile/mobilesite.tests"
  case="Mobile_Site"
  Remote="Grid"
	excl=""
	noncritical="--skiponfailure noncritical"
	rerunPercent=38
	processes=2
fi
# --RemoveKeywords WUKS
OPTIONS="--processes $processes -d $logs/$1 -P ./lib/:./ $noncritical -v ServerType:$ServerType -v general_api_version:${general_api_version} -v PR:${PR} -A ./vars/$1.txt -v HEADLESS:Yes -l NONE -r NONE -v REMOTE_TEST:$Remote $excl"

function FIRST ()
{
    echo "######################  Start $1 ##############################"
    pabot $OPTIONS -v Round:1 -o output_first_run.xml $suite
    : $(robot -d $logs  --nostatusrc -v xmlFile:$logs/$1/output_first_run.xml -v LogPath:$logs  -v TestKind:$1  --output NONE --report NONE --log NONE  ./web/analyize_output.robot)
}

function SECOND ()
{
		echo "##############  Running again failed in $1 **** first Run :$SP  ##############"
    pabot $OPTIONS -R $logs/$1/output_first_run.xml -o output_second_run.xml -v Round:2 --exclude Chat $suite
}

function run ()
{
FIRST $1 &
wait
SP=$(<${logs}/${1}_SP_log.txt)

if [ "$SP" -le 99 -a "$SP" -ge $rerunPercent ]; then
  # rm $logs/$1/*.png
  SECOND $1
else
	echo "no Running again needed in $1 first Run :$SP"
fi

rebot --logtitle ${case}_On_${PR}_${trumpet_prenv_id} --name ${PR} -d $logs -o output_${PR}_${case}.xml -l ${PR}_${case}_log.html -r ${PR}_${case}_report.html -R $logs/${1}/output_*_run.xml
robot -d  $logs  --nostatusrc -v xmlFile:$logs/output_${PR}_${case}.xml -v PR:${PR} -v LogPath:$logs  -v TestKind:${1}  --output NONE --report NONE --log NONE  ./web/analyize_output.robot

cp $logs/$1/*.png $logs/
rm -rf $logs/${1}
}

run $1
# echo "NO ANDROID TEST WILL BE EXECUTED AS IT SEEMS IT IS NOY NECESSARY AT ALL"
