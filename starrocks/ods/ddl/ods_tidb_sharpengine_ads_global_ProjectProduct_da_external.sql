CREATE EXTERNAL TABLE `ods_tidb_sharpengine_ads_global_ProjectProduct_da_external` (
  `Id` bigint(20) NOT NULL COMMENT "主键ID",
  `ProjectCode` int(11) NOT NULL COMMENT "项目编码 1=海外阅读|2=海外短剧",
  `ProductId` int(11) NOT NULL COMMENT "语言",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP_EXTERNAL 
PRIMARY KEY(`Id`)
COMMENT "项目语言"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "ProjectCode",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4",
"host" = "ads-starrocks-in.changdu.vip",
"port" = "19020",
"user" = "ztt",
"password" = "",
"database" = "sharpengine_ads_global",
"table" = "ProjectProduct"
);
