#!/bin/bash
GetGitReps ()
{
  rm -rf unit/.[a-zA-Z_-]*
  cd unit/
  wget http://trumpetbuild.mielse.com:8001/pr-build/$1/"$1".tar.gz
  tar -xzvf $1.tar.gz
}
GetUnitTestResult ()
{
  local  __resultvar="UnitTest"
  if [ ! -f ./unit/result.txt ]; then
    local  myresult=1
  else
    local  myresult=$(<./unit/result.txt)
    if [ -z "$myresult" ];then
      local  myresult=1
    fi
  fi
  eval $__resultvar=$myresult
}
Report{
  : $(GetUnitTestResult)
  if [[ $UnitTest -eq 0 ]]; then
  	echo "YES"
  else
    echo "NO"
  fi
}
CleanUp ()
{
  cp ./gradle.txt /var/lib/docker/qa/vids/AndroidApp/$1/
  cd /root
  rm -rf unit/*
}
GetGitReps $1
bash ./unit/unit.sh
Report
CleanUp
GradleTest=$(ssh mabdoli@${GRID_SERVER} 'docker exec -i android-gradle bash /home/mabdoli/dockers/mob/gradle/unit/unit.sh $1 $2')
