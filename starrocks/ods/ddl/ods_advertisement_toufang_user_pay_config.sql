CREATE TABLE `ods_advertisement_toufang_user_pay_config` (
  `id` int(11) NOT NULL COMMENT "",
  `tf_h` int(11) NULL COMMENT "小时投放",
  `roi_rate` int(11) NULL COMMENT "小时roi",
  `is_flag` int(11) NULL COMMENT "是否有效1 有效  2 无效",
  `create_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "创建时间"
) ENGINE=OLAP 
PRIMARY KEY(`id`)
DISTRIBUTED BY HASH(`id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
