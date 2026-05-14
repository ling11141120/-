CREATE TABLE `ods_tidb_sharpengine_bi_data_ai_app_ret` (
  `dt` date NOT NULL COMMENT "日期，由start_date转换而来",
  `Id` bigint(20) NOT NULL COMMENT "自增id",
  `product_id` bigint(20) NULL COMMENT "产品id",
  `country_code` varchar(65533) NULL COMMENT "国家码",
  `device_code` varchar(65533) NULL COMMENT "设备码",
  `granularity` varchar(65533) NULL COMMENT "时间维度",
  `start_date` datetime NULL COMMENT "开始日期",
  `end_date` datetime NULL COMMENT "结束日期",
  `retention_days` int(11) NULL COMMENT "留存天数",
  `est_retention_value` varchar(65533) NULL COMMENT "留存数",
  `updatetime` datetime NULL COMMENT "更新时间",
  `inittime` datetime NULL COMMENT "写入时间",
  `sr_createtime` datetime NULL COMMENT "sr数据创建时间",
  `sr_updatetime` datetime NULL COMMENT "sr数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `Id`)
COMMENT "app统计留存数表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "dt",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
