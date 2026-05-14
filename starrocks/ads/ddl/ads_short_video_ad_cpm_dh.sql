CREATE TABLE `ads_short_video_ad_cpm_dh` (
  `dt` date NOT NULL COMMENT "日期(事件时间)",
  `ad_set_id` bigint(20) NOT NULL COMMENT "广告组",
  `country` varchar(65533) NOT NULL COMMENT "国家",
  `cpm` decimal(18, 2) NULL COMMENT "CPM=花费/展示量  * 1000",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `ad_set_id`, `country`)
COMMENT "投放：CPM指标(老广告组)"
DISTRIBUTED BY HASH(`dt`, `ad_set_id`, `country`) BUCKETS 12 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);