#!/bin/bash
suite="./ProTools/api/protools.api.tests"
noncritical="--skiponfailure noncritical"
protools_version=$1
testName="v$1"
FIRST ()
{
  echo "######################  Start  ProTools $1##############################"
  pabot  --processes 100 $noncritical -d $logs/protools -P ./ -P ./lib/ -v ServerType:$ServerType -v protools_version:$protools_version -v general_api_version:$general_api_version -v trumpet_prenv_id:$trumpet_prenv_id -o output_first_run_${1}.xml -l NONE -r NONE --name $testName --exclude notest $suite
	: $(robot -d  $logs  --nostatusrc -v xmlFile:$logs/protools/output_first_run_${1}.xml -v LogPath:$logs -v TestKind:protools_api_${1} --output NONE --report NONE --log NONE  ./web/analyize_output.robot)
}

SECOND ()
{
	echo " #  Running again failed in ProTools api **** first Run :$SP  #"
	pabot --processes 50 $noncritical -d $logs/protools -P ./ -P ./lib/ -v ServerType:$ServerType -v protools_version:$protools_version -v general_api_version:$general_api_version -v trumpet_prenv_id:$trumpet_prenv_id -R $logs/protools/output_first_run_${1}.xml -o output_second_run_${1}.xml -l NONE -r NONE --name $testName --exclude notest $suite
}

FIRST $1 &
wait
SP=$(<${logs}/protools_api_${1}_SP_log.txt)

if [ "$SP" -le 99 -a "$SP" -ge 60 ]; then
  SECOND $1
  rebot --logtitle PROTOOLS_API__On_PR_${trumpet_prenv_id} --name $testName -d $logs/protools -o output_merged_$1.xml -l NONE -r NONE -R $logs/protools/output_*_run_$1.xml
else
  echo "no Running again needed in protools_api_V$1 first Run :$SP"
  mv $logs/protools/output_first_run_$1.xml $logs/protools/output_merged_$1.xml
fi
