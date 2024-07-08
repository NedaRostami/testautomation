#!/bin/bash
export logs="Reports"
export trumpet_prenv_id="$1"

echo "$1"
echo "$trumpet_prenv_id"
echo $PWD

: $(git pull origin master)
# # docker login registry.mielse.com/qa/api-base-docker-image/qa-base
#
: $(docker build -t fast-api -f Dockerfile-api .)
# #
: $(rm -rf $PWD/api_$logs)
: $(rm $PWD/api_$logs.tar.gz)
: $(mkdir $PWD/api_$logs)
#
docker run --rm --name api-v3.0.2 -v $pwd/api_$logs/3.0.2:/project/$logs -e logs=$logs -e trumpet_prenv_id=$trumpet_prenv_id fast-api 3.0.2 $(id -u) $(id -g) & \
docker run --rm --name api-v3.0.3 -v $PWD/api_$logs/3.0.3:/project/$logs -e logs=$logs -e trumpet_prenv_id=$trumpet_prenv_id fast-api 3.0.3 $(id -u) $(id -g) & \
docker run --rm --name api-v3.0.4 -v $PWD/api_$logs/3.0.4:/project/$logs -e logs=$logs -e trumpet_prenv_id=$trumpet_prenv_id fast-api 3.0.4 $(id -u) $(id -g) & \
docker run --rm --name api-v3.0.5 -v $PWD/api_$logs/3.0.5:/project/$logs -e logs=$logs -e trumpet_prenv_id=$trumpet_prenv_id fast-api 3.0.5 $(id -u) $(id -g) & \
docker run --rm --name api-v3.1.0 -v $PWD/api_$logs/3.1.0:/project/$logs -e logs=$logs -e trumpet_prenv_id=$trumpet_prenv_id fast-api 3.1.0 $(id -u) $(id -g) & \
docker run --rm --name api-v3.1.1 -v $PWD/api_$logs/3.1.1:/project/$logs -e logs=$logs -e trumpet_prenv_id=$trumpet_prenv_id fast-api 3.1.1 $(id -u) $(id -g) & \
docker run --rm --name api-v3.1.2 -v $PWD/api_$logs/3.1.2:/project/$logs -e logs=$logs -e trumpet_prenv_id=$trumpet_prenv_id fast-api 3.1.2 $(id -u) $(id -g) & \
docker run --rm --name api-v3.1.3 -v $PWD/api_$logs/3.1.3:/project/$logs -e logs=$logs -e trumpet_prenv_id=$trumpet_prenv_id fast-api 3.1.3 $(id -u) $(id -g) & \
docker run --rm --name api-v3.1.4 -v $PWD/api_$logs/3.1.4:/project/$logs -e logs=$logs -e trumpet_prenv_id=$trumpet_prenv_id fast-api 3.1.4 $(id -u) $(id -g) & \
docker run --rm --name api-v3.1.5 -v $PWD/api_$logs/3.1.5:/project/$logs -e logs=$logs -e trumpet_prenv_id=$trumpet_prenv_id fast-api 3.1.5 $(id -u) $(id -g) & \
docker run --rm --name api-v3.1.6 -v $PWD/api_$logs/3.1.6:/project/$logs -e logs=$logs -e trumpet_prenv_id=$trumpet_prenv_id fast-api 3.1.6 $(id -u) $(id -g) & \
docker run --rm --name api-v3.1.7 -v $PWD/api_$logs/3.1.7:/project/$logs -e logs=$logs -e trumpet_prenv_id=$trumpet_prenv_id fast-api 3.1.7 $(id -u) $(id -g) & \
docker run --rm --name api-v3.1.8 -v $PWD/api_$logs/3.1.8:/project/$logs -e logs=$logs -e trumpet_prenv_id=$trumpet_prenv_id fast-api 3.1.8 $(id -u) $(id -g) & \
docker run --rm --name api-v5.0.1 -v $PWD/api_$logs/5.0.1:/project/$logs -e logs=$logs -e trumpet_prenv_id=$trumpet_prenv_id fast-api 5.0.1 $(id -u) $(id -g) & \
docker run --rm --name api-v5.0.3 -v $PWD/api_$logs/5.0.3:/project/$logs -e logs=$logs -e trumpet_prenv_id=$trumpet_prenv_id fast-api 5.0.3 $(id -u) $(id -g) && \
wait
echo "tar logs"#
: $(tar -czvf api_$logs.tar.gz api_$logs/)
echo "logs tared"
: $(docker rmi $(docker images -f "dangling=true" -q))
