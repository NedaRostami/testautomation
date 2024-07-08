#!/bin/bash

cd `dirname $0`
git pull origin master
docker build -t fast-api -f ./Dockerfile-api .
