CREATE TABLE `ads_short_video_ad_yesterday_cac_dh` (
  `dt` date NOT NULL COMMENT "日期(统计时间)",
  `ad_set_id` bigint(20) NOT NULL COMMENT "广告组",
  `cac` decimal(18, 2) NULL COMMENT "CAC=花费/付费用户数",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `ad_set_id`)
COMMENT "投放：CAC指标,按天汇总（老广告组）"
DISTRIBUTED BY HASH(`dt`, `ad_set_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);