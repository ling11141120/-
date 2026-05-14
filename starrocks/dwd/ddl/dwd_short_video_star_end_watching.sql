CREATE TABLE `dwd_short_video_star_end_watching` (
  `login_id` varchar(1000) NULL COMMENT "id of site",
  `product_id` varchar(1000) NULL COMMENT "time of event",
  `shortplay_id` varchar(1000) NULL COMMENT "短剧ID",
  `episode_id` varchar(1000) NULL COMMENT "剧集ID",
  `min_start_watch_tm` datetime MIN NULL COMMENT "最早观看时间",
  `max_end_watch_tm` datetime MAX NULL COMMENT "最早观看时间"
) ENGINE=OLAP 
AGGREGATE KEY(`login_id`, `product_id`, `shortplay_id`, `episode_id`)
COMMENT "海剧开始观看时间和结束观看时间"
DISTRIBUTED BY HASH(`login_id`) BUCKETS 12 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);