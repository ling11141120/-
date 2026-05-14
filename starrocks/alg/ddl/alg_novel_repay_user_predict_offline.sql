CREATE TABLE `alg_novel_repay_user_predict_offline` (
  `user_id` varchar(200) NOT NULL COMMENT "剧id",
  `pay_list` varchar(65533) NOT NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`user_id`)
DISTRIBUTED BY HASH(`user_id`) BUCKETS 10 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);