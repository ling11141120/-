CREATE TABLE `alg_short_video_user_series_info` (
  `dt` varchar(1048576) NOT NULL COMMENT "统计日期",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `series_id` bigint(20) NOT NULL COMMENT "短剧id",
  `epis_cnt` bigint(20) NOT NULL COMMENT "观看剧集数量",
  `epis_complete_cnt` bigint(20) NOT NULL COMMENT "完整观看数量",
  `like_cnt` bigint(20) NULL COMMENT "点赞剧集数",
  `consume_amt` bigint(20) NULL COMMENT "花费金额",
  `etl_time` datetime NULL COMMENT "统计时间"
) ENGINE=OLAP 
DUPLICATE KEY(`dt`)
DISTRIBUTED BY HASH(`dt`) BUCKETS 12 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);