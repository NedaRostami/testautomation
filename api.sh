#!/bin/bash
if [ "$1" = '5.6.0' ]; then
  suite="--exclude notest --include $1 ./api/api.tests/"
else
  suite="--exclude notestOR5.6.0 ./api/api.tests/"
fi
noncritical="--skiponfailure noncritical"
testName="v$1"
FIRST ()
{
  echo "######################  Start  Sheypoor API $1##############################"
  pabot  --processes 100 -P ./lib/:./ $noncritical -d $logs/api -v ServerType:$ServerType -v general_api_version:$general_api_version -v trumpet_prenv_id:$trumpet_prenv_id -o output_first_run_$1.xml -l NONE -r NONE -v api_version:$1 --name $testName $suite
	: $(robot --nostatusrc -v xmlFile:$logs/api/output_first_run_$1.xml -v LogPath:$logs -v TestKind:api_${1} --output NONE --report NONE --log NONE  ./web/analyize_output.robot)
}
SECOND ()
{
  echo "##############  Running again failed in $1 **** first Run :$SP  ##############"
	pabot --processes 50 -P ./lib/:./ $noncritical -d $logs/api -v ServerType:$ServerType -v general_api_version:$general_api_version -v trumpet_prenv_id:$trumpet_prenv_id -R $logs/api/output_first_run_$1.xml -o output_second_run_$1.xml -l NONE -r NONE -v api_version:$1 --name $testName --exclude notest $suite
}

FIRST $1 &
wait
SP=$(cat ${logs}/api_${1}_SP_log.txt)
echo  "SP is $SP on ${testName}"

if [ "$SP" -le 99 -a "$SP" -ge 60 ]; then
  SECOND $1
  rebot --logtitle API --name $testName --nostatusrc -d $logs/api -o output_merged_$1.xml -l NONE -r NONE -R $logs/api/output_*_run_$1.xml
else
  mv $logs/api/output_first_run_$1.xml $logs/api/output_merged_$1.xml
fi

# : $(robot --nostatusrc -v xmlFile:$logs/api/output_merged_$1.xml -v LogPath:$logs -v TestKind:api_${1} --output NONE --report NONE --log NONE  ./web/analyize_output.robot)
chown -R$2:$3 /project/$logs
