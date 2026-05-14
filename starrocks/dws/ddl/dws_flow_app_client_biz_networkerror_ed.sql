CREATE TABLE `dws_flow_app_client_biz_networkerror_ed` (
  `dt` date NULL COMMENT "日期",
  `app_id` varchar(65533) NULL COMMENT "app_id",
  `corever` varchar(1048576) NULL COMMENT "core",
  `mt` varchar(1048576) NULL COMMENT "设备",
  `product_id` varchar(1048576) NULL COMMENT "产品id",
  `app_ver` varchar(65533) NULL COMMENT "应用版本",
  `biz_type` varchar(65533) NULL COMMENT "报错类型",
  `biz_url` varchar(65533) NULL COMMENT "报错url",
  `cnt` bigint(20) NOT NULL COMMENT "数量",
  `etl_tm` datetime NULL COMMENT "清洗时间"
) ENGINE=OLAP 
DUPLICATE KEY(`dt`, `app_id`, `corever`, `mt`, `product_id`, `app_ver`, `biz_type`, `biz_url`)
COMMENT "客户端上报错误 networkerror"
DISTRIBUTED BY HASH(`dt`) BUCKETS 12 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
