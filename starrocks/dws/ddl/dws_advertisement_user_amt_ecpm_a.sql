CREATE TABLE `dws_advertisement_user_amt_ecpm_a` (
  `dt` date NOT NULL COMMENT "数据统计时间-分区",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `latest_banner_ad_ecpm` decimal(10, 3) NULL COMMENT "banner广告最近一次展现eCPM",
  `latest_native_ad_ecpm` decimal(10, 3) NULL COMMENT "原生广告最近一次展现eCPM",
  `latest_incentive_ad_ecpm` decimal(10, 3) NULL COMMENT "激励视频最近一次展现eCPM",
  `latest_flashscreen_ad_ecpm` decimal(10, 3) NULL COMMENT "开屏广告最近一次展现eCPM",
  `latest_interstitial_ad_ecpm` decimal(10, 3) NULL COMMENT "插屏广告最近一次展现eCPM",
  `last_time` datetime NULL COMMENT "最近一次展现收益时间",
  `update_time` datetime NULL COMMENT "数据更新变化时间",
  `etl_time` datetime NULL COMMENT "清洗时间",
  INDEX index_productid (`product_id`) USING BITMAP COMMENT 'index_productid'
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `user_id`)
COMMENT "用户最近一次广告类型-广告展现eCPM"
PARTITION BY RANGE(`dt`)
(PARTITION p20260429 VALUES [("2026-04-29"), ("2026-04-30")),
PARTITION p20260430 VALUES [("2026-04-30"), ("2026-05-01")),
PARTITION p20260501 VALUES [("2026-05-01"), ("2026-05-02")),
PARTITION p20260502 VALUES [("2026-05-02"), ("2026-05-03")),
PARTITION p20260503 VALUES [("2026-05-03"), ("2026-05-04")),
PARTITION p20260504 VALUES [("2026-05-04"), ("2026-05-05")),
PARTITION p20260505 VALUES [("2026-05-05"), ("2026-05-06")),
PARTITION p20260506 VALUES [("2026-05-06"), ("2026-05-07")),
PARTITION p20260507 VALUES [("2026-05-07"), ("2026-05-08")),
PARTITION p20260508 VALUES [("2026-05-08"), ("2026-05-09")),
PARTITION p20260509 VALUES [("2026-05-09"), ("2026-05-10")),
PARTITION p20260510 VALUES [("2026-05-10"), ("2026-05-11")),
PARTITION p20260511 VALUES [("2026-05-11"), ("2026-05-12")),
PARTITION p20260512 VALUES [("2026-05-12"), ("2026-05-13")),
PARTITION p20260513 VALUES [("2026-05-13"), ("2026-05-14")),
PARTITION p20260514 VALUES [("2026-05-14"), ("2026-05-15")),
PARTITION p20260515 VALUES [("2026-05-15"), ("2026-05-16")),
PARTITION p20260516 VALUES [("2026-05-16"), ("2026-05-17")),
PARTITION p20260517 VALUES [("2026-05-17"), ("2026-05-18")))
DISTRIBUTED BY HASH(`product_id`, `user_id`) BUCKETS 12 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "update_time, user_id",
"dynamic_partition.enable" = "true",
"dynamic_partition.time_unit" = "DAY",
"dynamic_partition.time_zone" = "Asia/Shanghai",
"dynamic_partition.start" = "-15",
"dynamic_partition.end" = "3",
"dynamic_partition.prefix" = "p",
"dynamic_partition.buckets" = "12",
"dynamic_partition.history_partition_num" = "0",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
