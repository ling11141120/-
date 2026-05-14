CREATE TABLE `alg_short_video_dnn_series_feature` (
  `dt` date NOT NULL COMMENT "日期",
  `series_id` bigint(20) NOT NULL COMMENT "剧id",
  `release_year` int(11) NULL COMMENT "上架时间",
  `movie_genre1` varchar(50) NULL COMMENT "剧的类型",
  `movie_genre2` varchar(50) NULL COMMENT "剧的类型",
  `movie_genre3` varchar(50) NULL COMMENT "剧的类型",
  `movie_rating_count` int(11) NULL COMMENT "剧被打分的次数",
  `movie_avg_rating` decimal(12, 2) NULL COMMENT "剧被打分的平均分",
  `movie_rating_stddev` decimal(12, 2) NULL COMMENT "剧被打分的标准差",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `series_id`)
DISTRIBUTED BY HASH(`series_id`) BUCKETS 30 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);