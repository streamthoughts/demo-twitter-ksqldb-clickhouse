#!/bin/bash

set -e


# Functions
function exec_clickhouse_query() {
  SQL=$1
  echo -e "\n🚀 Executing ClickHouse query\n"
  echo "${SQL}"
  docker exec -it clickhouse bash -c "echo \"$SQL\" | clickhouse-client --multiline"
  echo "----------------------------------------------"
}

function exec_ksql_query() {
  echo -e "\n🚀 Executing KSQL query\n"
  KSQL_QUERY=$1
  docker exec -it ksqldb-server bash -c "echo \"$KSQL_QUERY\" | ksql"
}

# Main
echo "--------------------------------------------------------------------------------"
echo "---    Demo : Fast Analytic Platform with Kafka, ClickHouse & Superset       ---"
echo "--------------------------------------------------------------------------------"

export COMPOSE_PROJECT_NAME=demo-twitter-streams

echo -e "\n🐳 Stopping all previsously started Docker containers"
docker-compose down -v

echo -e "\n🏭 Building Maven project (cd ksql-custom-udfs; mvn clean -q package)\n"
(cd ksql-custom-udfs; mvn clean -q package)

echo -e "\n🐳 Starting all docker containers"
docker-compose up -d

KAFKA_CONTAINER_NAME=kafka

echo -e "\n⏳ Waiting for Kafka Broker to be up and running"
while true
do
  if [ $(docker logs $KAFKA_CONTAINER_NAME 2>&1 | grep "started (kafka.server.KafkaServer)" >/dev/null; echo $?) -eq 0 ]; then
    echo
    break
  fi
  printf "."
  sleep 1
done;

echo -e "\n⏳ Creating Kafka topics"
docker exec -it kafka kafka-topics --zookeeper zookeeper:2181 --create --topic tweets --partitions 4 --replication-factor 1
docker exec -it kafka kafka-topics --zookeeper zookeeper:2181 --create --topic tweets-normalized --partitions 4 --replication-factor 1

exec_clickhouse_query "$(cat ./sql/ch_create_table_tweets.sql)"

echo -e "\n⏳ Waiting for Kafka Connect to be up and running."
while true
do
  res=$(curl -sI http://localhost:8083 | head -n 1 | cut -d$' ' -f2)
  if [ "$res" == "200" ]; then
    echo
    break
  fi
  printf "."
  sleep 1
done;

echo -e "\n⏳ Waiting for KSQL to be available before launching CLI\n"
while [ $(curl -s -o /dev/null -w %{http_code} http://localhost:8088/) -eq 000 ]
do
  echo -e $(date) "KSQL Server HTTP state: " $(curl -s -o /dev/null -w %{http_code} http://localhost:8088/) " (waiting for 200)"
  sleep 5
done

echo -e "\n⏳ Starting JdbcSinkConnector for ClickHouse\n"

exec_ksql_query "$(cat ./sql/ksql_create_connector_sink_jdbc_clickhouse.sql)"

sleep 5

echo -e "\n⏳ Starting TwitterSourceConnector\n"
exec_ksql_query "$(cat ./sql/ksql_create_connector_source_twitter.sql)"

exec_ksql_query "SET 'auto.offset.reset' = 'earliest';"
exec_ksql_query "$(cat ./sql/ksql_create_stream_tweets.sql)"
exec_ksql_query "$(cat ./sql/ksql_create_stream_tweets_normalized.sql)"
exec_ksql_query "$(cat ./sql/ksql_create_stream_tweets_json.sql)"

exit 0
