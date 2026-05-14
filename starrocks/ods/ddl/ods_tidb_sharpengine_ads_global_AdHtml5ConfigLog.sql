CREATE TABLE `ods_tidb_sharpengine_ads_global_AdHtml5ConfigLog` (
  `Id` int(11) NOT NULL COMMENT "",
  `Lang` varchar(128) NOT NULL COMMENT "语言",
  `FileName` varchar(65533) NOT NULL COMMENT "文件名",
  `User` varchar(128) NOT NULL COMMENT "创建用户",
  `ConfigId` bigint(20) NOT NULL COMMENT "AdHtml5Config 配置Id",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `JsVer` varchar(1024) NULL COMMENT "js版本号",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "发布日志"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
