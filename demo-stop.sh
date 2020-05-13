#!/bin/bash 

set -e 

export COMPOSE_PROJECT_NAME=demo-twitter-streams

echo -e "\n🐳 Stopping all previsously started Docker containers"
docker-compose down -v

exit 0
