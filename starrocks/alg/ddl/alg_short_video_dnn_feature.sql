CREATE TABLE `alg_short_video_dnn_feature` (
  `dt` date NOT NULL COMMENT "日期",
  `series_id` bigint(20) NOT NULL COMMENT "剧id",
  `user_id` int(11) NOT NULL COMMENT "用户id",
  `rating` decimal(12, 2) NULL COMMENT "评分",
  `timestamp` int(11) NULL COMMENT "事件时间",
  `release_year` int(11) NULL COMMENT "上架时间",
  `movie_genre1` varchar(50) NULL COMMENT "剧的类型",
  `movie_genre2` varchar(50) NULL COMMENT "剧的类型",
  `movie_genre3` varchar(50) NULL COMMENT "剧的类型",
  `movie_rating_count` int(11) NULL COMMENT "剧被打分的次数",
  `movie_avg_rating` decimal(12, 2) NULL COMMENT "剧被打分的平均分",
  `movie_rating_stddev` decimal(12, 2) NULL COMMENT "剧被打分的标准差",
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
PRIMARY KEY(`dt`, `series_id`, `user_id`)
DISTRIBUTED BY HASH(`series_id`) BUCKETS 50 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);