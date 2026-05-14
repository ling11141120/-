CREATE TABLE `alg_short_video_exp_group_report_v1` (
  `dt` date NULL COMMENT "日期",
  `group_id` bigint(20) NULL COMMENT "group_id",
  `group_name` bigint(20) NULL COMMENT "group_name",
  `uv` bigint(20) NULL COMMENT "uv",
  `pay_total` bigint(20) NULL COMMENT "pay_total",
  `csum_cvr` bigint(20) NULL COMMENT "csum_cvr",
  `pay_cvr` bigint(20) NULL COMMENT "pay_cvr",
  `avg_pay_num` bigint(20) NULL COMMENT "avg_pay_num",
  `avg_csum` bigint(20) NULL COMMENT "avg_csum",
  `avg_pay` bigint(20) NULL COMMENT "avg_pay"
) ENGINE=OLAP 
DUPLICATE KEY(`dt`, `group_id`)
DISTRIBUTED BY HASH(`dt`) BUCKETS 14 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);