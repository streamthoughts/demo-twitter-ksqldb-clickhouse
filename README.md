# PoC : Fast Data Analytic platform with ClickHouse and Apache Kafka


## Prerequisites

* Git
* Maven (we recommend version 3.5.3)
* Java 11
* Docker, Docker-compose

## Project Tree

```
├── clickhouse-client.sh                // Utility to start a clickHouse client
├── demo-start.sh                       // Utility script to start the project
├── demo-stop.sh                        // Uitlity script to stop the project
├── docker-compose.yml
├── Dockerfile-kafka-connect
├── ksql-custom-udfs                    // Maven project that contains User Defined Functions (UDFs) for ksqlDB
│   ├── pom.xml
│   └── src
│       └── main
│           └── java
│               └── io
│                   └── streamthoughts
│                       └── ksql
│                           └── udfs
│                               ├── ArrayToString.java
│                               └── ExtractArrayField.java
├── README.md
└── sql                              // ksqlDB and ClickHouse queries
    ├── ch_create_table_tweets.sql
    ├── ksql_create_connector_sink_jdbc_clickhouse.sql
    ├── ksql_create_connector_source_twitter.sql
    ├── ksql_create_stream_tweets_json.sql
    ├── ksql_create_stream_tweets_normalized.sql
    └── ksql_create_stream_tweets.sql
```

## Twitter API OAuth

To run that demo project, you need to get credentials for using [Twitter API](https://developer.twitter.com/en/docs/basics/authentication/oauth-1-0a).

* Edit file `./sql/ksql_create_connector_source_twitter.sql` to set your Twitter API Credentials :

```sql
CREATE SOURCE CONNECTOR tweeterconnector WITH (
    'connector.class'='com.github.jcustenborder.kafka.connect.twitter.TwitterSourceConnector',
    'twitter.oauth.accessTokenSecret'='%ACCESS_TOKEN_SECRET%',
    'twitter.oauth.consumerSecret'='%CONSUMER_SECRET%',
    'twitter.oauth.accessToken'='%ACCESS_TOKEN%',
    'twitter.oauth.consumerKey'='%CONSUMER_KEY%',
    'kafka.status.topic'='tweets',
    'process.deletes'=false,
    'filter.keywords'='coronavirus,2019nCoV,SARSCoV2,covid19,cov19'
);
```

## Starting Project

**Start demonstration**

```bash
$ ./demo-start.sh
```

**Example of ClickHouse SQL query :**

```bash
$ ./clickhouse-client.sh
$ docker exec -it clickhouse bin/bash -c "clickhouse-client -q 'SELECT COUNT(*) AS COUNT, LANG FROM tweets GROUP BY LANG ORDER BY (COUNT) DESC LIMIT 10;'"
```

**Stopping**

```bash
$ ./demo-stop.sh
```
