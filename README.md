# PoC : Fast Data Analytic platform with ClickHouse and Apache Kafka

* Edit file `./sql/ksql_create_connector_source_twitter.sql` to set your Tweeter API Credentials :

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

**Start demonstration**

```bash
$ ./demo-start.sh
```

**Example of ClickHouse SQL query :**

```bash
$ ./clickhouse-client.sh
$ docker exec -it clickhouse bin/bash -c "clickhouse-client -q 'SELECT COUNT(*) AS COUNT, LANG FROM tweets GROUP BY LANG ORDER BY (COUNT) DESC LIMIT 10;'"
```
