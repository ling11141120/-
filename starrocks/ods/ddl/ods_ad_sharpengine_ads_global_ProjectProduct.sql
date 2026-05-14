CREATE TABLE `ods_ad_sharpengine_ads_global_ProjectProduct` (
  `Id` bigint(20) NOT NULL COMMENT "主键ID",
  `ProjectCode` int(11) NOT NULL COMMENT "项目编码 1=海外阅读|2=海外短剧",
  `ProductId` int(11) NOT NULL COMMENT "语言",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `sr_createtime` datetime NULL COMMENT "数据采集时间",
  `sr_updatetime` datetime NULL COMMENT "数据采集更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "项目语言"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
