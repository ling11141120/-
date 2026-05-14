CREATE TABLE `ads_sv_user_unlock_series` (
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `total_coin_series` int(11) NULL COMMENT "累计付费货币解锁剧目数",
  `total_vip_series` int(11) NULL COMMENT "累计VIP解锁剧目数",
  `total_svip_series` int(11) NULL COMMENT "累计SVIP解锁剧目数",
  `etl_tm` datetime NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`user_id`)
COMMENT "海剧-累计解锁剧目数"
DISTRIBUTED BY HASH(`user_id`) BUCKETS 20 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);