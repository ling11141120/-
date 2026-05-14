CREATE TABLE `ads_sv_automation_new_series_ranking_est` (
  `start_date` date NOT NULL COMMENT "爬榜周期开始时间，西五区",
  `end_date` date NOT NULL COMMENT "爬榜周期结束时间，西五区",
  `series_id` bigint(20) NOT NULL COMMENT "短剧id",
  `lang_id` int(11) NOT NULL COMMENT "语言id",
  `watch_num` int(11) NULL COMMENT "观看人数",
  `consume_num` int(11) NULL COMMENT "消费人数",
  `consume_amt` int(11) NULL COMMENT "观看币消耗",
  `exposure_num` int(11) NULL COMMENT "短剧曝光事件中的曝光用户数",
  `etl_time` datetime NULL COMMENT "etl时间"
) ENGINE=OLAP 
PRIMARY KEY(`start_date`, `end_date`, `series_id`, `lang_id`)
COMMENT "海剧-新书自动爬榜"
DISTRIBUTED BY HASH(`start_date`, `end_date`, `series_id`, `lang_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);