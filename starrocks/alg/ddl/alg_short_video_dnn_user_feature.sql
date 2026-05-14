CREATE TABLE `alg_short_video_dnn_user_feature` (
  `dt` date NOT NULL COMMENT "日期",
  `user_id` int(11) NOT NULL COMMENT "用户id",
  `user_rated_movie1` int(11) NULL COMMENT "用户最近打分的电影id",
  `user_rated_movie2` int(11) NULL COMMENT "用户最近打分的电影id",
  `user_rated_movie3` int(11) NULL COMMENT "用户最近打分的电影id",
  `user_rated_movie4` int(11) NULL COMMENT "用户最近打分的电影id",
  `user_rated_movie5` int(11) NULL COMMENT "用户最近打分的电影id",
  `user_rating_count` int(11) NULL COMMENT "用户打分次数",
  `user_avg_rating` decimal(12, 2) NULL COMMENT "用户平均打分",
  `user_rating_stddev` decimal(12, 2) NULL COMMENT "用户平均打分标准差",
  `user_genre1` varchar(50) NULL COMMENT "用户喜欢电影类别",
  `user_genre2` varchar(50) NULL COMMENT "用户喜欢电影类别",
  `user_genre3` varchar(50) NULL COMMENT "用户喜欢电影类别",
  `user_genre4` varchar(50) NULL COMMENT "用户喜欢电影类别",
  `user_genre5` varchar(50) NULL COMMENT "用户喜欢电影类别",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `user_id`)
DISTRIBUTED BY HASH(`user_id`) BUCKETS 30 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);