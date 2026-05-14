CREATE TABLE `ods_tidb_cv_cdvideo_tidb_xcx_sync_a_appid_da` (
  `Id` bigint(20) NOT NULL COMMENT "主键ID",
  `_id` varchar(65533) NULL COMMENT "原表_id",
  `appid` varchar(65533) NULL COMMENT "应用程序id",
  `appname` varchar(65533) NULL COMMENT "应用程序名",
  `appsecret` varchar(65533) NULL COMMENT "应用密钥",
  `type` varchar(65533) NULL COMMENT "类型",
  `create_time` datetime NULL COMMENT "添加时间",
  `sync_update_time` datetime NULL COMMENT "数据更新时间戳",
  `sr_createtime` datetime NULL COMMENT "sr入库时间",
  `sr_updatetime` datetime NULL COMMENT "sr更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "国剧应用程序表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "create_time",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
