CREATE TABLE `alg_short_video_repay_user` (
  `dt` datetime NOT NULL COMMENT "",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `series_id` bigint(20) NULL COMMENT "",
  `sex` varchar(65533) NULL COMMENT "",
  `mt` varchar(65533) NULL COMMENT "",
  `corever` varchar(65533) NULL COMMENT "",
  `current_language` varchar(65533) NULL COMMENT "",
  `chl` varchar(65533) NULL COMMENT "",
  `ram` varchar(65533) NULL COMMENT "",
  `device` varchar(65533) NULL COMMENT "",
  `brand` varchar(65533) NULL COMMENT "",
  `regdays` varchar(65533) NULL COMMENT "",
  `first_pay_money` varchar(65533) NULL COMMENT "",
  `pay_total` varchar(65533) NULL COMMENT "",
  `pay_max` varchar(65533) NULL COMMENT "",
  `pay_min` varchar(65533) NULL COMMENT "",
  `pay_avg` varchar(65533) NULL COMMENT "",
  `pay_num` varchar(65533) NULL COMMENT "",
  `pay_times` varchar(65533) NULL COMMENT "",
  `watch_series_7day` varchar(65533) NULL COMMENT "",
  `watch_epis_7day` varchar(65533) NULL COMMENT "",
  `watch_times_7day` varchar(65533) NULL COMMENT "",
  `watch_days_7day` varchar(65533) NULL COMMENT "",
  `login_days_7day` varchar(65533) NULL COMMENT "",
  `watch_series` varchar(65533) NULL COMMENT "",
  `watch_epis` varchar(65533) NULL COMMENT "",
  `max_epis` varchar(65533) NULL COMMENT "",
  `con_epis_num` varchar(65533) NULL COMMENT "",
  `csum_total_amount` varchar(65533) NULL COMMENT "",
  `ecpm` varchar(65533) NULL COMMENT "",
  `label` varchar(65533) NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `user_id`, `product_id`)
COMMENT "海剧-复充用户特征"
DISTRIBUTED BY HASH(`dt`, `user_id`, `product_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);