CREATE TABLE `dwm_ab_exp_distinct_stat_di_temp` (
  `dt` date NOT NULL COMMENT "日期天分区",
  `exp_id` int(11) NOT NULL COMMENT "实验ID",
  `exp_grp_id` int(11) NOT NULL COMMENT "实验组ID",
  `exp_grp_ver_id` bigint(20) NOT NULL COMMENT "实验组版本ID",
  `exp_grp_users` bitmap BITMAP_UNION NULL COMMENT "实验组用户id",
  `strategy_hit_users` bitmap BITMAP_UNION NULL COMMENT "策略命中用户id",
  `exposure_users` bitmap BITMAP_UNION NULL COMMENT "曝光用户id",
  `click_users` bitmap BITMAP_UNION NULL COMMENT "点击用户id",
  `watch_users` bitmap BITMAP_UNION NULL COMMENT "观看用户id",
  `unlock_users` bitmap BITMAP_UNION NULL COMMENT "解锁用户id",
  `adv_unlock_users` bitmap BITMAP_UNION NULL COMMENT "广告解锁剧集用户id",
  `recharge_users` bitmap BITMAP_UNION NULL COMMENT "充值用户id",
  `consume_users` bitmap BITMAP_UNION NULL COMMENT "消费用户id",
  `etl_time` datetime REPLACE NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
AGGREGATE KEY(`dt`, `exp_id`, `exp_grp_id`, `exp_grp_ver_id`)
COMMENT "海剧-AB实验-核心指标-去重指标-小时统计"
PARTITION BY RANGE(`dt`)
(PARTITION p2024 VALUES [("2024-01-01"), ("2025-01-01")),
PARTITION p2025 VALUES [("2025-01-01"), ("2026-01-01")),
PARTITION p2026 VALUES [("2026-01-01"), ("2027-01-01")),
PARTITION p2027 VALUES [("2027-01-01"), ("2028-01-01")),
PARTITION p2028 VALUES [("2028-01-01"), ("2029-01-01")),
PARTITION p2029 VALUES [("2029-01-01"), ("2030-01-01")))
DISTRIBUTED BY HASH(`dt`, `exp_id`, `exp_grp_id`, `exp_grp_ver_id`) BUCKETS 3 
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
