CREATE EXTERNAL TABLE `ads_srsv_d0_hour_dpt_user_tz` (
  `dt` varchar(20) NOT NULL COMMENT "日期",
  `md5_key` varchar(100) NOT NULL COMMENT "md5_key",
  `product_id` int(11) NULL COMMENT "产品id",
  `ad_id` varchar(600) NULL COMMENT "广告id",
  `user_num` int(11) NULL COMMENT "",
  `new_num` int(11) NULL COMMENT "",
  `rmt_num` int(11) NULL COMMENT "",
  `af` int(11) NULL COMMENT "",
  `attribution` int(11) NULL COMMENT "归因",
  `net_dpt` int(11) NULL COMMENT "dpt",
  `ast` int(11) NULL COMMENT "ast",
  `new_d0_amount` decimal(12, 2) NULL COMMENT "",
  `rmt_d0_amount` decimal(12, 2) NULL COMMENT "",
  `new_d3_amount` decimal(12, 2) NULL COMMENT "",
  `rmt_d3_amount` decimal(12, 2) NULL COMMENT "",
  `new_d7_amount` decimal(12, 2) NULL COMMENT "",
  `rmt_d7_amount` decimal(12, 2) NULL COMMENT "",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间"
) ENGINE=OLAP_EXTERNAL 
PRIMARY KEY(`dt`, `md5_key`)
COMMENT "D0分时报表增加AST(助攻归因)-广告时区"
DISTRIBUTED BY HASH(`dt`, `md5_key`) BUCKETS 10 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD",
"host" = "ads-starrocks-in.changdu.vip",
"port" = "19020",
"user" = "ztt",
"password" = "",
"database" = "sharpengine_bi",
"table" = "ads_srsv_d0_hour_dpt_user_tz"
);