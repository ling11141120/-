CREATE TABLE `ads_sr_third_party_payment_exposure_order` (
  `dt` date NOT NULL COMMENT "日期分区",
  `product_id` int(11) NOT NULL COMMENT "产品ID",
  `user_id` varchar(50) NOT NULL COMMENT "用户ID coalesce(identity_user_id,login_id)",
  `zffs_id` varchar(200) NOT NULL COMMENT "支付渠道ID-从zffs_id_list拆出来的原始ID",
  `zffs_rank` int(11) NOT NULL COMMENT "曝光位次-zffs_id_list里各个支付渠道对应的位次1,2,3,4...",
  `zffs` varchar(200) NULL COMMENT "支付渠道-从zffs_id_list拆出来的支付渠道",
  `strategy_id` varchar(200) NULL COMMENT "策略ID",
  `app_core_ver` varchar(50) NULL COMMENT "core版本",
  `shop_item` varchar(200) NULL COMMENT "充值类型",
  `mt` varchar(50) NULL COMMENT "终端",
  `user_type` varchar(200) NULL COMMENT "用户类型",
  `reg_country` varchar(200) NULL COMMENT "国家",
  `current_language2` int(11) NULL COMMENT "投放语言",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `user_id`, `zffs_id`, `zffs_rank`)
COMMENT "海阅三方支付曝光顺序链路报表-曝光表"
PARTITION BY RANGE(`dt`)
(PARTITION p202511 VALUES [("2025-11-01"), ("2025-12-01")),
PARTITION p202512 VALUES [("2025-12-01"), ("2026-01-01")),
PARTITION p202601 VALUES [("2026-01-01"), ("2026-02-01")),
PARTITION p202602 VALUES [("2026-02-01"), ("2026-03-01")),
PARTITION p202603 VALUES [("2026-03-01"), ("2026-04-01")),
PARTITION p202604 VALUES [("2026-04-01"), ("2026-05-01")),
PARTITION p202605 VALUES [("2026-05-01"), ("2026-06-01")),
PARTITION p202606 VALUES [("2026-06-01"), ("2026-07-01")),
PARTITION p202607 VALUES [("2026-07-01"), ("2026-08-01")),
PARTITION p202608 VALUES [("2026-08-01"), ("2026-09-01")))
DISTRIBUTED BY HASH(`dt`, `product_id`, `user_id`) BUCKETS 5 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "dt",
"dynamic_partition.enable" = "true",
"dynamic_partition.time_unit" = "month",
"dynamic_partition.time_zone" = "Asia/Shanghai",
"dynamic_partition.start" = "-2147483648",
"dynamic_partition.end" = "3",
"dynamic_partition.prefix" = "p",
"dynamic_partition.buckets" = "3",
"dynamic_partition.history_partition_num" = "0",
"dynamic_partition.start_day_of_month" = "1",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);