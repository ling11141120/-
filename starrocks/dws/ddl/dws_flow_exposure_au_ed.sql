CREATE TABLE `dws_flow_exposure_au_ed` (
  `dt` date NOT NULL COMMENT "日期",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `corever` int(11) NULL COMMENT "core",
  `mt` int(11) NULL COMMENT "设备",
  `app_ver` varchar(65533) NULL COMMENT "app版本",
  `user_type` varchar(1048576) NULL COMMENT "1IAA 2纯白嫖 3付费白嫖 4非白嫖",
  `baoguang_user_id` varchar(65533) NULL COMMENT "曝光userid",
  `user_cnt` bigint(20) NULL COMMENT "曝光次数",
  `etl_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `user_id`)
DISTRIBUTED BY HASH(`user_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
