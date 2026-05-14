CREATE TABLE `ads_edm_user_info_ed` (
  `dt` date NULL COMMENT "统计日期",
  `user_id` bigint(20) NULL COMMENT "用户id",
  `current_language` int(11) NULL COMMENT "界面语言",
  `product_id` int(11) NULL COMMENT "产品id",
  `country` varchar(255) NULL COMMENT "国家",
  `corever` int(11) NULL COMMENT "core",
  `mt` int(11) NULL COMMENT "终端",
  `utc_offest` int(11) NULL COMMENT "时区",
  `book_id` bigint(20) NULL COMMENT "书籍id",
  `last_login_time` datetime NULL COMMENT "最后登陆时间",
  `last_charge_time` datetime NULL COMMENT "最后充值时间",
  `svip_expire_time` datetime NULL COMMENT "svip到期时间",
  `is_boud_email` int(11) NULL COMMENT "是否绑定邮箱",
  `etl_time` datetime NULL COMMENT "数据更新时间",
  INDEX index_book_id (`book_id`) USING BITMAP COMMENT 'index_book_id',
  INDEX index_current_language (`current_language`) USING BITMAP COMMENT 'index_current_language',
  INDEX index_product_id (`product_id`) USING BITMAP COMMENT 'index_product_id'
) ENGINE=OLAP 
DUPLICATE KEY(`dt`, `user_id`)
COMMENT "edm召回活动指标表"
PARTITION BY RANGE(`dt`)
(PARTITION p20260509 VALUES [("2026-05-09"), ("2026-05-10")),
PARTITION p20260510 VALUES [("2026-05-10"), ("2026-05-11")),
PARTITION p20260511 VALUES [("2026-05-11"), ("2026-05-12")),
PARTITION p20260512 VALUES [("2026-05-12"), ("2026-05-13")),
PARTITION p20260513 VALUES [("2026-05-13"), ("2026-05-14")),
PARTITION p20260514 VALUES [("2026-05-14"), ("2026-05-15")),
PARTITION p20260515 VALUES [("2026-05-15"), ("2026-05-16")),
PARTITION p20260516 VALUES [("2026-05-16"), ("2026-05-17")),
PARTITION p20260517 VALUES [("2026-05-17"), ("2026-05-18")))
DISTRIBUTED BY HASH(`dt`, `user_id`) BUCKETS 5 
PROPERTIES (
"replication_num" = "3",
"dynamic_partition.enable" = "true",
"dynamic_partition.time_unit" = "DAY",
"dynamic_partition.time_zone" = "Asia/Shanghai",
"dynamic_partition.start" = "-5",
"dynamic_partition.end" = "3",
"dynamic_partition.prefix" = "p",
"dynamic_partition.buckets" = "5",
"dynamic_partition.history_partition_num" = "0",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);