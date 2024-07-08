#!/bin/bash
# get all running docker container names
# usage:  start 14 0
# usage   restart Web / Android / Mobile
ports ()
{
	list=$(docker inspect --format='{{(index (index .NetworkSettings.Ports "6080/tcp") 0).HostPort}}' $(docker ps --format "{{.ID}}" --filter name=$1))
  echo ${list[*]}| tr " " "\n" | sort -g >> ports.txt
  mv ports.txt /var/lib/docker/qa/ports/
}
GetDockerName ()
{
  containers=$(docker ps --format "{{.Names}}" --filter name=${2})
  if [[ ! -z "$containers" ]]; then
    # loop through all containers
    for container in $containers;do
      name="$(docker exec -i $container curl -s localhost:4723/wd/hub/sessions | jq -r '.value[0].capabilities.name')"
      # $(docker exec -i $container adb logcat -c)
      # name="Chat_Test_Saler_Build4221_PRstaging_1"
      if [[ $name == "${1}" ]]; then
        dockername="$container"
        break
      else
        dockername="No"
      fi
    done
  echo ${dockername}
  fi
}

PrintDockerName ()
{
  containers=$(docker ps --format "{{.Names}}" --filter name=${1})
  if [[ ! -z "$containers" ]]; then
    # loop through all containers
    for container in $containers;do
      name="$(docker exec -i $container curl -s localhost:4723/wd/hub/sessions | jq -r '.value[0].capabilities.name')"
      echo "test:${name} in docker ${container}"
    done
  fi
}

postbuild ()
{
	name="${1:-Android}"
  containers=$(docker ps --format "{{.Names}}" --filter name=$name)
  if [[ ! -z "$containers" ]]; then
    # loop through all containers
    for container in $containers;do
			unset coords
			unset health
			echo "################################### $container###########################"
			echo "##############################################################"
			health=$(docker inspect $container | jq '.[].State.Health.Status')
			if [ "$health" = 'unhealthy' ]; then
				docker restart $container &
				continue
			fi
			echo "get view"
      : $(docker exec -i $container adb pull $(docker exec -i $container adb shell uiautomator dump | grep -oP '[^ ]+.xml') /tmp/view.xml)
      : coords=$(docker exec -i $container perl -ne 'printf "%d %d\n", ($1+$3)/2, ($2+$4)/2 if /text="Close app"[^>]*bounds="\[(\d+),(\d+)\]\[(\d+),(\d+)\]"/' /tmp/view.xml)
			if [ -z "$coords" ]; then
				echo "$container has no problem"
			else
				echo "!!!!!!!!!!!!!!!!!!!!! $container has problem!!!!!!!!!!!!!!!!"
				: $(docker exec -i $container adb shell input tap $coords )
			fi
			docker exec -i $container bash /root/src/utils.sh
    done
  fi
}

Unhealthy ()
{
  containers=$(docker ps --format "{{.Names}}" --filter health=unhealthy)
  if [ ! -z "$containers" ]; then
  	echo "Restart Unhealthy Emulators"
    echo ================================
    # loop through all containers
    for container in $containers;do
			echo "Container: $container"
	    docker restart $container
      echo ================================
    done
  fi
}

restart () {
	containers=$(docker ps --format "{{.Names}}" --filter name=$1)
  if [[ ! -z "$containers" ]]; then
  	echo "Restart Emulators"
    echo ================================
    # loop through all containers
    for container in $containers;do
	    echo "Container: $container"
	    docker restart $container
      echo ================================
    done
  fi
	Unhealthy
}

HowManyHealth ()
{
	let "a = $2 + 1"
  while : ; do
    containers=$(docker ps | grep healthy | grep -v unhealthy | wc -l)
		# containers=$(docker ps --format "{{.Names}}" --filter name=$1 | grep -v unhealthy | wc -l)
    echo "healthy:$containers"
    if [[ $containers -eq $a ]]; then
      echo "healthy containers are $containers"
      break
    fi
    sleep 5;
  done;
}

restartZA () {
  cd /home/mabdoli/dockers/web
	if [ "$1" = 'up' ]; then
    : $(COMPOSE_HTTP_TIMEOUT=200 docker-compose up --force-recreate -d)
	else
    : $(docker-compose down)
	fi
}

QA () {
  check=$(docker exec -it mob_$2_$1  adb shell 'su 0 ls -1 /mnt/sdcard/Pictures/ | wc -l')
  if [[ $check -ne "8" ]]; then
    resp=$(docker exec -i mob_$2_$1 ./src/sheypoor.sh)
    echo $resp
  else
    echo $check
  fi
}

Images ()
{
	containers=$(docker ps --format "{{.Names}}" --filter name=$1)
	if [[ ! -z "$containers" ]]; then
		for container in $containers;do
			echo "Container: $container"
			resp=$(docker exec -i $container ./src/sheypoor.sh)
			while [[ $resp -ne "8" ]];
			do
				sleep 1;
				resp=$(docker exec -i $container ./src/sheypoor.sh)
			done;
		done
	fi
}

Finished () {
  counter=$(QA $1 $2)
  while [[ $counter -ne "8" ]];
  do
    sleep 1;
    counter=$(QA $1 $2)
  done;
  echo "8"
}

Exist () {
	exist=$(docker ps --format "{{.Names}}" --filter name=mob_$2_$1)
	if [[ $exist -eq "mob_$2_$1" ]]; then
		echo "YES"
	else
		echo "NO"
	fi
}

Health () {
  status=$(Exist $1 $2)
	if [[ $status -eq "YES" ]]; then
		containers=$(docker ps --format "{{.Names}}" --filter health=unhealthy)
		if [ ! -z "$containers" ]; then
			for container in $containers;do
				if [[ $container -eq "mob_$2_$1" ]]; then
					docker stop mob_$2_$1
          docker rm mob_$2_$1
					echo "NO"
				fi
			done
			echo "YES"
		else
			echo "YES"
		fi
	else
		echo "NO"
	fi
}

StopUnhealth () {
	containers=$(docker ps --format "{{.Names}}" --filter health=unhealthy)
	if [ ! -z "$containers" ]; then
		for container in $containers;do
			docker stop $container
      docker rm $container
		done
		count=${#container[@]}
		echo $[count-1]
  else
		echo 0
	fi
}


AdbShell () {
	containers=$(docker ps --format "{{.Names}}" --filter name=$1)
  if [[ ! -z "$containers" ]]; then
  	echo "Run Adb Shell commands"
    echo ================================
    for container in $containers;do
	    echo "Container: $container"
      :$(docker exec  $container adb shell 'su 0 settings put secure location_providers_allowed +gps')
      :$(docker exec  $container adb shell 'su 0 settings put global window_animation_scale 0.0')
      :$(docker exec  $container adb shell 'su 0 settings put global transition_animation_scale 0.0')
      :$(docker exec  $container adb shell 'su 0 settings put global animator_duration_scale 0.0')
      :$(docker exec  $container adb shell 'su 0 settings put secure show_ime_with_hard_keyboard 0')
      docker exec  $container adb shell 'su 0 am broadcast -a com.android.intent.action.SET_LOCALE --es com.android.intent.extra.LOCALE fa_IR'
      :$(docker exec  $container adb shell 'su 0 settings put secure location_providers_allowed +gps')
      :$(docker exec  $container adb -s emulator-5554 emu geo fix 51.4 35.7  1400)
      # adb shell 'su 0 pm grant com.sheypoor.mobile android.permission.ACCESS_FINE_LOCATION'
      # adb root
      # adb shell "setprop persist.sys.language fa; setprop persist.sys.country IR; setprop ctl.restart zygote"
      echo ================================
    done
  else
    echo "No emulator found"
  fi
}

CudtomAdb () {
	containers=$(docker ps --format "{{.Names}}" --filter name=app_Android)
  if [[ ! -z "$containers" ]]; then
  	echo "Run Adb Shell commands"
    echo ================================
    for container in $containers;do
	    echo "Container: $container"
      docker exec  $container adb uninstall com.sheypoor.mobile

      echo ================================
    done
  else
    echo "No emulator found"
  fi
}

ClearGoogle () {
	containers=$(docker ps --format "{{.Names}}" --filter name=$1)
  if [[ ! -z "$containers" ]]; then
  	echo "Run Adb Shell commands"
    echo ================================
    for container in $containers;do
	    echo "Container: $container"
      docker exec $container adb shell pm clear com.google.android.ext.services
      docker exec $container adb shell pm clear com.google.android.ext.shared
      echo ================================
    done
  else
    echo "No emulator found"
  fi
}

dispatch ()
{
	if [ "$1" = 'unhealth' ]; then
		Unhealthy
  elif [ "$1" = 'ports' ]; then
    ports $2
  elif [ "$1" = 'shell' ]; then
    AdbShell $2
  elif [ "$1" = 'ClearGoogle' ]; then
    ClearGoogle $2
  elif [ "$1" = 'GetDockerName' ]; then
    GetDockerName $2
  elif [ "$1" = 'chromedriver' ]; then
    chromedriver
	elif [ "$1" = 'names' ]; then
		PrintDockerName	$2
	elif [ "$1" = 'postbuild' ]; then
		postbuild	$2
	elif [ "$1" = 'custom' ]; then
		CudtomAdb
	else
		echo "Please specify commands by sending as arg to bash: 1:$1 2:$2 3:$3"
	fi
}
dispatch $1 $2 $3 $4
