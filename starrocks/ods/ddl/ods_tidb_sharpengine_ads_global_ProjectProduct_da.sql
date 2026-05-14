CREATE TABLE `ods_tidb_sharpengine_ads_global_ProjectProduct_da` (
  `Id` bigint(20) NOT NULL COMMENT "主键ID",
  `ProjectCode` int(11) NULL COMMENT "项目编码 1=海外阅读|2=海外短剧",
  `ProductId` int(11) NULL COMMENT "语言",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `sr_createtime` datetime NULL COMMENT "sr入库时间",
  `sr_updatetime` datetime NULL COMMENT "sr更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "项目语言"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "CreateTime",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
