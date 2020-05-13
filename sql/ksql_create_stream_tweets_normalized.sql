CREATE STREAM TWEETS_NORMALIZED
    WITH (kafka_topic = 'tweets-normalized') AS
    SELECT
        Id,
        CreatedAt / 1000 as CreatedAt,
        Text,
        Lang,
        Retweeted,
        User->Id as UserId,
        User->Name as UserName,
        IFNULL(User->Description, '') as UserDescription,
        IFNULL(User->Location, '') as UserLocation,
        ARRAY_TO_STRING( EXTRACT_ARRAY_FIELD(UserMentionEntities, 'Name'), ',', '') as Mentions,
        ARRAY_TO_STRING( EXTRACT_ARRAY_FIELD(HashtagEntities, 'Text'), ',', '') as Hashtags
    FROM tweets EMIT CHANGES;


