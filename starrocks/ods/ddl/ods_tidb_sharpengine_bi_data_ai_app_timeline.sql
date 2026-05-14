CREATE TABLE `ods_tidb_sharpengine_bi_data_ai_app_timeline` (
  `product_id` bigint(20) NOT NULL COMMENT "产品id",
  `date` varchar(10) NOT NULL COMMENT "发布日期",
  `old_value` varchar(50) NOT NULL COMMENT "更新前老版本号",
  `Id` bigint(20) NOT NULL COMMENT "",
  `new_value` varchar(50) NULL COMMENT "新版本号",
  `event_type` varchar(50) NULL COMMENT "更新类型",
  `release_note` varchar(1000) NULL COMMENT "新版本描述（更新内容）",
  `release_date` varchar(10) NULL COMMENT "发布日期",
  `updatetime` datetime NOT NULL COMMENT "更新时间",
  `inittime` datetime NOT NULL COMMENT "写入时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `date`, `old_value`)
COMMENT "app版本信息表"
DISTRIBUTED BY HASH(`product_id`) BUCKETS 5 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "product_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
