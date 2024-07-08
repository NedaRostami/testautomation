#!/bin/bash

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

GetSP ()
{
  if [ ! -f ${logs}/$1_SP_log.txt ]; then
    local  myresult=0
  else
    local  myresult=$(<${logs}/${1}_SP_log.txt)
    if [ -z "$myresult" ];then
      local  myresult=0
    fi
  fi
	GetStatus $myresult
  echo $myresult
}

if [[ -z "${2}" ]]; then
    metrics_file="${trumpet_prenv_id}_${1}_metrics.html"
    log_file="${trumpet_prenv_id}_${1}_log.html"
    report_file="${trumpet_prenv_id}_${1}_report.html"
    output_file="output_${trumpet_prenv_id}_${1}.xml"
else
    metrics_file="${PR}_${2}_metrics.html"
    log_file="${PR}_${2}_log.html"
    report_file="${PR}_${2}_report.html"
    output_file="output_${PR}_${2}.xml"
fi

SP=$(GetSP $1)

product="sheypoor"

if [[ "$1" == 'ch' || "$1" == 'ff' ]]; then
    platform="desktop"
elif [[ "$1" == 'MobCh' || "$1" == 'mob' ]]; then
    platform="mobile"
elif [[ "$1" == 'app' ]]; then
    platform="Android"
elif [[ "$1" == 'api' ]]; then
    platform="api"
elif [[ "$1" == 'protools_api' ]]; then
    platform="api"
    product="protools"
elif [[ "$1" == 'protools_web' ]]; then
    platform="desktop"
    product="protools"
fi

python3 metrics_logo.py ${product} ${platform} ${trumpet_prenv_id} ${SP} ${logs}/${product}_${trumpet_prenv_id}_${platform}_logo

logo=${product}_${trumpet_prenv_id}_${platform}_logo.png
echo "(cd ${logs}; robotmetrics -M ${metrics_file} -O ${output_file} -L ${log_file} -R${report_file} --logo ${logo})"
(cd ${logs}; robotmetrics -M ${metrics_file} -O ${output_file} -L ${log_file} -R${report_file} --logo ${logo})
echo "*************** Created Output For $1 ***************"
