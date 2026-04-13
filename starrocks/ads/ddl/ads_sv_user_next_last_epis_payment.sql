CREATE TABLE `ads_sv_user_next_last_epis_payment` (
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `series_id` bigint(20) NULL COMMENT "剧id",
  `epis_id` bigint(20) NULL COMMENT "剧集id",
  `if_free` int(11) NULL COMMENT "是否免费 1免费 0收费",
  `create_time` datetime NULL COMMENT "最后一次观看时间"
) ENGINE=OLAP
PRIMARY KEY(`user_id`)
COMMENT "海剧-用户最后一次观看剧集的下一集是否付费"
DISTRIBUTED BY HASH(`user_id`) BUCKETS 10
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);