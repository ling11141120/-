CREATE TABLE `dwm_ab_exp_accumulation_stat_di_temp` (
  `dt` date NOT NULL COMMENT "日期天分区",
  `exp_id` int(11) NOT NULL COMMENT "实验ID",
  `exp_grp_id` int(11) NOT NULL COMMENT "实验组ID",
  `exp_grp_ver_id` bigint(20) NOT NULL COMMENT "实验组版本ID",
  `watch_episodes` bigint(20) NULL COMMENT "观看集数",
  `unlock_episodes` bigint(20) NULL COMMENT "付费解锁集数",
  `recharge_amount` decimal(20, 2) NULL COMMENT "充值金额(分成后)",
  `recharge_amount_pre` decimal(20, 2) NULL COMMENT "充值金额(分成前)",
  `third_recharge_amount` decimal(20, 2) NULL COMMENT "三方充值金额",
  `recharge_times` bigint(20) NULL COMMENT "充值次数",
  `coin_consume` decimal(20, 2) NULL COMMENT "阅读币消费金额",
  `gift_consume` decimal(20, 2) NULL COMMENT "礼券消费金额",
  `consume_times` bigint(20) NULL COMMENT "消费次数",
  `total_adv_amount` decimal(20, 2) NULL COMMENT "总广告收入",
  `adv_amount` decimal(20, 2) NULL COMMENT "广告收入",
  `third_h5_amount` decimal(20, 2) NULL COMMENT "三方H5收入",
  `adv_unlock_times` bigint(20) NULL COMMENT "广告解锁剧集次数",
  `etl_time` datetime NOT NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `exp_id`, `exp_grp_id`, `exp_grp_ver_id`)
COMMENT "海剧-AB实验-核心指标-可累加指标-小时统计"
PARTITION BY RANGE(`dt`)
(PARTITION p2024 VALUES [("2024-01-01"), ("2025-01-01")),
PARTITION p2025 VALUES [("2025-01-01"), ("2026-01-01")),
PARTITION p2026 VALUES [("2026-01-01"), ("2027-01-01")),
PARTITION p2027 VALUES [("2027-01-01"), ("2028-01-01")),
PARTITION p2028 VALUES [("2028-01-01"), ("2029-01-01")),
PARTITION p2029 VALUES [("2029-01-01"), ("2030-01-01")))
DISTRIBUTED BY HASH(`exp_id`, `exp_grp_id`, `exp_grp_ver_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "exp_id, exp_grp_id, exp_grp_ver_id",
"dynamic_partition.enable" = "true",
"dynamic_partition.time_unit" = "year",
"dynamic_partition.time_zone" = "Asia/Shanghai",
"dynamic_partition.start" = "-365",
"dynamic_partition.end" = "3",
"dynamic_partition.prefix" = "p",
"dynamic_partition.buckets" = "3",
"dynamic_partition.history_partition_num" = "0",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);
