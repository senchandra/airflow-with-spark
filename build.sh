#!/bin/sh

docker build -t airflow .
docker-compose up -d
docker rmi $(docker images -f dangling=true)
docker ps -a | grep airflow
