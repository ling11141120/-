CREATE TABLE `ads_sv_iaa_push_series` (
  `dt` date NOT NULL COMMENT "日期",
  `series_id` bigint(20) NOT NULL COMMENT "短剧id",
  `lang_id` int(11) NOT NULL COMMENT "语言id",
  `vip_watch_cnt` int(11) NULL COMMENT "付费集播放次数",
  `vip_watch_num` int(11) NULL COMMENT "付费集观看人数",
  `consume_num` int(11) NULL COMMENT "消费（含订阅）人数",
  `etl_time` datetime NULL COMMENT "etl时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `series_id`)
COMMENT "海剧-IAA变现算法推剧"
DISTRIBUTED BY HASH(`dt`, `series_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);