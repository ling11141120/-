CREATE TABLE `dim_applications` (
  `app_id` int(11) NOT NULL COMMENT "应用程序id",
  `app_name` varchar(255) NOT NULL COMMENT "应用程序名",
  `area` varchar(255) NOT NULL COMMENT "地域",
  `corever` varchar(255) NOT NULL COMMENT "core",
  `lang` varchar(255) NOT NULL COMMENT "语言",
  `remark` varchar(255) NOT NULL COMMENT "",
  `app_key` varchar(255) NULL COMMENT "",
  `product_id` int(11) NULL COMMENT "产品id",
  `app_tps` varchar(50) NULL COMMENT "应用类型",
  `sr_updatetime` datetime NULL COMMENT "ods同步时间"
) ENGINE=OLAP 
PRIMARY KEY(`app_id`)
COMMENT "app应用信息"
DISTRIBUTED BY HASH(`app_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);