CREATE TABLE `alg_short_video_exp_group_report_v2` (
  `dt` date NULL COMMENT "日期",
  `group_id` varchar(512) NULL COMMENT "group_id",
  `group_name` varchar(512) NULL COMMENT "group_name",
  `uv` bigint(20) NULL COMMENT "uv",
  `pay_total` bigint(20) NULL COMMENT "pay_total",
  `csum_cvr` decimal(16, 6) NULL COMMENT "csum_cvr",
  `pay_cvr` decimal(16, 6) NULL COMMENT "pay_cvr",
  `avg_pay_num` decimal(16, 6) NULL COMMENT "avg_pay_num",
  `avg_csum` decimal(16, 6) NULL COMMENT "avg_csum",
  `avg_pay` decimal(16, 6) NULL COMMENT "avg_pay"
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