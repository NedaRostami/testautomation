#! /bin/bash
# a dockercompose restart for refereshing the env resources
# docker stop $(docker ps --format "{{.Names}}" --filter name=zalenium) || docker rm $(docker ps --format "{{.Names}}" --filter name=zalenium)
docker container prune -f
/usr/local/bin/docker-compose -f /home/qa/dockers/test-dockers/web/docker-compose.yaml down > /dev/null
/usr/local/bin/docker-compose -f /home/qa/dockers/test-dockers/web/docker-compose.yaml up -d > /dev/null
echo "docker-compose restarted at $(date) >> /tmp/dockercompose.debug"
