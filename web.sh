#!/bin/bash
if [ "$1" = 'ff' ]; then
	#excl="--exclude Trumpet  --exclude serp  --exclude js"
  case="Firefox"
  excl="--exclude   notest   jsunit  edit_Listing"
	BrowserName="Firefox"
  suite="./web/desktop.tests"
  noncritical="--skiponfailure noncritical"
  processes="8"
  rerunPercent=60
elif [ "$1" = 'MobCh' ]; then
  case="Mobile__Chrome"
	excl="--exclude  notest  Trumpet  NoMob  jsunit"
  BrowserName="Chrome"
  suite="./MobCh/MobCh.Tests"
  noncritical="--skiponfailure noncritical"
  processes="8"
  rerunPercent=60
elif [ "$1" = 'smoke' ]; then
  case="Smoke__Test"
	excl="--exclude  notest"
  BrowserName="Chrome"
  suite="./Smoke"
  noncritical="--skiponfailure noncritical"
  rerunPercent=60
  processes="16"
elif [ "$1" = 'protools_web' ]; then
  case="Protools__Web"
	excl="--exclude  notest"
  BrowserName="Chrome"
  suite="./ProTools/Web/protools.web.tests"
  noncritical="--skiponfailure noncritical"
  processes="16"
  rerunPercent=60
else
  case="Desktop__Chrome"
	excl="--exclude  notest"
	BrowserName="Chrome"
  suite="./web/desktop.tests"
  noncritical="--skiponfailure noncritical"
  processes="20"
  rerunPercent=60
fi
if [ "$trumpet_prenv_id" = 'staging' ] || [ "$trumpet_prenv_id" = 'Live' ]; then
	excl=$excl
else
	excl="$excl --exclude header"
fi

FIRST ()
{
  echo "######################  Start $1 $BrowserName##############################"
  pabot --processes $processes -P ./ -P ./lib/ $noncritical -v ServerType:$ServerType -v protools_version:2 -v general_api_version:$general_api_version  -v trumpet_prenv_id:${trumpet_prenv_id} -d $logs/$1 -v HEADLESS:No -v RecordV:Yes -v Round:1 -A ./vars/$1.txt  -o output_first_run.xml -l NONE -r NONE $excl $suite
  : $(robot -d  $logs  --nostatusrc -v xmlFile:$logs/$1/output_first_run.xml -v LogPath:$logs -v TestKind:$1 --output NONE --report NONE --log NONE  ./web/analyize_output.robot)
}

SECOND ()
{
  echo "##############  Running again failed in $1 $BrowserName **** first Run :$SP  ##############"
	pabot --processes $processes -P ./ -P ./lib/ $noncritical -v ServerType:$ServerType -v protools_version:2 -v general_api_version:$general_api_version  -v trumpet_prenv_id:${trumpet_prenv_id} -d $logs/$1 -v HEADLESS:No -v RecordV:Yes -v Round:2 -A ./vars/$1.txt -R $logs/$1/output_first_run.xml -o output_second_run.xml -l NONE -r NONE  --exclude nosecond $suite
}

FIRST $1 &
wait
SP=$(<${logs}/${1}_SP_log.txt)
#
if [ "$SP" -le 99 -a "$SP" -ge $rerunPercent ]; then
  rm $logs/$1/*.png
  SECOND $1
else
  echo "no Running again needed in $1 first Run :$SP"
fi


rebot --logtitle Tests__on_${case}__On_PR_${trumpet_prenv_id} --name ${trumpet_prenv_id} --nostatusrc -d $logs -o output_${trumpet_prenv_id}_${1}.xml -l ${trumpet_prenv_id}_${1}_log.html -r ${trumpet_prenv_id}_${1}_report.html -R $logs/$1/output_*_run.xml
robot -d  $logs  --nostatusrc -v xmlFile:$logs/output_${trumpet_prenv_id}_${1}.xml -v LogPath:$logs -v TestKind:$1 --output NONE --report NONE --log NONE  ./web/analyize_output.robot

cp $logs/$1/*.png $logs/
rm -rf $logs/${1}
