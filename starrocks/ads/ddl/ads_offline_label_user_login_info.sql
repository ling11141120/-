CREATE TABLE `ads_offline_label_user_login_info` (
  `dt` date NOT NULL COMMENT "日期",
  `product_id` smallint(6) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NOT NULL COMMENT "用户ID",
  `first_login_time` datetime NULL COMMENT "首次登录时间",
  `last_login_time` datetime NULL COMMENT "上次登录时间",
  `new_login_time` datetime NULL COMMENT "最新登录时间",
  `first_login_ip` varchar(65533) NULL COMMENT "首次登录ip",
  `last_login_ip` varchar(65533) NULL COMMENT "上次登录ip",
  `new_login_ip` varchar(65533) NULL COMMENT "最新登录ip",
  `first_login_location` varchar(65533) NULL COMMENT "首次登录地",
  `last_login_location` varchar(65533) NULL COMMENT "上一次登录地",
  `new_login_location` varchar(65533) NULL COMMENT "最新登录地",
  `remain_day` int(11) NULL COMMENT "留存天数(登录留存天数)",
  `login_days` int(11) NULL COMMENT "登录天数",
  `login_times` bigint(20) NULL COMMENT "登录次数",
  `user_login_type` varchar(65533) NULL COMMENT "用户活跃类型",
  `etl_time` datetime NULL COMMENT "数据处理时间",
  INDEX index_product_id (`product_id`) USING BITMAP COMMENT '产品id索引'
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `user_id`)
COMMENT "离线标签用户登录信息汇总表"
PARTITION BY RANGE(`dt`)
(PARTITION p20260507 VALUES [("2026-05-07"), ("2026-05-08")),
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
DISTRIBUTED BY HASH(`product_id`, `user_id`) BUCKETS 2 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "user_id",
"dynamic_partition.enable" = "true",
"dynamic_partition.time_unit" = "DAY",
"dynamic_partition.time_zone" = "Asia/Shanghai",
"dynamic_partition.start" = "-7",
"dynamic_partition.end" = "3",
"dynamic_partition.prefix" = "p",
"dynamic_partition.buckets" = "4",
"dynamic_partition.history_partition_num" = "0",
"in_memory" = "true",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);