CREATE TABLE `ads_report_AB_experiment_mul_ltv_mid1` (
  `dt` date NOT NULL COMMENT "统计周期",
  `process_types` smallint(6) NOT NULL COMMENT "类型，1消耗，2充值",
  `source_types` smallint(6) NOT NULL COMMENT "推荐来源（1榜单-猜你喜欢，2频道-猜你喜欢，3退出弹窗，4串书，5章末推,6末页推）",
  `product_id` int(11) NOT NULL COMMENT "产品语言",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `is_read` smallint(6) NULL COMMENT "是否阅读",
  `ltv0` bigint(20) NULL COMMENT "当天累计",
  `ltv1` bigint(20) NULL COMMENT "1天累计",
  `ltv3` bigint(20) NULL COMMENT "3天累计",
  `ltv5` bigint(20) NULL COMMENT "5天累计",
  `ltv7` bigint(20) NULL COMMENT "7天累计",
  `ltv15` bigint(20) NULL COMMENT "15天累计",
  `ltv30` bigint(20) NULL COMMENT "30天累计",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `process_types`, `source_types`, `product_id`, `user_id`, `book_id`)
DISTRIBUTED BY HASH(`dt`, `process_types`, `source_types`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "dt",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);