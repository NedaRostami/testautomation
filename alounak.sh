#!/bin/bash
suite="./ProTools/Android/Aloonak/aloonak.test"
processes=$1
# ServerType=Staging
# general_api_version=6.4.0
# trumpet_prenv_id=staging
# logs=Reports/Alounak
testName="v$file_version"
FIRST ()
{
  echo "######################  Start  Alounak App ##############################"
  pabot  --processes $processes -A ./vars/alounak_app.txt -v ServerType:$ServerType -v general_api_version:$general_api_version -v trumpet_prenv_id:$trumpet_prenv_id -o output_first_run.xml -l NONE -r NONE --name $testName --exclude notest $suite
	: $(robot -d $logs --nostatusrc -v xmlFile:$logs/alounak/output_first_run.xml -v LogPath:$logs -v TestKind:alounak_app --output NONE --report NONE --log NONE  ./web/analyize_output.robot)
}

SECOND ()
{
	echo "######################  Running again failed in Alounak App **** first Run :$SP  ######################"
	pabot --processes $processes -A ./vars/alounak_app.txt -v ServerType:$ServerType -v general_api_version:$general_api_version -v trumpet_prenv_id:$trumpet_prenv_id -R $logs/alounak/output_first_run.xml -o output_second_run.xml -l NONE -r NONE --name $testName --exclude notest $suite
}

FIRST &
wait
SP=$(<${logs}/alounak_app_SP_log.txt)

if [ "$SP" -le 99 -a "$SP" -ge 60 ]; then
  rm -rf $logs/alounak/*.png
  SECOND
else
  echo "no Running again needed in alounak app first Run :$SP"
fi

rebot --logtitle Alounak_app__on_${trumpet_prenv_id} --name ${trumpet_prenv_id} --nostatusrc -d $logs -o output_${trumpet_prenv_id}_alounak_app.xml -l ${trumpet_prenv_id}_alounak_app_log.html -r ${trumpet_prenv_id}_alounak_app_report.html -R $logs/alounak/output_*_run.xml
robot -d  $logs  --nostatusrc -v xmlFile:$logs/output_${trumpet_prenv_id}_alounak_app.xml -v LogPath:$logs -v TestKind:alounak_app --output NONE --report NONE --log NONE  ./web/analyize_output.robot

cp $logs/alounak/*.png $logs/
rm -rf $logs/alounak
