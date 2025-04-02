CREATE TABLE `ads_bi_dc_user_statistic_ad_info_di` (
  `dt` date NOT NULL COMMENT "统计日期",
  `md5_key` varchar(65533) NOT NULL COMMENT "主键md5key",
  `product_id` int(11) NULL COMMENT "产品id",
  `ad_id` varchar(65533) NULL COMMENT "广告id",
  `dc_code` bigint(20) NULL COMMENT "所属机构",
  `dc_account` bigint(20) NULL COMMENT "机构投放账号",
  `core` int(11) NULL COMMENT "corever",
  `mt` int(11) NULL COMMENT "终端",
  `user_type` int(11) NULL COMMENT "用户类型:1 新用户 0老用户123123",
  `new_user_count` int(11) NULL COMMENT "新增用户数",
  `pay_user_count` int(11) NULL COMMENT "新增用户数",
  `pay_order_count` int(11) NULL COMMENT "订单数",
  `pay_order_amount` decimal(18, 4) NULL COMMENT "订单金额",
  `etl_tm` datetime NOT NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `md5_key`)
COMMENT "分销机构用户统计报表"
PARTITION BY RANGE(`dt`)
(PARTITION p202409 VALUES [("2024-09-01"), ("2024-10-01")),
PARTITION p202410 VALUES [("2024-10-01"), ("2024-11-01")),
PARTITION p202411 VALUES [("2024-11-01"), ("2024-12-01")),
PARTITION p202412 VALUES [("2024-12-01"), ("2025-01-01")),
PARTITION p202501 VALUES [("2025-01-01"), ("2025-02-01")),
PARTITION p202502 VALUES [("2025-02-01"), ("2025-03-01")),
PARTITION p202503 VALUES [("2025-03-01"), ("2025-04-01")),
PARTITION p202504 VALUES [("2025-04-01"), ("2025-05-01")),
PARTITION p202505 VALUES [("2025-05-01"), ("2025-06-01")),
PARTITION p202506 VALUES [("2025-06-01"), ("2025-07-01")))
DISTRIBUTED BY HASH(`dt`, `md5_key`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"dynamic_partition.enable" = "true",
"dynamic_partition.time_unit" = "month",
"dynamic_partition.time_zone" = "Asia/Shanghai",
"dynamic_partition.start" = "-2147483648",
"dynamic_partition.end" = "3",
"dynamic_partition.prefix" = "p",
"dynamic_partition.buckets" = "1",
"dynamic_partition.history_partition_num" = "0",
"dynamic_partition.start_day_of_month" = "1",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);