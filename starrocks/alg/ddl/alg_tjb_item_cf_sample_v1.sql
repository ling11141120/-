CREATE TABLE `alg_tjb_item_cf_sample_v1` (
  `dt` date NOT NULL COMMENT "日期",
  `user_id` bigint(20) NULL COMMENT "用户ID",
  `book_feature` varchar(65533) NULL COMMENT "阅读特征"
) ENGINE=OLAP 
DUPLICATE KEY(`dt`, `user_id`)
DISTRIBUTED BY HASH(`dt`) BUCKETS 12 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);