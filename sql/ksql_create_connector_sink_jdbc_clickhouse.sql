CREATE SOURCE CONNECTOR clickhousejdbcconnector WITH (
    'connector.class'='io.confluent.connect.jdbc.JdbcSinkConnector',
    'topics'='tweets-normalized',
    'tasks.max'='1',
    'connection.url'='jdbc:clickhouse://clickhouse:8123/default',
    'table.name.format'='tweets'
);
