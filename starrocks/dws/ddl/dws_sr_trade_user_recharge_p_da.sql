CREATE TABLE `dws_sr_trade_user_recharge_p_da` (
  `dt` date NOT NULL COMMENT "时间 分区",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `recharge_amount` int(11) NULL COMMENT "分成前的充值金额",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `user_id`)
COMMENT "海外阅读业务--交易域--用户充值金额天汇总"
PARTITION BY RANGE(`dt`)
(PARTITION p2020 VALUES [("2020-01-01"), ("2021-01-01")),
PARTITION p2021 VALUES [("2021-01-01"), ("2022-01-01")),
PARTITION p2022 VALUES [("2022-01-01"), ("2023-01-01")),
PARTITION p2023 VALUES [("2023-01-01"), ("2024-01-01")),
PARTITION p2024 VALUES [("2024-01-01"), ("2025-01-01")),
PARTITION p2025 VALUES [("2025-01-01"), ("2026-01-01")),
PARTITION p2026 VALUES [("2026-01-01"), ("2027-01-01")),
PARTITION p2027 VALUES [("2027-01-01"), ("2028-01-01")))
DISTRIBUTED BY HASH(`dt`, `user_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "user_id",
"colocate_with" = "ab_exp_user_grp",
"dynamic_partition.enable" = "true",
"dynamic_partition.time_unit" = "YEAR",
"dynamic_partition.time_zone" = "Asia/Shanghai",
"dynamic_partition.start" = "-5000",
"dynamic_partition.end" = "1",
"dynamic_partition.prefix" = "p",
"dynamic_partition.buckets" = "3",
"dynamic_partition.history_partition_num" = "0",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "LZ4"
);
