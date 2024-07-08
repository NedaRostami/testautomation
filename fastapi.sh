#!/bin/bash

: $(docker pull registry.mielse.com/qa/test-dockers/python:3.6-alpine)
: $(docker build -t fast-api -f Dockerfile-api .)

: $(mkdir `dirname $(realpath fastapi.sh)`/api_$logs)

hosts="--add-host=${SUT}:${SUT_IP} --add-host=${QA_SERVER}:${QA_IP} --add-host=${QA2_SERVER}:${QA2_IP} --add-host=staging.mielse.com:${STAGING_IP} --add-host=sheypoor.com:${LIVE_IP}"

docker run $hosts --network=host --rm --name api-v3.0.2 -v `dirname $(realpath fastapi.sh)`/api_$logs/3.0.2:/project/$logs -e logs=$logs -e trumpet_prenv_id=$trumpet_prenv_id fast-api 3.0.2 $(id -u) $(id -g) & \
docker run $hosts --network=host --rm --name api-v3.0.3 -v `dirname $(realpath fastapi.sh)`/api_$logs/3.0.3:/project/$logs -e logs=$logs -e trumpet_prenv_id=$trumpet_prenv_id fast-api 3.0.3 $(id -u) $(id -g) & \
docker run $hosts --network=host --rm --name api-v3.0.4 -v `dirname $(realpath fastapi.sh)`/api_$logs/3.0.4:/project/$logs -e logs=$logs -e trumpet_prenv_id=$trumpet_prenv_id fast-api 3.0.4 $(id -u) $(id -g)
docker run $hosts --network=host --rm --name api-v3.0.5 -v `dirname $(realpath fastapi.sh)`/api_$logs/3.0.5:/project/$logs -e logs=$logs -e trumpet_prenv_id=$trumpet_prenv_id fast-api 3.0.5 $(id -u) $(id -g) & \
docker run $hosts --network=host --rm --name api-v3.1.0 -v `dirname $(realpath fastapi.sh)`/api_$logs/3.1.0:/project/$logs -e logs=$logs -e trumpet_prenv_id=$trumpet_prenv_id fast-api 3.1.0 $(id -u) $(id -g) & \
docker run $hosts --network=host --rm --name api-v3.1.1 -v `dirname $(realpath fastapi.sh)`/api_$logs/3.1.1:/project/$logs -e logs=$logs -e trumpet_prenv_id=$trumpet_prenv_id fast-api 3.1.1 $(id -u) $(id -g)
docker run $hosts --network=host --rm --name api-v3.1.2 -v `dirname $(realpath fastapi.sh)`/api_$logs/3.1.2:/project/$logs -e logs=$logs -e trumpet_prenv_id=$trumpet_prenv_id fast-api 3.1.2 $(id -u) $(id -g) & \
docker run $hosts --network=host --rm --name api-v3.1.3 -v `dirname $(realpath fastapi.sh)`/api_$logs/3.1.3:/project/$logs -e logs=$logs -e trumpet_prenv_id=$trumpet_prenv_id fast-api 3.1.3 $(id -u) $(id -g) & \
docker run $hosts --network=host --rm --name api-v3.1.4 -v `dirname $(realpath fastapi.sh)`/api_$logs/3.1.4:/project/$logs -e logs=$logs -e trumpet_prenv_id=$trumpet_prenv_id fast-api 3.1.4 $(id -u) $(id -g)
docker run $hosts --network=host --rm --name api-v3.1.5 -v `dirname $(realpath fastapi.sh)`/api_$logs/3.1.5:/project/$logs -e logs=$logs -e trumpet_prenv_id=$trumpet_prenv_id fast-api 3.1.5 $(id -u) $(id -g) & \
docker run $hosts --network=host --rm --name api-v3.1.6 -v `dirname $(realpath fastapi.sh)`/api_$logs/3.1.6:/project/$logs -e logs=$logs -e trumpet_prenv_id=$trumpet_prenv_id fast-api 3.1.6 $(id -u) $(id -g) & \
docker run $hosts --network=host --rm --name api-v3.1.7 -v `dirname $(realpath fastapi.sh)`/api_$logs/3.1.7:/project/$logs -e logs=$logs -e trumpet_prenv_id=$trumpet_prenv_id fast-api 3.1.7 $(id -u) $(id -g)
docker run $hosts --network=host --rm --name api-v3.1.8 -v `dirname $(realpath fastapi.sh)`/api_$logs/3.1.8:/project/$logs -e logs=$logs -e trumpet_prenv_id=$trumpet_prenv_id fast-api 3.1.8 $(id -u) $(id -g) & \
docker run $hosts --network=host --rm --name api-v5.0.1 -v `dirname $(realpath fastapi.sh)`/api_$logs/5.0.1:/project/$logs -e logs=$logs -e trumpet_prenv_id=$trumpet_prenv_id fast-api 5.0.1 $(id -u) $(id -g) & \
docker run $hosts --network=host --rm --name api-v5.0.3 -v `dirname $(realpath fastapi.sh)`/api_$logs/5.0.3:/project/$logs -e logs=$logs -e trumpet_prenv_id=$trumpet_prenv_id fast-api 5.0.3 $(id -u) $(id -g) & \
docker run $hosts --network=host --rm --name api-v5.6.0 -v `dirname $(realpath fastapi.sh)`/api_$logs/5.6.0:/project/$logs -e logs=$logs -e trumpet_prenv_id=$trumpet_prenv_id fast-api 5.6.0 $(id -u) $(id -g) && \

wait


: $(docker stop $(docker ps -aq) && docker rm $(docker ps -aq))
: $(docker rmi $(docker images -f "dangling=true" -q))
