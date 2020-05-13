CREATE TABLE IF NOT EXISTS default.tweets
(
    ID String,
    CREATEDAT DateTime,
    TEXT String,
    LANG String,
    RETWEETED UInt8,
    USERID String,
    USERNAME String,
    USERDESCRIPTION String,
    USERLOCATION String,
    HASHTAGS String,
    MENTIONS String
) ENGINE = MergeTree()
PARTITION BY toYYYYMM(CREATEDAT)
ORDER BY (CREATEDAT, LANG);
