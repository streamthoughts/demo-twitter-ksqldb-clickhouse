CREATE SOURCE CONNECTOR tweeterconnector WITH (
    'connector.class'='com.github.jcustenborder.kafka.connect.twitter.TwitterSourceConnector',
    'twitter.oauth.accessTokenSecret'='%OAUTH_ACCESS_TOKEN_SECRET%',
    'twitter.oauth.consumerSecret'='%OAUTH_CONSUMER_SECRET%',
    'twitter.oauth.accessToken'='%OAUTH_ACCESS_TOKEN%',
    'twitter.oauth.consumerKey'='%OAUTH_CONSUMER_KEY%',
    'kafka.status.topic'='tweets',
    'process.deletes'=false,
    'filter.keywords'='coronavirus,2019nCoV,SARSCoV2,covid19,cov19'
);
